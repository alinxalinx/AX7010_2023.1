// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XMEM2STREAM_H
#define XMEM2STREAM_H

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
#include "xmem2stream_hw.h"

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
} XMem2stream_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XMem2stream;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XMem2stream_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XMem2stream_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XMem2stream_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XMem2stream_ReadReg(BaseAddress, RegOffset) \
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
int XMem2stream_Initialize(XMem2stream *InstancePtr, u16 DeviceId);
XMem2stream_Config* XMem2stream_LookupConfig(u16 DeviceId);
int XMem2stream_CfgInitialize(XMem2stream *InstancePtr, XMem2stream_Config *ConfigPtr);
#else
int XMem2stream_Initialize(XMem2stream *InstancePtr, const char* InstanceName);
int XMem2stream_Release(XMem2stream *InstancePtr);
#endif

void XMem2stream_Start(XMem2stream *InstancePtr);
u32 XMem2stream_IsDone(XMem2stream *InstancePtr);
u32 XMem2stream_IsIdle(XMem2stream *InstancePtr);
u32 XMem2stream_IsReady(XMem2stream *InstancePtr);
void XMem2stream_EnableAutoRestart(XMem2stream *InstancePtr);
void XMem2stream_DisableAutoRestart(XMem2stream *InstancePtr);

void XMem2stream_Set_pMemPort(XMem2stream *InstancePtr, u64 Data);
u64 XMem2stream_Get_pMemPort(XMem2stream *InstancePtr);
void XMem2stream_Set_rows(XMem2stream *InstancePtr, u32 Data);
u32 XMem2stream_Get_rows(XMem2stream *InstancePtr);
void XMem2stream_Set_cols(XMem2stream *InstancePtr, u32 Data);
u32 XMem2stream_Get_cols(XMem2stream *InstancePtr);
u32 XMem2stream_Get_baseAddr_BaseAddress(XMem2stream *InstancePtr);
u32 XMem2stream_Get_baseAddr_HighAddress(XMem2stream *InstancePtr);
u32 XMem2stream_Get_baseAddr_TotalBytes(XMem2stream *InstancePtr);
u32 XMem2stream_Get_baseAddr_BitWidth(XMem2stream *InstancePtr);
u32 XMem2stream_Get_baseAddr_Depth(XMem2stream *InstancePtr);
u32 XMem2stream_Write_baseAddr_Words(XMem2stream *InstancePtr, int offset, word_type *data, int length);
u32 XMem2stream_Read_baseAddr_Words(XMem2stream *InstancePtr, int offset, word_type *data, int length);
u32 XMem2stream_Write_baseAddr_Bytes(XMem2stream *InstancePtr, int offset, char *data, int length);
u32 XMem2stream_Read_baseAddr_Bytes(XMem2stream *InstancePtr, int offset, char *data, int length);

void XMem2stream_InterruptGlobalEnable(XMem2stream *InstancePtr);
void XMem2stream_InterruptGlobalDisable(XMem2stream *InstancePtr);
void XMem2stream_InterruptEnable(XMem2stream *InstancePtr, u32 Mask);
void XMem2stream_InterruptDisable(XMem2stream *InstancePtr, u32 Mask);
void XMem2stream_InterruptClear(XMem2stream *InstancePtr, u32 Mask);
u32 XMem2stream_InterruptGetEnabled(XMem2stream *InstancePtr);
u32 XMem2stream_InterruptGetStatus(XMem2stream *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
