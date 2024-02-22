/*
 * dma_pl.c
 *
 *  Created on: 2018Äê7ÔÂ9ÈÕ
 *      Author: Administrator
 */


#include "xaxidma.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "ad9767_send.h"
#include "wave.h"
#include "xgpiops.h"
#include "xgpio.h"
#include "dma_bd/dma_bd.h"


/*
 * AD9767 definitions
 */
#define AD9767_CH0_BASE        XPAR_AD9767_SEND_0_S00_AXI_BASEADDR
#define AD9767_CH0_START       AD9767_SEND_S00_AXI_SLV_REG0_OFFSET
#define AD9767_CH0_LENGTH      AD9767_SEND_S00_AXI_SLV_REG1_OFFSET

#define AD9767_CH1_BASE        XPAR_AD9767_SEND_1_S00_AXI_BASEADDR
#define AD9767_CH1_START       AD9767_SEND_S00_AXI_SLV_REG0_OFFSET
#define AD9767_CH1_LENGTH      AD9767_SEND_S00_AXI_SLV_REG1_OFFSET
/*
 * Interrupt definitions
 */
#define INT_DEVICE_ID          XPAR_SCUGIC_SINGLE_DEVICE_ID
/*
 * DMA definitions
 */
#define CH0_MM2S_INTR_ID       XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR
#define CH1_MM2S_INTR_ID       XPAR_FABRIC_AXI_DMA_1_MM2S_INTROUT_INTR
#define CH0_DMA_DEV_ID	  	   XPAR_AXI_DMA_0_DEVICE_ID
#define CH1_DMA_DEV_ID	   	   XPAR_AXI_DMA_1_DEVICE_ID
#define CH0_DMA_BASE   	 	   XPAR_AXI_DMA_0_BASEADDR
#define CH1_DMA_BASE   	 	   XPAR_AXI_DMA_1_BASEADDR

#define BD_COUNT          	   4
/*
 * Wave Parameter definitions
 */
#define CH0_MAX_PKT_LEN		   4096		/* must be bigger than 1024, or FIFO will be empty */
#define CH0_MAX_AMP_VAL        16384    /* 2^14, do not change */
#define CH0_AMP_VAL            16384    /* must be less than 2^14 */
#define CH1_MAX_PKT_LEN		   4096		/* must be bigger than 1024, or FIFO will be empty */
#define CH1_MAX_AMP_VAL        16384    /* 2^14, do not change */
#define CH1_AMP_VAL            16384	/* must be less than 2^14 */

#define ADC_BYTE           2
/*
 * PS GPIO definitions
 */
#define MIO_0_ID           XPAR_PS7_GPIO_0_DEVICE_ID
#define PS_KEY_INTR_ID     XPAR_XGPIOPS_0_INTR
#define GPIO_INPUT         0
/*
 * PL GPIO definitions
 */
#define KEY_DEVICE_ID   XPAR_AXI_GPIO_0_DEVICE_ID
#define PL_KEY_INTR_ID 	XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR
#define KEY_CHANNEL 1

/*
 * variable declaratinons
 */
XScuGic INST ;

XAxiDma Ch0AxiDma;
XAxiDma Ch1AxiDma;

XGpioPs PsGpio ;

XGpio PlGpio ;

volatile int ch0_key_flag = 0 ;
volatile int ch1_key_flag = 0 ;

/*
 * DMA buffer to MM2S
 */
u16 Ch0DmaTxBuffer[CH0_MAX_PKT_LEN] __attribute__ ((aligned(64)));
u16 Ch1DmaTxBuffer[CH1_MAX_PKT_LEN] __attribute__ ((aligned(64)));
/*
 * wave buffer
 */
u16 Ch0WaveBuffer[CH0_MAX_PKT_LEN] __attribute__ ((aligned(64)));
u16 Ch1WaveBuffer[CH1_MAX_PKT_LEN] __attribute__ ((aligned(64)));
/*
 * BD buffer
 */
u32 Ch0BdTxChainBuffer[BD_ALIGNMENT*16] __attribute__ ((aligned(64)));
u32 Ch1BdTxChainBuffer[BD_ALIGNMENT*16] __attribute__ ((aligned(64)));

/*
 * Function definitions
 */
