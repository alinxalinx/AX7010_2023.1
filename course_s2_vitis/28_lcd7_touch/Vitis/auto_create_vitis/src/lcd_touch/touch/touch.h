#include "xil_types.h"
#include "xscugic.h"
#include "xiicps.h"
#include "xparameters.h"
#include "xil_exception.h"
#ifndef TOUCH_H_
#define TOUCH_H_

//GT911 部分寄存器定义
#define GT_CTRL_REG 	0X8040   	//GT911控制寄存器
#define GT_CFGS_REG 	0X8047   	//GT911配置起始地址寄存器
#define GT_CHECK_REG 	0X80FF   	//GT911校验和寄存器
#define GT_PID_REG 		0X8140   	//GT911产品ID寄存器

#define GT_GSTID_REG 	0X814E   	//GT911当前检测到的触摸情况
#define GT_TP1_REG 		0X814F  	//第一个触摸点数据地址
#define GT_TP2_REG 		0X8157		//第二个触摸点数据地址
#define GT_TP3_REG 		0X815F		//第三个触摸点数据地址
#define GT_TP4_REG 		0X8167		//第四个触摸点数据地址
#define GT_TP5_REG 		0X816F		//第五个触摸点数据地址


int touch_init (XIicPs *pIicIns,XScuGic *XScuGicInstancePtr,u32 Int_Id);
int touch_i2c_read_bytes(u8 *BufferPtr, u16 address, u16 ByteCount);
int touch_i2c_write_bytes(u16 address, char Data);

extern int touch_sig;

#endif /* TOUCH_H_ */
