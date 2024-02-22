/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "dma_ctrl.h"
#include "dma_bd/dma_bd.h"
#include "xgpiops.h"

/*
 * BD buffer
 */
u32 BdTxChainBuffer[BD_ALIGNMENT*16] __attribute__ ((aligned(64)));
u32 BdRxChainBuffer[BD_ALIGNMENT*16] __attribute__ ((aligned(64)));
/*
 * DMA struct
 */
XAxiDma AxiDma;
/*
 * s2mm interrupt flag
 */
volatile int s2mm_flag = 0 ;
volatile int mm2s_flag = 0 ;


extern XGpioPs Gpio;
extern volatile int key_flag ;
extern volatile int key_hold ;
/*
 * Function declaration
 */
int XAxiDma_Initial(u16 DeviceId, u16 S2mm_IntrID, u16 Mm2s_IntrID, XAxiDma *XAxiDma, XScuGic *InstancePtr) ;
void Dma_Interrupt_Handler(void *CallBackRef);
/*
 *Initial DMA,Start audio record and play
 *
 *@param Databuf is buffer pointer
 *@param length is transfer length
 *@param AudioInstance is audio pointer
 *@param InstancePtr is GIC pointer
 */
int XAxiDma_Audio_Record_Play(XScuGic *InstancePtr, Audio *AudioInstance, u32 length, u32 *Databuf)
{

	/* Initial DMA, enable s2mm and mm2s interrupt */
	XAxiDma_Initial(DMA_DEV_ID, S2MM_INTR_ID, MM2S_INTR_ID, &AxiDma, InstancePtr) ;

	/* Create BD chain */
	CreateBdChain(BdTxChainBuffer, BD_COUNT, length * sizeof(u32) , (u8 *)Databuf, TXPATH) ;

	/* Create BD chain */
	CreateBdChain(BdRxChainBuffer, BD_COUNT, length * sizeof(u32) , (u8 *)Databuf, RXPATH) ;


	while(1) {

		if (key_flag == 1){

			key_flag = 2 ;

			key_hold = 1 ;

			XGpioPs_WritePin(&Gpio, RECORD_LED, LED_ON);
			/* Start DMA transfer */
			Bd_Start(BdRxChainBuffer, BD_COUNT, &AxiDma, RXPATH) ;
			/* Enable RX channel */
			audio_txrx_enable(AudioInstance, RX_ENABLE_MASK) ;
		}

		if (key_flag == 3){

			key_flag = 0 ;

			key_hold = 1 ;

			XGpioPs_WritePin(&Gpio, PLAY_LED, LED_ON);
			/* Start DMA transfer */
			Bd_Start(BdTxChainBuffer, BD_COUNT, &AxiDma, TXPATH) ;
			/* Enable TX channel */
			audio_txrx_enable(AudioInstance, TX_ENABLE_MASK) ;

		}

		if (s2mm_flag)
		{
			/* clear s2mm_flag */
			s2mm_flag = 0 ;
			/* disable RX channel */
			audio_txrx_disable(AudioInstance, RX_ENABLE_MASK) ;

			XGpioPs_WritePin(&Gpio, RECORD_LED, LED_OFF);
			/* Clear BD Status */
			Bd_StatusClr(BdRxChainBuffer, BD_COUNT) ;

			key_hold = 0 ;
		}

		if (mm2s_flag)
		{
			/* clear s2mm_flag */
			mm2s_flag = 0 ;
			/* disable TX channel */
			audio_txrx_disable(AudioInstance, TX_ENABLE_MASK) ;

			XGpioPs_WritePin(&Gpio, PLAY_LED, LED_OFF);
			/* Clear BD Status */
			Bd_StatusClr(BdTxChainBuffer, BD_COUNT) ;

			key_hold = 0 ;
		}
	}
}



/*
 *Initial DMA and connect interrupt to handler, open s2mm interrupt
 *
 *@param DeviceId    DMA device id
 *@param IntrID      DMA interrupt id
 *@param XAxiDma     DMA pointer
 *@param InstancePtr GIC pointer
 *
 *@note  none
 */
int XAxiDma_Initial(u16 DeviceId, u16 S2mm_IntrID, u16 Mm2s_IntrID, XAxiDma *XAxiDma, XScuGic *InstancePtr)
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

	Status = XScuGic_Connect(InstancePtr, S2mm_IntrID,
			(Xil_ExceptionHandler)Dma_Interrupt_Handler,
			(void *)XAxiDma) ;

	if (Status != XST_SUCCESS) {
		return Status;
	}

	XScuGic_Enable(InstancePtr, S2mm_IntrID);

	Status = XScuGic_Connect(InstancePtr, Mm2s_IntrID,
			(Xil_ExceptionHandler)Dma_Interrupt_Handler,
			(void *)XAxiDma) ;

	if (Status != XST_SUCCESS) {
		return Status;
	}

	XScuGic_Enable(InstancePtr, Mm2s_IntrID);


	/* Enable MM2S and S2MM interrupt */
	XAxiDma_IntrEnable(XAxiDma, XAXIDMA_IRQ_ALL_MASK,
			XAXIDMA_DMA_TO_DEVICE);
	XAxiDma_IntrEnable(XAxiDma, XAXIDMA_IRQ_ALL_MASK,
			XAXIDMA_DEVICE_TO_DMA);

	return XST_SUCCESS ;
}


/*
 *callback function
 *Check interrupt status and assert s2mm flag
 */
void Dma_Interrupt_Handler(void *CallBackRef)
{
	XAxiDma *XAxiDmaPtr ;
	XAxiDmaPtr = (XAxiDma *) CallBackRef ;

	int mm2s_sr ;
	int s2mm_sr ;

	mm2s_sr = XAxiDma_IntrGetIrq(XAxiDmaPtr, XAXIDMA_DMA_TO_DEVICE) ;
	s2mm_sr = XAxiDma_IntrGetIrq(XAxiDmaPtr, XAXIDMA_DEVICE_TO_DMA) ;

	if (mm2s_sr & XAXIDMA_IRQ_IOC_MASK)
	{
		/* Clear interrupt */
		XAxiDma_IntrAckIrq(XAxiDmaPtr, XAXIDMA_IRQ_IOC_MASK,
				XAXIDMA_DMA_TO_DEVICE) ;

		mm2s_flag = 1 ;
	}

	if (s2mm_sr & XAXIDMA_IRQ_IOC_MASK)
	{
		/* Clear interrupt */
		XAxiDma_IntrAckIrq(XAxiDmaPtr, XAXIDMA_IRQ_IOC_MASK,
				XAXIDMA_DEVICE_TO_DMA) ;

		s2mm_flag = 1 ;
	}

}


