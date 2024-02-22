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
#include "xmem2stream.h"

extern XMem2stream_Config XMem2stream_ConfigTable[];

XMem2stream_Config *XMem2stream_LookupConfig(u16 DeviceId) {
	XMem2stream_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XMEM2STREAM_NUM_INSTANCES; Index++) {
		if (XMem2stream_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XMem2stream_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XMem2stream_Initialize(XMem2stream *InstancePtr, u16 DeviceId) {
	XMem2stream_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XMem2stream_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XMem2stream_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

