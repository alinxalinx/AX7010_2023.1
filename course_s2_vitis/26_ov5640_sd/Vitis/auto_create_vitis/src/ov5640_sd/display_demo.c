/************************************************************************/
/*																		*/
/*	display_demo.c	--	ALINX AX7010 HDMI Display demonstration 						*/
/*																		*/
/************************************************************************/

/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "display_demo.h"
#include "display_ctrl/display_ctrl.h"
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
#include "xgpiops.h"
#include "ff.h"
#include "bmp.h"
#include "xil_cache.h"
#include "xtime_l.h"
/*
 * XPAR redefines
 */
#define DYNCLK_BASEADDR XPAR_AXI_DYNCLK_0_BASEADDR
#define DISPLAY_VDMA_ID XPAR_AXIVDMA_0_DEVICE_ID
#define DISP_VTC_ID XPAR_VTC_0_DEVICE_ID
#define VID_VTC_IRPT_ID XPS_FPGA3_INT_ID
#define VID_GPIO_IRPT_ID XPS_FPGA4_INT_ID
#define SCU_TIMER_ID XPAR_SCUTIMER_DEVICE_ID
#define UART_BASEADDR XPAR_PS7_UART_1_BASEADDR
#define CAME_VDMA_ID  XPAR_AXIVDMA_1_DEVICE_ID

#define S2MM_INTID XPAR_FABRIC_AXI_VDMA_1_S2MM_INTROUT_INTR
#define MM2S_INTID XPAR_FABRIC_AXI_VDMA_0_MM2S_INTROUT_INTR

#define KEY_INTR_ID        XPAR_XGPIOPS_0_INTR
#define MIO_0_ID           XPAR_PS7_GPIO_0_DEVICE_ID
#define GPIO_INPUT         0
#define GPIO_OUTPUT		   1

/* ------------------------------------------------------------ */
/*				Global Variables								*/
/* ------------------------------------------------------------ */

/*
 * Display Driver structs
 */
DisplayCtrl dispCtrl;
XAxiVdma display_vdma;
XAxiVdma camera_vdma;
XIicPs ps_i2c0;
XGpio cmos_rstn;

XScuGic XScuGicInstance;


static FIL fil;		/* File object */
static FATFS fatfs;

static int WriteError;

int wr_index = 0;
int rd_index = 0;


XGpioPs GpioInstance ;
volatile int key_flag = 0;
int KeyFlagHold = 1 ;

/*
 * Framebuffers for video data
 */

u8 photobuf[DEMO_MAX_FRAME] ;

u8 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(64)));
u8 *pFrames[DISPLAY_NUM_FRAMES]; //array of pointers to the frame buffers
unsigned char PhotoBuf[DEMO_MAX_FRAME] ;

/* ------------------------------------------------------------ */
/*				Procedure Definitions							*/
/* ------------------------------------------------------------ */

static void WriteCallBack(void *CallbackRef, u32 Mask);
static void WriteErrorCallBack(void *CallbackRef, u32 Mask);
static void ReadCallBack(void *CallbackRef, u32 Mask);

int GpioSetup(XScuGic *InstancePtr, u16 DeviceId, u16 IntrID, XGpioPs *GpioInstancePtr) ;
void GpioHandler(void *CallbackRef);





