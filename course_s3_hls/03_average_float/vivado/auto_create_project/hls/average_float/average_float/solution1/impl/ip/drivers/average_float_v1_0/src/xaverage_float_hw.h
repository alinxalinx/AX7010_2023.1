// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0 - ap_done (Read/TOW)
//        bit 1 - ap_ready (Read/TOW)
//        others - reserved
// 0x10 : Data signal of ap_return
//        bit 31~0 - ap_return[31:0] (Read)
// 0x18 : Data signal of src
//        bit 31~0 - src[31:0] (Read/Write)
// 0x1c : Data signal of src
//        bit 31~0 - src[63:32] (Read/Write)
// 0x20 : reserved
// 0x24 : Data signal of num
//        bit 31~0 - num[31:0] (Read/Write)
// 0x28 : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XAVERAGE_FLOAT_CONTROL_ADDR_AP_CTRL   0x00
#define XAVERAGE_FLOAT_CONTROL_ADDR_GIE       0x04
#define XAVERAGE_FLOAT_CONTROL_ADDR_IER       0x08
#define XAVERAGE_FLOAT_CONTROL_ADDR_ISR       0x0c
#define XAVERAGE_FLOAT_CONTROL_ADDR_AP_RETURN 0x10
#define XAVERAGE_FLOAT_CONTROL_BITS_AP_RETURN 32
#define XAVERAGE_FLOAT_CONTROL_ADDR_SRC_DATA  0x18
#define XAVERAGE_FLOAT_CONTROL_BITS_SRC_DATA  64
#define XAVERAGE_FLOAT_CONTROL_ADDR_NUM_DATA  0x24
#define XAVERAGE_FLOAT_CONTROL_BITS_NUM_DATA  32

