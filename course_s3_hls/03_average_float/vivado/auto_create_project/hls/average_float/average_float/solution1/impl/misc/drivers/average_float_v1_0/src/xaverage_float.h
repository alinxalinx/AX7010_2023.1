// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XAVERAGE_FLOAT_H
#define XAVERAGE_FLOAT_H

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
#include "xaverage_float_hw.h"

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
} XAverage_float_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XAverage_float;

typedef u32 word_type;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XAverage_float_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XAverage_float_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XAverage_float_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XAverage_float_ReadReg(BaseAddress, RegOffset) \
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
int XAverage_float_Initialize(XAverage_float *InstancePtr, u16 DeviceId);
XAverage_float_Config* XAverage_float_LookupConfig(u16 DeviceId);
int XAverage_float_CfgInitialize(XAverage_float *InstancePtr, XAverage_float_Config *ConfigPtr);
#else
int XAverage_float_Initialize(XAverage_float *InstancePtr, const char* InstanceName);
int XAverage_float_Release(XAverage_float *InstancePtr);
#endif

void XAverage_float_Start(XAverage_float *InstancePtr);
u32 XAverage_float_IsDone(XAverage_float *InstancePtr);
u32 XAverage_float_IsIdle(XAverage_float *InstancePtr);
u32 XAverage_float_IsReady(XAverage_float *InstancePtr);
void XAverage_float_EnableAutoRestart(XAverage_float *InstancePtr);
void XAverage_float_DisableAutoRestart(XAverage_float *InstancePtr);
u32 XAverage_float_Get_return(XAverage_float *InstancePtr);

void XAverage_float_Set_src(XAverage_float *InstancePtr, u64 Data);
u64 XAverage_float_Get_src(XAverage_float *InstancePtr);
void XAverage_float_Set_num(XAverage_float *InstancePtr, u32 Data);
u32 XAverage_float_Get_num(XAverage_float *InstancePtr);

void XAverage_float_InterruptGlobalEnable(XAverage_float *InstancePtr);
void XAverage_float_InterruptGlobalDisable(XAverage_float *InstancePtr);
void XAverage_float_InterruptEnable(XAverage_float *InstancePtr, u32 Mask);
void XAverage_float_InterruptDisable(XAverage_float *InstancePtr, u32 Mask);
void XAverage_float_InterruptClear(XAverage_float *InstancePtr, u32 Mask);
u32 XAverage_float_InterruptGetEnabled(XAverage_float *InstancePtr);
u32 XAverage_float_InterruptGetStatus(XAverage_float *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
