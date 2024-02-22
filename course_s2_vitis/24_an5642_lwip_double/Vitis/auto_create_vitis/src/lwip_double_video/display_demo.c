/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "display_demo.h"
#include <stdio.h>
#include "math.h"
#include <ctype.h>
#include <stdlib.h>
#include "xil_types.h"
#include "xil_cache.h"
#include "xparameters.h"
#include "xiicps.h"
#include "vdma.h"
#include "i2c/PS_i2c.h"
#include "xgpio.h"
#include "sleep.h"
#include "ov5640.h"
#include "xscugic.h"
#include "zynq_interrupt.h"

/*
 * XPAR redefines
 */
#define DYNCLK_BASEADDR XPAR_AXI_DYNCLK_0_BASEADDR

/* ------------------------------------------------------------ */
/*				Global Variables								*/
/* ------------------------------------------------------------ */

/*
 * Display Driver structs
 */

XAxiVdma vdma_vout;
XIicPs ps_i2c0;
XIicPs ps_i2c1;
XGpio cmos_rstn;
XScuGic XScuGicInstance;

XAxiVdma vdma_vin[2];

static int WriteError;

int wr_index[2]={0,0};
int rd_index[2]={0,0};
int frame_length_curr;
/*
 * Framebuffers for video data
 */
u8 frameBuf0[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(64)));
u8 frameBuf1[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(64)));
u8 *pFrames0[DISPLAY_NUM_FRAMES]; //array of pointers to the frame buffers
u8 *pFrames1[DISPLAY_NUM_FRAMES];
int WriteOneFrameEnd[2]={-1,-1};

/* ------------------------------------------------------------ */
/*				Procedure Definitions							*/
/* ------------------------------------------------------------ */
static void WriteCallBack0(void *CallbackRef, u32 Mask);
static void WriteCallBack1(void *CallbackRef, u32 Mask);
static void WriteErrorCallBack(void *CallbackRef, u32 Mask);

void resetVideoFmt(int w, int h, int ch)
{

	frame_length_curr = 0;
	/* Stop vdma write process, disable vdma interrupt */
	vdma_write_stop(&vdma_vin[ch]);
	XAxiVdma_IntrDisable(&vdma_vin[ch], XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);

	/* reconfig Sensor horizontal width and vertical height */
	if(ch == 0)
	{
		i2c_reg16_write(&ps_i2c0, 0x3c, 0x3808, (w>>8)&0xff);
		i2c_reg16_write(&ps_i2c0, 0x3c, 0x3809, (w>>0)&0xff);
		i2c_reg16_write(&ps_i2c0, 0x3c, 0x380a, (h>>8)&0xff);
		i2c_reg16_write(&ps_i2c0, 0x3c, 0x380b, (h>>0)&0xff);
	}
	else
	{
		i2c_reg16_write(&ps_i2c1, 0x3c, 0x3808, (w>>8)&0xff);
		i2c_reg16_write(&ps_i2c1, 0x3c, 0x3809, (w>>0)&0xff);
		i2c_reg16_write(&ps_i2c1, 0x3c, 0x380a, (h>>8)&0xff);
		i2c_reg16_write(&ps_i2c1, 0x3c, 0x380b, (h>>0)&0xff);
	}

	/*
	 * Initial vdma write path, set call back function and register interrupt to GIC
	 */
	if(ch == 0)
	{
		vdma_write_init(XPAR_AXIVDMA_0_DEVICE_ID, &vdma_vin[ch], w * 3, h, w * 3,
				(unsigned int)pFrames0[0], (unsigned int)pFrames0[1], (unsigned int)pFrames0[2]);
		XAxiVdma_SetCallBack(&vdma_vin[ch], XAXIVDMA_HANDLER_GENERAL,WriteCallBack0, (void *)&vdma_vin[ch], XAXIVDMA_WRITE);
		XAxiVdma_SetCallBack(&vdma_vin[ch], XAXIVDMA_HANDLER_ERROR,WriteErrorCallBack, (void *)&vdma_vin[ch], XAXIVDMA_WRITE);
		InterruptConnect(&XScuGicInstance,XPAR_FABRIC_AXI_VDMA_0_S2MM_INTROUT_INTR,XAxiVdma_WriteIntrHandler,(void *)&vdma_vin[ch]);
	}
	else
	{
		vdma_write_init(XPAR_AXIVDMA_1_DEVICE_ID, &vdma_vin[ch], w * 3, h, w * 3,
				(unsigned int)pFrames1[0], (unsigned int)pFrames1[1], (unsigned int)pFrames1[2]);
		XAxiVdma_SetCallBack(&vdma_vin[ch], XAXIVDMA_HANDLER_GENERAL,WriteCallBack1, (void *)&vdma_vin[ch], XAXIVDMA_WRITE);
		XAxiVdma_SetCallBack(&vdma_vin[ch], XAXIVDMA_HANDLER_ERROR,WriteErrorCallBack, (void *)&vdma_vin[ch], XAXIVDMA_WRITE);
		InterruptConnect(&XScuGicInstance,XPAR_FABRIC_AXI_VDMA_1_S2MM_INTROUT_INTR,XAxiVdma_WriteIntrHandler,(void *)&vdma_vin[ch]);
	}
	/* Start vdma write process, enable vdma interrupt */
	XAxiVdma_IntrEnable(&vdma_vin[ch], XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);
	vdma_write_start(&vdma_vin[ch]);
	frame_length_curr = w*h*3;
}

