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
#include "xscugic.h"
#include "dma_ctrl.h"
#include "xgpiops.h"
#include "xtime_l.h"

/************************** Constant Definitions *****************************/
/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */

#define INTC_DEVICE_ID			XPAR_SCUGIC_SINGLE_DEVICE_ID

#define GPIO_DEVICE_ID			XPAR_XGPIOPS_0_DEVICE_ID

#define KEY_INTR_ID   		  	XPAR_XGPIOPS_0_INTR



/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/


int SetupInterrupt(XScuGic *GicPtr);
int GpioSetup(XGpioPs *Gpioinstance, u16 Deviceid, XScuGic *InstancePtr) ;
int GpioHandler(void *CallbackRef) ;

/************************** Macro Definitions *****************************/


/************************** Variable Definitions *****************************/

XGpioPs Gpio;	/* The driver instance for GPIO Device. */
volatile int key_flag = 0;
volatile int key_hold = 0;

XScuGic GicInstance;

XTime TimerCurr, TimerLast;

#define PLAY_LEN 0x4000000
#define RECORD_LEN  960000   //record length about 10 second for 48K sample

Audio AudioInst ;

XIicPs ps_i2c0;

u32 WriteBuf[PLAY_LEN] __attribute__ ((aligned(64)));
u32 ReadBuf[RECORD_LEN] __attribute__ ((aligned(64)));


int main(void)
{

	int Status;

	/* Initialize i2c  */
	i2c_init(&ps_i2c0, XPAR_XIICPS_0_DEVICE_ID,40000);
	usleep(500000);
	/* Initialize audio module  */
	audio_init(&AudioInst, &ps_i2c0) ;

	AudioInst.TxBufferPtr = WriteBuf ;
	AudioInst.RxBufferPtr = ReadBuf ;
	memset(AudioInst.TxBufferPtr, 0, PLAY_LEN * sizeof(u32)) ;
	memset(AudioInst.RxBufferPtr, 0, RECORD_LEN * sizeof(u32)) ;

	audio_txrx_disable(&AudioInst, TX_ENABLE_MASK|RX_ENABLE_MASK) ;
	/* Rx Stream data length */
	Audio_RxStreamLengthSetting(&AudioInst, RECORD_LEN) ;

	/*
	 * Setup the interrupt system.
	 */
	Status = SetupInterrupt(&GicInstance);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	GpioSetup(&Gpio, GPIO_DEVICE_ID, &GicInstance) ;




	XAxiDma_Audio_Record_Play(&GicInstance, &AudioInst, RECORD_LEN, AudioInst.RxBufferPtr) ;


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
	 * Set the direction for the pin to be input.
	 * Set interrupt type as rising edge and enable gpio interrupt
	 */

	Status = XScuGic_Connect(InstancePtr, KEY_INTR_ID,
			(Xil_ExceptionHandler)GpioHandler,
			(void *)Gpioinstance) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	/*
	 * Enable the interrupt for the device.
	 */
	XScuGic_Enable(InstancePtr, KEY_INTR_ID) ;
	XGpioPs_SetDirectionPin(Gpioinstance, KEY, 0) ;
	XGpioPs_SetIntrTypePin(Gpioinstance, KEY, XGPIOPS_IRQ_TYPE_EDGE_RISING) ;

	XGpioPs_IntrEnablePin(Gpioinstance, KEY) ;
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


int GpioHandler(void *CallbackRef)
{
	XGpioPs *GpioInstancePtr = (XGpioPs *)CallbackRef ;
	int value ;
	float Interval_time ;

	value = XGpioPs_IntrGetStatusPin(GpioInstancePtr, KEY) ;
	/*
	 * Clear interrupt.
	 */
	XGpioPs_IntrClearPin(GpioInstancePtr, KEY) ;
	if (value)
	{
		{
			TimerLast = TimerCurr ;
			XTime_GetTime(&TimerCurr) ;
			Interval_time = ((float)(TimerCurr-TimerLast))/((float)COUNTS_PER_SECOND) ;
			/* Key debounce, set decounce time to 100ms*/
			if (Interval_time < 0.1)
			{
				return 1 ;
			}
			else
			{
				if (key_hold)
					return 1 ;
				if (key_flag == 0)
					key_flag = 1 ;
				else if (key_flag == 2)
					key_flag = 3 ;
			}
		}
	}
	return 0 ;
}
