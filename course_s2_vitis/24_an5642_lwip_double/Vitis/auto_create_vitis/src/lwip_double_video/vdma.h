
#ifndef VDMA_H_
#define VDMA_H_

#include "xaxivdma.h"


int vdma_read_init(short DeviceID,short HoriSizeInput,short VertSizeInput,short Stride,unsigned int FrameStoreStartAddr);
int vdma_write_init(short DeviceID,XAxiVdma *Vdma,short HoriSizeInput,short VertSizeInput,short Stride,unsigned int FrameStoreStartAddr0,unsigned int FrameStoreStartAddr1,unsigned int FrameStoreStartAddr2);
u32 vdma_version();

int vdma_write_stop(XAxiVdma *Vdma) ;
int vdma_write_start(XAxiVdma *Vdma) ;

#endif /* VDMA_H_ */
