/*
 * main.c
 *
 *  Created on: 2019Äê7ÔÂ18ÈÕ
 *      Author: myj
 */
#include <stdio.h>
#include "xparameters.h"
#include "i2c/PS_i2c.h"
#include "sleep.h"
#include "ff.h"
#include "xscugic.h"
#include "xgpiops.h"
#include "dma_ctrl.h"

/************************** Constant Definitions *****************************/
/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */

#define INTC_DEVICE_ID			XPAR_SCUGIC_SINGLE_DEVICE_ID

#define GPIO_DEVICE_ID			XPAR_XGPIOPS_0_DEVICE_ID

#define KEY_INTR_ID   		    XPAR_XGPIOPS_0_INTR


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/


int SetupInterrupt(XScuGic *GicPtr);
int GpioSetup(XGpioPs *Gpioinstance, u16 Deviceid, XScuGic *InstancePtr) ;

/************************** Macro Definitions *****************************/


/************************** Variable Definitions *****************************/

XGpioPs Gpio;	/* The driver instance for GPIO Device. */
int key_flag = 0;


XScuGic GicInstance;


#define PLAY_LEN 0x4000000
#define RECORD_LEN  960000   //record length about 10 second for 48K sample

Audio AudioInst ;

XIicPs ps_i2c0;

static FIL fil;		/* File object */
static FATFS fatfs;

unsigned int WavLength ;

u32 WriteBuf[PLAY_LEN] __attribute__ ((aligned(64)));
u32 ReadBuf[RECORD_LEN] __attribute__ ((aligned(64)));
u8 waveframe[PLAY_LEN] __attribute__ ((aligned(64)));

unsigned int wav_read(char * wave,u8 *frame)
{
	unsigned int x;

	FRESULT res;
	unsigned char TMPBUF[100];
	unsigned int br;         // File R/W count
	unsigned int FrameLength ;

	res = f_open(&fil, wave, FA_OPEN_EXISTING | FA_READ);
	if(res != FR_OK)
	{
		return 0;
	}
	res = f_read(&fil, TMPBUF, 88, &br);
	if(res != FR_OK)
	{
		return 0;
	}

	if(TMPBUF[0] == 'R' && TMPBUF[1] == 'I' && TMPBUF[2] == 'F' && TMPBUF[3] == 'F'
			&& TMPBUF[8] == 'W' && TMPBUF[9] == 'A' && TMPBUF[10] == 'V' && TMPBUF[11] == 'E'){
		FrameLength = ((unsigned int)TMPBUF[7]<<24) + ((unsigned int)TMPBUF[6]<<16) + ((unsigned int)TMPBUF[5]<<8) + TMPBUF[4] ;
		xil_printf("wave length is %x\r\n", FrameLength) ;
	}
	else
		return 0;


	res =f_read(&fil, frame, FrameLength-80, &br);
	if(res != FR_OK)
	{
		return 0;
	}
	for(x = 0; x < (FrameLength-80)/2; x++)
	{
		WriteBuf[x] = (u32)frame[x*2 + 1]<<24 | (u32)frame[x*2 + 0]<<16 ;

	}


	f_close(&fil);

	return (FrameLength-80)/2 ;
}


int main(void)
{

	int Status;


	FRESULT rc;
	rc = f_mount(&fatfs, "0:/", 0);
	if (rc != FR_OK)
	{
		return 0 ;
	}

	/* Initialize i2c  */
	i2c_init(&ps_i2c0, XPAR_XIICPS_0_DEVICE_ID,40000);
	usleep(500000);
	/* Initialize audio module  */
	audio_init(&AudioInst, &ps_i2c0) ;

	AudioInst.TxBufferPtr = WriteBuf ;
	memset(AudioInst.TxBufferPtr, 0, PLAY_LEN * sizeof(u32)) ;
	/*
	 * disable tx and rx channel before transfer
	 */
	audio_txrx_disable(&AudioInst, TX_ENABLE_MASK|RX_ENABLE_MASK) ;
	/*
	 * Setup the interrupt system.
	 */
	Status = SetupInterrupt(&GicInstance);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	GpioSetup(&Gpio, GPIO_DEVICE_ID, &GicInstance) ;

	/* Read wav data from sd card  */
	WavLength = wav_read("1.wav",waveframe);

	Xil_DCacheFlushRange((UINTPTR)AudioInst.TxBufferPtr, PLAY_LEN * sizeof(u32));

	/* Start play music */
	XAxiDma_Audio_Play(&GicInstance, &AudioInst, WavLength, AudioInst.TxBufferPtr) ;


	return 0;
}


int GpioSetup(XGpioPs *Gpioinstance, u16 Deviceid, XScuGic *InstancePtr)
{
	int Status;
	XGpioPs_Config *ConfigPtr;

	/* Initialize the GPIO driver. */
	ConfigPtr = XGpioPs_LookupConfig(Deviceid);

	Status = XGpioPs_CfgInitialize(Gpioinstance, ConfigPtr,
			ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	/*
	 * Set the direction for the pin to be output and
	 * Enable the Output enable for the LED Pin.
	 */
	XGpioPs_SetDirectionPin(Gpioinstance, PLAY_LED, 1);
	XGpioPs_SetDirectionPin(Gpioinstance, RECORD_LED, 1);
	XGpioPs_SetOutputEnablePin(Gpioinstance, PLAY_LED, 1);
	XGpioPs_SetOutputEnablePin(Gpioinstance, RECORD_LED, 1);

	/* Set the led low. */
	XGpioPs_WritePin(&Gpio, PLAY_LED, LED_OFF);
	XGpioPs_WritePin(&Gpio, RECORD_LED, LED_OFF);

	return XST_SUCCESS;

}



int SetupInterrupt(XScuGic *GicPtr)
{
	int Status;

	XScuGic_Config *GicConfig;


	Xil_ExceptionInit();

	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	GicConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == GicConfig) {
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize(GicPtr, GicConfig,
			GicConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Connect the interrupt controller interrupt handler to the hardware
	 * interrupt handling logic in the processor.
	 */
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler,
			GicPtr);


	Xil_ExceptionEnable();

	return XST_SUCCESS;

}

