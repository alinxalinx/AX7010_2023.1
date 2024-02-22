// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// control
// 0x00 : reserved
// 0x04 : reserved
// 0x08 : reserved
// 0x0c : reserved
// 0x10 : Data signal of average
//        bit 31~0 - average[31:0] (Read)
// 0x14 : Control signal of average
//        bit 0  - average_ap_vld (Read/COR)
//        others - reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XSOBEL_FOCUS_CONTROL_ADDR_AVERAGE_DATA 0x10
#define XSOBEL_FOCUS_CONTROL_BITS_AVERAGE_DATA 32
#define XSOBEL_FOCUS_CONTROL_ADDR_AVERAGE_CTRL 0x14

