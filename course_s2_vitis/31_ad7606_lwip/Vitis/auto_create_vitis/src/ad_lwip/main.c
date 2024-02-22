/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xscugic.h"
#include "zynq_interrupt.h"
#include "xil_io.h"
#include "sleep.h"
#include "xil_cache.h"
#include "xaxidma.h"
#include "adc_dma.h"
#include "dma_bd/dma_bd.h"
#include "xil_types.h"

#define INT_DEVICE_ID      XPAR_SCUGIC_SINGLE_DEVICE_ID



XScuGic XScuGicInstance;

/*
 * DMA s2mm receiver buffer
 */
short DmaRxBuffer[MAX_DMA_LEN/sizeof(short)]  __attribute__ ((aligned(64)));
short DmaRxBufferTmp[MAX_DMA_LEN/(ADC_CH_COUNT*sizeof(short))]  __attribute__ ((aligned(64)));

/*
 * BD buffer
 */
u32 BdChainBuffer[BD_ALIGNMENT*16] __attribute__ ((aligned(64)));

/*
 * DMA struct
 */
XAxiDma AxiDma;



int s2mm_flag = -1 ;


int XAxiDma_Initial(u16 DeviceId, u16 IntrID, XAxiDma *XAxiDma, XScuGic *InstancePtr) ;
void Dma_Interrupt_Handler(void *CallBackRef);
void XAxiDma_Adc(u32 *BdChainBuffer, u32 adc_addr, u32 adc_len, u16 BdCount, XAxiDma *AxiDma) ;
void ad7606_sample(u32 adc_addr, u32 adc_len) ;

int lwip_loop();

int main()
{
    init_platform();

    InterruptInit(INT_DEVICE_ID,&XScuGicInstance);
    /* Initialize DMA */
    XAxiDma_Initial(DMA_DEV_ID, S2MM_INTR_ID, &AxiDma, &XScuGicInstance) ;

    /* Interrupt register */
    InterruptConnect(&XScuGicInstance,S2MM_INTR_ID,Dma_Interrupt_Handler, &AxiDma,0,3);

    /* Create BD chain */
    CreateBdChain(BdChainBuffer, BD_COUNT, ADC_BYTE*ADC_CH_COUNT*ADC_SAMPLE_NUM, (unsigned char *)DmaRxBuffer, RXPATH) ;


    lwip_loop();
    cleanup_platform();
    return 0;
}

void XAxiDma_Adc(u32 *BdChainBuffer, u32 adc_addr, u32 adc_len, u16 BdCount, XAxiDma *AxiDma)
{
	/* Clear BD Status */
	Bd_StatusClr(BdChainBuffer, BdCount) ;
	/* Start sample */
	ad7606_sample(adc_addr, adc_len)  ;
	/* start DMA translation from ADC to DDR3 */
	Bd_Start(BdChainBuffer, BdCount, AxiDma, RXPATH) ;
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
	//xil_printf("Interrupt Value is 0x%x\r\n", s2mm_sr) ;

	if (s2mm_sr & XAXIDMA_IRQ_IOC_MASK)
	{
		/* Clear interrupt */
		XAxiDma_IntrAckIrq(XAxiDmaPtr, XAXIDMA_IRQ_IOC_MASK,
				XAXIDMA_DEVICE_TO_DMA) ;

			s2mm_flag = 1;
	}
}


/*
 *This is ADC sample function, use it and start sample adc data
 *
 *@param adc_addr ADC base address
 *@param adc_len is sample length
 */
void ad7606_sample(u32 adc_addr, u32 adc_len)
{
	/* provide length to AD7606 */
	AD7606_SAMPLE_mWriteReg(adc_addr, AD7606_LENGTH, adc_len)  ;
	/* start sample AD7606 */
	AD7606_SAMPLE_mWriteReg(adc_addr, AD7606_START, 1) ;
}

