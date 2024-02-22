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
//2017/7/20                    1.0          Original
//*******************************************************************************/
module top(
	//system clocks
	input                       sys_clk,
	input                       rst_n,
	//adc
	input[7:0]                  ad9280_data,
	output                      ad9280_clk,
	//dac
	output[7:0]                 ad9708_data,
	output                      ad9708_clk,
	//hdmi output        
            output                      TMDS_clk_p,
            output                      TMDS_clk_n,
            output[2:0]                 TMDS_data_p,       //rgb
            output[2:0]                 TMDS_data_n,        //rgb
            output [0:0]                hdmi_oen

);

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

wire                            grid_hs;
wire                            grid_vs;
wire                            grid_de;
wire[7:0]                       grid_r;
wire[7:0]                       grid_g;
wire[7:0]                       grid_b;

wire                            wave0_hs;
wire                            wave0_vs;
wire                            wave0_de;
wire[7:0]                       wave0_r;
wire[7:0]                       wave0_g;
wire[7:0]                       wave0_b;

wire                            adc_clk;
wire                            adc0_buf_wr;
wire[10:0]                      adc0_buf_addr;
wire[7:0]                       adc0_buf_data;
wire                            dac_clk;
wire[7:0]                       dac_data;
reg[8:0]                        rom_addr;
assign hdmi_hs = wave0_hs;
assign hdmi_vs = wave0_vs;
assign hdmi_de = wave0_de;
assign hdmi_r  = wave0_r;
assign hdmi_g  = wave0_g;
assign hdmi_b  = wave0_b;

assign ad9280_clk = adc_clk;
assign ad9708_clk = dac_clk;
assign ad9708_data = dac_data;


//generate video pixel clock
video_pll video_pll_m0
 (
	.clk_in1                    (sys_clk                  ),
	.clk_out1                   (video_clk                ),
	.clk_out2                   (video_clk5x              ),
	.reset                      (1'b0                     ),
	.locked                     (                         )
 );

adda_pll adda_pll_m0
 (
	.clk_in1                    (sys_clk                  ),
	.clk_out1                   (adc_clk                  ),
	.clk_out2                   (dac_clk                  ),
	.reset                      (1'b0                     ),
	.locked                     (                         )
 );
 
//dac 125Mhz/512 = 244.14khz
always@(posedge dac_clk)
begin
	rom_addr <= rom_addr + 9'd1;
end
da_rom da_rom_m0 (
	.clka                       (dac_clk                 ),   
	.ena                        (1'b1                    ),     
	.addra                      (rom_addr                ), 
	.douta                      (dac_data                )  
);

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
    .vid_pData({hdmi_r,hdmi_g,hdmi_b}),
    .vid_pVDE(hdmi_de),
    .vid_pHSync(hdmi_hs),
    .vid_pVSync(hdmi_vs),       
    .PixelClk(video_clk),
    
    .SerialClk(video_clk5x)// 5x PixelClk
    );

grid_display  grid_display_m0(
	.rst_n                 (rst_n                      ),
	.pclk                  (video_clk                  ),
	.i_hs                  (video_hs                   ),
	.i_vs                  (video_vs                   ),
	.i_de                  (video_de                   ),
	.i_data                ({video_r,video_g,video_b}  ),
	.o_hs                  (grid_hs                    ),
	.o_vs                  (grid_vs                    ),
	.o_de                  (grid_de                    ),
	.o_data                ({grid_r,grid_g,grid_b}     )
);

ad9280_sample ad9280_sample_m0(
	.adc_clk               (adc_clk                    ),
	.rst                   (~rst_n                     ),
	.adc_data              (ad9280_data                ),
	.adc_data_valid        (1'b1                       ),
	.adc_buf_wr            (adc0_buf_wr                ),
	.adc_buf_addr          (adc0_buf_addr              ),
	.adc_buf_data          (adc0_buf_data              )
);

//display 50khz - 1Mhz
wav_display wav_display_m0(
	.rst_n                 (rst_n                      ),
	.pclk                  (video_clk                  ),
	.wave_color            (24'hff0000                 ),
	.adc_clk               (adc_clk                    ),
	.adc_buf_wr            (adc0_buf_wr                ),
	.adc_buf_addr          (adc0_buf_addr              ),
	.adc_buf_data          (adc0_buf_data              ),
	.i_hs                  (grid_hs                    ),
	.i_vs                  (grid_vs                    ),
	.i_de                  (grid_de                    ),
	.i_data                ({grid_r,grid_g,grid_b}     ),
	.o_hs                  (wave0_hs                   ),
	.o_vs                  (wave0_vs                   ),
	.o_de                  (wave0_de                   ),
	.o_data                ({wave0_r,wave0_g,wave0_b}  )
);

endmodule