//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2017/6/19     meisq         1.0         Original
//*******************************************************************************/
module top(
    //sys
    input       				sys_clk,   
    input       				rst_n,
	//rtc interface
    output      				rtc_sclk,
    output      				rtc_ce,
    inout       				rtc_data,
	//hdmi output        
    output                      TMDS_clk_p,
    output                      TMDS_clk_n,
    output[2:0]                 TMDS_data_p,        
    output[2:0]                 TMDS_data_n,        
    output [0:0]                hdmi_oen
    );

wire[7:0] 						read_second;
wire[7:0] 						read_minute;
wire[7:0] 						read_hour;
wire[7:0] 						read_date;
wire[7:0] 						read_month;
wire[7:0] 						read_week;
wire[7:0] 						read_year;


wire                            video_clk;
wire                            video_clk5x;
wire                            video_hs;
wire                            video_vs;
wire                            video_de;
wire[7:0]                       video_r;
wire[7:0]                       video_g;
wire[7:0]                       video_b;

wire                            hdmi_hs;
wire                            hdmi_vs;
wire                            hdmi_de;
wire[7:0]                       hdmi_r;
wire[7:0]                       hdmi_g;
wire[7:0]                       hdmi_b;

wire                            osd_hs;
wire                            osd_vs;
wire                            osd_de;
wire[7:0]                       osd_r;
wire[7:0]                       osd_g;
wire[7:0]                       osd_b;


assign hdmi_hs     = osd_hs;
assign hdmi_vs     = osd_vs;
assign hdmi_de     = osd_de;
assign hdmi_r      = osd_r[7:0];
assign hdmi_g      = osd_g[7:0];
assign hdmi_b      = osd_b[7:0];
//generate video pixel clock
video_pll video_pll_m0(
    .clk_in1                    (sys_clk                  ),
    .clk_out1                   (video_clk                ),
    .clk_out2                   (video_clk5x              ),
    .reset                      (1'b0                     ),
    .locked                     (                         )
    );
	
//color bar
color_bar color_bar_m0(
	.clk                        (video_clk                ),
	.rst                        (~rst_n                   ),
	.hs                         (video_hs                 ),
	.vs                         (video_vs                 ),
	.de                         (video_de                 ),
	.rgb_r                      (video_r                  ),
	.rgb_g                      (video_g                  ),
	.rgb_b                      (video_b                  )
);
//rgb to dvi module
rgb2dvi_0 rgb2dvi_m0 (
    // DVI 1.0 TMDS video interface
    .TMDS_Clk_p		(TMDS_clk_p),
    .TMDS_Clk_n		(TMDS_clk_n),
    .TMDS_Data_p	(TMDS_data_p),
    .TMDS_Data_n	(TMDS_data_n),
    .oen			(hdmi_oen),
    //Auxiliary signals 
    .aRst_n			(1'b1), //-asynchronous reset; must be reset when RefClk is not within spec
    
    // Video in
    .vid_pData		({hdmi_r,hdmi_g,hdmi_b}),
    .vid_pVDE		(hdmi_de),
    .vid_pHSync		(hdmi_hs),
    .vid_pVSync		(hdmi_vs),       
    .PixelClk		(video_clk),    
    .SerialClk		(video_clk5x)// 5x PixelClk
    ); 

rtc_osd  osd_display_m0(
	.rst_n                 (rst_n                      ),
	.pclk                  (video_clk                  ),
	.rtc_data			   ({read_hour,read_minute,read_second}),	//only use hour, minute,second data
	.i_hs                  (video_hs                   ),
	.i_vs                  (video_vs                   ),
	.i_de                  (video_de                   ),
	.i_data                ({video_r,video_g,video_b}  ),
	.o_hs                  (osd_hs                     ),
	.o_vs                  (osd_vs                     ),
	.o_de                  (osd_de                     ),
	.o_data                ({osd_r,osd_g,osd_b}        )
);


ds1302_test ds1302_test_m0(
    .rst         	(~rst_n),
    .clk         	(video_clk),
    .ds1302_ce   	(rtc_ce),
    .ds1302_sclk 	(rtc_sclk),
    .ds1302_io   	(rtc_data),
    .read_second 	(read_second),
    .read_minute 	(read_minute),
    .read_hour   	(read_hour),
    .read_date   	(read_date),
    .read_month  	(read_month),
    .read_week   	(read_week),
    .read_year   	(read_year)
);
endmodule 
    
    