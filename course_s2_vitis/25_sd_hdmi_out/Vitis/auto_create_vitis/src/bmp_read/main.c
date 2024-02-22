/************************************************************************/
/*																		*/
/*	display_demo.c	--	ALINX AX7021 HDMI Display demonstration 						*/
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
#include "pic_800_600.h"
//#include "i2c/PS_i2c.h"
#include "sleep.h"
#include "ff.h"
#include "bmp.h"
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
XAxiVdma vdma;

static FIL fil;		/* File object */
static FATFS fatfs;

/*
 * Framebuffers for video data
 */
u8 frameBuf[DISPLAY_NUM_FRAMES][DEMO_MAX_FRAME] __attribute__ ((aligned(64)));
u8 *pFrames[DISPLAY_NUM_FRAMES]; //array of pointers to the frame buffers

//XIicPs IicInstance;

/* ------------------------------------------------------------ */
/*				Procedure Definitions							*/
/* ------------------------------------------------------------ */

unsigned char read_line_buf[1920 * 3];
unsigned char Write_line_buf[1920 * 3];
void bmp_read(char * bmp,u8 *frame,u32 stride)
{
	short y,x;
	short Ximage;
	short Yimage;
	u32 iPixelAddr = 0;
	FRESULT res;
	unsigned char TMPBUF[64];
	unsigned int br;         // File R/W count

	res = f_open(&fil, bmp, FA_OPEN_EXISTING | FA_READ);
	if(res != FR_OK)
	{
		return ;
	}
	res = f_read(&fil, TMPBUF, 54, &br);
	if(res != FR_OK)
	{
		return ;
	}
	Ximage=(unsigned short int)TMPBUF[19]*256+TMPBUF[18];
	Yimage=(unsigned short int)TMPBUF[23]*256+TMPBUF[22];
	iPixelAddr = (Yimage-1)*stride ;

	for(y = 0; y < Yimage ; y++)
	{
		f_read(&fil, read_line_buf, Ximage * 3, &br);
		for(x = 0; x < Ximage; x++)
		{
			frame[x * BYTES_PIXEL + iPixelAddr + 0] = read_line_buf[x * 3 + 0];
			frame[x * BYTES_PIXEL + iPixelAddr + 1] = read_line_buf[x * 3 + 1];
			frame[x * BYTES_PIXEL + iPixelAddr + 2] = read_line_buf[x * 3 + 2];
		}
		iPixelAddr -= stride;
	}
	f_close(&fil);
}


void bmp_write(char * name, char *head_buf, char *data_buf)
{
	short y,x;
	short Ximage;
	short Yimage;
	u32 iPixelAddr = 0;
	FRESULT res;
	unsigned int br;         // File R/W count

	memset(&Write_line_buf, 0, 1920*3) ;

	res = f_open(&fil, name, FA_CREATE_ALWAYS | FA_WRITE);
	if(res != FR_OK)
	{
		return ;
	}
	res = f_write(&fil, head_buf, 54, &br) ;
	if(res != FR_OK)
	{
		return ;
	}
	Ximage=(unsigned short)head_buf[19]*256+head_buf[18];
	Yimage=(unsigned short)head_buf[23]*256+head_buf[22];
	iPixelAddr = (Yimage-1)*Ximage*3 ;
	for(y = 0; y < Yimage ; y++)
	{
		for(x = 0; x < Ximage; x++)
		{
			Write_line_buf[x*3 + 0] = data_buf[x*3 + iPixelAddr + 0] ;
			Write_line_buf[x*3 + 1] = data_buf[x*3 + iPixelAddr + 1] ;
			Write_line_buf[x*3 + 2] = data_buf[x*3 + iPixelAddr + 2] ;
		}
		res = f_write(&fil, Write_line_buf, Ximage*3, &br) ;
		if(res != FR_OK)
		{
			return ;
		}
		iPixelAddr -= Ximage*3;
	}

	f_close(&fil);
}


int main(void)
{

	int Status;
	XAxiVdma_Config *vdmaConfig;
	int i;
	FRESULT rc;


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

	rc = f_mount(&fatfs, "0:/", 0);
	if (rc != FR_OK)
	{
		return 0 ;
	}

	bmp_write("cat.bmp", (char *)&BMODE_800x600, (char *)&gImage_pic_800_600) ;
	bmp_read("1.bmp",dispCtrl.framePtr[dispCtrl.curFrame], DEMO_STRIDE);
	Xil_DCacheFlushRange((unsigned int) dispCtrl.framePtr[dispCtrl.curFrame], DEMO_MAX_FRAME);

	return 0;
}

