
#ifndef VDMA_H_
#define VDMA_H_

#include "xaxivdma.h"


int vdma_read_init(short DeviceID, XAxiVdma *Vdma, short HoriSizeInput,short VertSizeInput,short Stride,unsigned int FrameStoreStartAddr0,unsigned int FrameStoreStartAddr1,unsigned int FrameStoreStartAddr2);
int vdma_write_init(short DeviceID,XAxiVdma *Vdma,short HoriSizeInput,short VertSizeInput,short Stride,unsigned int FrameStoreStartAddr, int FrameNum) ;
u32 vdma_version();

int vdma_write_stop(XAxiVdma *Vdma) ;
int vdma_write_start(XAxiVdma *Vdma) ;

int vdma_read_start(XAxiVdma *Vdma) ;
int vdma_read_stop(XAxiVdma *Vdma) ;

#endif /* VDMA_H_ */
