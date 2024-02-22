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
#include <unistd.h>
#include "platform.h"
#include "xil_printf.h"
#include "xaverage_float.h"
#include "xil_cache.h"
#include "xil_exception.h"

#include "xtime_l.h"
#include "xparameters.h"
#include "xscugic.h"
#include "xil_exception.h"

int global_cnt;


#define COUNTS_PER_USECOND  (XPAR_CPU_CORTEXA9_CORE_CLOCK_FREQ_HZ / (2U*1000000U))

u64 getDlyUs(void)
{
	XTime dly;
	static XTime Xtime_last = 0;
	XTime Xtime_curr;

	XTime_GetTime(&Xtime_curr);
	dly = Xtime_curr-Xtime_last;
	Xtime_last = Xtime_curr;
	return dly/COUNTS_PER_USECOND;
}

int InterruptInit(u16 DeviceId, XScuGic *XScuGicInstancePtr)
{

	XScuGic_Config *IntcConfig;
	int status;
	// Interrupt controller initialization
	IntcConfig = XScuGic_LookupConfig(DeviceId);
	status = XScuGic_CfgInitialize(XScuGicInstancePtr, IntcConfig, IntcConfig->CpuBaseAddress);
	if(status != XST_SUCCESS) return XST_FAILURE;

	// Call interrupt setup function
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,(Xil_ExceptionHandler)XScuGic_InterruptHandler, XScuGicInstancePtr);
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

int InterruptConnect(XScuGic *XScuGicInstancePtr,u32 Int_Id,void * Handler,void *CallBackRef)
{
	int status;
	// Register GPIO interrupt handler
	status = XScuGic_Connect(XScuGicInstancePtr,Int_Id,(Xil_InterruptHandler)Handler,CallBackRef);
	if(status != XST_SUCCESS)
	{
		return XST_FAILURE;
	}
	XScuGic_SetPriorityTriggerType(XScuGicInstancePtr, Int_Id, 0, 3);
	XScuGic_Enable(XScuGicInstancePtr, Int_Id);
	return XST_SUCCESS;
}

void averageException(XAverage_float *pXAverageInstance)
{
	u32 average;
	int state;

	state = XAverage_float_InterruptGetStatus(pXAverageInstance);
	average = XAverage_float_Get_return(pXAverageInstance);

	XAverage_float_InterruptClear(pXAverageInstance, state);
	if(global_cnt)
	{
		global_cnt--;
		XAverage_float_Start(pXAverageInstance);
	}
	else
	{
		printf("the fpga average:%f use time:%lluus\r\n", *(float *)&average, getDlyUs());
	}
}

void averageExceptionInit(XScuGic *pXScuGicInstance, XAverage_float *ptr)
{
	InterruptInit(XPAR_XSCUTIMER_0_DEVICE_ID, pXScuGicInstance);
	InterruptConnect(pXScuGicInstance, XPAR_FABRIC_AVERAGE_FLOAT_0_VEC_ID, averageException, ptr);
	XAverage_float_InterruptGlobalEnable(ptr);
}

int main()
{
	int state;
	XScuGic scuGic;
	XAverage_float averagDev;
	float dataAry[1024];
	float average;
	double sum;

	int num = (int)sizeof(dataAry)/sizeof(dataAry[0]);

	//================================硬件初始化================================
	init_platform();
	state = XAverage_float_Initialize(&averagDev, 0);
	if(state != XST_SUCCESS)
	{
		printf("XAverage_float_Initialize fail\n\r");
	}
	averageExceptionInit(&scuGic, &averagDev);
	XAverage_float_DisableAutoRestart(&averagDev);
	XAverage_float_InterruptEnable(&averagDev, 1);

	//================================数据初始化================================
	for(int i=0;i<num;i++)
	{
		dataAry[i] = 1.1f;
	}
	dataAry[100] += 1024*0.6;

	//================================arm核运算================================
	getDlyUs();
	global_cnt=9;
	while(1)
	{
		sum = 0;
		for(int i=0;i<num;i++)
		{
			sum += dataAry[i];
		}
		if(global_cnt)
		{
			global_cnt--;
		}
		else
		{
			break;
		}
	}
	average = (float)(sum/num);
	printf("the arm average:%f use time:%lluus\r\n", average, getDlyUs());

	//================================fpga运算================================
	getDlyUs();
	Xil_DCacheFlushRange((INTPTR)dataAry, sizeof(dataAry));
	XAverage_float_Set_src(&averagDev, (u32)dataAry);
	XAverage_float_Set_num(&averagDev, num);
	global_cnt = 9;
	XAverage_float_Start(&averagDev);

	while(1);
	cleanup_platform();
	return 0;
}
