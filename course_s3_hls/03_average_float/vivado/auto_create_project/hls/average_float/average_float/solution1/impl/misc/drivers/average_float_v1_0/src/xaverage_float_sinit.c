// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xaverage_float.h"

extern XAverage_float_Config XAverage_float_ConfigTable[];

XAverage_float_Config *XAverage_float_LookupConfig(u16 DeviceId) {
	XAverage_float_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XAVERAGE_FLOAT_NUM_INSTANCES; Index++) {
		if (XAverage_float_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XAverage_float_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XAverage_float_Initialize(XAverage_float *InstancePtr, u16 DeviceId) {
	XAverage_float_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XAverage_float_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XAverage_float_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