void XAxiDma_DAC();
int XAxiDma_Initial(u16 DeviceId, u16 IntrID, XAxiDma *XAxiDma, XScuGic *InstancePtr) ;
int SetInterruptInit(XScuGic *InstancePtr, u16 IntID) ;
void DAC_Interrupt_Handler(void *CallBackRef) ;
int PsKeySetup(XScuGic *InstancePtr, u16 IntrID, XGpioPs *GpioInstancePtr) ;
int PLKeySetup(XScuGic *InstancePtr, u16 IntrID, XGpio *GpioInstancePtr) ;
void PsGpioHandler(void *CallbackRef);
void PlGpioHandler(void *CallbackRef) ;
void wave_switch(int wave_sel, int pkg_len, int max_amp_val, int amp_val, u16 *wave_buffer) ;




int main()
{
	int Status;

	Status = SetInterruptInit(&INST, INT_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	PsKeySetup(&INST, PS_KEY_INTR_ID, &PsGpio) ;

	PLKeySetup(&INST, PL_KEY_INTR_ID, &PlGpio) ;

	XAxiDma_DAC();

	return XST_SUCCESS;

}



void XAxiDma_DAC()
{
	int ch0_wave_sel = 0;
	int ch1_wave_sel = 0;

	/* Initialize DMA and enable MM2S interrupt */
	XAxiDma_Initial(CH0_DMA_DEV_ID, CH0_MM2S_INTR_ID, &Ch0AxiDma, &INST) ;
	XAxiDma_Initial(CH1_DMA_DEV_ID, CH1_MM2S_INTR_ID, &Ch1AxiDma, &INST) ;
	/* Create initial wave data */
	wave_switch(ch0_wave_sel, CH0_MAX_PKT_LEN, CH0_MAX_AMP_VAL, CH0_AMP_VAL, Ch0WaveBuffer) ;
	wave_switch(ch1_wave_sel, CH1_MAX_PKT_LEN, CH1_MAX_AMP_VAL, CH1_AMP_VAL, Ch1WaveBuffer) ;
	/* Copy wave data to DMA buffer */
	memcpy(Ch0DmaTxBuffer, Ch0WaveBuffer, ADC_BYTE*CH0_MAX_PKT_LEN) ;
	Xil_DCacheFlushRange((UINTPTR)Ch0DmaTxBuffer, ADC_BYTE*CH0_MAX_PKT_LEN);

	memcpy(Ch1DmaTxBuffer, Ch1WaveBuffer, ADC_BYTE*CH1_MAX_PKT_LEN) ;
	Xil_DCacheFlushRange((UINTPTR)Ch1DmaTxBuffer, ADC_BYTE*CH1_MAX_PKT_LEN);
	/*
	 * Start AD9767 sample
	 */
	AD9767_SEND_mWriteReg(AD9767_CH0_BASE, AD9767_CH0_START, 1) ;
	AD9767_SEND_mWriteReg(AD9767_CH1_BASE, AD9767_CH1_START, 1) ;

	/*
	 * Create BD and Start
	 */
	CreateBdChain(Ch0BdTxChainBuffer, BD_COUNT, ADC_BYTE*CH0_MAX_PKT_LEN, (u8 *)Ch0DmaTxBuffer, TXPATH) ;
	Bd_Start(Ch0BdTxChainBuffer, BD_COUNT, &Ch0AxiDma, TXPATH) ;

	CreateBdChain(Ch1BdTxChainBuffer, BD_COUNT, ADC_BYTE*CH1_MAX_PKT_LEN, (u8 *)Ch1DmaTxBuffer, TXPATH) ;
	Bd_Start(Ch1BdTxChainBuffer, BD_COUNT, &Ch1AxiDma, TXPATH) ;


	while(1)
	{
		if (ch0_key_flag)
		{
			if (ch0_wave_sel == 4)
				ch0_wave_sel = 0 ;
			else
				ch0_wave_sel++ ;

			wave_switch(ch0_wave_sel, CH0_MAX_PKT_LEN, CH0_MAX_AMP_VAL, CH0_AMP_VAL, Ch0WaveBuffer) ;

			memcpy(Ch0DmaTxBuffer, Ch0WaveBuffer, ADC_BYTE*CH0_MAX_PKT_LEN) ;
			Xil_DCacheFlushRange((UINTPTR)Ch0DmaTxBuffer, ADC_BYTE*CH0_MAX_PKT_LEN);

			/* Clear flag */
			ch0_key_flag = 0 ;
		}


		if (ch1_key_flag)
		{
			if (ch1_wave_sel == 4)
				ch1_wave_sel = 0 ;
			else
				ch1_wave_sel++ ;

			wave_switch(ch1_wave_sel, CH1_MAX_PKT_LEN, CH1_MAX_AMP_VAL, CH1_AMP_VAL, Ch1WaveBuffer) ;

			memcpy(Ch1DmaTxBuffer, Ch1WaveBuffer, ADC_BYTE*CH1_MAX_PKT_LEN) ;
			Xil_DCacheFlushRange((UINTPTR)Ch1DmaTxBuffer, ADC_BYTE*CH1_MAX_PKT_LEN);

			/* Clear flag */
			ch1_key_flag = 0 ;
		}

	}
}

/*
 * switch wave
 */
void wave_switch(int wave_sel, int pkg_len, int max_amp_val, int amp_val, u16 *wave_buffer)
{
	switch(wave_sel)
	{
	case 0 : GetSinWave(pkg_len, max_amp_val, amp_val, wave_buffer) ; break ;
	case 1 : GetSquareWave(pkg_len, max_amp_val, amp_val, wave_buffer) ; break ;
	case 2 : GetTriangleWave(pkg_len, max_amp_val, amp_val, wave_buffer) ; break ;
	case 3 : GetSawtoothWave(pkg_len, max_amp_val, amp_val, wave_buffer) ; break ;
	case 4 : GetSubSawtoothWave(pkg_len, max_amp_val, amp_val, wave_buffer) ; break ;
	default: GetSinWave(pkg_len, max_amp_val, amp_val, wave_buffer) ; break ;
	}
}

/*
 * Set up PS key and enable GPIO interrupt
 */
int PsKeySetup(XScuGic *InstancePtr, u16 IntrID, XGpioPs *GpioInstancePtr)
{
	XGpioPs_Config *GPIO_CONFIG ;
	int Status ;

	GPIO_CONFIG = XGpioPs_LookupConfig(MIO_0_ID) ;
	Status = XGpioPs_CfgInitialize(GpioInstancePtr, GPIO_CONFIG, GPIO_CONFIG->BaseAddr) ;
	if (Status != XST_SUCCESS)
	{
		return XST_FAILURE ;
	}
	//set MIO 50 as input
	XGpioPs_SetDirectionPin(GpioInstancePtr, 50, GPIO_INPUT) ;
	//set interrupt type
	XGpioPs_SetIntrTypePin(GpioInstancePtr, 50, XGPIOPS_IRQ_TYPE_EDGE_RISING) ;


	//set priority and trigger type
	XScuGic_SetPriorityTriggerType(InstancePtr, IntrID,
			0xA0, 0x3);
	Status = XScuGic_Connect(InstancePtr, IntrID,
			(Xil_ExceptionHandler)PsGpioHandler,
			(void *)GpioInstancePtr) ;

	XScuGic_Enable(InstancePtr, IntrID) ;

	if (Status != XST_SUCCESS) {
		return Status;
	}


	XGpioPs_IntrEnablePin(GpioInstancePtr, 50) ;

	return XST_SUCCESS ;
}

/*
 * Set up PL key and enable GPIO interrupt
 */
int PLKeySetup(XScuGic *InstancePtr, u16 IntrID, XGpio *GpioInstancePtr)
{
	int Status ;

	/* initial gpio key */
	Status = XGpio_Initialize(GpioInstancePtr, KEY_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	/* set key as input */
	XGpio_SetDataDirection(GpioInstancePtr, KEY_CHANNEL, 0x1);


	/* Enable key interrupt */
	XGpio_InterruptGlobalEnable(GpioInstancePtr) ;
	XGpio_InterruptEnable(GpioInstancePtr, XGPIO_IR_CH1_MASK) ;

	Status = XScuGic_Connect(InstancePtr, IntrID,
			(Xil_ExceptionHandler)PlGpioHandler,
			(void *)GpioInstancePtr) ;

	XScuGic_Enable(InstancePtr, IntrID) ;

	return XST_SUCCESS ;
}


/*
 * Initial DMA and enable MM2S interrupt
 */
int XAxiDma_Initial(u16 DeviceId, u16 IntrID, XAxiDma *XAxiDma, XScuGic *InstancePtr)
{
	XAxiDma_Config *CfgPtr;
	int Status;
	/* Initialize the XAxiDma device. */
	CfgPtr = XAxiDma_LookupConfig(DeviceId);
	if (!CfgPtr) {
		xil_printf("No config found for %d\r\n", DeviceId);
		return XST_FAILURE;
	}

	Status = XAxiDma_CfgInitialize(XAxiDma, CfgPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}

	Status = XScuGic_Connect(InstancePtr, IntrID,
			(Xil_ExceptionHandler)DAC_Interrupt_Handler,
			(void *)XAxiDma) ;

	if (Status != XST_SUCCESS) {
		return Status;
	}

	XScuGic_Enable(InstancePtr, IntrID);


	/* Disable S2MM interrupt, Enable MM2S interrupt */
	XAxiDma_IntrDisable(XAxiDma, XAXIDMA_IRQ_ALL_MASK,
			XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrEnable(XAxiDma, XAXIDMA_IRQ_IOC_MASK,
			XAXIDMA_DMA_TO_DEVICE);

	return XST_SUCCESS ;
}

/*
 * Initial interrupt GIC
 */
int SetInterruptInit(XScuGic *InstancePtr, u16 IntID)
{

	XScuGic_Config * Config ;
	int Status ;

	Config = XScuGic_LookupConfig(IntID) ;

	Status = XScuGic_CfgInitialize(&INST, Config, Config->CpuBaseAddress) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;


	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler) XScuGic_InterruptHandler,
			InstancePtr);

	Xil_ExceptionEnable();


	return XST_SUCCESS ;

}


void DAC_Interrupt_Handler(void *CallBackRef)
{
	XAxiDma *XAxiDmaPtr = (XAxiDma *) CallBackRef ;
	int mm2s_sr ;

	mm2s_sr = XAxiDma_IntrGetIrq(XAxiDmaPtr, XAXIDMA_DMA_TO_DEVICE) ;

	if (mm2s_sr & XAXIDMA_IRQ_IOC_MASK)
	{
		/* Clear interrupt */
		XAxiDma_IntrAckIrq(XAxiDmaPtr, XAXIDMA_IRQ_IOC_MASK,
				XAXIDMA_DMA_TO_DEVICE) ;
		/*
		 * Clear BD Status and Start Channel 0
		 */
		if (XAxiDmaPtr->RegBase == CH0_DMA_BASE)
		{
			Bd_StatusClr(Ch0BdTxChainBuffer, BD_COUNT) ;
			Bd_Start(Ch0BdTxChainBuffer, BD_COUNT, &Ch0AxiDma, TXPATH) ;
		}
		/*
		 * Clear BD Status and Start Channel 1
		 */
		else if (XAxiDmaPtr->RegBase == CH1_DMA_BASE)
		{
			Bd_StatusClr(Ch1BdTxChainBuffer, BD_COUNT) ;
			Bd_Start(Ch1BdTxChainBuffer, BD_COUNT, &Ch1AxiDma, TXPATH) ;
		}
	}
}


void PsGpioHandler(void *CallbackRef)
{
	XGpioPs *GpioInstancePtr = (XGpioPs *)CallbackRef ;
	int Int_val ;

	Int_val = XGpioPs_IntrGetStatusPin(GpioInstancePtr, 50) ;
	/* clear key interrupt */
	XGpioPs_IntrClearPin(GpioInstancePtr, 50) ;
	if (Int_val)
		ch0_key_flag = 1 ;

}

void PlGpioHandler(void *CallbackRef)
{
	XGpio *GpioInstancePtr = (XGpio *)CallbackRef ;
	int Int_val ;
	int key_val ;

	Int_val = XGpio_InterruptGetStatus(GpioInstancePtr);
	key_val = XGpio_DiscreteRead(GpioInstancePtr, KEY_CHANNEL) ;
	/* Clear Interrupt */
	XGpio_InterruptClear(GpioInstancePtr, XGPIO_IR_CH1_MASK) ;

	if (Int_val & ~key_val)
		ch1_key_flag = 1 ;
}
