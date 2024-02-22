/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */
#include <stdio.h>
#include "xil_printf.h"
#include "xsysmon.h"
#include "sleep.h"
#include "xscugic.h"

#define ADC_DEVICE_ID     XPAR_SYSMON_0_DEVICE_ID
#define INT_DEVICE_ID     XPAR_SCUGIC_SINGLE_DEVICE_ID
#define INTR_ID           XPAR_FABRIC_XADC_WIZ_0_IP2INTC_IRPT_INTR

XSysMon SysMon ;

XScuGic INST ;

void SysMonHandler(void *CallBackRef) ;
int SetInterruptInit(XScuGic *InstancePtr, u16 IntrID, XSysMon *SysMonPtr) ;


int main()
{
    u16 raw_data ;
    u16 temp_code ;

    float Temp ;
    float vccint ;
    float vccaux ;
    float vccbram ;
    float vccpint ;
    float vccpaux ;
    float vccpdro ;

    XSysMon_Config *Config ;
    int Status ;

   Config = XSysMon_LookupConfig(ADC_DEVICE_ID) ;

   Status = XSysMon_CfgInitialize(&SysMon, Config, Config->BaseAddress) ;
   if (Status != XST_SUCCESS)
         return XST_FAILURE ;

   /*
    * disable alarm
    */
   XSysMon_SetAlarmEnables(&SysMon, 0x0);
   /*
    * Set temperature upper and lower alarm
    */
   temp_code = XSysMon_TemperatureToRaw(80) ;
   XSysMon_SetAlarmThreshold(&SysMon, XSM_ATR_TEMP_UPPER, temp_code) ;
   temp_code = XSysMon_TemperatureToRaw(70) ;
   XSysMon_SetAlarmThreshold(&SysMon, XSM_ATR_TEMP_LOWER, temp_code) ;
   /*
    * Enable alarm
    */
   XSysMon_SetAlarmEnables(&SysMon, XSM_CFR1_ALM_TEMP_MASK) ;
   /* Enable Global interrupt */
   XSysMon_IntrGlobalEnable(&SysMon) ;
   /* Enable temperature interrupt */
   XSysMon_IntrEnable(&SysMon, XSM_IPIXR_TEMP_MASK) ;

   Status = SetInterruptInit(&INST,INTR_ID, &SysMon) ;
   if (Status != XST_SUCCESS)
            return XST_FAILURE ;


    while(1)
    {
    	raw_data = XSysMon_GetAdcData(&SysMon, XSM_CH_TEMP) ;
    	Temp = XSysMon_RawToTemperature(raw_data) ;
    	raw_data = XSysMon_GetAdcData(&SysMon, XSM_CH_VCCINT) ;
    	vccint = XSysMon_RawToVoltage(raw_data) ;
    	raw_data = XSysMon_GetAdcData(&SysMon, XSM_CH_VCCAUX) ;
    	vccaux = XSysMon_RawToVoltage(raw_data) ;
    	raw_data = XSysMon_GetAdcData(&SysMon, XSM_CH_VBRAM) ;
    	vccbram = XSysMon_RawToVoltage(raw_data) ;
    	raw_data = XSysMon_GetAdcData(&SysMon, XSM_CH_VCCPINT) ;
    	vccpint = XSysMon_RawToVoltage(raw_data) ;
    	raw_data = XSysMon_GetAdcData(&SysMon, XSM_CH_VCCPAUX) ;
    	vccpaux = XSysMon_RawToVoltage(raw_data) ;
    	raw_data = XSysMon_GetAdcData(&SysMon, XSM_CH_VCCPDRO) ;
    	vccpdro = XSysMon_RawToVoltage(raw_data) ;
    	printf("Temperature : %.2fC\t\nVCCINT : %.2fV\t\nVCCAUX : %.2fV\t\n"
    			"VBRAM : %.2fV\t\nVCCPINT : %.2fV\t\nVCCPAUX : %.2fV\t\nVCCPDRO : %.2fV\t\n", Temp, vccint, vccaux ,vccbram,vccpint, vccpaux,vccpdro) ;
    	sleep(1) ;
    }


}


int SetInterruptInit(XScuGic *InstancePtr, u16 IntrID, XSysMon *SysMonPtr)
{

	XScuGic_Config * Config ;
	int Status ;

	Config = XScuGic_LookupConfig(INT_DEVICE_ID) ;

	Status = XScuGic_CfgInitialize(&INST, Config, Config->CpuBaseAddress) ;
	if (Status != XST_SUCCESS)
		return XST_FAILURE ;

	Status = XScuGic_Connect(InstancePtr, IntrID,
			(Xil_ExceptionHandler)SysMonHandler,
			 (void *)SysMonPtr) ;

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


void SysMonHandler(void *CallBackRef)
{
	int intr_val ;

	XSysMon *SysMonPtr = (XSysMon *)CallBackRef;

	printf("Enter Interrupt\t\n") ;
	intr_val = XSysMon_IntrGetStatus(SysMonPtr) ;
	XSysMon_IntrClear(SysMonPtr, XSM_IPIXR_TEMP_MASK) ;

	if (intr_val & XSM_IPIXR_TEMP_MASK)
		printf("temperature interrupt is detected\t\n") ;


}
