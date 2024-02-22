/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "adc_dma_ctrl.h"
#include "wave/wave.h"
/*
 * DMA s2mm receiver buffer
 */
#define DMA_LEN      MAX_DMA_LEN/sizeof(short)
#define DMA_LEN_TMP  MAX_DMA_LEN/(ADC_CH_COUNT*sizeof(short))

short DmaRxBuffer[DMA_LEN]  __attribute__ ((aligned(64)));
short DmaRxBufferTmp[ADC_CH_COUNT][DMA_LEN_TMP]  __attribute__ ((aligned(64)));
/*
 * Canvas buffer for drawing grid and wave
 */
u8 CanvasBuffer[CANVAS_LEN] ;
/*
 * DMA struct
 */
XAxiDma AxiDma;
/*
 * s2mm interrupt flag
 */
volatile int s2mm_flag ;
/*
 * Function declaration
 */
int XAxiDma_Initial(u16 DeviceId, u16 IntrID, XAxiDma *XAxiDma, XScuGic *InstancePtr) ;
void Dma_Interrupt_Handler(void *CallBackRef);
void ad7606_sample(u32 adc_addr, u32 adc_len) ;
void frame_copy(u32 width, u32 height, u32 stride, int hor_x, int ver_y, u8 *frame, u8 *CanvasBufferPtr) ;
/*
 *Initial DMA,Draw grid and wave,Start ADC sample
 *
 *@param width is frame width
 *@param frame is display frame pointer
 *@param stride is frame stride
 *@param InstancePtr is GIC pointer
 */
int XAxiDma_Adc_Wave(u32 width, u8 *frame, u32 stride, XScuGic *InstancePtr)
{
	int Status ;
	int i,j ;
	u32 wave_width = width ;

	s2mm_flag = 1 ;

	XAxiDma_Initial(DMA_DEV_ID, S2MM_INTR_ID, &AxiDma, InstancePtr) ;


	while(1)
	{

		if (s2mm_flag)
		{
			/* clear s2mm_flag */
			s2mm_flag = 0 ;


			/* Adjust ADC order */
			for(i = 0; i < 8 ; i++)
			{
				for(j = 0 ; j < width ; j++)
				{
					DmaRxBufferTmp[i][j] = DmaRxBuffer[8*j + i] ;
				}
			}

			/* Background and Grid Overlay */
			draw_grid(wave_width, WAVE_HEIGHT,CanvasBuffer) ;

			/* Wave Overlay */
			for(i = 0; i < 8 ; i++)
			{
				draw_wave(wave_width, WAVE_HEIGHT, (void *)DmaRxBufferTmp[i], CanvasBuffer, SHORT, ADC_BITS, i, ADC_COE+10*i) ;
			}

			/* Copy Canvas to frame buffer */
			frame_copy(wave_width, WAVE_HEIGHT, stride, WAVE_START_COLUMN, WAVE_START_ROW, frame, CanvasBuffer) ;

			/* delay 100ms */
			usleep(100000) ;

			/* Start Sample AD7606 */
			ad7606_sample(AD7606_BASE, ADC_CAPTURELEN)  ;

			/* start DMA translation from AD7606 */
			Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) DmaRxBuffer,
					ADC_BYTE*ADC_CH_COUNT*ADC_CAPTURELEN, XAXIDMA_DEVICE_TO_DMA);
			if (Status != XST_SUCCESS) {
				return XST_FAILURE;
			}

		}
	}
	return XST_SUCCESS ;
}

/*
 *This is ADC sample function, use it and start sample adc data
 *
 *@param adc_addr ADC base address
 *@param adc_len is sample length in ADC data width
 */
void ad7606_sample(u32 adc_addr, u32 adc_len)
{
	/* provide length to AD7606 */
	AD7606_SAMPLE_mWriteReg(adc_addr, AD7606_LENGTH, adc_len)  ;
	/* start sample AD7606 */
	AD7606_SAMPLE_mWriteReg(adc_addr, AD7606_START, 1) ;
}

/*
 *Copy canvas buffer data to special position in frame
 *
 *@param hor_x  start horizontal position for copy
 *@param ver_y  start vertical position for copy
 *@param width  width for copy
 *@param height height for copy
 *
 *@note  hor_x+width should be less than frame width, ver_y+height should be less than frame height
 */
void frame_copy(u32 width, u32 height, u32 stride, int hor_x, int ver_y, u8 *frame, u8 *CanvasBufferPtr)
{
	int i ;
	u32 FrameOffset ;
	u32 CanvasOffset ;
	u32 CopyLen = width*BYTES_PIXEL ;

	for(i = 0 ; i < height;  i++)
	{
		FrameOffset = (ver_y+i)*stride + hor_x*BYTES_PIXEL ;
		CanvasOffset = i*width*BYTES_PIXEL ;
		memcpy(frame+FrameOffset, CanvasBufferPtr+CanvasOffset, CopyLen) ;
	}

	FrameOffset = ver_y*stride ;

	Xil_DCacheFlushRange((INTPTR) frame+FrameOffset, height*stride) ;
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


	/* Disable MM2S interrupt, Enable S2MM interrupt */
	XAxiDma_IntrEnable(XAxiDma, XAXIDMA_IRQ_IOC_MASK,
			XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(XAxiDma, XAXIDMA_IRQ_ALL_MASK,
			XAXIDMA_DMA_TO_DEVICE);

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

	int s2mm_sr ;

	s2mm_sr = XAxiDma_IntrGetIrq(XAxiDmaPtr, XAXIDMA_DEVICE_TO_DMA) ;

	if (s2mm_sr & XAXIDMA_IRQ_IOC_MASK)
	{
		/* Clear interrupt */
		XAxiDma_IntrAckIrq(XAxiDmaPtr, XAXIDMA_IRQ_IOC_MASK,
				XAXIDMA_DEVICE_TO_DMA) ;
		/* Invalidate the Data cache for the given address range */
		Xil_DCacheInvalidateRange((INTPTR)DmaRxBuffer, ADC_BYTE*ADC_CH_COUNT*ADC_CAPTURELEN);

		s2mm_flag = 1 ;
	}

}


