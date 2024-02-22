// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xsobel_focus.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XSobel_focus_CfgInitialize(XSobel_focus *InstancePtr, XSobel_focus_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

u32 XSobel_focus_Get_average(XSobel_focus *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSobel_focus_ReadReg(InstancePtr->Control_BaseAddress, XSOBEL_FOCUS_CONTROL_ADDR_AVERAGE_DATA);
    return Data;
}

u32 XSobel_focus_Get_average_vld(XSobel_focus *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XSobel_focus_ReadReg(InstancePtr->Control_BaseAddress, XSOBEL_FOCUS_CONTROL_ADDR_AVERAGE_CTRL);
    return Data & 0x1;
}

