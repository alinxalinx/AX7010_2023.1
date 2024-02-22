/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */
#include "dma_bd.h"

/*
 * Create buffer descriptor
 *
 *@param BdDesptr         Buffer Descriptor pointer
 *@param BdCount          BD count
 *@param TotalByteLen     Total byte length will be transferred
 *@param DmaBufferPtr     DMA buffer pointer
 *@param Direction        TXPATH and RXPATH
 *
 *@note  create buffer descriptor with continuous DMA buffer address, divide into BdCount parts
 *
 */
int CreateBdChain(u32 *BdDesptr, u16 BdCount, u32 TotalByteLen, u8 *DmaBufferPtr, u32 Direction)
{
	int i ;

	u32 *BdPtrCurr ;
	u32 *BdPtrNext ;

	u8 *RxBufCurr ;

	/* BD is 16 words alignment, every word is 4 bytes*/
	u32 Bd_Align = BD_ALIGNMENT/sizeof(u32) ;

	/* Current BD pointer and Next BD pointer */
	BdPtrCurr = BdDesptr ;
	BdPtrNext = BdDesptr + Bd_Align ;

	/* DMA buffer pointer */
	RxBufCurr = DmaBufferPtr ;

	/* Set all content to 0 */
	memset(BdDesptr, 0, BdCount*BD_ALIGNMENT) ;

	for(i = 0 ; i < BdCount ; i++)
	{
		/* Write to Next descriptor point Lower 32bit */
		XAxiDma_BdWrite(BdPtrCurr, XAXIDMA_BD_NDESC_OFFSET, (u32)BdPtrNext & XAXIDMA_DESC_LSB_MASK) ;
		/* Write to Buffer Address Lower 32bit */
		XAxiDma_BdWrite(BdPtrCurr, XAXIDMA_BD_BUFA_OFFSET, (u32)RxBufCurr) ;
		/* Write to length field */
		if (Direction == TXPATH)
		{
			if (i == 0)
				XAxiDma_BdWrite(BdPtrCurr, XAXIDMA_BD_CTRL_LEN_OFFSET, (u32)(TotalByteLen/BdCount) | XAXIDMA_BD_CTRL_TXSOF_MASK) ;
			else if (i == BdCount - 1)
				XAxiDma_BdWrite(BdPtrCurr, XAXIDMA_BD_CTRL_LEN_OFFSET, (u32)(TotalByteLen/BdCount) | XAXIDMA_BD_CTRL_TXEOF_MASK) ;
			else
				XAxiDma_BdWrite(BdPtrCurr, XAXIDMA_BD_CTRL_LEN_OFFSET, (u32)(TotalByteLen/BdCount) ) ;
		}
		else
			XAxiDma_BdWrite(BdPtrCurr, XAXIDMA_BD_CTRL_LEN_OFFSET, (u32)(TotalByteLen/BdCount) ) ;

		if (i < BdCount - 2)
		{
			BdPtrCurr += Bd_Align ;
			BdPtrNext += Bd_Align ;
		}
		else
		{
			BdPtrCurr += Bd_Align ;
			BdPtrNext = BdDesptr ;
		}
		/* Provide next DmaRxBuffer address */
		RxBufCurr += TotalByteLen/BdCount ;

	}

	Xil_DCacheFlushRange((INTPTR) BdDesptr, BdCount*BD_ALIGNMENT) ;

	return XST_SUCCESS ;

}

/*
 * Start BD fetching, write CURDESC register, DMACR register, TAILDESC register, after write TAILDESC, SG will start to fetch Descriptor
 *
 *@param BdDesptr         Buffer Descriptor pointer
 *@param BdCount          BD count
 *@param XAxiDmaPtr       DMA pointer
 *@param Direction        TXPATH and RXPATH
 *
 *@note  none
 */
int Bd_Start(u32 *BdDesptr, u16 BdCount, XAxiDma *XAxiDmaPtr, u32 Direction)
{
	u32 *BdPtrLast ;
	XAxiDma_BdRing * RingPtr ;

	if (Direction == TXPATH)
		RingPtr = XAxiDma_GetTxRing(XAxiDmaPtr);
	else
		RingPtr = XAxiDma_GetRxRing(XAxiDmaPtr);
	/* The Last BD address */
	BdPtrLast = BdDesptr + (BdCount - 1) * (BD_ALIGNMENT/sizeof(u32)) ;

	/* Write current descriptor pointer to DMA register */
	XAxiDma_BdWrite(RingPtr->ChanBase, XAXIDMA_CDESC_OFFSET, (u32)BdDesptr & XAXIDMA_DESC_LSB_MASK) ;
	/* Start DMA */
	XAxiDma_BdWrite(RingPtr->ChanBase, XAXIDMA_CR_OFFSET,
			XAxiDma_ReadReg(RingPtr->ChanBase, XAXIDMA_CR_OFFSET) | XAXIDMA_CR_RUNSTOP_MASK) ;

	/* Write Tail descriptor pointer to DMA register, once it is written, SG will start fetching current descriptor pointer */
	if (XAxiDma_BdRingHwIsStarted(RingPtr))
		XAxiDma_BdWrite(RingPtr->ChanBase, XAXIDMA_TDESC_OFFSET, (u32)BdPtrLast & XAXIDMA_DESC_LSB_MASK) ;

	return XST_SUCCESS ;
}

/*
 * Clear BD status before Bd_Start, or SG will not start
 *
 *@param BdDesptr         Buffer Descriptor pointer
 *@param BdCount          BD count
 *
 *@note  none
 */
void Bd_StatusClr(u32 *BdDesptr, u16 BdCount)
{
	int i ;
	u32 *BdPtrCurr = BdDesptr ;
	/* BD is 16 words alignment, every word is 4 bytes*/
	u32 Bd_Align = BD_ALIGNMENT/sizeof(u32) ;

	for(i = 0 ; i < BdCount ; i ++)
	{
		XAxiDma_BdWrite(BdPtrCurr, XAXIDMA_BD_STS_OFFSET, 0) ;
		BdPtrCurr += Bd_Align ;
	}
	Xil_DCacheFlushRange((INTPTR) BdDesptr, BdCount*BD_ALIGNMENT) ;
}

