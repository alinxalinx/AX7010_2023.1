/*
 * cpu1_app.c
 *
 *  Created on: 2018Äê9ÔÂ17ÈÕ
 *      Author: myj
 */

#include "xparameters.h"
#include "xscugic.h"
#include "xgpio.h"

#include "xil_printf.h"
#include "xil_exception.h"
#include "xil_mmu.h"
#include "sleep.h"
#include "share.h"
#include "xtime_l.h"


#define KEY_DEVICE_ID XPAR_AXI_GPIO_1_DEVICE_ID
#define LED_DEVICE_ID XPAR_AXI_GPIO_0_DEVICE_ID

#define KEY_INTR_ID XPAR_FABRIC_AXI_GPIO_1_IP2INTC_IRPT_INTR
#define INTC_DEVICE_ID	XPAR_SCUGIC_SINGLE_DEVICE_ID

#define LED_DIR 0x0f
#define LED_CHANNEL 1
#define KEY_DIR 0x0f
#define KEY_CHANNEL 1

#define BTN_INT             XGPIO_IR_CH1_MASK


ShareMem *SharePtr ;

unsigned char Cpu0_Data[12] = "Hello Cpu0!" ;

#define SHARE_BASE  0x1FFFFF00

XGpio Gpio_key ;
XGpio Gpio_led ;

XScuGic InterrruptInst;

int key_flag = 0 ;
int soft_flag = 0 ;

u32 CPU0 = 0x1 ;

u16 SoftIntrIdToCpu0 = 1 ;
u16 SoftIntrIdToCpu1 = 2 ;

unsigned char Cpu1_Data[12] = "Hello Cpu0!" ;
unsigned char *Cpu0Data ;

XTime TimerCurr, TimerLast;


int InterruptInit(XScuGic *InstancePtr, u16 DeviceId);
int InterruptConnnect(XScuGic *InstancePtr, u16 IntId, void * Handler,void *CallBackRef) ;

int PLGpioSetup(XScuGic *InstancePtr) ;
int GpioHandler(void *InstancePtr);

void SoftHandler(void *CallbackRef) ;



int main()
{
	int Status ;
	int LedVal = 0x1;

	/*
	 * Disable cache on OCM  S=b1 TEX=b100 AP=b11, Domain=b1111, C=b0, B=b0
	 */
	Xil_SetTlbAttributes(0xFFFF0000,0x14de2);

	SharePtr = (ShareMem *)SHARE_BASE ;
	/*
	 * Initial interrupt
	 */
	Status = InterruptInit(&InterrruptInst, INTC_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;
	/*
	 * Setup Gpio and Enable Gpio interrupt
	 */
	PLGpioSetup(&InterrruptInst);
	/*
	 * Connect interrupt
	 */
	InterruptConnnect(&InterrruptInst, SoftIntrIdToCpu1, (void *)SoftHandler, (void *)&InterrruptInst) ;


	while(1)
	{
		if (key_flag)
		{
			/*
			 * initial shared Struct
			 */
			SharePtr->addr = (unsigned int *)&Cpu1_Data ;
			SharePtr->length = sizeof(Cpu1_Data) ;
			/*
			 * Write led value
			 */
			XGpio_DiscreteWrite(&Gpio_led, LED_CHANNEL, LedVal);
			LedVal = ~LedVal ;
			/*
			 * Software interrupt to CPU0
			 */
			XScuGic_SoftwareIntr(&InterrruptInst, SoftIntrIdToCpu0, CPU0) ;
			key_flag = 0 ;
		}
		else if (soft_flag)
		{
			/*
			 * When Software interrupt, print data in CPU0
			 */
			Cpu0Data = (unsigned char *)SharePtr->addr ;
			xil_printf("This is CPU1, Now Start to Print:\r\n") ;
			xil_printf("%s\r\n", Cpu0Data) ;
			soft_flag = 0 ;
		}

	}


	return 0 ;
}

int PLGpioSetup(XScuGic *InstancePtr)
{
	int Status ;

	/* initial gpio key */
	Status = XGpio_Initialize(&Gpio_key, KEY_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	/* initial gpio led */
	Status = XGpio_Initialize(&Gpio_led, LED_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	/* set key as input */
	XGpio_SetDataDirection(&Gpio_key, KEY_CHANNEL, 0x1);
	/* set led as output */
	XGpio_SetDataDirection(&Gpio_led, LED_CHANNEL, 0x0);

	/* Enable key interrupt */
	XGpio_InterruptGlobalEnable(&Gpio_key) ;
	XGpio_InterruptEnable(&Gpio_key, BTN_INT) ;
	/* Connect key interrupt to CPU1 */
	XScuGic_InterruptMaptoCpu(InstancePtr, XPAR_CPU_ID, KEY_INTR_ID) ;

	InterruptConnnect(InstancePtr, KEY_INTR_ID, (void *)GpioHandler, (void *)&Gpio_key) ;

	return XST_SUCCESS ;
}


int InterruptInit(XScuGic *InstancePtr, u16 DeviceId)
{
	XScuGic_Config *IntcConfig;
	int Status ;

	IntcConfig = XScuGic_LookupConfig(DeviceId);

	Status = XScuGic_CfgInitialize(InstancePtr, IntcConfig, IntcConfig->CpuBaseAddress) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	/*
	 * Initialize the  exception table
	 */
	Xil_ExceptionInit();

	/*
	 * Register the interrupt controller handler with the exception table
	 */
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler,
			InstancePtr);

	/*
	 * Enable non-critical exceptions
	 */
	Xil_ExceptionEnable();


	return XST_SUCCESS ;

}


int InterruptConnnect(XScuGic *InstancePtr, u16 IntId, void * Handler,void *CallBackRef)
{
	XScuGic_Connect(InstancePtr, IntId,
			(Xil_InterruptHandler)Handler,
			CallBackRef) ;

	XScuGic_Enable(InstancePtr, IntId) ;
	return XST_SUCCESS ;
}

int GpioHandler(void *CallbackRef)
{
	XGpio *GpioInstancePtr = (XGpio *)CallbackRef ;
	int Int_val ;
	int key_val ;
	float Interval_time ;

	Int_val = XGpio_InterruptGetStatus(GpioInstancePtr);
	key_val = XGpio_DiscreteRead(GpioInstancePtr, KEY_CHANNEL) ;
	/* Clear Interrupt */
	XGpio_InterruptClear(GpioInstancePtr, XGPIO_IR_CH1_MASK) ;

	if (Int_val == 1 && key_val == 0)
	{
		TimerLast = TimerCurr ;
		XTime_GetTime(&TimerCurr) ;
		Interval_time = ((float)(TimerCurr-TimerLast))/((float)COUNTS_PER_SECOND) ;
		/* Key debounce, set decounce time to 200ms*/
		if (Interval_time < 0.2)
		{
			key_flag = 0 ;
			return 0 ;
		}
		else
		{
			key_flag = 1 ;
		}
	}

	return 1 ;
}


void SoftHandler(void *CallbackRef)
{
	xil_printf("Soft Interrupt from CPU0\r\n") ;
	soft_flag = 1 ;
}

