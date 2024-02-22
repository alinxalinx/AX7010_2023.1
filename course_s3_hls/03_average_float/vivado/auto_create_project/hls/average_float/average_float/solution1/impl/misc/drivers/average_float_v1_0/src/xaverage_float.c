// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xaverage_float.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XAverage_float_CfgInitialize(XAverage_float *InstancePtr, XAverage_float_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XAverage_float_Start(XAverage_float *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_AP_CTRL) & 0x80;
    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XAverage_float_IsDone(XAverage_float *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XAverage_float_IsIdle(XAverage_float *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XAverage_float_IsReady(XAverage_float *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XAverage_float_EnableAutoRestart(XAverage_float *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XAverage_float_DisableAutoRestart(XAverage_float *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_AP_CTRL, 0);
}

u32 XAverage_float_Get_return(XAverage_float *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_AP_RETURN);
    return Data;
}
void XAverage_float_Set_src(XAverage_float *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_SRC_DATA, (u32)(Data));
    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_SRC_DATA + 4, (u32)(Data >> 32));
}

u64 XAverage_float_Get_src(XAverage_float *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_SRC_DATA);
    Data += (u64)XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_SRC_DATA + 4) << 32;
    return Data;
}

void XAverage_float_Set_num(XAverage_float *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_NUM_DATA, Data);
}

u32 XAverage_float_Get_num(XAverage_float *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_NUM_DATA);
    return Data;
}

void XAverage_float_InterruptGlobalEnable(XAverage_float *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_GIE, 1);
}

void XAverage_float_InterruptGlobalDisable(XAverage_float *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_GIE, 0);
}

void XAverage_float_InterruptEnable(XAverage_float *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_IER);
    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_IER, Register | Mask);
}

void XAverage_float_InterruptDisable(XAverage_float *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_IER);
    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_IER, Register & (~Mask));
}

void XAverage_float_InterruptClear(XAverage_float *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XAverage_float_WriteReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_ISR, Mask);
}

u32 XAverage_float_InterruptGetEnabled(XAverage_float *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_IER);
}

u32 XAverage_float_InterruptGetStatus(XAverage_float *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XAverage_float_ReadReg(InstancePtr->Control_BaseAddress, XAVERAGE_FLOAT_CONTROL_ADDR_ISR);
}

