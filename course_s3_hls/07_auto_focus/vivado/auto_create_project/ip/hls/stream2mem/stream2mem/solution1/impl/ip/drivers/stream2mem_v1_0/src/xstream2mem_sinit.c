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
#include "xstream2mem.h"

extern XStream2mem_Config XStream2mem_ConfigTable[];

XStream2mem_Config *XStream2mem_LookupConfig(u16 DeviceId) {
	XStream2mem_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSTREAM2MEM_NUM_INSTANCES; Index++) {
		if (XStream2mem_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XStream2mem_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XStream2mem_Initialize(XStream2mem *InstancePtr, u16 DeviceId) {
	XStream2mem_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XStream2mem_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XStream2mem_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

