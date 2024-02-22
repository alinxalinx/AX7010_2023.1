// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
`timescale 1ns/1ps
module stream2mem_control_s_axi
#(parameter
    C_S_AXI_ADDR_WIDTH = 6,
    C_S_AXI_DATA_WIDTH = 32
)(
    input  wire                          ACLK,
    input  wire                          ARESET,
    input  wire                          ACLK_EN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] AWADDR,
    input  wire                          AWVALID,
    output wire                          AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] WDATA,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0] WSTRB,
    input  wire                          WVALID,
    output wire                          WREADY,
    output wire [1:0]                    BRESP,
    output wire                          BVALID,
    input  wire                          BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] ARADDR,
    input  wire                          ARVALID,
    output wire                          ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] RDATA,
    output wire [1:0]                    RRESP,
    output wire                          RVALID,
    input  wire                          RREADY,
    output wire [63:0]                   pMemPort,
    output wire [31:0]                   rows,
    output wire [31:0]                   cols,
    input  wire [1:0]                    baseAddr_address0,
    input  wire                          baseAddr_ce0,
    output wire [31:0]                   baseAddr_q0
);
//------------------------Address Info-------------------
// 0x00 : reserved
// 0x04 : reserved
// 0x08 : reserved
// 0x0c : reserved
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

//------------------------Parameter----------------------
localparam
    ADDR_PMEMPORT_DATA_0 = 6'h10,
    ADDR_PMEMPORT_DATA_1 = 6'h14,
    ADDR_PMEMPORT_CTRL   = 6'h18,
    ADDR_ROWS_DATA_0     = 6'h1c,
    ADDR_ROWS_CTRL       = 6'h20,
    ADDR_COLS_DATA_0     = 6'h24,
    ADDR_COLS_CTRL       = 6'h28,
    ADDR_BASEADDR_BASE   = 6'h30,
    ADDR_BASEADDR_HIGH   = 6'h3f,
    WRIDLE               = 2'd0,
    WRDATA               = 2'd1,
    WRRESP               = 2'd2,
    WRRESET              = 2'd3,
    RDIDLE               = 2'd0,
    RDDATA               = 2'd1,
    RDRESET              = 2'd2,
    ADDR_BITS                = 6;

//------------------------Local signal-------------------
    reg  [1:0]                    wstate = WRRESET;
    reg  [1:0]                    wnext;
    reg  [ADDR_BITS-1:0]          waddr;
    wire [C_S_AXI_DATA_WIDTH-1:0] wmask;
    wire                          aw_hs;
    wire                          w_hs;
    reg  [1:0]                    rstate = RDRESET;
    reg  [1:0]                    rnext;
    reg  [C_S_AXI_DATA_WIDTH-1:0] rdata;
    wire                          ar_hs;
    wire [ADDR_BITS-1:0]          raddr;
    // internal registers
    reg  [63:0]                   int_pMemPort = 'b0;
    reg  [31:0]                   int_rows = 'b0;
    reg  [31:0]                   int_cols = 'b0;
    // memory signals
    wire [1:0]                    int_baseAddr_address0;
    wire                          int_baseAddr_ce0;
    wire [31:0]                   int_baseAddr_q0;
    wire [1:0]                    int_baseAddr_address1;
    wire                          int_baseAddr_ce1;
    wire                          int_baseAddr_we1;
    wire [3:0]                    int_baseAddr_be1;
    wire [31:0]                   int_baseAddr_d1;
    wire [31:0]                   int_baseAddr_q1;
    reg                           int_baseAddr_read;
    reg                           int_baseAddr_write;

//------------------------Instantiation------------------
// int_baseAddr
stream2mem_control_s_axi_ram #(
    .MEM_STYLE ( "auto" ),
    .MEM_TYPE  ( "2P" ),
    .BYTES     ( 4 ),
    .DEPTH     ( 3 )
) int_baseAddr (
    .clk0      ( ACLK ),
    .address0  ( int_baseAddr_address0 ),
    .ce0       ( int_baseAddr_ce0 ),
    .we0       ( {4{1'b0}} ),
    .d0        ( {32{1'b0}} ),
    .q0        ( int_baseAddr_q0 ),
    .clk1      ( ACLK ),
    .address1  ( int_baseAddr_address1 ),
    .ce1       ( int_baseAddr_ce1 ),
    .we1       ( int_baseAddr_be1 ),
    .d1        ( int_baseAddr_d1 ),
    .q1        ( int_baseAddr_q1 )
);


//------------------------AXI write fsm------------------
assign AWREADY = (wstate == WRIDLE);
assign WREADY  = (wstate == WRDATA) && (!ar_hs);
assign BRESP   = 2'b00;  // OKAY
assign BVALID  = (wstate == WRRESP);
assign wmask   = { {8{WSTRB[3]}}, {8{WSTRB[2]}}, {8{WSTRB[1]}}, {8{WSTRB[0]}} };
assign aw_hs   = AWVALID & AWREADY;
assign w_hs    = WVALID & WREADY;

// wstate
always @(posedge ACLK) begin
    if (ARESET)
        wstate <= WRRESET;
    else if (ACLK_EN)
        wstate <= wnext;
end

// wnext
always @(*) begin
    case (wstate)
        WRIDLE:
            if (AWVALID)
                wnext = WRDATA;
            else
                wnext = WRIDLE;
        WRDATA:
            if (w_hs)
                wnext = WRRESP;
            else
                wnext = WRDATA;
        WRRESP:
            if (BREADY)
                wnext = WRIDLE;
            else
                wnext = WRRESP;
        default:
            wnext = WRIDLE;
    endcase
end

// waddr
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (aw_hs)
            waddr <= AWADDR[ADDR_BITS-1:0];
    end
end

//------------------------AXI read fsm-------------------
assign ARREADY = (rstate == RDIDLE);
assign RDATA   = rdata;
assign RRESP   = 2'b00;  // OKAY
assign RVALID  = (rstate == RDDATA) & !int_baseAddr_read;
assign ar_hs   = ARVALID & ARREADY;
assign raddr   = ARADDR[ADDR_BITS-1:0];

// rstate
always @(posedge ACLK) begin
    if (ARESET)
        rstate <= RDRESET;
    else if (ACLK_EN)
        rstate <= rnext;
end

// rnext
always @(*) begin
    case (rstate)
        RDIDLE:
            if (ARVALID)
                rnext = RDDATA;
            else
                rnext = RDIDLE;
        RDDATA:
            if (RREADY & RVALID)
                rnext = RDIDLE;
            else
                rnext = RDDATA;
        default:
            rnext = RDIDLE;
    endcase
end

// rdata
always @(posedge ACLK) begin
    if (ACLK_EN) begin
        if (ar_hs) begin
            rdata <= 'b0;
            case (raddr)
                ADDR_PMEMPORT_DATA_0: begin
                    rdata <= int_pMemPort[31:0];
                end
                ADDR_PMEMPORT_DATA_1: begin
                    rdata <= int_pMemPort[63:32];
                end
                ADDR_ROWS_DATA_0: begin
                    rdata <= int_rows[31:0];
                end
                ADDR_COLS_DATA_0: begin
                    rdata <= int_cols[31:0];
                end
            endcase
        end
        else if (int_baseAddr_read) begin
            rdata <= int_baseAddr_q1;
        end
    end
end


//------------------------Register logic-----------------
assign pMemPort = int_pMemPort;
assign rows     = int_rows;
assign cols     = int_cols;
// int_pMemPort[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_pMemPort[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_PMEMPORT_DATA_0)
            int_pMemPort[31:0] <= (WDATA[31:0] & wmask) | (int_pMemPort[31:0] & ~wmask);
    end
end

// int_pMemPort[63:32]
always @(posedge ACLK) begin
    if (ARESET)
        int_pMemPort[63:32] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_PMEMPORT_DATA_1)
            int_pMemPort[63:32] <= (WDATA[31:0] & wmask) | (int_pMemPort[63:32] & ~wmask);
    end
end

// int_rows[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_rows[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_ROWS_DATA_0)
            int_rows[31:0] <= (WDATA[31:0] & wmask) | (int_rows[31:0] & ~wmask);
    end
end

// int_cols[31:0]
always @(posedge ACLK) begin
    if (ARESET)
        int_cols[31:0] <= 0;
    else if (ACLK_EN) begin
        if (w_hs && waddr == ADDR_COLS_DATA_0)
            int_cols[31:0] <= (WDATA[31:0] & wmask) | (int_cols[31:0] & ~wmask);
    end
end


//------------------------Memory logic-------------------
// baseAddr
assign int_baseAddr_address0 = baseAddr_address0;
assign int_baseAddr_ce0      = baseAddr_ce0;
assign baseAddr_q0           = int_baseAddr_q0;
assign int_baseAddr_address1 = ar_hs? raddr[3:2] : waddr[3:2];
assign int_baseAddr_ce1      = ar_hs | (int_baseAddr_write & WVALID);
assign int_baseAddr_we1      = int_baseAddr_write & w_hs;
assign int_baseAddr_be1      = int_baseAddr_we1 ? WSTRB : 'b0;
assign int_baseAddr_d1       = WDATA;
// int_baseAddr_read
always @(posedge ACLK) begin
    if (ARESET)
        int_baseAddr_read <= 1'b0;
    else if (ACLK_EN) begin
        if (ar_hs && raddr >= ADDR_BASEADDR_BASE && raddr <= ADDR_BASEADDR_HIGH)
            int_baseAddr_read <= 1'b1;
        else
            int_baseAddr_read <= 1'b0;
    end
end

// int_baseAddr_write
always @(posedge ACLK) begin
    if (ARESET)
        int_baseAddr_write <= 1'b0;
    else if (ACLK_EN) begin
        if (aw_hs && AWADDR[ADDR_BITS-1:0] >= ADDR_BASEADDR_BASE && AWADDR[ADDR_BITS-1:0] <= ADDR_BASEADDR_HIGH)
            int_baseAddr_write <= 1'b1;
        else if (w_hs)
            int_baseAddr_write <= 1'b0;
    end
end


endmodule


`timescale 1ns/1ps

