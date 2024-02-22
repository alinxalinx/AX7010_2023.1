/*
 * cpu0_app.c
 *
 *  Created on: 2018Äê9ÔÂ17ÈÕ
 *      Author: myj
 */

#include "xparameters.h"
#include "xscugic.h"
#include "xgpiops.h"
#include "xil_printf.h"
#include "xil_exception.h"
#include "xil_mmu.h"
#include "xpseudo_asm.h"
#include "stdio.h"
#include "share.h"
#include "xil_cache.h"
#include "xtime_l.h"

/* GPIO paramter */
#define MIO_0_ID        XPAR_PS7_GPIO_0_DEVICE_ID
#define INTC_DEVICE_ID	XPAR_SCUGIC_SINGLE_DEVICE_ID
#define KEY_INTR_ID     XPAR_XGPIOPS_0_INTR

#define GPIO_INPUT      0
#define GPIO_OUTPUT     1

int key_flag = 0 ;
int soft_flag = 0 ;
XGpioPs GPIO_PTR ;

XScuGic InterrruptInst;


u16 SoftIntrIdToCpu0 = 1 ;
u16 SoftIntrIdToCpu1 = 2 ;

ShareMem *SharePtr ;

u32 CPU1 = 0x2 ;

unsigned char Cpu0_Data[12] = "Hello Cpu1!" ;
unsigned char *Cpu1Data ;

XTime TimerCurr, TimerLast;

#define SHARE_BASE  0x1FFFFF00

int InterruptInit(XScuGic *InstancePtr, u16 DeviceId) ;
int InterruptConnnect(XScuGic *InstancePtr, u16 IntId, void * Handler,void *CallBackRef) ;

int PsGpioSetup(XScuGic *InstancePtr) ;
int GpioHandler(void *CallbackRef);

void SoftHandler(void *CallbackRef) ;

#define sev() __asm__("sev")
#define CPU1STARTADR 0xFFFFFFF0
#define CPU1STARTMEM 0x10000000

void StartCpu1(void)
{
	printf("Write the address of the application for CPU1 to 0xFFFFFFF0\r\n");
	Xil_Out32(CPU1STARTADR, CPU1STARTMEM);
	dmb();
	printf("Execute the SEV instruction to cause CPU1 to wake up and jump to the application\r\n");
	sev();
}


int main()
{
	int Status ;
	int LedVal  = 0 ;
	/*
	 * Disable cache on OCM  S=b1 TEX=b100 AP=b11, Domain=b1111, C=b0, B=b0
	 */
	Xil_SetTlbAttributes(0xFFFF0000,0x14de2);
	/*
	 * Wake up CPU1
	 */
	StartCpu1();

	SharePtr = (ShareMem *)SHARE_BASE ;
	/*
	 * Initial interrupt
	 */
	Status = InterruptInit(&InterrruptInst, INTC_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;
	/*
	 * Setup Ps Gpio and Enable Gpio interrupt
	 */
	PsGpioSetup(&InterrruptInst) ;
	/*
	 * Connect interrupt
	 */
	InterruptConnnect(&InterrruptInst, SoftIntrIdToCpu0, (void *)SoftHandler, (void *)&InterrruptInst) ;


	while(1)
	{
		if (key_flag)
		{
			/*
			 * initial shared Struct
			 */
			SharePtr->addr = (unsigned int *)&Cpu0_Data ;
			SharePtr->length = sizeof(Cpu0_Data) ;
			/*
			 * Write led value
			 */
			XGpioPs_WritePin(&GPIO_PTR, 0, LedVal) ;
			LedVal = ~LedVal ;
			/*
			 * Software interrupt to CPU1
			 */
			XScuGic_SoftwareIntr(&InterrruptInst, SoftIntrIdToCpu1, CPU1) ;
			key_flag = 0 ;
		}
		else if (soft_flag)
		{
			/*
			 * When Software interrupt, print data in CPU1
			 */
			Cpu1Data = (unsigned char *)SharePtr->addr ;
			xil_printf("This is CPU0, Now Start to Print:\r\n") ;
			xil_printf("%s\r\n", Cpu1Data) ;
			soft_flag = 0 ;
		}

	}

	return 0 ;
}


int PsGpioSetup(XScuGic *InstancePtr)
{
	XGpioPs_Config *GPIO_CONFIG ;
	int Status ;

	GPIO_CONFIG = XGpioPs_LookupConfig(MIO_0_ID) ;

	Status = XGpioPs_CfgInitialize(&GPIO_PTR, GPIO_CONFIG, GPIO_CONFIG->BaseAddr) ;
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE ;
	}
	/* set MIO 50 as input */
	XGpioPs_SetDirectionPin(&GPIO_PTR, 50, GPIO_INPUT) ;
	/* set MIO 0 as output */
	XGpioPs_SetDirectionPin(&GPIO_PTR, 0, GPIO_OUTPUT) ;
	/* enable MIO 0 output */
	XGpioPs_SetOutputEnablePin(&GPIO_PTR, 0, GPIO_OUTPUT) ;
	/* set interrupt type */
	XGpioPs_SetIntrTypePin(&GPIO_PTR, 50, XGPIOPS_IRQ_TYPE_EDGE_RISING) ;

	/* enable GPIO interrupt */
	XGpioPs_IntrEnablePin(&GPIO_PTR, 50) ;

	InterruptConnnect(InstancePtr, KEY_INTR_ID, (void *)GpioHandler, (void *)&GPIO_PTR) ;

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
	XGpioPs *GpioInstancePtr = (XGpioPs *)CallbackRef ;
	int Int_val ;
	float Interval_time ;

	Int_val = XGpioPs_IntrGetStatusPin(GpioInstancePtr, 50) ;
	/* clear key interrupt */
	XGpioPs_IntrClearPin(GpioInstancePtr, 50) ;
	if (Int_val)
	{
		TimerLast = TimerCurr ;
		XTime_GetTime(&TimerCurr) ;
		Interval_time = ((float)(TimerCurr-TimerLast))/((float)COUNTS_PER_SECOND) ;
		/* Key debounce, set decounce time to 50ms*/
		if (Interval_time < 0.05)
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
	xil_printf("Soft Interrupt from CPU1\r\n") ;
	soft_flag = 1 ;
}

