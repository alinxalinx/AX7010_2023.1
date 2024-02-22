/*
 * uart_parameter.h
 *
 *  Created on: 2018Äê7ÔÂ3ÈÕ
 *      Author: Administrator
 */

#ifndef SRC_UART_PARAMETER_H_
#define SRC_UART_PARAMETER_H_

#include "xuartps.h"

u8 TxString[14] =
{
		"Hello ALINX!\r\n"
};

XUartPsFormat UartFormat =
{
		115200,
		XUARTPS_FORMAT_8_BITS,
		XUARTPS_FORMAT_NO_PARITY,
		XUARTPS_FORMAT_1_STOP_BIT
};



#endif /* SRC_UART_PARAMETER_H_ */
