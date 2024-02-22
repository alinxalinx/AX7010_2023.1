// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xstream2mem.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XStream2mem_CfgInitialize(XStream2mem *InstancePtr, XStream2mem_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XStream2mem_Set_pMemPort(XStream2mem *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStream2mem_WriteReg(InstancePtr->Control_BaseAddress, XSTREAM2MEM_CONTROL_ADDR_PMEMPORT_DATA, (u32)(Data));
    XStream2mem_WriteReg(InstancePtr->Control_BaseAddress, XSTREAM2MEM_CONTROL_ADDR_PMEMPORT_DATA + 4, (u32)(Data >> 32));
}

u64 XStream2mem_Get_pMemPort(XStream2mem *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStream2mem_ReadReg(InstancePtr->Control_BaseAddress, XSTREAM2MEM_CONTROL_ADDR_PMEMPORT_DATA);
    Data += (u64)XStream2mem_ReadReg(InstancePtr->Control_BaseAddress, XSTREAM2MEM_CONTROL_ADDR_PMEMPORT_DATA + 4) << 32;
    return Data;
}

void XStream2mem_Set_rows(XStream2mem *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStream2mem_WriteReg(InstancePtr->Control_BaseAddress, XSTREAM2MEM_CONTROL_ADDR_ROWS_DATA, Data);
}

u32 XStream2mem_Get_rows(XStream2mem *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStream2mem_ReadReg(InstancePtr->Control_BaseAddress, XSTREAM2MEM_CONTROL_ADDR_ROWS_DATA);
    return Data;
}

void XStream2mem_Set_cols(XStream2mem *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XStream2mem_WriteReg(InstancePtr->Control_BaseAddress, XSTREAM2MEM_CONTROL_ADDR_COLS_DATA, Data);
}

u32 XStream2mem_Get_cols(XStream2mem *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XStream2mem_ReadReg(InstancePtr->Control_BaseAddress, XSTREAM2MEM_CONTROL_ADDR_COLS_DATA);
    return Data;
}

u32 XStream2mem_Get_baseAddr_BaseAddress(XStream2mem *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE);
}

u32 XStream2mem_Get_baseAddr_HighAddress(XStream2mem *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (InstancePtr->Control_BaseAddress + XSTREAM2MEM_CONTROL_ADDR_BASEADDR_HIGH);
}

u32 XStream2mem_Get_baseAddr_TotalBytes(XStream2mem *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return (XSTREAM2MEM_CONTROL_ADDR_BASEADDR_HIGH - XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE + 1);
}

u32 XStream2mem_Get_baseAddr_BitWidth(XStream2mem *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSTREAM2MEM_CONTROL_WIDTH_BASEADDR;
}

u32 XStream2mem_Get_baseAddr_Depth(XStream2mem *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XSTREAM2MEM_CONTROL_DEPTH_BASEADDR;
}

u32 XStream2mem_Write_baseAddr_Words(XStream2mem *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XSTREAM2MEM_CONTROL_ADDR_BASEADDR_HIGH - XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(int *)(InstancePtr->Control_BaseAddress + XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE + (offset + i)*4) = *(data + i);
    }
    return length;
}

u32 XStream2mem_Read_baseAddr_Words(XStream2mem *InstancePtr, int offset, word_type *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length)*4 > (XSTREAM2MEM_CONTROL_ADDR_BASEADDR_HIGH - XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(int *)(InstancePtr->Control_BaseAddress + XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE + (offset + i)*4);
    }
    return length;
}

u32 XStream2mem_Write_baseAddr_Bytes(XStream2mem *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XSTREAM2MEM_CONTROL_ADDR_BASEADDR_HIGH - XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(char *)(InstancePtr->Control_BaseAddress + XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE + offset + i) = *(data + i);
    }
    return length;
}

u32 XStream2mem_Read_baseAddr_Bytes(XStream2mem *InstancePtr, int offset, char *data, int length) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr -> IsReady == XIL_COMPONENT_IS_READY);

    int i;

    if ((offset + length) > (XSTREAM2MEM_CONTROL_ADDR_BASEADDR_HIGH - XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE + 1))
        return 0;

    for (i = 0; i < length; i++) {
        *(data + i) = *(char *)(InstancePtr->Control_BaseAddress + XSTREAM2MEM_CONTROL_ADDR_BASEADDR_BASE + offset + i);
    }
    return length;
}

