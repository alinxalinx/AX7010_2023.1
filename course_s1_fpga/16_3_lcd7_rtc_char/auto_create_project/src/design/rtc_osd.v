`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: myj                                                                 //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//     WEB: http://www.alinx.com/                                                //
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
//  2019/10/31     myj         1.0         Original
//*******************************************************************************/

module rtc_osd(
	input                       rst_n,  	//复位信号
	input                       pclk,		//像素时钟
	input [23:0]				rtc_data,	//RTC数据
	input                       i_hs, 		//行同步输入信号   
	input                       i_vs,   	//场同步输入信号
	input                       i_de,		//图像有效输入信号
	input[23:0]                 i_data, 	//图像数据输入信号
	output                      o_hs,   	//行同步输出信号    
	output                      o_vs,   	//场同步输出信号 
	output                      o_de,   	//图像有效输出信号 
	output[23:0]                o_data  	//图像数据输出信号
);
localparam OSD_X_START 	= 	12'd9  ;	//X起始坐标
localparam OSD_Y_START 	= 	12'd9  ;	//Y起始坐标
localparam OSD_GAP 		= 	12'd16 ;	//两个字符间隔像素点
localparam OSD_WIDTH   	=  	12'd16 ;	//设置OSD的宽度，可根据字符生成软件设置
localparam OSD_HEGIHT  	=  	12'd32 ;	//设置OSD的高度，可根据字符生成软件设置

wire [11:0] 		pos_x;		//X坐标
wire [11:0] 		pos_y;		//Y坐标
wire        		pos_hs;
wire        		pos_vs;
wire        		pos_de;
wire [23:0] 		pos_data;
reg	 [23:0]  		v_data;
     
reg	 [11:0]  		osd_x	[7:0] ;
reg	 [11:0]  		osd_y;
reg	 [15:0]  		osd_ram_addr	[7:0] ;
reg  [7:0]      	region_active;
reg  [7:0]      	region_active_d0;

reg        			pos_vs_d0;
reg        			pos_vs_d1;
	
reg	 [3:0]			char_addr_sel ;		//字符库选择 十进制0-9对应数字“0-9”；十进制10对应“:”
reg	 [5:0]			char_addr ;			//字符的地址
wire [7:0]			char_data ;			//字符数据

assign o_data 	= v_data;
assign o_hs 	= pos_hs;
assign o_vs 	= pos_vs;
assign o_de 	= pos_de;

always@(posedge pclk)
	begin
		pos_vs_d0 <= pos_vs;
		pos_vs_d1 <= pos_vs_d0;
	end
//generate生成8个显示区域，24小时制显示，时分秒加上:共8个区域
genvar i ;
generate
	for (i = 0 ;i < 8 ; i = i + 1)
	begin : osd_region
		//OSD区域设置，起始坐标为（9，9），区域大小根据生成的字符长宽设置
		always@(posedge pclk)
		begin
			if(pos_y >= OSD_Y_START && pos_y <= OSD_Y_START + OSD_HEGIHT - 12'd1 
				&& pos_x >= OSD_X_START + OSD_WIDTH*i && pos_x  <= OSD_X_START + OSD_WIDTH*(i+1) - 12'd1)
				region_active[i] <= 1'b1;
			else
				region_active[i] <= 1'b0;
		end
		//延时一个周期
		always@(posedge pclk)
		begin
			region_active_d0[i] <= region_active[i];
		end	
		
		
		//产生OSD的计数器
		always@(posedge pclk)
		begin
			if(region_active_d0[i] == 1'b1)
				osd_x[i] <= osd_x[i] + 12'd1;
			else
				osd_x[i] <= 12'd0;
		end
		//产生ROM的读地址，在region_active有效时，地址加1
		always@(posedge pclk)
		begin
			if(pos_vs_d1 == 1'b1 && pos_vs_d0 == 1'b0)
				osd_ram_addr[i] <= 16'd0;
			else if(region_active[i] == 1'b1)
				osd_ram_addr[i] <= osd_ram_addr[i] + 16'd1;
		end	
		
	end		
endgenerate
//字符数据判断，颜色设置
always@(posedge pclk)
begin
	case(region_active_d0)
		8'b0000_0001 : begin
						if(char_data[osd_x[0][2:0]] == 1'b1)  //检查bit位是否是1，如果是1，将此像素设为红色
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //否则保持原来的值
					   end
		8'b0000_0010 : begin
						if(char_data[osd_x[1][2:0]] == 1'b1)  //检查bit位是否是1，如果是1，将此像素设为红色
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //否则保持原来的值
					   end
		8'b0000_0100 : begin
						if(char_data[osd_x[2][2:0]] == 1'b1)  //检查bit位是否是1，如果是1，将此像素设为红色
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //否则保持原来的值
					   end
		8'b0000_1000 : begin
						if(char_data[osd_x[3][2:0]] == 1'b1)  //检查bit位是否是1，如果是1，将此像素设为红色
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //否则保持原来的值
					   end
		8'b0001_0000 : begin
						if(char_data[osd_x[4][2:0]] == 1'b1)  //检查bit位是否是1，如果是1，将此像素设为红色
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //否则保持原来的值
					   end
		8'b0010_0000 : begin
						if(char_data[osd_x[5][2:0]] == 1'b1)  //检查bit位是否是1，如果是1，将此像素设为红色
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //否则保持原来的值
					   end
		8'b0100_0000 : begin
						if(char_data[osd_x[6][2:0]] == 1'b1)  //检查bit位是否是1，如果是1，将此像素设为红色
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //否则保持原来的值
					   end
		8'b1000_0000 : begin
						if(char_data[osd_x[7][2:0]] == 1'b1)  //检查bit位是否是1，如果是1，将此像素设为红色
							v_data <= 24'hff0000;
						else
							v_data <= pos_data;	   //否则保持原来的值
					   end
		default	: v_data <= pos_data;
	endcase
end

//根据rtc的数据进行译码，为BCD编码，可以直接与字符库选择信号对接
always @(*)
begin
	case(region_active)
		8'b0000_0001 : char_addr_sel <= rtc_data[23:20] ;	//hour
		8'b0000_0010 : char_addr_sel <= rtc_data[19:16] ;
		8'b0000_0100 : char_addr_sel <= 4'd10 ;  			//:
		8'b0000_1000 : char_addr_sel <= rtc_data[15:12] ;	//minute
		8'b0001_0000 : char_addr_sel <= rtc_data[11:8] ;
		8'b0010_0000 : char_addr_sel <= 4'd10 ;	 			//:
		8'b0100_0000 : char_addr_sel <= rtc_data[7:4] ;		//second
		8'b1000_0000 : char_addr_sel <= rtc_data[3:0] ;
		default :	char_addr_sel <= 6'd0 ;
	endcase
end
//字符地址译码
always @(*)
begin
	case(region_active)
		8'b0000_0001 : char_addr <= osd_ram_addr[0][15:3] ;
		8'b0000_0010 : char_addr <= osd_ram_addr[1][15:3] ;
		8'b0000_0100 : char_addr <= osd_ram_addr[2][15:3] ;
		8'b0000_1000 : char_addr <= osd_ram_addr[3][15:3] ;
		8'b0001_0000 : char_addr <= osd_ram_addr[4][15:3] ;
		8'b0010_0000 : char_addr <= osd_ram_addr[5][15:3] ;
		8'b0100_0000 : char_addr <= osd_ram_addr[6][15:3] ;
		8'b1000_0000 : char_addr <= osd_ram_addr[7][15:3] ;
		default :	char_addr <= 6'd0 ;
	endcase
end




//实例化字符库
char_repo  char_repo_inst(
	.clk			(pclk),
	.char_addr_sel	(char_addr_sel),
	.char_addr		(char_addr),
	.char_data      (char_data)

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
