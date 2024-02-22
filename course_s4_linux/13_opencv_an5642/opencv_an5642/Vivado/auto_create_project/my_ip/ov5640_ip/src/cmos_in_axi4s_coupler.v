`timescale 1ps/1ps
module cmos_in_axi4s_coupler  
#(
   parameter BUFFER_DEPTH = 4096
)(
  // System signals
  input  wire VID_IN_CLK,                 // Native video clock
  input  wire ACLK,                       // AXI4-Stream clock
  input  wire ARESETN,                    // AXI4-Stream reset, active low

  // FIFO write signals
  input  wire [FIFO_WIDTH - 1:0] FIFO_WR_DATA, // FIFO write data
  input  wire FIFO_WR_EN,                 // FIFO write enable

  // FIFO read signals
  output wire [FIFO_WIDTH - 1:0] FIFO_RD_DATA, // FIFO read data
  output wire FIFO_VALID,                 // FIFO valid
  input  wire FIFO_READY,                 // FIFO ready

  // FIFO status signals
  output wire FIFO_OVERFLOW,              // AXI4-Stream FIFO overflow
  output wire FIFO_UNDERFLOW              // Native video FIFO underflow
);
localparam FIFO_WIDTH	 = 18;
wire empty;
assign FIFO_VALID = FIFO_READY & ~empty;

reg[31:0]     reset_cnt;
reg[31:0]     fifo_ready_cnt;
reg           fifo_ready_write;
reg           cmos_aresetn;
(* ASYNC_REG="true" *) reg           axis_reset;
(* ASYNC_REG="true" *) reg           fifo_ready_maxis;
always@(posedge ACLK)
begin
    axis_reset <= cmos_aresetn;
    fifo_ready_maxis <= fifo_ready_write;
end
always@(posedge VID_IN_CLK)
begin
    if(reset_cnt < 32'd200_000_000)
    begin
        reset_cnt <= reset_cnt + 32'd1;
        cmos_aresetn <= 1'b0;
    end
    else
    begin
        cmos_aresetn <= 1'b1;
    end
end

always@(posedge VID_IN_CLK)
begin
    if(cmos_aresetn == 1'b0)
    begin
        fifo_ready_cnt <= 32'd0;
        fifo_ready_write <= 1'b0;
    end
    else if(fifo_ready_cnt < 32'd100_000_000)
    begin
        fifo_ready_cnt <= fifo_ready_cnt + 32'd1;
        fifo_ready_write <= 1'b0;
    end
    else
    begin
        fifo_ready_write <= 1'b1;
    end
end
/*
cmos_in_buf cmos_in_buf_inst
(
	.rst(~cmos_aresetn),
	.wr_clk(VID_IN_CLK),
	.rd_clk(ACLK),
	.din(FIFO_WR_DATA),
	.wr_en(FIFO_WR_EN & fifo_ready_write),
	.rd_en(FIFO_READY & fifo_ready_maxis & ~empty),
	.dout(FIFO_RD_DATA),
	.full(),
	.overflow(FIFO_OVERFLOW),
	.empty(empty),
	.underflow(FIFO_UNDERFLOW)
 );
 */
 xpm_fifo_async # (
 
   .FIFO_MEMORY_TYPE          ("auto"),           //string; "auto", "block", or "distributed";
   .ECC_MODE                  ("no_ecc"),         //string; "no_ecc" or "en_ecc";
   .RELATED_CLOCKS            (0),                //positive integer; 0 or 1
   .FIFO_WRITE_DEPTH          (BUFFER_DEPTH),     //positive integer
   .WRITE_DATA_WIDTH          (18),               //positive integer
   .WR_DATA_COUNT_WIDTH       (12),               //positive integer
   .PROG_FULL_THRESH          (10),               //positive integer
   .FULL_RESET_VALUE          (0),                //positive integer; 0 or 1
   .USE_ADV_FEATURES          ("0707"),           //string; "0000" to "1F1F"; 
   .READ_MODE                 ("fwft"),            //string; "std" or "fwft";
   .FIFO_READ_LATENCY         (0),                //positive integer;
   .READ_DATA_WIDTH           (18),               //positive integer
   .RD_DATA_COUNT_WIDTH       (12),               //positive integer
   .PROG_EMPTY_THRESH         (10),               //positive integer
   .DOUT_RESET_VALUE          ("0"),              //string
   .CDC_SYNC_STAGES           (2),                //positive integer
   .WAKEUP_TIME               (0)                 //positive integer; 0 or 2;
 
 ) xpm_fifo_async_inst (
 
       .rst              (~cmos_aresetn),
       .wr_clk           (VID_IN_CLK),
       .wr_en            (FIFO_WR_EN & fifo_ready_write),
       .din              (FIFO_WR_DATA),
       .full             (full),
       .overflow         (FIFO_OVERFLOW),
       .prog_full        (),
       .wr_data_count    (),
       .almost_full      (),
       .wr_ack           (),
       .wr_rst_busy      (),
       .rd_clk           (ACLK),
       .rd_en            (FIFO_READY & fifo_ready_maxis & ~empty),
       .dout             (FIFO_RD_DATA),
       .empty            (empty),
       .underflow        (FIFO_UNDERFLOW),
       .rd_rst_busy      (),
       .prog_empty       (),
       .rd_data_count    (),
       .almost_empty     (),
       .data_valid       (),
       .sleep            (1'b0),
       .injectsbiterr    (1'b0),
       .injectdbiterr    (1'b0),
       .sbiterr          (),
       .dbiterr          ()
 
 );
endmodule