int main(void)
{

	int Status;
	XAxiVdma_Config *vdmaConfig;
	int i;
	FRESULT rc;
	XTime TimerStart, TimerEnd;
	float elapsed_time ;
	unsigned int PhotoCount = 0 ;

	char PhotoName[9] ;

	/*
	 * Initialize an array of pointers to the 3 frame buffers
	 */
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
		memset(pFrames[i], 0, DEMO_MAX_FRAME);
		Xil_DCacheFlushRange((INTPTR) pFrames[i], DEMO_MAX_FRAME) ;
	}

	/*
	 * Initial GIC
	 */
	InterruptInit(XPAR_SCUGIC_0_DEVICE_ID,&XScuGicInstance);

	i2c_init(&ps_i2c0, XPAR_XIICPS_0_DEVICE_ID,40000);


	XGpio_Initialize(&cmos_rstn, XPAR_CMOS_RST_DEVICE_ID);
	XGpio_SetDataDirection(&cmos_rstn, 1, 0x0);
	XGpio_DiscreteWrite(&cmos_rstn, 1, 0x1);
	usleep(500000);
	XGpio_DiscreteWrite(&cmos_rstn, 1, 0x0);

	usleep(500000);
	XGpio_DiscreteWrite(&cmos_rstn, 1, 0x1);
	usleep(500000);
	/*
	 * Initialize Sensor
	 */
	sensor_init(&ps_i2c0);

	/*
	 * Setup PS KEY and PS LED
	 */
	GpioSetup(&XScuGicInstance, MIO_0_ID, KEY_INTR_ID, &GpioInstance) ;

	/* Initial Camera Vdma */
	vdma_write_init(CAME_VDMA_ID, &camera_vdma, 1280 * 3, 720, DEMO_STRIDE,	(unsigned int)pFrames[0], DISPLAY_NUM_FRAMES);
	/* Set General Callback for Sensor Vdma */
	XAxiVdma_SetCallBack(&camera_vdma, XAXIVDMA_HANDLER_GENERAL,WriteCallBack, (void *)&camera_vdma, XAXIVDMA_WRITE);
	/* Set Error Callback for Sensor Vdma */
	XAxiVdma_SetCallBack(&camera_vdma, XAXIVDMA_HANDLER_ERROR,WriteErrorCallBack, (void *)&camera_vdma, XAXIVDMA_WRITE);
	/* Connect interrupt to GIC */
	InterruptConnect(&XScuGicInstance,S2MM_INTID,XAxiVdma_WriteIntrHandler,(void *)&camera_vdma);
	/* enable vdma interrupt */
	XAxiVdma_IntrEnable(&camera_vdma, XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_WRITE);

	/*
	 * Initialize Display VDMA driver
	 */
	vdmaConfig = XAxiVdma_LookupConfig(DISPLAY_VDMA_ID);
	if (!vdmaConfig)
	{
		xil_printf("No video DMA found for ID %d\r\n", DISPLAY_VDMA_ID);
	}
	Status = XAxiVdma_CfgInitialize(&display_vdma, vdmaConfig, vdmaConfig->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		xil_printf("VDMA Configuration Initialization failed %d\r\n", Status);

	}

	/*
	 * Initialize the Display controller and start it
	 */
	Status = DisplayInitialize(&dispCtrl, &display_vdma, DISP_VTC_ID, DYNCLK_BASEADDR,pFrames, DEMO_STRIDE);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Display Ctrl initialization failed during demo initialization%d\r\n", Status);

	}
	Status = DisplayStart(&dispCtrl);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Couldn't start display during demo initialization%d\r\n", Status);

	}
	/* Set General Callback for dispaly Vdma */
	XAxiVdma_SetCallBack(&display_vdma, XAXIVDMA_HANDLER_GENERAL,ReadCallBack, (void *)&display_vdma, XAXIVDMA_READ);
	/* Connect interrupt to GIC */
	InterruptConnect(&XScuGicInstance,MM2S_INTID,XAxiVdma_ReadIntrHandler,(void *)&display_vdma);
	/* enable vdma interrupt */
	XAxiVdma_IntrEnable(&display_vdma, XAXIVDMA_IXR_ALL_MASK, XAXIVDMA_READ);

	/* Set PS LED off */
	XGpioPs_WritePin(&GpioInstance, 0, 1) ;

	rc = f_mount(&fatfs, "0:/", 0);
	if (rc != FR_OK)
	{
		return 0 ;
	}

	while(1)
	{
		if (key_flag == 2)
		{
			KeyFlagHold = 0;
			/*
			 * increment of photo name
			 */
			PhotoCount++ ;
			sprintf(PhotoName, "%04u.bmp", PhotoCount) ;

			/* Set PS LED on */
			XGpioPs_WritePin(&GpioInstance, 0, 0) ;
			printf("Successfully Take Photo, Photo Name is %s\r\n", PhotoName) ;
			printf("Write to SD Card...\r\n") ;
			/*
			 * Set timer
			 */
			XTime_SetTime(0) ;
			XTime_GetTime(&TimerStart) ;

			Xil_DCacheInvalidateRange((unsigned int) pFrames[(wr_index+1)%3], DEMO_MAX_FRAME) ;
			/*
			 * Copy frame data to photo buffer
			 */
			memcpy(&photobuf, pFrames[(wr_index+1)%3],  DEMO_MAX_FRAME) ;

			/*
			 * Clear key flag
			 */
			key_flag = 0 ;
			/*
			 * Write to SD Card
			 */
			bmp_write(PhotoName, (char *)&BMODE_1280x720, (char *)&photobuf, DEMO_STRIDE, &fil) ;
			/*
			 * Print Elapsed time
			 */
			XTime_GetTime(&TimerEnd) ;
			elapsed_time = ((float)(TimerEnd-TimerStart))/((float)COUNTS_PER_SECOND) ;
			printf("INFO:Elapsed time = %.2f sec\r\n", elapsed_time) ;
		}
		/* Set PS LED off */
		XGpioPs_WritePin(&GpioInstance, 0, 1) ;
		KeyFlagHold = 1;
	}


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
static void WriteCallBack(void *CallbackRef, u32 Mask)
{
	if (Mask & XAXIVDMA_IXR_FRMCNT_MASK)
	{

		if(key_flag == 1)
		{
			key_flag = 2 ;
			return;
		}
		else if(key_flag == 2)
		{
			return ;
		}

		if(wr_index==2)
		{
			wr_index=0;
			rd_index=2;
		}
		else
		{
			rd_index = wr_index;
			wr_index++;
		}
		/* Set park pointer */
		XAxiVdma_StartParking((XAxiVdma*)CallbackRef, wr_index, XAXIVDMA_WRITE);
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


static void ReadCallBack(void *CallbackRef, u32 Mask)
{
	if (Mask & XAXIVDMA_IXR_FRMCNT_MASK)
	{
		/* Set park pointer */
		XAxiVdma_StartParking((XAxiVdma*)CallbackRef, rd_index, XAXIVDMA_READ);
	}
}


/*
 * Set up GPIO and enable GPIO interrupt
 */
int GpioSetup(XScuGic *InstancePtr, u16 DeviceId, u16 IntrID, XGpioPs *GpioInstancePtr)
{
	XGpioPs_Config *GpioCfg ;
	int Status ;

	GpioCfg = XGpioPs_LookupConfig(DeviceId) ;
	Status = XGpioPs_CfgInitialize(GpioInstancePtr, GpioCfg, GpioCfg->BaseAddr) ;
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE ;
	}
	/* set MIO 50 as input */
	XGpioPs_SetDirectionPin(GpioInstancePtr, 50, GPIO_INPUT) ;
	/* set interrupt type */
	XGpioPs_SetIntrTypePin(GpioInstancePtr, 50, XGPIOPS_IRQ_TYPE_EDGE_RISING) ;

	/* set MIO 0 as output */
	XGpioPs_SetDirectionPin(&GpioInstance, 0, GPIO_OUTPUT) ;
	/* enable MIO 0 output */
	XGpioPs_SetOutputEnablePin(&GpioInstance, 0, GPIO_OUTPUT) ;
	/* set priority and trigger type */
	XScuGic_SetPriorityTriggerType(InstancePtr, IntrID,
			0xA0, 0x3);
	Status = XScuGic_Connect(InstancePtr, IntrID,
			(Xil_ExceptionHandler)GpioHandler,
			(void *)GpioInstancePtr) ;

	XScuGic_Enable(InstancePtr, IntrID) ;

	XGpioPs_IntrEnablePin(GpioInstancePtr, 50) ;

	return XST_SUCCESS ;
}
/*
 * GPIO interrupt handler
 */
void GpioHandler(void *CallbackRef)
{
	XGpioPs *GpioInstancePtr = (XGpioPs *)CallbackRef ;
	int IntVal ;

	IntVal = XGpioPs_IntrGetStatusPin(GpioInstancePtr, 50) ;
	/* clear key interrupt */
	XGpioPs_IntrClearPin(GpioInstancePtr, 50) ;
	if (IntVal & KeyFlagHold)
		key_flag = 1 ;

}
