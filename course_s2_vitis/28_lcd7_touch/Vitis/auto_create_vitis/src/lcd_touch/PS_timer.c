#include "xil_types.h"
#include "xscutimer.h"

int PS_timer_init(XScuTimer *Timer, u16 DeviceId, u32 timer_load)
{
	int Status;
	XScuTimer_Config *TMRConfigPtr;
	//私有定时器初始化
	TMRConfigPtr = XScuTimer_LookupConfig(DeviceId);
	XScuTimer_CfgInitialize(Timer, TMRConfigPtr,TMRConfigPtr->BaseAddr);
	XScuTimer_SelfTest(Timer);
	XScuTimer_LoadTimer(Timer, timer_load);
	//自动装载
	XScuTimer_EnableAutoReload(Timer);
	//启动定时器
	XScuTimer_Start(Timer);
	return XST_SUCCESS;
}
