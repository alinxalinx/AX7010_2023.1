/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "adc_dma_ctrl.h"
#include "wave/wave.h"
#include "dma_bd/dma_bd.h"
/*
 * DMA s2mm receiver buffer
 */
short CH0DmaRxBuffer[MAX_DMA_LEN/sizeof(short)]  __attribute__ ((aligned(64)));
short CH1DmaRxBuffer[MAX_DMA_LEN/sizeof(short)]  __attribute__ ((aligned(64)));
/*
 * BD buffer
 */
u32 Ch0BdChainBuffer[BD_ALIGNMENT*16] __attribute__ ((aligned(64)));
u32 Ch1BdChainBuffer[BD_ALIGNMENT*16] __attribute__ ((aligned(64)));
/*
 * Grid buffer
 */
u8 GridBuffer[WAVE_LEN] ;
/*
 * Wave buffer
 */
u8 WaveBuffer[WAVE_LEN] ;
/*
 * DMA struct
 */
XAxiDma AxiDmaCh0;
XAxiDma AxiDmaCh1;
/*
 * s2mm interrupt flag
 */
volatile int ch0_s2mm_flag ;
volatile int ch1_s2mm_flag ;
/*
 * Function declaration
 */
int XAxiDma_Initial(u16 DeviceId, u16 IntrID, XAxiDma *XAxiDma, XScuGic *InstancePtr) ;
void Dma_Interrupt_Handler(void *CallBackRef);
void ad9238_sample(u32 adc_addr, u32 adc_len) ;
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
	int Status;
	u32 wave_width = width ;

	ch0_s2mm_flag = 1 ;
	ch1_s2mm_flag = 1 ;

	XAxiDma_Initial(CH0_DMA_DEV_ID, CH0_S2MM_INTR_ID, &AxiDmaCh0, InstancePtr) ;
	XAxiDma_Initial(CH1_DMA_DEV_ID, CH1_S2MM_INTR_ID, &AxiDmaCh1, InstancePtr) ;

	/* Create BD chain */
	CreateBdChain(Ch0BdChainBuffer, BD_COUNT, ADC_BYTE*ADC_CAPTURELEN, (u8 *)CH0DmaRxBuffer, RXPATH) ;
	CreateBdChain(Ch1BdChainBuffer, BD_COUNT, ADC_BYTE*ADC_CAPTURELEN, (u8 *)CH1DmaRxBuffer, RXPATH) ;

	/* Grid Overlay */
	draw_grid(wave_width, WAVE_HEIGHT,GridBuffer) ;

	while(1)
	{

		if (ch0_s2mm_flag & ch1_s2mm_flag)
		{
			/* clear s2mm_flag */
			ch0_s2mm_flag = 0 ;
			ch1_s2mm_flag = 0 ;

			/* Clear BD Status */
			Bd_StatusClr(Ch0BdChainBuffer, BD_COUNT) ;
			Bd_StatusClr(Ch1BdChainBuffer, BD_COUNT) ;

			/* Copy grid to Wave buffer */
			memcpy(WaveBuffer, GridBuffer, WAVE_LEN) ;
			/* channel 0 Overlay */
			draw_wave(wave_width, WAVE_HEIGHT, (void *)CH0DmaRxBuffer, WaveBuffer, UNSIGNEDSHORT, ADC_BITS, YELLOW, ADC_COE) ;
			/* channel 1 Overlay */
			draw_wave(wave_width, WAVE_HEIGHT, (void *)CH1DmaRxBuffer, WaveBuffer, UNSIGNEDSHORT, ADC_BITS, RED, ADC_COE) ;

			/* Copy Canvas to frame buffer */
			frame_copy(wave_width, WAVE_HEIGHT, stride, WAVE_START_COLUMN, WAVE_START_ROW, frame, WaveBuffer) ;


			/* delay 100ms */
			usleep(100000) ;

			/* Start Channel 0 sample */
			ad9238_sample(AD9238_CH0_BASE, ADC_CAPTURELEN)  ;
			/* Start Channel 0 sample */
			ad9238_sample(AD9238_CH1_BASE, ADC_CAPTURELEN)  ;

			/* start DMA translation from AD9226 channel 0 to DDR3 */
			Bd_Start(Ch0BdChainBuffer, BD_COUNT, &AxiDmaCh0, RXPATH) ;
			/* start DMA translation from AD9226 channel 1 to DDR3 */
			Bd_Start(Ch1BdChainBuffer, BD_COUNT, &AxiDmaCh1, RXPATH) ;

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
void ad9238_sample(u32 adc_addr, u32 adc_len)
{
	/* provide length to AD9238 channel */
	AD9238_SAMPLE_mWriteReg(adc_addr, AD9238_LENGTH, adc_len)  ;
	/* start sample AD9238 channel */
	AD9238_SAMPLE_mWriteReg(adc_addr, AD9238_START, 1) ;
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


		if (XAxiDmaPtr->RegBase == CH0_DMA_BASE)
		{
			/* Invalidate the Data cache for the given address range */
			Xil_DCacheInvalidateRange((INTPTR)CH0DmaRxBuffer, ADC_BYTE*ADC_CAPTURELEN);
			ch0_s2mm_flag = 1 ;
		}

		else if (XAxiDmaPtr->RegBase == CH1_DMA_BASE)
		{
			/* Invalidate the Data cache for the given address range */
			Xil_DCacheInvalidateRange((INTPTR)CH1DmaRxBuffer, ADC_BYTE*ADC_CAPTURELEN);
			ch1_s2mm_flag = 1 ;
		}

	}
}


