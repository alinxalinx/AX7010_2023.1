`timescale 1ns / 1ps
module alinx_ov5640
#(
   parameter BUFFER_DEPTH = 4096
)
(
	input                                        cmos_vsync,       //cmos vsync
	input                                        cmos_href,        //cmos hsync refrence
	input                                        cmos_pclk,        //cmos pxiel clock
	input   [9:0]                                cmos_d,           //cmos data
	// AXI4-Stream signals
	input                                        m_axis_video_aclk,                  // AXI4-Stream clock
	input                                        m_axis_video_aresetn,               // AXI4-Stream reset, active low 
	output [16:0]                                m_axis_video_tdata,    // AXI4-Stream data
	output                                       m_axis_video_tvalid,   // AXI4-Stream valid 
	input                                        m_axis_video_tready,   // AXI4-Stream ready 
	output                                       m_axis_video_tuser,    // AXI4-Stream tuser (SOF)
	output                                       m_axis_video_tlast,    // AXI4-Stream tlast (EOL)
	output[1:0]                                  m_axis_video_tkeep    // AXI4-Stream tkeep


    );
assign m_axis_video_tkeep = 2'b11;
wire[15:0] cmos_d_16bit;
wire cmos_href_16bit;
reg[7:0] cmos_d_d0;
reg cmos_href_d0;
reg cmos_vsync_d0;
wire cmos_hblank;

always@(posedge cmos_pclk)
begin
    cmos_d_d0 <= cmos_d[9:2];
    cmos_href_d0 <= cmos_href;
    cmos_vsync_d0 <= cmos_vsync;
end



cmos_8_16bit cmos_8_16bit_m0(
	.rst(1'b0),
	.pclk(cmos_pclk),
	.pdata_i(cmos_d_d0),
	.de_i(cmos_href_d0),
	
	.pdata_o(cmos_d_16bit),
	.hblank(cmos_hblank),
	.de_o(cmos_href_16bit)
);


wire vid_io_in_active_video;
wire vid_io_in_clk;
wire[15:0] vid_io_in_data;
wire vid_io_in_hsync;
wire vid_io_in_vsync;
assign vid_io_in_clk = cmos_pclk;
assign vid_io_in_active_video = cmos_href_16bit;
assign vid_io_in_data = cmos_d_16bit[15:0];
assign vid_io_in_hsync = cmos_href_d0;
assign vid_io_in_vsync = cmos_vsync_d0;


wire[15:0] m_axis_video_tdata;
wire m_axis_video_tvalid;
wire m_axis_video_tready;
wire m_axis_video_tuser;
wire m_axis_video_tlast;



cmos_in_axi4s #(
   .BUFFER_DEPTH(BUFFER_DEPTH)
)
cmos_in_axi4s_m0
  (
  // Native video signals
  .vid_io_in_clk           (vid_io_in_clk              ), // Native video clock
  .vid_active_video        (vid_io_in_active_video     ), // Native video data enable
  .vid_vblank              (1'b0                       ), // Native video vertical blank
  .vid_hblank              (cmos_hblank                ), // Native video horizontal blank
  .vid_vsync               (vid_io_in_vsync            ), // Native video vertical sync
  .vid_hsync               (vid_io_in_hsync            ), // Native video horizontal sync
  .vid_data                (vid_io_in_data             ), // Native video data 
  
  // AXI4-Stream signals
  .aclk                    (m_axis_video_aclk    ), // AXI4-Stream clock
  .aresetn                 (m_axis_video_aresetn ), // AXI4-Stream reset active low 
  .m_axis_video_tdata      (m_axis_video_tdata   ), // AXI4-Stream data
  .m_axis_video_tvalid     (m_axis_video_tvalid  ), // AXI4-Stream valid 
  .m_axis_video_tready     (m_axis_video_tready  ), // AXI4-Stream ready 
  .m_axis_video_tuser      (m_axis_video_tuser   ), // AXI4-Stream tuser (SOF)
  .m_axis_video_tlast      (m_axis_video_tlast   ) // AXI4-Stream tlast (EOL)

);
endmodule
