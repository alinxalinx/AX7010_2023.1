/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */


#include "xaxidma.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "xscugic.h"


#define DMA_DEV_ID		  XPAR_AXIDMA_0_DEVICE_ID
#define INT_DEVICE_ID     XPAR_SCUGIC_SINGLE_DEVICE_ID
#define INTR_ID           XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR

#define FIFO_DATABYTE   4
#define TEST_COUNT      80
#define MAX_PKT_LEN		TEST_COUNT*FIFO_DATABYTE

#define TEST_START_VALUE	0xC

#define NUMBER_OF_TRANSFERS	2

/*
 * Function declaration
 */
int XAxiDma_Setup(u16 DeviceId);
static int CheckData(void);
int SetInterruptInit(XScuGic *InstancePtr, u16 IntrID, XAxiDma *XAxiDmaPtr) ;

XScuGic INST ;

XAxiDma AxiDma;

u8 TxBufferPtr[MAX_PKT_LEN] ;
u8 RxBufferPtr[MAX_PKT_LEN] ;


int main()
{
	int Status;

	xil_printf("\r\n--- Entering main() --- \r\n");

	Status = XAxiDma_Setup(DMA_DEV_ID);

	if (Status != XST_SUCCESS) {
		xil_printf("XAxiDma Test Failed\r\n");
		return XST_FAILURE;
	}

	xil_printf("Successfully Ran XAxiDma Test\r\n");

	xil_printf("--- Exiting main() --- \r\n");

	return XST_SUCCESS;

}



int SetInterruptInit(XScuGic *InstancePtr, u16 IntrID, XAxiDma *XAxiDmaPtr)
{

	XScuGic_Config * Config ;
	int Status ;

	Config = XScuGic_LookupConfig(INT_DEVICE_ID) ;

	Status = XScuGic_CfgInitialize(&INST, Config, Config->CpuBaseAddress) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	Status = XScuGic_Connect(InstancePtr, IntrID,
			(Xil_ExceptionHandler)CheckData,
			XAxiDmaPtr) ;

	if (Status != XST_SUCCESS) {
			return Status;
		}

	XScuGic_Enable(InstancePtr, IntrID) ;

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
					(Xil_ExceptionHandler) XScuGic_InterruptHandler,
					InstancePtr);

	Xil_ExceptionEnable();


	return XST_SUCCESS ;

}


int XAxiDma_Setup(u16 DeviceId)
{
	XAxiDma_Config *CfgPtr;
	int Status;
	int Tries = NUMBER_OF_TRANSFERS;
	int Index;
	u8 Value;

	/* Initialize the XAxiDma device.
	 */
	CfgPtr = XAxiDma_LookupConfig(DeviceId);
	if (!CfgPtr) {
		xil_printf("No config found for %d\r\n", DeviceId);
		return XST_FAILURE;
	}

	Status = XAxiDma_CfgInitialize(&AxiDma, CfgPtr);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed %d\r\n", Status);
		return XST_FAILURE;
	}

	if(XAxiDma_HasSg(&AxiDma)){
		xil_printf("Device configured as SG mode \r\n");
		return XST_FAILURE;
	}

	Status = SetInterruptInit(&INST,INTR_ID, &AxiDma) ;
	if (Status != XST_SUCCESS)
		         return XST_FAILURE ;

	/* Disable MM2S interrupt, Enable S2MM interrupt */
	XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_IOC_MASK,
						XAXIDMA_DEVICE_TO_DMA);
	XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
						XAXIDMA_DMA_TO_DEVICE);

	Value = TEST_START_VALUE;

	for(Index = 0; Index < MAX_PKT_LEN; Index ++) {
			TxBufferPtr[Index] = Value;

			Value = (Value + 1) & 0xFF;
	}
	/* Flush the SrcBuffer before the DMA transfer, in case the Data Cache
	 * is enabled
	 */
	Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, MAX_PKT_LEN);
	Xil_DCacheFlushRange((UINTPTR)RxBufferPtr, MAX_PKT_LEN);

	for(Index = 0; Index < Tries; Index ++) {

			Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) TxBufferPtr,
								MAX_PKT_LEN, XAXIDMA_DMA_TO_DEVICE);

			if (Status != XST_SUCCESS) {
				return XST_FAILURE;
			}

		    Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferPtr,
								MAX_PKT_LEN, XAXIDMA_DEVICE_TO_DMA);


			if (Status != XST_SUCCESS) {
				return XST_FAILURE;
			}


			while ((XAxiDma_Busy(&AxiDma,XAXIDMA_DEVICE_TO_DMA)) ||
				(XAxiDma_Busy(&AxiDma,XAXIDMA_DMA_TO_DEVICE)))
					{
					/* Wait */
			}


		}

		/* Test finishes successfully
		 */
		return XST_SUCCESS;
	}


static int CheckData(void)
{
	u8 *RxPacket;
	int Index = 0;
	u8 Value;

	RxPacket = RxBufferPtr;
	Value = TEST_START_VALUE;

	xil_printf("Enter Interrupt\r\n");
	/*Clear Interrupt*/
	XAxiDma_IntrAckIrq(&AxiDma, XAXIDMA_IRQ_IOC_MASK,
			XAXIDMA_DEVICE_TO_DMA) ;
	/* Invalidate the DestBuffer before receiving the data, in case the
		 * Data Cache is enabled
		 */
	Xil_DCacheInvalidateRange((UINTPTR)RxPacket, MAX_PKT_LEN);


	for(Index = 0; Index < MAX_PKT_LEN; Index++) {
		if (RxPacket[Index] != Value) {
			xil_printf("Data error %d: %x/%x\r\n",
			Index, (unsigned int)RxPacket[Index],
				(unsigned int)Value);

			return XST_FAILURE;
		}
		Value = (Value + 1) & 0xFF;
	}

	return XST_SUCCESS;
}
