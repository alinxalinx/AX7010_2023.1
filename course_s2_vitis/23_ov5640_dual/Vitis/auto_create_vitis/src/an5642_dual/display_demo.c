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
#include "vdma.h"
#include "i2c/PS_i2c.h"
#include "xgpio.h"
#include "sleep.h"
#include "ov5640.h"
/*
 * XPAR redefines
 */
#define DYNCLK_BASEADDR XPAR_AXI_DYNCLK_0_BASEADDR
#define VGA_VDMA_ID XPAR_AXIVDMA_0_DEVICE_ID
#define DISP_VTC_ID XPAR_VTC_0_DEVICE_ID
#define VID_VTC_IRPT_ID XPS_FPGA3_INT_ID
#define VID_GPIO_IRPT_ID XPS_FPGA4_INT_ID
#define SCU_TIMER_ID XPAR_SCUTIMER_DEVICE_ID
#define UART_BASEADDR XPAR_PS7_UART_1_BASEADDR

/* ------------------------------------------------------------ */
/*				Global Variables								*/
/* ------------------------------------------------------------ */

/*
 * Display Driver structs
 */
DisplayCtrl dispCtrl;
XAxiVdma *vdma[DISPLAY_NUM_VDMA];
u32 stride[DISPLAY_NUM_VDMA];
XIicPs ps_i2c0;
XIicPs ps_i2c1;
XGpio cmos_rstn;
/*
 * Framebuffers for video data
 */
__attribute__ ((aligned(8))) u8 frameBuf[DISPLAY_NUM_VDMA][DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME];

u8 *pFrames[DISPLAY_NUM_VDMA][DISPLAY_NUM_FRAMES]; //array of pointers to the frame buffers

/* ------------------------------------------------------------ */
/*				Procedure Definitions							*/
/* ------------------------------------------------------------ */

int main(void) {

	int Status;
	XAxiVdma_Config *vdmaConfig;
	int i, j;
	XAxiVdma vmda0, vmda1;
	vdma[0] = &vmda0;
	vdma[1] = &vmda1;

	i2c_init(&ps_i2c0, XPAR_XIICPS_0_DEVICE_ID,100000);
	i2c_init(&ps_i2c1, XPAR_XIICPS_1_DEVICE_ID,100000);

	XGpio_Initialize(&cmos_rstn, XPAR_CMOS_RST_DEVICE_ID);   //initialize GPIO IP
	XGpio_SetDataDirection(&cmos_rstn, 1, 0x0);            //set GPIO as output
	XGpio_DiscreteWrite(&cmos_rstn, 1, 0x3);
	usleep(500000);
	XGpio_DiscreteWrite(&cmos_rstn, 1, 0x0);               //set GPIO output value to 0
	usleep(500000);
	XGpio_DiscreteWrite(&cmos_rstn, 1, 0x3);
	usleep(500000);


	sensor_init(&ps_i2c0);
	sensor_init(&ps_i2c1);

	/*
	 * Initialize an array of pointers to the 3 frame buffers
	 */
	for (i = 0; i < DISPLAY_NUM_VDMA; i++) {
		for (j = 0; j < DISPLAY_NUM_FRAMES; j++) {
			pFrames[i][j] = frameBuf[i][j];
			memset(pFrames[i][j], 0, DEMO_MAX_FRAME);
			Xil_DCacheFlushRange((INTPTR) pFrames[i][j], DEMO_MAX_FRAME) ;
		}
	}
	/*
	 * Initialize VDMA driver
	 */
	vdmaConfig = XAxiVdma_LookupConfig(VGA_VDMA_ID);
	if (!vdmaConfig) {
		xil_printf("No video DMA found for ID %d\r\n", VGA_VDMA_ID);

	}

	Status = XAxiVdma_CfgInitialize(vdma[0], vdmaConfig,
			vdmaConfig->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("VDMA Configuration Initialization failed %d\r\n", Status);

	}

	vdmaConfig = XAxiVdma_LookupConfig(XPAR_AXIVDMA_2_DEVICE_ID);
	if (!vdmaConfig) {
		xil_printf("No video DMA found for ID %d\r\n",
				XPAR_AXIVDMA_2_DEVICE_ID);

	}
	Status = XAxiVdma_CfgInitialize(vdma[1], vdmaConfig,
			vdmaConfig->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("VDMA Configuration Initialization failed %d\r\n", Status);

	}

	stride[0] = 1920 * 3;
	stride[1] = 1920 * 3;
	/*
	 * Initialize the Display controller and start it
	 */
	Status = DisplayInitialize(&dispCtrl, vdma, DISP_VTC_ID, DYNCLK_BASEADDR,
			pFrames, stride);
	if (Status != XST_SUCCESS) {
		xil_printf(
				"Display Ctrl initialization failed during demo initialization%d\r\n",
				Status);

	}
	dispCtrl.HoriSizeInput[0] = 1280 * 3;
	dispCtrl.VertSizeInput[0] = 720;
	dispCtrl.HoriSizeInput[1] = 1280 * 3;
	dispCtrl.VertSizeInput[1] = 720;
	Status = DisplayStart(&dispCtrl);
	if (Status != XST_SUCCESS) {
		xil_printf("Couldn't start display during demo initialization%d\r\n",
				Status);

	}
	vdma_write_init(XPAR_AXIVDMA_1_DEVICE_ID, 1280 * 3, 720, 1920 * 3,
			(unsigned int)dispCtrl.framePtr[0][dispCtrl.curFrame[0]]);
	vdma_write_init(XPAR_AXIVDMA_3_DEVICE_ID, 1280 * 3, 720, 1920 * 3,
			(unsigned int)dispCtrl.framePtr[1][dispCtrl.curFrame[1]]);
	return 0;
}

