/* ------------------------------------------------------------ */
/*				Include File Definitions						*/
/* ------------------------------------------------------------ */

#include <stdio.h>
#include "xil_printf.h"
#include "xadcps.h"
#include "sleep.h"
#include "xscugic.h"

#define ADC_DEVICE_ID     XPAR_PS7_XADC_0_DEVICE_ID

XAdcPs XAdc ;

int main()
{
    u16 raw_data ;

    float Temp ;
    float vccint ;
    float vccaux ;
    float vccbram ;
    float vccpint ;
    float vccpaux ;
    float vccpdro ;

    XAdcPs_Config *Config ;
    int Status ;


   Config = XAdcPs_LookupConfig(ADC_DEVICE_ID) ;

   Status = XAdcPs_CfgInitialize(&XAdc, Config, Config->BaseAddress) ;
   if (Status != XST_SUCCESS)
         return XST_FAILURE ;


    while(1)
    {
    	raw_data = XAdcPs_GetAdcData(&XAdc, XADCPS_CH_TEMP) ;
    	Temp = XAdcPs_RawToTemperature(raw_data) ;
    	raw_data = XAdcPs_GetAdcData(&XAdc, XADCPS_CH_VCCINT) ;
    	vccint = XAdcPs_RawToVoltage(raw_data) ;
    	raw_data = XAdcPs_GetAdcData(&XAdc, XADCPS_CH_VCCAUX) ;
    	vccaux = XAdcPs_RawToVoltage(raw_data) ;
    	raw_data = XAdcPs_GetAdcData(&XAdc, XADCPS_CH_VBRAM) ;
    	vccbram = XAdcPs_RawToVoltage(raw_data) ;
    	raw_data = XAdcPs_GetAdcData(&XAdc, XADCPS_CH_VCCPINT) ;
    	vccpint = XAdcPs_RawToVoltage(raw_data) ;
    	raw_data = XAdcPs_GetAdcData(&XAdc, XADCPS_CH_VCCPAUX) ;
    	vccpaux = XAdcPs_RawToVoltage(raw_data) ;
    	raw_data = XAdcPs_GetAdcData(&XAdc, XADCPS_CH_VCCPDRO) ;
    	vccpdro = XAdcPs_RawToVoltage(raw_data) ;
    	printf("Temperature : %.2fC\t\nVCCINT : %.2fV\t\nVCCAUX : %.2fV\t\n"
    			"VBRAM : %.2fV\t\nVCCPINT : %.2fV\t\nVCCPAUX : %.2fV\t\nVCCPDRO : %.2fV\t\n", Temp, vccint, vccaux ,vccbram,vccpint, vccpaux,vccpdro) ;
    	sleep(1) ;
    }
}

