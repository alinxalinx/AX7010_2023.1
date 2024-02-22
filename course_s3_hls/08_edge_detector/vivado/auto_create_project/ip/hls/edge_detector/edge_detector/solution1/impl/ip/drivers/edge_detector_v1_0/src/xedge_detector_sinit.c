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
#include "xedge_detector.h"

extern XEdge_detector_Config XEdge_detector_ConfigTable[];

XEdge_detector_Config *XEdge_detector_LookupConfig(u16 DeviceId) {
	XEdge_detector_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XEDGE_DETECTOR_NUM_INSTANCES; Index++) {
		if (XEdge_detector_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XEdge_detector_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XEdge_detector_Initialize(XEdge_detector *InstancePtr, u16 DeviceId) {
	XEdge_detector_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XEdge_detector_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XEdge_detector_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

