/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */


#include "xaxidma.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "ad9708_send.h"
#include "wave.h"
#include "xgpiops.h"


/*
 * AD9708 definitions
 */
#define AD9708_BASE        XPAR_AD9708_SEND_0_S00_AXI_BASEADDR
#define AD9708_START       AD9708_SEND_S00_AXI_SLV_REG0_OFFSET
#define AD9708_LENGTH      AD9708_SEND_S00_AXI_SLV_REG1_OFFSET
/*
 * Interrupt definitions
 */
#define INT_DEVICE_ID      XPAR_SCUGIC_SINGLE_DEVICE_ID
#define MM2S_INTR_ID       XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR
#define KEY_INTR_ID        XPAR_XGPIOPS_0_INTR
/*
 * Wave Parameter definitions
 */
#define MAX_PKT_LEN		   4096	/* must be bigger than 1024, or FIFO will be empty */
#define MAX_AMP_VAL        256	/* 2^8, do not change */
#define AMP_VAL            256	/* must be less than 2^8 */
/*
 * Device id definitions
 */
#define DMA_DEV_ID		   XPAR_AXIDMA_0_DEVICE_ID
#define MIO_0_ID           XPAR_PS7_GPIO_0_DEVICE_ID

#define GPIO_INPUT         0
/*
 * Function definitions
 */
int XAxiDma_DAC(u16 DeviceId);
void DAC_Interrupt_Handler(void *CallBackRef) ;
int XAxiDma_Initial(u16 DeviceId, u16 IntrID, XAxiDma *XAxiDma, XScuGic *InstancePtr) ;
int SetInterruptInit(XScuGic *InstancePtr, u16 IntID) ;
int KeySetup(XScuGic *InstancePtr, u16 IntrID, XGpioPs *GpioInstancePtr) ;
void GpioHandler(void *CallbackRef);

XScuGic INST ;

XAxiDma AxiDma;

XGpioPs GPIO_PTR ;

volatile int key_flag ;

/*
 * DMA buffer to MM2S
 */
u8 DmaTxBuffer[MAX_PKT_LEN] __attribute__ ((aligned(64)));
/*
 * wave buffer
 */
u8 WaveBuffer[MAX_PKT_LEN] __attribute__ ((aligned(64)));


int main()
{
	int Status;

	Status = SetInterruptInit(&INST, INT_DEVICE_ID) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	KeySetup(&INST, KEY_INTR_ID, &GPIO_PTR) ;

	Status = XAxiDma_DAC(DMA_DEV_ID);

	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	return XST_SUCCESS;

}




int XAxiDma_DAC(u16 DeviceId)
{

	int wave_sel = 0;

	/* Initialize DMA and enable MM2S interrupt */
	XAxiDma_Initial(DeviceId, MM2S_INTR_ID, &AxiDma, &INST) ;
	/* Create initial wave data */
	GetSinWave(MAX_PKT_LEN, MAX_AMP_VAL, AMP_VAL, WaveBuffer) ;
	/* Copy wave data to DMA buffer */
	memcpy(DmaTxBuffer, WaveBuffer, MAX_PKT_LEN) ;
	Xil_DCacheFlushRange((UINTPTR)DmaTxBuffer, MAX_PKT_LEN);

	AD9708_SEND_mWriteReg(AD9708_BASE, AD9708_START, 1) ;

	XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) DmaTxBuffer,
			MAX_PKT_LEN, XAXIDMA_DMA_TO_DEVICE);

	while(1)
	{
		if (key_flag)
		{
			switch(wave_sel)
			{
			case 0 : GetSquareWave(MAX_PKT_LEN, MAX_AMP_VAL, AMP_VAL, WaveBuffer) ; break ;
			case 1 : GetTriangleWave(MAX_PKT_LEN, MAX_AMP_VAL, AMP_VAL, WaveBuffer) ; break ;
			case 2 : GetSawtoothWave(MAX_PKT_LEN, MAX_AMP_VAL, AMP_VAL, WaveBuffer) ; break ;
			case 3 : GetSubSawtoothWave(MAX_PKT_LEN, MAX_AMP_VAL, AMP_VAL, WaveBuffer) ; break ;
			case 4 : GetSinWave(MAX_PKT_LEN, MAX_AMP_VAL, AMP_VAL, WaveBuffer) ; break ;
			default: GetSinWave(MAX_PKT_LEN, MAX_AMP_VAL, AMP_VAL, WaveBuffer) ; break ;
			}

			memcpy(DmaTxBuffer, WaveBuffer, MAX_PKT_LEN) ;
			Xil_DCacheFlushRange((UINTPTR)DmaTxBuffer, MAX_PKT_LEN);

			if (wave_sel == 4)
				wave_sel = 0 ;
			else
				wave_sel++ ;

			/* Clear flag */
			key_flag = 0 ;
		}

	}

	return XST_SUCCESS;
}

/*
 * Set up key and enable GPIO interrupt
 */
int KeySetup(XScuGic *InstancePtr, u16 IntrID, XGpioPs *GpioInstancePtr)
{
	XGpioPs_Config *GPIO_CONFIG ;
	int Status ;
	key_flag = 0 ;


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
			(Xil_ExceptionHandler)GpioHandler,
			(void *)GpioInstancePtr) ;

	XScuGic_Enable(InstancePtr, IntrID) ;

	if (Status != XST_SUCCESS) {
		return Status;
	}


	XGpioPs_IntrEnablePin(GpioInstancePtr, 50) ;

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
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
			XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_IOC_MASK,
			XAXIDMA_DMA_TO_DEVICE);

	return XST_SUCCESS ;
}


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

		XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) DmaTxBuffer,
				MAX_PKT_LEN, XAXIDMA_DMA_TO_DEVICE);
	}
}


void GpioHandler(void *CallbackRef)
{
	XGpioPs *GpioInstancePtr = (XGpioPs *)CallbackRef ;
	int Int_val ;

	Int_val = XGpioPs_IntrGetStatusPin(GpioInstancePtr, 50) ;
	/* clear key interrupt */
	XGpioPs_IntrClearPin(GpioInstancePtr, 50) ;
	if (Int_val == TRUE)
		key_flag = 1 ;

}