int lwip_loop();


int main(void)
{
	int i;
	/*
	 * Initialize an array of pointers to the 3 frame buffers
	 */
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames0[i] = frameBuf0[i];
		pFrames1[i] = frameBuf1[i];
		memset(pFrames0[i], 0, DEMO_MAX_FRAME);
		Xil_DCacheFlushRange((INTPTR) pFrames0[i], DEMO_MAX_FRAME) ;
		memset(pFrames1[i], 0, DEMO_MAX_FRAME);
		Xil_DCacheFlushRange((INTPTR) pFrames1[i], DEMO_MAX_FRAME) ;
	}
	/*
	 * Interrupt initialization
	 */
	InterruptInit(XPAR_XSCUTIMER_0_DEVICE_ID,&XScuGicInstance);
	/*
	 * cmos reset
	 */
	/*initialize GPIO*/
	XGpio_Initialize(&cmos_rstn, XPAR_CMOS_RST_DEVICE_ID);
	/* set GPIO as output */
	XGpio_SetDataDirection(&cmos_rstn, 1, 0x0);
	XGpio_DiscreteWrite(&cmos_rstn, 1, 0x3);
	usleep(500000);
	/* set GPIO output value to 0 */
	XGpio_DiscreteWrite(&cmos_rstn, 1, 0x0);
	usleep(500000);
	XGpio_DiscreteWrite(&cmos_rstn, 1, 0x3);
	usleep(500000);
	/*
	 * initial i2c and sensor
	 */
	i2c_init(&ps_i2c0, XPAR_XIICPS_0_DEVICE_ID,40000);
	i2c_init(&ps_i2c1, XPAR_XIICPS_1_DEVICE_ID,40000);
	sensor_init(&ps_i2c0);
	sensor_init(&ps_i2c1);
	/*
	 * Reconfiguration Sensor and VDMA
	 */
	resetVideoFmt(1280, 720, 0);
	resetVideoFmt(1280, 720, 1);
	/*
	 * Start lwip engine
	 */
	lwip_loop();
	return 0;
}

/*****************************************************************************/
/*
 * Call back function for write channel
 *
 * This callback only clears the interrupts and updates the transfer status.
 *
 * @param	CallbackRef is the call back reference pointer
 * @param	Mask is the interrupt mask passed in from the driver
 *
 * @return	None
 *
 ******************************************************************************/
static void WriteCallBack0(void *CallbackRef, u32 Mask)
{
	if (Mask & XAXIVDMA_IXR_FRMCNT_MASK)
	{
		if(WriteOneFrameEnd[0] >= 0)
		{
			return;
		}
		int hold_rd = rd_index[0];
		if(wr_index[0]==2)
		{
			wr_index[0]=0;
			rd_index[0]=2;
		}
		else
		{
			rd_index[0] = wr_index[0];
			wr_index[0]++;
		}
		/* Set park pointer */
		XAxiVdma_StartParking((XAxiVdma*)CallbackRef, wr_index[0], XAXIVDMA_WRITE);
		WriteOneFrameEnd[0] = hold_rd;
	}
}

static void WriteCallBack1(void *CallbackRef, u32 Mask)
{
	if (Mask & XAXIVDMA_IXR_FRMCNT_MASK)
	{
		if(WriteOneFrameEnd[1] >= 0)
		{
			return;
		}
		int hold_rd = rd_index[1];
		if(wr_index[1]==2)
		{
			wr_index[1]=0;
			rd_index[1]=2;
		}
		else
		{
			rd_index[1] = wr_index[1];
			wr_index[1]++;
		}
		/* Set park pointer */
		XAxiVdma_StartParking((XAxiVdma*)CallbackRef, wr_index[1], XAXIVDMA_WRITE);
		WriteOneFrameEnd[1] = hold_rd;
	}
}

/*****************************************************************************/
/*
 * Call back function for write channel error interrupt
 *
 * @param	CallbackRef is the call back reference pointer
 * @param	Mask is the interrupt mask passed in from the driver
 *
 * @return	None
 *
 ******************************************************************************/
static void WriteErrorCallBack(void *CallbackRef, u32 Mask)
{

	if (Mask & XAXIVDMA_IXR_ERROR_MASK) {
		WriteError += 1;
	}
}


