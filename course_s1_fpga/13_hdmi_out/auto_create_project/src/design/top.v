module top(
    input sys_clk,
    output hdmi_oen,
    output TMDS_clk_n,
    output TMDS_clk_p,
    output [2:0]TMDS_data_n,
    output [2:0]TMDS_data_p
);
wire video_clk;
wire video_clk_5x;
wire video_hs;
wire video_vs;
wire video_de;
wire[7:0] video_r;
wire[7:0] video_g;
wire[7:0] video_b;

color_bar hdmi_color_bar(
	.clk(video_clk),
	.rst(1'b0),
	.hs(video_hs),
	.vs(video_vs),
	.de(video_de),
	.rgb_r(video_r),
	.rgb_g(video_g),
	.rgb_b(video_b)
);

video_clock video_clock_m0
(
     // Clock in ports
    .clk_in1(sys_clk),
      // Clock out ports
    .clk_out1(video_clk),
    .clk_out2(video_clk_5x),
      // Status and control signals
    .reset(1'b0),
    .locked()
 );
 
rgb2dvi_0 rgb2dvi_m0 (
	// DVI 1.0 TMDS video interface
	.TMDS_Clk_p(TMDS_clk_p),
	.TMDS_Clk_n(TMDS_clk_n),
	.TMDS_Data_p(TMDS_data_p),
	.TMDS_Data_n(TMDS_data_n),
	.oen(hdmi_oen),
	//Auxiliary signals 
	.aRst_n(1'b1), //-asynchronous reset; must be reset when RefClk is not within spec
	
	// Video in
	.vid_pData({video_r,video_g,video_b}),
	.vid_pVDE(video_de),
	.vid_pHSync(video_hs),
	.vid_pVSync(video_vs),
	.PixelClk(video_clk),
	.SerialClk(video_clk_5x)// 5x PixelClk
); 
  
endmodule