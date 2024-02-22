#include "touch.h"
#include "../i2c/PS_i2c.h"
#include "../zynq_interrupt.h"
#include "sleep.h"
#include "xtime_l.h"
/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */

// Parameter definitions
#define IIC_DEVICE_ID	XPAR_XIICPS_0_DEVICE_ID
#define TOUCH_ADDRESS 		0x5D
u8 WriteBuffer[20];	/* Read buffer for reading a page. */
XIicPs *pIicInstance;

u8 ReadBuffer[50];
u16 current_x1;
u16 current_y1;
u16 curr_x1;
u16 curr_y1;
u16 last_x1;
u16 last_y1;
extern XTime TimerCurr, TimerLast;
int touch_sig;

const u8 GT911_CFG_TBL[]=
{
		0x70,0x20,0x03,0xE0,0x01,0x05,0x0D,0x00,0x02,0x0F,
		0x28,0x0F,0x50,0x32,0x03,0x05,0x00,0x00,0x00,0x00,
		0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x87,0x29,0x0A,
		0x2D,0x2F,0x0F,0x0A,0x00,0x00,0x00,0x02,0x02,0x1D,
		0x00,0x00,0x00,0x00,0x00,0x03,0x64,0x32,0x00,0x00,
		0x00,0x1E,0x50,0x94,0xC5,0x02,0x07,0x00,0x00,0x04,
		0xA3,0x21,0x00,0x8C,0x28,0x00,0x78,0x31,0x00,0x69,
		0x3B,0x00,0x5D,0x48,0x00,0x5D,0x00,0x00,0x00,0x00,
		0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
		0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
		0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
		0x00,0x00,0x02,0x04,0x06,0x08,0x0A,0x0C,0x0E,0x10,
		0x12,0x14,0xFF,0xFF,0xFF,0xFF,0x00,0x00,0x00,0x00,
		0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
		0x00,0x00,0x00,0x02,0x04,0x06,0x08,0x0A,0x0C,0x1D,
		0x1E,0x1F,0x20,0x21,0x22,0x24,0x26,0x28,0xFF,0xFF,
		0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0x00,0x00,
		0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
		0x00,0x00,0x00,0x00
};


void Touch_Intr_Handler(void *InstancePtr)

{
	u8 temp[4];
	u8 touch_num ;
	u8 bufferStatus ;

	//check status register if touch has detected
	touch_i2c_read_bytes(temp, GT_GSTID_REG, 1);
	touch_num = temp[0] & 0xF ;
	bufferStatus = (temp[0] & 0x80)>>7 ;
	//read coordinate
	touch_i2c_read_bytes(ReadBuffer, GT_TP1_REG, 20);
	//clear status register
	touch_i2c_write_bytes(GT_GSTID_REG, 0x00);

	last_x1 = current_x1;
	last_y1 = current_y1;
	curr_x1=((ReadBuffer[2]&0x0f)<<8) + ReadBuffer[1];
	curr_y1=((ReadBuffer[4]&0x0f)<<8) + ReadBuffer[3];

	if (bufferStatus == 1 && touch_num == 0)
	{
		touch_sig = -1 ;
	}
	if (bufferStatus == 1 && touch_num > 0)  //has touched
	{
		if (curr_x1 != last_x1 || curr_y1 != last_y1)
		{
			touch_sig = 1 ;
			current_x1 = curr_x1 ;
			current_y1 = curr_y1 ;
		}
	}
}
/*****************************************************************************/
/**
 * This function write bytes from IIC device*
 *
 ******************************************************************************/
int touch_i2c_write_bytes(u16 address, char Data)
{
	int Status ;
	u8 buf[3];
	buf[0] = address>>8;
	buf[1] = address;
	buf[2] = Data;

	Status = XIicPs_MasterSendPolled(pIicInstance, buf, 3, TOUCH_ADDRESS);
	while (XIicPs_BusIsBusy(pIicInstance));
	return XST_SUCCESS;
}
/*****************************************************************************/
/**
 * This function read bytes from IIC device*
 *
 ******************************************************************************/
int touch_i2c_read_bytes(u8 *BufferPtr, u16 address, u16 ByteCount)
{

	u8 buf[2];
	buf[0] = address>>8;
	buf[1] = address;
	if(i2c_wrtie_bytes(pIicInstance,TOUCH_ADDRESS,buf,2) != XST_SUCCESS)
		return XST_FAILURE;
	if(i2c_read_bytes(pIicInstance,TOUCH_ADDRESS,BufferPtr,ByteCount) != XST_SUCCESS)
		return XST_FAILURE;
	return XST_SUCCESS;
}

int touch_init (XIicPs *pIicIns,XScuGic *XScuGicInstancePtr,u32 Int_Id)
{
	u8 temp[4];
	u8 checkdata[200];
	int Status ;
	int i;
	u8 buf[2];
	pIicInstance=pIicIns;
	//read product id
	touch_i2c_read_bytes(temp, GT_PID_REG, 4);

	xil_printf("%s\r\n",temp);
	xil_printf("TouchPad_ID:%d,%d,%d\r\n",temp[0],temp[1],temp[2]);

	if(strcmp((char*)temp,"911")==0)
	{
		//configure GT911
		for(i=0;i<sizeof(GT911_CFG_TBL);i++)
		{
			Status = touch_i2c_write_bytes(GT_CFGS_REG+i, GT911_CFG_TBL[i]);
			if (Status != XST_SUCCESS)
			{
				xil_printf("I2C configuration failed!Register addr is %x\r\n", GT_CFGS_REG+i);

			}
		}

		buf[0]=0;
		buf[1]=1;
		//calculate checksum
		for(i=0;i<sizeof(GT911_CFG_TBL);i++)
			buf[0]+=GT911_CFG_TBL[i];
		buf[0]=(~buf[0])+1;
		//write checksum
		for(i=0;i<2;i++)
			touch_i2c_write_bytes(GT_CHECK_REG+i,buf[i]);

		//check configurations register
		touch_i2c_read_bytes(checkdata, GT_CFGS_REG, sizeof(GT911_CFG_TBL));
		touch_i2c_read_bytes(temp, GT_CHECK_REG, 1);
		for(i=0;i<sizeof(GT911_CFG_TBL);i++)
		{
			if(checkdata[i] != GT911_CFG_TBL[i])
			{
				xil_printf("Configuration failed!i:%d\r\n",i);
				return XST_FAILURE;
			}
		}
		if(temp[0] != buf[0])
		{
			xil_printf("Checksum Configuration failed!\r\n");
			return XST_FAILURE;
		}
		xil_printf("Configuration Successfully!\r\n");

	}

	//soft reset
	touch_i2c_write_bytes(GT_CTRL_REG, 0x02);
	usleep(10000);
	//clear point register
	touch_i2c_write_bytes(GT_CTRL_REG, 0x00);
	//clear point register
	touch_i2c_write_bytes(GT_GSTID_REG, 0x00);

	//set priority and trigger type
	XScuGic_SetPriorityTriggerType(XScuGicInstancePtr, Int_Id,	0xA0, 0x3);
	InterruptConnect(XScuGicInstancePtr,Int_Id,Touch_Intr_Handler,NULL);

	return XST_SUCCESS;

}


