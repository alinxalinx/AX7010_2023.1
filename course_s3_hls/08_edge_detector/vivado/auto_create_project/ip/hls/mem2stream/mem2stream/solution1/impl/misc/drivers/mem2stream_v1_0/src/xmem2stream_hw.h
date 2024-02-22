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
// 0x10 : Data signal of pMemPort
//        bit 31~0 - pMemPort[31:0] (Read/Write)
// 0x14 : Data signal of pMemPort
//        bit 31~0 - pMemPort[63:32] (Read/Write)
// 0x18 : reserved
// 0x1c : Data signal of rows
//        bit 31~0 - rows[31:0] (Read/Write)
// 0x20 : reserved
// 0x24 : Data signal of cols
//        bit 31~0 - cols[31:0] (Read/Write)
// 0x28 : reserved
// 0x30 ~
// 0x3f : Memory 'baseAddr' (3 * 32b)
//        Word n : bit [31:0] - baseAddr[n]
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XMEM2STREAM_CONTROL_ADDR_AP_CTRL       0x00
#define XMEM2STREAM_CONTROL_ADDR_GIE           0x04
#define XMEM2STREAM_CONTROL_ADDR_IER           0x08
#define XMEM2STREAM_CONTROL_ADDR_ISR           0x0c
#define XMEM2STREAM_CONTROL_ADDR_PMEMPORT_DATA 0x10
#define XMEM2STREAM_CONTROL_BITS_PMEMPORT_DATA 64
#define XMEM2STREAM_CONTROL_ADDR_ROWS_DATA     0x1c
#define XMEM2STREAM_CONTROL_BITS_ROWS_DATA     32
#define XMEM2STREAM_CONTROL_ADDR_COLS_DATA     0x24
#define XMEM2STREAM_CONTROL_BITS_COLS_DATA     32
#define XMEM2STREAM_CONTROL_ADDR_BASEADDR_BASE 0x30
#define XMEM2STREAM_CONTROL_ADDR_BASEADDR_HIGH 0x3f
#define XMEM2STREAM_CONTROL_WIDTH_BASEADDR     32
#define XMEM2STREAM_CONTROL_DEPTH_BASEADDR     3