module stream2mem_control_s_axi_ram
#(parameter
    MEM_STYLE = "auto",
    MEM_TYPE  = "S2P",
    BYTES  = 4,
    DEPTH  = 256,
    AWIDTH = log2(DEPTH)
) (
    input  wire               clk0,
    input  wire [AWIDTH-1:0]  address0,
    input  wire               ce0,
    input  wire [BYTES-1:0]   we0,
    input  wire [BYTES*8-1:0] d0,
    output reg  [BYTES*8-1:0] q0,
    input  wire               clk1,
    input  wire [AWIDTH-1:0]  address1,
    input  wire               ce1,
    input  wire [BYTES-1:0]   we1,
    input  wire [BYTES*8-1:0] d1,
    output reg  [BYTES*8-1:0] q1
);
//------------------------ Parameters -------------------
localparam
    BYTE_WIDTH = 8,
    PORT0 = (MEM_TYPE == "S2P") ? "WO" : ((MEM_TYPE == "2P") ? "RO" : "RW"),
    PORT1 = (MEM_TYPE == "S2P") ? "RO" : "RW";
//------------------------Local signal-------------------
(* ram_style = MEM_STYLE*)
reg  [BYTES*8-1:0] mem[0:DEPTH-1];
wire re0, re1;
//------------------------Task and function--------------
function integer log2;
    input integer x;
    integer n, m;
