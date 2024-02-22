`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ALINX黑金
// Engineer: 老梅
// 
// Create Date: 2016/11/17 10:27:06
// Design Name: 
// Module Name: mem_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
  inout [14:0]DDR_addr,
  inout [2:0]DDR_ba,
  inout DDR_cas_n,
  inout DDR_ck_n,
  inout DDR_ck_p,
  inout DDR_cke,
  inout DDR_cs_n,
  inout [3:0]DDR_dm,
  inout [31:0]DDR_dq,
  inout [3:0]DDR_dqs_n,
  inout [3:0]DDR_dqs_p,
  inout DDR_odt,
  inout DDR_ras_n,
  inout DDR_reset_n,
  inout DDR_we_n,
  inout FIXED_IO_ddr_vrn,
  inout FIXED_IO_ddr_vrp,
  inout [53:0]FIXED_IO_mio,
  inout FIXED_IO_ps_clk,
  inout FIXED_IO_ps_porb,
  inout FIXED_IO_ps_srstb,
  
  output error
    );
wire rst_n;	
wire M_AXI_ACLK;
// Master Write Address
wire [0:0]  M_AXI_AWID;
wire [31:0] M_AXI_AWADDR;
wire [7:0]  M_AXI_AWLEN;    // Burst Length: 0-255
wire [2:0]  M_AXI_AWSIZE;   // Burst Size: Fixed 2'b011
wire [1:0]  M_AXI_AWBURST;  // Burst Type: Fixed 2'b01(Incremental Burst)
wire        M_AXI_AWLOCK;   // Lock: Fixed 2'b00
wire [3:0]  M_AXI_AWCACHE;  // Cache: Fiex 2'b0011
wire [2:0]  M_AXI_AWPROT;   // Protect: Fixed 2'b000
wire [3:0]  M_AXI_AWQOS;    // QoS: Fixed 2'b0000
wire [0:0]  M_AXI_AWUSER;   // User: Fixed 32'd0
wire        M_AXI_AWVALID;
wire        M_AXI_AWREADY;

// Master Write Data
wire [63:0] M_AXI_WDATA;
wire [7:0]  M_AXI_WSTRB;
wire        M_AXI_WLAST;
wire [0:0]  M_AXI_WUSER;
wire        M_AXI_WVALID;
wire        M_AXI_WREADY;

// Master Write Response
wire [0:0]   M_AXI_BID;
wire [1:0]   M_AXI_BRESP;
wire [0:0]   M_AXI_BUSER;
wire         M_AXI_BVALID;
wire         M_AXI_BREADY;
    
// Master Read Address
wire [0:0]  M_AXI_ARID;
wire [31:0] M_AXI_ARADDR;
wire [7:0]  M_AXI_ARLEN;
wire [2:0]  M_AXI_ARSIZE;
wire [1:0]  M_AXI_ARBURST;
wire [1:0]  M_AXI_ARLOCK;
wire [3:0]  M_AXI_ARCACHE;
wire [2:0]  M_AXI_ARPROT;
wire [3:0]  M_AXI_ARQOS;
wire [0:0]  M_AXI_ARUSER;
wire        M_AXI_ARVALID;
wire        M_AXI_ARREADY;
    
// Master Read Data 
wire [0:0]   M_AXI_RID;
wire [63:0]  M_AXI_RDATA;
wire [1:0]   M_AXI_RRESP;
wire         M_AXI_RLAST;
wire [0:0]   M_AXI_RUSER;
wire         M_AXI_RVALID;
wire         M_AXI_RREADY;

(*mark_debug="true"*)wire wr_burst_data_req;
(*mark_debug="true"*)wire wr_burst_finish;
(*mark_debug="true"*)wire rd_burst_finish;
(*mark_debug="true"*)wire rd_burst_req;
(*mark_debug="true"*)wire wr_burst_req;
(*mark_debug="true"*)wire[9:0] rd_burst_len;
(*mark_debug="true"*)wire[9:0] wr_burst_len;
(*mark_debug="true"*)wire[31:0] rd_burst_addr;
(*mark_debug="true"*)wire[31:0] wr_burst_addr;
(*mark_debug="true"*)wire rd_burst_data_valid;
(*mark_debug="true"*)wire[63 : 0] rd_burst_data;
(*mark_debug="true"*)wire[63 : 0] wr_burst_data;

mem_test
#(
	.MEM_DATA_BITS(64),
	.ADDR_BITS(27)
)
mem_test_m0
(
	.rst(~rst_n),                                 
	.mem_clk(M_AXI_ACLK),                             
	.rd_burst_req(rd_burst_req),               
	.wr_burst_req(wr_burst_req),               
	.rd_burst_len(rd_burst_len),               
	.wr_burst_len(wr_burst_len),               
	.rd_burst_addr(rd_burst_addr),        
	.wr_burst_addr(wr_burst_addr),        
	.rd_burst_data_valid(rd_burst_data_valid),  
	.wr_burst_data_req(wr_burst_data_req),  
	.rd_burst_data(rd_burst_data),  
	.wr_burst_data(wr_burst_data),    
	.rd_burst_finish(rd_burst_finish),   
	.wr_burst_finish(wr_burst_finish),

	.error(error)
); 
aq_axi_master u_aq_axi_master
(
	.ARESETN(rst_n),
	.ACLK(M_AXI_ACLK),
	
	.M_AXI_AWID(M_AXI_AWID),
	.M_AXI_AWADDR(M_AXI_AWADDR),     
	.M_AXI_AWLEN(M_AXI_AWLEN),
	.M_AXI_AWSIZE(M_AXI_AWSIZE),
	.M_AXI_AWBURST(M_AXI_AWBURST),
	.M_AXI_AWLOCK(M_AXI_AWLOCK),
	.M_AXI_AWCACHE(M_AXI_AWCACHE),
	.M_AXI_AWPROT(M_AXI_AWPROT),
	.M_AXI_AWQOS(M_AXI_AWQOS),
	.M_AXI_AWUSER(M_AXI_AWUSER),
	.M_AXI_AWVALID(M_AXI_AWVALID),
	.M_AXI_AWREADY(M_AXI_AWREADY),
	
	.M_AXI_WDATA(M_AXI_WDATA),
	.M_AXI_WSTRB(M_AXI_WSTRB),
	.M_AXI_WLAST(M_AXI_WLAST),
	.M_AXI_WUSER(M_AXI_WUSER),
	.M_AXI_WVALID(M_AXI_WVALID),
	.M_AXI_WREADY(M_AXI_WREADY),
	
	.M_AXI_BID(M_AXI_BID),
	.M_AXI_BRESP(M_AXI_BRESP),
	.M_AXI_BUSER(M_AXI_BUSER),
	.M_AXI_BVALID(M_AXI_BVALID),
	.M_AXI_BREADY(M_AXI_BREADY),
	
	.M_AXI_ARID(M_AXI_ARID),
	.M_AXI_ARADDR(M_AXI_ARADDR),
	.M_AXI_ARLEN(M_AXI_ARLEN),
	.M_AXI_ARSIZE(M_AXI_ARSIZE),
	.M_AXI_ARBURST(M_AXI_ARBURST),
	.M_AXI_ARLOCK(M_AXI_ARLOCK),
	.M_AXI_ARCACHE(M_AXI_ARCACHE),
	.M_AXI_ARPROT(M_AXI_ARPROT),
	.M_AXI_ARQOS(M_AXI_ARQOS),
	.M_AXI_ARUSER(M_AXI_ARUSER),
	.M_AXI_ARVALID(M_AXI_ARVALID),
	.M_AXI_ARREADY(M_AXI_ARREADY),
	
	.M_AXI_RID(M_AXI_RID),
	.M_AXI_RDATA(M_AXI_RDATA),
	.M_AXI_RRESP(M_AXI_RRESP),
	.M_AXI_RLAST(M_AXI_RLAST),
	.M_AXI_RUSER(M_AXI_RUSER),
	.M_AXI_RVALID(M_AXI_RVALID),
	.M_AXI_RREADY(M_AXI_RREADY),
	
	.MASTER_RST(~rst_n),
	
	.WR_START(wr_burst_req),
	.WR_ADRS({wr_burst_addr[28:0],3'd0}),
	.WR_LEN({wr_burst_len,3'd0}), 
	.WR_READY(),
	.WR_FIFO_RE(wr_burst_data_req),
	.WR_FIFO_EMPTY(1'b0),
	.WR_FIFO_AEMPTY(1'b0),
	.WR_FIFO_DATA(wr_burst_data),
	.WR_DONE(wr_burst_finish),
	
	.RD_START(rd_burst_req),
	.RD_ADRS({rd_burst_addr[28:0],3'd0}),
	.RD_LEN({rd_burst_len,3'd0}), 
	.RD_READY(),
	.RD_FIFO_WE(rd_burst_data_valid),
	.RD_FIFO_FULL(1'b0),
	.RD_FIFO_AFULL(1'b0),
	.RD_FIFO_DATA(rd_burst_data),
	.RD_DONE(rd_burst_finish),
	.DEBUG()                                         
);

	
design_1_wrapper ps_block
(
	.DDR_addr(DDR_addr),
	.DDR_ba(DDR_ba),
	.DDR_cas_n(DDR_cas_n),
	.DDR_ck_n(DDR_ck_n),
	.DDR_ck_p(DDR_ck_p),
	.DDR_cke(DDR_cke),
	.DDR_cs_n(DDR_cs_n),
	.DDR_dm(DDR_dm),
	.DDR_dq(DDR_dq),
	.DDR_dqs_n(DDR_dqs_n),
	.DDR_dqs_p(DDR_dqs_p),
	.DDR_odt(DDR_odt),
	.DDR_ras_n(DDR_ras_n),
	.DDR_reset_n(DDR_reset_n),
	.DDR_we_n(DDR_we_n),
	.FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
	.FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
	.FIXED_IO_mio(FIXED_IO_mio),
	.FIXED_IO_ps_clk(FIXED_IO_ps_clk),
	.FIXED_IO_ps_porb(FIXED_IO_ps_porb),
	.FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
    	
	.S00_AXI_araddr       (M_AXI_ARADDR          ),
	.S00_AXI_arburst      (M_AXI_ARBURST         ),
	.S00_AXI_arcache      (M_AXI_ARCACHE         ),
	.S00_AXI_arid         (M_AXI_ARID            ),
	.S00_AXI_arlen        (M_AXI_ARLEN           ),
	.S00_AXI_arlock       (M_AXI_ARLOCK          ),
	.S00_AXI_arprot       (M_AXI_ARPROT          ),
	.S00_AXI_arqos        (M_AXI_ARQOS           ),
	.S00_AXI_arready      (M_AXI_ARREADY         ),
	.S00_AXI_arregion     (4'b0000               ),
	.S00_AXI_arsize       (M_AXI_ARSIZE          ),
	.S00_AXI_arvalid      (M_AXI_ARVALID         ),
	.S00_AXI_rdata        (M_AXI_RDATA           ),
	.S00_AXI_rid          (M_AXI_RID             ),
	.S00_AXI_rlast        (M_AXI_RLAST           ),
	.S00_AXI_rready       (M_AXI_RREADY          ),
	.S00_AXI_rresp        (M_AXI_RRESP           ),
	.S00_AXI_rvalid       (M_AXI_RVALID          ),
		
	.S00_AXI_awaddr       (M_AXI_AWADDR          ),
	.S00_AXI_awburst      (M_AXI_AWBURST         ),
	.S00_AXI_awcache      (M_AXI_AWCACHE         ),
	.S00_AXI_awid         (M_AXI_AWID            ),
	.S00_AXI_awlen        (M_AXI_AWLEN           ),
	.S00_AXI_awlock       (M_AXI_AWLOCK          ),
	.S00_AXI_awprot       (M_AXI_AWPROT          ),
	.S00_AXI_awqos        (M_AXI_AWQOS           ),
	.S00_AXI_awready      (M_AXI_AWREADY         ),
	.S00_AXI_awregion     (4'b0000               ),
	.S00_AXI_awsize       (M_AXI_AWSIZE          ),
	.S00_AXI_awvalid      (M_AXI_AWVALID         ),
	.S00_AXI_bid          (M_AXI_BID             ),
	.S00_AXI_bready       (M_AXI_BREADY          ),
	.S00_AXI_bresp        (M_AXI_BRESP           ),
	.S00_AXI_bvalid       (M_AXI_BVALID          ),
	.S00_AXI_wdata        (M_AXI_WDATA           ),
	.S00_AXI_wlast        (M_AXI_WLAST           ),
	.S00_AXI_wready       (M_AXI_WREADY          ),
	.S00_AXI_wstrb        (M_AXI_WSTRB           ),
	.S00_AXI_wvalid       (M_AXI_WVALID          ),
	
	.axim_rst_n(rst_n),
	.FCLK_CLK0(M_AXI_ACLK),
	.axi_hp_clk(M_AXI_ACLK)
);
endmodule
