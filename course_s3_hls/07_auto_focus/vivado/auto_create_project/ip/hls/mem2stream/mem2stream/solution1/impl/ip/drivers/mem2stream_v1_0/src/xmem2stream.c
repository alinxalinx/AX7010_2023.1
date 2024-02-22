// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xmem2stream.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XMem2stream_CfgInitialize(XMem2stream *InstancePtr, XMem2stream_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XMem2stream_Start(XMem2stream *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_AP_CTRL) & 0x80;
    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XMem2stream_IsDone(XMem2stream *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XMem2stream_IsIdle(XMem2stream *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XMem2stream_IsReady(XMem2stream *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XMem2stream_EnableAutoRestart(XMem2stream *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XMem2stream_DisableAutoRestart(XMem2stream *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_AP_CTRL, 0);
}

void XMem2stream_Set_pMemPort(XMem2stream *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_PMEMPORT_DATA, (u32)(Data));
    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_PMEMPORT_DATA + 4, (u32)(Data >> 32));
}

u64 XMem2stream_Get_pMemPort(XMem2stream *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_PMEMPORT_DATA);
    Data += (u64)XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_PMEMPORT_DATA + 4) << 32;
    return Data;
}

void XMem2stream_Set_rows(XMem2stream *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_ROWS_DATA, Data);
}

u32 XMem2stream_Get_rows(XMem2stream *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_ROWS_DATA);
    return Data;
}

void XMem2stream_Set_cols(XMem2stream *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_COLS_DATA, Data);
}

u32 XMem2stream_Get_cols(XMem2stream *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_COLS_DATA);
    return Data;
}

u32 XMem2stream_Get_baseAddr_BaseAddress(XMem2stream *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE);
}

u32 XMem2stream_Get_baseAddr_HighAddress(XMem2stream *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XMEM2STREAM_CONTROL_ADDR_BASEADDR_HIGH);
}

u32 XMem2stream_Get_baseAddr_TotalBytes(XMem2stream *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XMEM2STREAM_CONTROL_ADDR_BASEADDR_HIGH - XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE + 1);
}

u32 XMem2stream_Get_baseAddr_BitWidth(XMem2stream *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XMEM2STREAM_CONTROL_WIDTH_BASEADDR;
}

u32 XMem2stream_Get_baseAddr_Depth(XMem2stream *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XMEM2STREAM_CONTROL_DEPTH_BASEADDR;
}

u32 XMem2stream_Write_baseAddr_Words(XMem2stream *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XMEM2STREAM_CONTROL_ADDR_BASEADDR_HIGH - XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XMem2stream_Read_baseAddr_Words(XMem2stream *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XMEM2STREAM_CONTROL_ADDR_BASEADDR_HIGH - XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE + (offset + i)*4);
    }
    return length;
}

u32 XMem2stream_Write_baseAddr_Bytes(XMem2stream *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XMEM2STREAM_CONTROL_ADDR_BASEADDR_HIGH - XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XMem2stream_Read_baseAddr_Bytes(XMem2stream *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XMEM2STREAM_CONTROL_ADDR_BASEADDR_HIGH - XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE + offset + i);
    }
    return length;
}

void XMem2stream_InterruptGlobalEnable(XMem2stream *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_GIE, 1);
}

void XMem2stream_InterruptGlobalDisable(XMem2stream *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_GIE, 0);
}

void XMem2stream_InterruptEnable(XMem2stream *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_IER);
    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_IER, Register | Mask);
}

void XMem2stream_InterruptDisable(XMem2stream *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_IER);
    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_IER, Register & (~Mask));
}

void XMem2stream_InterruptClear(XMem2stream *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XMem2stream_WriteReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_ISR, Mask);
}

u32 XMem2stream_InterruptGetEnabled(XMem2stream *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_IER);
}

u32 XMem2stream_InterruptGetStatus(XMem2stream *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XMem2stream_ReadReg(InstancePtr->Control_BaseAddress, XMEM2STREAM_CONTROL_ADDR_ISR);
}

