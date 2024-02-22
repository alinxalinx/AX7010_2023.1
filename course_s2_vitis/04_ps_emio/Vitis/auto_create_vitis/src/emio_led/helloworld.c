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
#include "platform.h"
#include "xil_printf.h"
#include "xgpiops.h"
#include "sleep.h"

#define GPIO_DEVICE_ID		XPAR_XGPIOPS_0_DEVICE_ID

/*
 * The following are declared globally so they are zeroed and can be
 * easily accessible from a debugger.
 */
XGpioPs Gpio;	/* The driver instance for GPIO Device. */

int main()
{
	init_platform();

	int Status;
	XGpioPs_Config *ConfigPtr;

	print("Hello World\n\r");
	/* Initialize the GPIO driver. */
	ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);

	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr,
			ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Set the direction for the pin to be output and
	 * Enable the Output enable for the LED Pin.
	 */
	XGpioPs_SetDirectionPin(&Gpio, 54, 1);
	XGpioPs_SetDirectionPin(&Gpio, 55, 1);
	XGpioPs_SetDirectionPin(&Gpio, 56, 1);
	XGpioPs_SetDirectionPin(&Gpio, 57, 1);
	XGpioPs_SetOutputEnablePin(&Gpio, 54, 1);
	XGpioPs_SetOutputEnablePin(&Gpio, 55, 1);
	XGpioPs_SetOutputEnablePin(&Gpio, 56, 1);
	XGpioPs_SetOutputEnablePin(&Gpio, 57, 1);

	while(1){
		/* Set the GPIO output to be low. */
		XGpioPs_WritePin(&Gpio, 54, 0x0);
		XGpioPs_WritePin(&Gpio, 55, 0x0);
		XGpioPs_WritePin(&Gpio, 56, 0x0);
		XGpioPs_WritePin(&Gpio, 57, 0x0);
		sleep(1) ;
		/* Set the GPIO output to be high. */
		XGpioPs_WritePin(&Gpio, 54, 0x1);
		XGpioPs_WritePin(&Gpio, 55, 0x1);
		XGpioPs_WritePin(&Gpio, 56, 0x1);
		XGpioPs_WritePin(&Gpio, 57, 0x1);
		sleep(1) ;
	}

	cleanup_platform();
	return 0;
}
