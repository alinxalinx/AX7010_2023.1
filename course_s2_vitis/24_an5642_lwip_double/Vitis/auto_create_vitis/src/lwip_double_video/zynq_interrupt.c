#include "xparameters.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "zynq_interrupt.h"
int InterruptSystemSetup(XScuGic *XScuGicInstancePtr)
{
	// Register GIC interrupt handler
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,(Xil_ExceptionHandler)XScuGic_InterruptHandler,XScuGicInstancePtr);
    Xil_ExceptionEnable();
    return XST_SUCCESS;

}

int InterruptInit(u16 DeviceId,XScuGic *XScuGicInstancePtr)
{

	XScuGic_Config *IntcConfig;
	int status;
	// Interrupt controller initialization
    IntcConfig = XScuGic_LookupConfig(DeviceId);
    status = XScuGic_CfgInitialize(XScuGicInstancePtr, IntcConfig, IntcConfig->CpuBaseAddress);
    if(status != XST_SUCCESS) return XST_FAILURE;

    // Call interrupt setup function
    status = InterruptSystemSetup(XScuGicInstancePtr);
    if(status != XST_SUCCESS) return XST_FAILURE;
    return XST_SUCCESS;
}

int InterruptConnect(XScuGic *XScuGicInstancePtr,u32 Int_Id,void * Handler,void *CallBackRef)
{
	int status;
	// Register GPIO interrupt handler
	status = XScuGic_Connect(XScuGicInstancePtr,Int_Id,(Xil_InterruptHandler)Handler,CallBackRef);
	if(status != XST_SUCCESS) return XST_FAILURE;
	XScuGic_Enable(XScuGicInstancePtr, Int_Id);
	return XST_SUCCESS;
}


