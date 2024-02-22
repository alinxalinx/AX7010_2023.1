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
#include "xsobel_focus.h"

extern XSobel_focus_Config XSobel_focus_ConfigTable[];

XSobel_focus_Config *XSobel_focus_LookupConfig(u16 DeviceId) {
	XSobel_focus_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSOBEL_FOCUS_NUM_INSTANCES; Index++) {
		if (XSobel_focus_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XSobel_focus_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSobel_focus_Initialize(XSobel_focus *InstancePtr, u16 DeviceId) {
	XSobel_focus_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSobel_focus_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSobel_focus_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

