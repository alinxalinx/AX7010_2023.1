// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xedge_detector.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XEdge_detector_CfgInitialize(XEdge_detector *InstancePtr, XEdge_detector_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XEdge_detector_Set_threshold(XEdge_detector *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XEdge_detector_WriteReg(InstancePtr->Control_BaseAddress, XEDGE_DETECTOR_CONTROL_ADDR_THRESHOLD_DATA, Data);
}

u32 XEdge_detector_Get_threshold(XEdge_detector *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XEdge_detector_ReadReg(InstancePtr->Control_BaseAddress, XEDGE_DETECTOR_CONTROL_ADDR_THRESHOLD_DATA);
    return Data;
}

