/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include "xil_printf.h"
#include "xbram.h"
#include <stdio.h>
#include "pl_bram_ctrl.h"
#include "xscugic.h"

#define BRAM_CTRL_BASE      XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR
#define BRAM_CTRL_HIGH      XPAR_AXI_BRAM_CTRL_0_S_AXI_HIGHADDR
#define PL_RAM_BASE         XPAR_PL_BRAM_CTRL_0_S00_AXI_BASEADDR
#define PL_RAM_CTRL         PL_BRAM_CTRL_S00_AXI_SLV_REG0_OFFSET
#define PL_RAM_INIT_DATA    PL_BRAM_CTRL_S00_AXI_SLV_REG1_OFFSET
#define PL_RAM_LEN          PL_BRAM_CTRL_S00_AXI_SLV_REG2_OFFSET
#define PL_RAM_ST_ADDR      PL_BRAM_CTRL_S00_AXI_SLV_REG3_OFFSET

#define START_MASK   0x00000001
#define INTRCLR_MASK 0x00000002


#define INTC_DEVICE_ID	    XPAR_SCUGIC_SINGLE_DEVICE_ID
#define INTR_ID              XPAR_FABRIC_PL_BRAM_CTRL_0_INTR_INTR

#define TEST_START_VAL      0xC
/*
 * BRAM bytes number
 */
#define BRAM_BYTENUM        4


XScuGic INTCInst;

int Len  ;
int Start_Addr ;
int Intr_flag ;
/*
 * Function declaration
 */
int bram_read_write() ;
int IntrInitFuntion(u16 DeviceId);
void IntrHandler(void *InstancePtr);

int main()
{

	int Status;
	Intr_flag = 1 ;

    IntrInitFuntion(INTC_DEVICE_ID) ;

	while(1)
	{
		if (Intr_flag)
		{
			Intr_flag = 0 ;
			printf("Please provide start address\t\n") ;
			scanf("%d", &Start_Addr) ;
			printf("Start address is %d\t\n", Start_Addr) ;
			printf("Please provide length\t\n") ;
			scanf("%d", &Len) ;
			printf("Length is %d\t\n", Len) ;
			Status = bram_read_write() ;
			if (Status != XST_SUCCESS)
			{
				xil_printf("Bram Test Failed!\r\n") ;
				xil_printf("******************************************\r\n");
				Intr_flag = 1 ;
			}
		}
	}
}


int bram_read_write()
{

	u32 Write_Data = TEST_START_VAL ;
	int i ;

	/*
	 * if exceed BRAM address range, assert error
	 */
	if ((Start_Addr + Len) > (BRAM_CTRL_HIGH - BRAM_CTRL_BASE + 1)/4)
	{
		xil_printf("******************************************\r\n");
		xil_printf("Error! Exceed Bram Control Address Range!\r\n");
		return XST_FAILURE ;
	}
	/*
	 * Write data to BRAM
	 */
	for(i = BRAM_BYTENUM*Start_Addr ; i < BRAM_BYTENUM*(Start_Addr + Len) ; i += BRAM_BYTENUM)
	{
		XBram_WriteReg(XPAR_BRAM_0_BASEADDR, i , Write_Data) ;
		Write_Data += 1 ;
	}
	//Set ram read and write length
	PL_BRAM_CTRL_mWriteReg(PL_RAM_BASE, PL_RAM_LEN , BRAM_BYTENUM*Len) ;
	//Set ram start address
	PL_BRAM_CTRL_mWriteReg(PL_RAM_BASE, PL_RAM_ST_ADDR , BRAM_BYTENUM*Start_Addr) ;
	//Set pl initial data
	PL_BRAM_CTRL_mWriteReg(PL_RAM_BASE, PL_RAM_INIT_DATA , (Start_Addr+1)) ;
	//Set ram start signal
	PL_BRAM_CTRL_mWriteReg(PL_RAM_BASE, PL_RAM_CTRL , START_MASK) ;

	return XST_SUCCESS ;
}



int IntrInitFuntion(u16 DeviceId)
{
	XScuGic_Config *IntcConfig;
	int Status ;


	//check device id
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	//intialization
	Status = XScuGic_CfgInitialize(&INTCInst, IntcConfig, IntcConfig->CpuBaseAddress) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;


	XScuGic_SetPriorityTriggerType(&INTCInst, INTR_ID,
			0xA0, 0x3);

	Status = XScuGic_Connect(&INTCInst, INTR_ID,
			(Xil_ExceptionHandler)IntrHandler,
			(void *)NULL) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	XScuGic_Enable(&INTCInst, INTR_ID) ;


	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)XScuGic_InterruptHandler,
			&INTCInst);
	Xil_ExceptionEnable();


	return XST_SUCCESS ;

}


void IntrHandler(void *CallbackRef)
{
	int Read_Data ;

	int i ;
	printf("Enter interrupt\t\n");
	//clear interrupt status
	PL_BRAM_CTRL_mWriteReg(PL_RAM_BASE, PL_RAM_CTRL , INTRCLR_MASK) ;

	for(i = BRAM_BYTENUM*Start_Addr ; i < BRAM_BYTENUM*(Start_Addr + Len) ; i += BRAM_BYTENUM)
	{
		Read_Data = XBram_ReadReg(XPAR_BRAM_0_BASEADDR , i) ;
		printf("Address is %d\t Read data is %d\t\n",  i/BRAM_BYTENUM ,Read_Data) ;
	}
	Intr_flag = 1 ;
}
