// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XSTREAM2MEM_H
#define XSTREAM2MEM_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xstream2mem_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u64 Control_BaseAddress;
} XStream2mem_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XStream2mem;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XStream2mem_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XStream2mem_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XStream2mem_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XStream2mem_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XStream2mem_Initialize(XStream2mem *InstancePtr, u16 DeviceId);
XStream2mem_Config* XStream2mem_LookupConfig(u16 DeviceId);
int XStream2mem_CfgInitialize(XStream2mem *InstancePtr, XStream2mem_Config *ConfigPtr);
#else
int XStream2mem_Initialize(XStream2mem *InstancePtr, const char* InstanceName);
int XStream2mem_Release(XStream2mem *InstancePtr);
#endif


void XStream2mem_Set_pMemPort(XStream2mem *InstancePtr, u64 Data);
u64 XStream2mem_Get_pMemPort(XStream2mem *InstancePtr);
void XStream2mem_Set_rows(XStream2mem *InstancePtr, u32 Data);
u32 XStream2mem_Get_rows(XStream2mem *InstancePtr);
void XStream2mem_Set_cols(XStream2mem *InstancePtr, u32 Data);
u32 XStream2mem_Get_cols(XStream2mem *InstancePtr);
u32 XStream2mem_Get_baseAddr_BaseAddress(XStream2mem *InstancePtr);
u32 XStream2mem_Get_baseAddr_HighAddress(XStream2mem *InstancePtr);
u32 XStream2mem_Get_baseAddr_TotalBytes(XStream2mem *InstancePtr);
u32 XStream2mem_Get_baseAddr_BitWidth(XStream2mem *InstancePtr);
u32 XStream2mem_Get_baseAddr_Depth(XStream2mem *InstancePtr);
u32 XStream2mem_Write_baseAddr_Words(XStream2mem *InstancePtr, int offset, word_type *data, int length);
u32 XStream2mem_Read_baseAddr_Words(XStream2mem *InstancePtr, int offset, word_type *data, int length);
u32 XStream2mem_Write_baseAddr_Bytes(XStream2mem *InstancePtr, int offset, char *data, int length);
u32 XStream2mem_Read_baseAddr_Bytes(XStream2mem *InstancePtr, int offset, char *data, int length);

#ifdef __cplusplus
}
#endif

#endif
