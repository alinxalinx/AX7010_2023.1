#ifndef ZYNQ_INTERRUPT_H_
#define ZYNQ_INTERRUPT_H_

#include "xparameters.h"
#include "xscugic.h"
#include "xil_exception.h"
int InterruptSystemSetup(XScuGic *XScuGicInstancePtr);
int InterruptInit(u16 DeviceId,XScuGic *XScuGicInstancePtr);
int InterruptConnect(XScuGic *XScuGicInstancePtr,u32 Int_Id,void * Handler,void *CallBackRef);

#endif


