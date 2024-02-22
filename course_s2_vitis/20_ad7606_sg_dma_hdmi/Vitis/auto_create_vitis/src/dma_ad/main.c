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
//#include "i2c/PS_i2c.h"
#include "sleep.h"
#include "adc_dma_ctrl.h"
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

#define INT_DEVICE_ID      XPAR_SCUGIC_SINGLE_DEVICE_ID


/* ------------------------------------------------------------ */
/*				Global Variables								*/
/* ------------------------------------------------------------ */

/*
 * Display Driver structs
 */
DisplayCtrl dispCtrl;
XAxiVdma vdma;


/*
 * Framebuffers for video data
 */
u8 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(64)));
u8 *pFrames[DISPLAY_NUM_FRAMES]; //array of pointers to the frame buffers

//XIicPs IicInstance;



/*
 * Interrupt struct and function
 */
XScuGic INST ;

int SetInterruptInit(XScuGic *InstancePtr, u16 IntrID) ;
/* ------------------------------------------------------------ */
/*				Procedure Definitions							*/
/* ------------------------------------------------------------ */


int main(void)
{

	int Status;
	XAxiVdma_Config *vdmaConfig;
	int i;

	/*
	 * Initialize ScuGic interrupt
	 */
	Status = SetInterruptInit(&INST, INT_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	/*
	 * Initialize an array of pointers to the 3 frame buffers
	 */
	for (i = 0; i < DISPLAY_NUM_FRAMES; i++)
	{
		pFrames[i] = frameBuf[i];
	}

	/*
	 * Initialize VDMA driver
	 */
	vdmaConfig = XAxiVdma_LookupConfig(VGA_VDMA_ID);
	if (!vdmaConfig)
	{
		xil_printf("No video DMA found for ID %d\r\n", VGA_VDMA_ID);

	}
	Status = XAxiVdma_CfgInitialize(&vdma, vdmaConfig, vdmaConfig->BaseAddress);
	if (Status != XST_SUCCESS)
	{
		xil_printf("VDMA Configuration Initialization failed %d\r\n", Status);

	}

	/*
	 * Initialize the Display controller and start it
	 */
	Status = DisplayInitialize(&dispCtrl, &vdma, DISP_VTC_ID, DYNCLK_BASEADDR, pFrames, DEMO_STRIDE);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Display Ctrl initialization failed during demo initialization%d\r\n", Status);

	}
	Status = DisplayStart(&dispCtrl);
	if (Status != XST_SUCCESS)
	{
		xil_printf("Couldn't start display during demo initialization%d\r\n", Status);

	}

	DemoPrintTest(dispCtrl.framePtr[dispCtrl.curFrame], dispCtrl.vMode.width, dispCtrl.vMode.height, dispCtrl.stride, DEMO_PATTERN_3);

	Status = XAxiDma_Adc_Wave(dispCtrl.vMode.width, dispCtrl.framePtr[dispCtrl.curFrame],  dispCtrl.stride, &INST) ;
	if (Status != XST_SUCCESS)
	{
		xil_printf("ADC Running Failed\r\n");
	}

	return 0;
}



void DemoPrintTest(u8 *frame, u32 width, u32 height, u32 stride, int pattern)
{
	u32 xcoi, ycoi;
	u32 iPixelAddr = 0;
	u8 wRed, wBlue, wGreen;
	u32 xInt;

	xInt = width*BYTES_PIXEL / 8; //each with width/8 pixels

	for(ycoi = 0; ycoi < height; ycoi++)
	{

		/*
		 * Just draw white in the last partial interval (when width is not divisible by 7)
		 */

		for(xcoi = 0; xcoi < (width*BYTES_PIXEL); xcoi+=BYTES_PIXEL)
		{

			if (xcoi < xInt) {                                   //White color
				wRed = 255;
				wGreen = 255;
				wBlue = 255;
			}

			else if ((xcoi >= xInt) && (xcoi < xInt*2)){         //YELLOW color
				wRed = 255;
				wGreen = 255;
				wBlue = 0;
			}
			else if ((xcoi >= xInt*2) && (xcoi < xInt*3)){        //CYAN color
				wRed = 0;
				wGreen = 255;
				wBlue = 255;
			}
			else if ((xcoi >= xInt*3) && (xcoi < xInt*4)){        //GREEN color
				wRed = 0;
				wGreen = 255;
				wBlue = 0;
			}
			else if ((xcoi >= xInt*4) && (xcoi < xInt*5)){        //MAGENTA color
				wRed = 255;
				wGreen = 0;
				wBlue = 255;
			}
			else if ((xcoi >= xInt*5) && (xcoi < xInt*6)){        //RED color
				wRed = 255;
				wGreen = 0;
				wBlue = 0;
			}
			else if ((xcoi >= xInt*6) && (xcoi < xInt*7)){        //BLUE color
				wRed = 0;
				wGreen = 0;
				wBlue = 255;
			}
			else {                                                //BLACK color
				wRed = 0;
				wGreen = 0;
				wBlue = 0;
			}

			frame[xcoi+iPixelAddr + 0] = wBlue;
			frame[xcoi+iPixelAddr + 1] = wGreen;
			frame[xcoi+iPixelAddr + 2] = wRed;
			/*
			 * This pattern is printed one vertical line at a time, so the address must be incremented
			 * by the stride instead of just 1.
			 */
		}
		iPixelAddr += stride;

	}

	/*
	 * Flush the framebuffer memory range to ensure changes are written to the
	 * actual memory, and therefore accessible by the VDMA.
	 */
	Xil_DCacheFlushRange((unsigned int) frame, DEMO_MAX_FRAME);
}


int SetInterruptInit(XScuGic *InstancePtr, u16 IntrID)
{

	XScuGic_Config * Config ;
	int Status ;

	Config = XScuGic_LookupConfig(IntrID) ;

	Status = XScuGic_CfgInitialize(InstancePtr, Config, Config->CpuBaseAddress) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) XScuGic_InterruptHandler,
			InstancePtr);

	Xil_ExceptionEnable();


	return XST_SUCCESS ;

}
