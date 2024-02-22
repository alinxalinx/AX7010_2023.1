/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "dma_ctrl.h"
#include "dma_bd/dma_bd.h"
#include "xgpiops.h"
/*
 * DMA s2mm receiver buffer
 */
u32 DmaTxBuffer[MAX_DMA_LEN]  __attribute__ ((aligned(64)));
/*
 * BD buffer
 */
u32 BdTxChainBuffer[BD_ALIGNMENT*16] __attribute__ ((aligned(64)));
/*
 * DMA struct
 */
XAxiDma AxiDma;
/*
 * s2mm interrupt flag
 */
volatile int mm2s_flag ;


extern XGpioPs Gpio;
/*
 * Function declaration
 */
int XAxiDma_Initial(u16 DeviceId, u16 IntrID, XAxiDma *XAxiDma, XScuGic *InstancePtr) ;
void Dma_Interrupt_Handler(void *CallBackRef);
/*
 *Initial DMA,Start audio record and play
 *
 *@param Databuf is buffer pointer
 *@param length is transfer length
 *@param AudioInstance is audio pointer
 *@param InstancePtr is GIC pointer
 */
int XAxiDma_Audio_Play(XScuGic *InstancePtr, Audio *AudioInstance, u32 length, u32 *Databuf)
{

	XAxiDma_Initial(DMA_DEV_ID, MM2S_INTR_ID, &AxiDma, InstancePtr) ;

	/* Create BD chain */
	CreateBdChain(BdTxChainBuffer, BD_COUNT, length * sizeof(u32) , (u8 *)Databuf, TXPATH) ;

	XGpioPs_WritePin(&Gpio, PLAY_LED, LED_ON);
	/* Start DMA transfer */
	Bd_Start(BdTxChainBuffer, BD_COUNT, &AxiDma, TXPATH) ;
	/* Enable TX channel */
	audio_txrx_enable(AudioInstance, TX_ENABLE_MASK) ;


	while(1) {

		if (mm2s_flag)
		{
			/* clear mm2s_flag */
			mm2s_flag = 0 ;

			XGpioPs_WritePin(&Gpio, PLAY_LED, LED_OFF);
			/* disable TX channel */
			audio_txrx_disable(AudioInstance, TX_ENABLE_MASK) ;
			/* Clear BD Status */
			Bd_StatusClr(BdTxChainBuffer, BD_COUNT) ;

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
			(Xil_ExceptionHandler)Dma_Interrupt_Handler,
			(void *)XAxiDma) ;

	if (Status != XST_SUCCESS) {
		return Status;
	}

	XScuGic_Enable(InstancePtr, IntrID);


	/* Disable S2MM interrupt, Enable MM2S interrupt */
	XAxiDma_IntrEnable(XAxiDma, XAXIDMA_IRQ_IOC_MASK,
			XAXIDMA_DMA_TO_DEVICE);
	XAxiDma_IntrDisable(XAxiDma, XAXIDMA_IRQ_ALL_MASK,
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

	mm2s_sr = XAxiDma_IntrGetIrq(XAxiDmaPtr, XAXIDMA_DMA_TO_DEVICE) ;

	if (mm2s_sr & XAXIDMA_IRQ_IOC_MASK)
	{
		/* Clear interrupt */
		XAxiDma_IntrAckIrq(XAxiDmaPtr, XAXIDMA_IRQ_IOC_MASK,
				XAXIDMA_DMA_TO_DEVICE) ;

		mm2s_flag = 1 ;
	}

}


