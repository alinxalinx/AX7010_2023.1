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
//2017/8/20                    1.0          Original
//*******************************************************************************/
module wav_display(
	input                       rst_n,   
	input                       pclk,
	input[23:0]                 wave_color,
	input                       adc_clk,
	input                       adc_buf_wr,
	input[11:0]                 adc_buf_addr,
	input[7:0]                  adc_buf_data,
	input                       i_hs,    
	input                       i_vs,    
	input                       i_de,	
	input[23:0]                 i_data,  
	output                      o_hs,    
	output                      o_vs,    
	output                      o_de,    
	output[23:0]                o_data
);
wire[11:0] pos_x;
wire[11:0] pos_y;
wire       pos_hs;
wire       pos_vs;
wire       pos_de;
wire[23:0] pos_data;
reg[23:0]  v_data;
reg[10:0]   rdaddress;
wire[7:0]  q;
reg        region_active;

assign o_data = v_data;
assign o_hs = pos_hs;
assign o_vs = pos_vs;
assign o_de = pos_de;
always@(posedge pclk)
begin
	if(pos_y >= 12'd9 && pos_y <= 12'd308 && pos_x >= 12'd9 && pos_x  <= 12'd1018)		//active region, (x,y)-->(9,9)-(1018,308)
		region_active <= 1'b1;
	else
		region_active <= 1'b0;
end
//RAM read address control
always@(posedge pclk)
begin
	if(region_active == 1'b1 && pos_de == 1'b1)		
		rdaddress <= rdaddress + 11'd1;
	else
		rdaddress <= 11'd0;
end
/* if q + pos_y = 287, use wave color, because q is 8 bit, max value is 8'd255, so minimum pos_y is 32.
   for example, if in line 32, pos_y value is 32, when data read from ram is 255, in (pos_x, pos_y) position,
   use wave color, other points in this line use previous color. In every line, ram will be read  */
always@(posedge pclk)
begin
	if(region_active == 1'b1)
		if(12'd287 - pos_y == {4'd0,q})	
			v_data <= wave_color;
		else
			v_data <= pos_data;
	else
		v_data <= pos_data;
end

dpram2048x8 buffer (
	.clka		(adc_clk),   
	.ena		(1'b1),     
	.wea		(adc_buf_wr),     
	.addra		(adc_buf_addr[10:0]), 
	.dina		(adc_buf_data),   
	.clkb		(pclk),   
	.enb		(1'b1),     
	.addrb		(rdaddress), 
	.doutb		(q)  
);


timing_gen_xy timing_gen_xy_m0(
	.rst_n    (rst_n    ),
	.clk      (pclk     ),
	.i_hs     (i_hs     ),
	.i_vs     (i_vs     ),
	.i_de     (i_de     ),
	.i_data   (i_data   ),
	.o_hs     (pos_hs   ),
	.o_vs     (pos_vs   ),
	.o_de     (pos_de   ),
	.o_data   (pos_data ),
	.x        (pos_x    ),
	.y        (pos_y    )
);
endmodule