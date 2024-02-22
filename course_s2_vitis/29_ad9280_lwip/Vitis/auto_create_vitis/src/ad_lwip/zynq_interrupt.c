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
/*
* @param	Priority is the new priority for the IRQ source. 0 is highest
* 			priority, 0xF8 (248) is lowest. There are 32 priority levels
*			supported with a step of 8. Hence the supported priorities are
*			0, 8, 16, 32, 40 ..., 248.
* @param	Trigger is the new trigger type for the IRQ source.
* Each bit pair describes the configuration for an INT_ID.
* SFI    Read Only    b10 always
* PPI    Read Only    depending on how the PPIs are configured.
*                    b01    Active HIGH level sensitive
*                    b11 Rising edge sensitive
* SPI                LSB is read only.
*                    b01    Active HIGH level sensitive
*                    b11 Rising edge sensitive
*/
int InterruptConnect(XScuGic *XScuGicInstancePtr,u32 Int_Id,void * Handler,void *CallBackRef,u8 Priority, u8 Trigger)
{
	int status;
	// Register GPIO interrupt handler
	status = XScuGic_Connect(XScuGicInstancePtr,Int_Id,(Xil_InterruptHandler)Handler,CallBackRef);
	if(status != XST_SUCCESS) return XST_FAILURE;
	XScuGic_SetPriorityTriggerType(XScuGicInstancePtr,Int_Id,Priority,Trigger);
	XScuGic_Enable(XScuGicInstancePtr, Int_Id);
	return XST_SUCCESS;
}