begin
    n = 1;
    m = 2;
    while (m < x) begin
        n = n + 1;
        m = m * 2;
    end
    log2 = n;
end
endfunction
//------------------------Body---------------------------
generate
    if (MEM_STYLE == "hls_ultra" && PORT0 == "RW") begin
        assign re0 = ce0 & ~|we0;
    end else begin
        assign re0 = ce0;
    end
endgenerate

generate
    if (MEM_STYLE == "hls_ultra" && PORT1 == "RW") begin
        assign re1 = ce1 & ~|we1;
    end else begin
        assign re1 = ce1;
    end
endgenerate

// read port 0
generate if (PORT0 != "WO") begin
    always @(posedge clk0) begin
        if (re0) q0 <= mem[address0];
    end
end
endgenerate

// read port 1
generate if (PORT1 != "WO") begin
    always @(posedge clk1) begin
        if (re1) q1 <= mem[address1];
    end
end
endgenerate

integer i;
// write port 0
generate if (PORT0 != "RO") begin
    always @(posedge clk0) begin
        if (ce0)
        for (i = 0; i < BYTES; i = i + 1)
            if (we0[i])
                mem[address0][i*BYTE_WIDTH +: BYTE_WIDTH] <= d0[i*BYTE_WIDTH +: BYTE_WIDTH];
    end
end
endgenerate

// write port 1
generate if (PORT1 != "RO") begin
    always @(posedge clk1) begin
        if (ce1)
        for (i = 0; i < BYTES; i = i + 1)
            if (we1[i])
                mem[address1][i*BYTE_WIDTH +: BYTE_WIDTH] <= d1[i*BYTE_WIDTH +: BYTE_WIDTH];
    end
end
endgenerate

endmodule

