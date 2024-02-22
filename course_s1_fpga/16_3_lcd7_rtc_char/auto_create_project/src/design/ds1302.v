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
module ds1302(
	input           rst,
	input           clk,
	output          ds1302_ce,
	output          ds1302_sclk,
	inout           ds1302_io,
	input           write_time_req,	//write time request
	output          write_time_ack,	//write time ack
	input[7:0]      write_second,	//second data to write
	input[7:0]      write_minute,   //minute data to write
	input[7:0]      write_hour,     //hour data to write
	input[7:0]      write_date,     //data data to write
	input[7:0]      write_month,    //month data to write
	input[7:0]      write_week,     //week data to write
	input[7:0]      write_year,     //year data to write
	input           read_time_req,	//read time request
	output          read_time_ack,  //read time ack
	output reg[7:0] read_second,    //read second data 
	output reg[7:0] read_minute,    //read minute data 
	output reg[7:0] read_hour,      //read hour data 
	output reg[7:0] read_date,      //read data data 
	output reg[7:0] read_month,     //read month data
	output reg[7:0] read_week,      //read week data 
	output reg[7:0] read_year       //read year data 

);
localparam S_IDLE         =  0;
localparam S_WR_WP        =  1;
localparam S_WR_SEC       =  2;
localparam S_WR_MIN       =  3;
localparam S_WR_HOUR      =  4;
localparam S_WR_MON       =  5;
localparam S_WR_WEEK      =  6;
localparam S_WR_YEAR      =  7;
localparam S_RD_SEC       =  8;
localparam S_RD_MIN       =  9;
localparam S_RD_HOUR      = 10;
localparam S_RD_MON       = 11;
localparam S_RD_WEEK      = 12;
localparam S_RD_YEAR      = 13;
localparam S_RD_DATE      = 15;
localparam S_ACK          = 14;
localparam S_WR_DATE      = 16;

reg	[4:0] 	state, next_state;
reg	[7:0] 	read_addr;		//read address
reg	[7:0] 	write_addr; 	//write address
reg	[7:0] 	write_data; 	//write data
wire[7:0] 	read_data;  	//read data
reg 		cmd_write;		//write command
reg 		cmd_read;		//read command
wire 		cmd_read_ack;	//read command ack
wire 		cmd_write_ack;	//write command ack
assign write_time_ack = (state == S_ACK);
assign read_time_ack  = (state == S_ACK);
always@(posedge clk or posedge rst)
begin
	if(rst)
		cmd_write <= 1'b0;
	else if(cmd_write_ack)
		cmd_write <= 1'b0;
	else
		case(state)			//when in below state, assert cmd_write signal
			S_WR_WP,
			S_WR_SEC,
			S_WR_MIN,
			S_WR_HOUR,
			S_WR_DATE,
			S_WR_MON,
			S_WR_WEEK,
			S_WR_YEAR:
			cmd_write <= 1'b1;
		endcase
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		cmd_read <= 1'b0;
	else if(cmd_read_ack)
		cmd_read <= 1'b0;
	else
		case(state)			//when in below state, assert cmd_read signal
			S_RD_SEC,
			S_RD_MIN,
			S_RD_HOUR,
			S_RD_DATE,
			S_RD_MON,
			S_RD_WEEK,
			S_RD_YEAR:
				cmd_read <= 1'b1;
		endcase
end
//read second data
always@(posedge clk or posedge rst)
begin
	if(rst)
		read_second <= 8'h00;
	else if(state == S_RD_SEC && cmd_read_ack)
		read_second <= read_data;
end
//read minute data
always@(posedge clk or posedge rst)
begin
	if(rst)
		read_minute <= 8'h00;
	else if(state == S_RD_MIN && cmd_read_ack)
		read_minute <= read_data;
end
//read hour data
always@(posedge clk or posedge rst)
begin
	if(rst)
		read_hour <= 8'h00;
	else if(state == S_RD_HOUR && cmd_read_ack)
		read_hour <= read_data;
end
//read date data
always@(posedge clk or posedge rst)
begin
	if(rst)
		read_date <= 8'h00;
	else if(state == S_RD_DATE && cmd_read_ack)
		read_date <= read_data;
end
//read month data
always@(posedge clk or posedge rst)
begin
	if(rst)
		read_month <= 8'h00;
	else if(state == S_RD_MON && cmd_read_ack)
		read_month <= read_data;
end
//read week data
always@(posedge clk or posedge rst)
begin
	if(rst)
		read_week <= 8'h00;
	else if(state == S_RD_WEEK && cmd_read_ack)
		read_week <= read_data;
end
//read year data
always@(posedge clk or posedge rst)
begin
	if(rst)
		read_year <= 8'h00;
	else if(state == S_RD_YEAR && cmd_read_ack)
		read_year <= read_data;
end
//read address value assignment
always@(posedge clk or posedge rst)
begin
	if(rst)
		read_addr <= 8'h00;
	else
		case(state)
				S_RD_SEC:
					read_addr <= 8'h81;
				S_RD_MIN:
					read_addr <= 8'h83;
				S_RD_HOUR:
					read_addr <= 8'h85;
				S_RD_DATE:
					read_addr <= 8'h87;
				S_RD_MON:
					read_addr <= 8'h89;
				S_RD_WEEK:
					read_addr <= 8'h8b;
				S_RD_YEAR:
					read_addr <= 8'h8d;
			default:
				read_addr <= read_addr;
		endcase
end
//write address value assignment
always@(posedge clk or posedge rst)
begin
	if(rst)
		begin
			write_addr <= 8'h00;
			write_data <= 8'h00;
		end
	else
		case(state)
			S_WR_WP:
				begin
					write_addr <= 8'h8e;
					write_data <= 8'h00;
				end
			S_WR_SEC:
				begin
					write_addr <= 8'h80;
					write_data <= write_second;
				end
			S_WR_MIN:
				begin
					write_addr <= 8'h82;
					write_data <= write_minute;
				end
			S_WR_HOUR:
				begin
					write_addr <= 8'h84;
					write_data <= write_hour;
				end
			S_WR_DATE:
				begin
					write_addr <= 8'h86;
					write_data <= write_date;
				end
			S_WR_MON:
				begin
					write_addr <= 8'h88;
					write_data <= write_month;
				end
			S_WR_WEEK:
				begin
					write_addr <= 8'h8a;
					write_data <= write_week;
				end
			S_WR_YEAR:
				begin
					write_addr <= 8'h8c;
					write_data <= write_year;
				end
			default:
				begin
					write_addr <= 8'h00;
					write_data <= 8'h00;
				end
		endcase
end

always@(posedge clk or posedge rst)
begin
	if(rst)
		state <= S_IDLE;
	else
		state <= next_state;
end
always@(*)
begin
	case(state)
		S_IDLE:
			if(write_time_req)
				next_state <= S_WR_WP;
			else if(read_time_req)
				next_state <= S_RD_SEC;
			else
				next_state <= S_IDLE;
		S_WR_WP:						//write protect state, clear write protect
			if(cmd_write_ack)
				next_state <= S_WR_SEC;
			else
				next_state <= S_WR_WP;
		S_WR_SEC:
			if(cmd_write_ack)
				next_state <= S_WR_MIN;
			else
				next_state <= S_WR_SEC;
		S_WR_MIN:
			if(cmd_write_ack)
				next_state <= S_WR_HOUR;
			else
				next_state <= S_WR_MIN;
		S_WR_HOUR:
			if(cmd_write_ack)
				next_state <= S_WR_DATE;
			else
				next_state <= S_WR_HOUR;
		S_WR_DATE:
			if(cmd_write_ack)
				next_state <= S_WR_MON;
			else
				next_state <= S_WR_DATE;
		S_WR_MON:
			if(cmd_write_ack)
				next_state <= S_WR_WEEK;
			else
				next_state <= S_WR_MON;
		S_WR_WEEK:
			if(cmd_write_ack)
				next_state <= S_WR_YEAR;
			else
				next_state <= S_WR_WEEK;
		S_WR_YEAR:
			if(cmd_write_ack)
				next_state <= S_ACK;
			else
				next_state <= S_WR_YEAR;
		S_RD_SEC:
			if(cmd_read_ack)
				next_state <= S_RD_MIN;
			else
				next_state <= S_RD_SEC;
		S_RD_MIN:
			if(cmd_read_ack)
				next_state <= S_RD_HOUR;
			else
				next_state <= S_RD_MIN;
		S_RD_HOUR:
			if(cmd_read_ack)
				next_state <= S_RD_DATE;
			else
				next_state <= S_RD_HOUR;
		S_RD_DATE:
			if(cmd_read_ack)
				next_state <= S_RD_MON;
			else
				next_state <= S_RD_DATE;
		S_RD_MON:
			if(cmd_read_ack)
				next_state <= S_RD_WEEK;
			else
				next_state <= S_RD_MON;
		S_RD_WEEK:
			if(cmd_read_ack)
				next_state <= S_RD_YEAR;
			else
				next_state <= S_RD_WEEK;
		S_RD_YEAR:
			if(cmd_read_ack)
				next_state <= S_ACK;
			else
				next_state <= S_RD_YEAR;
		S_ACK:
			next_state <= S_IDLE;
		default:
			next_state <= S_IDLE;
	endcase
end

ds1302_io ds1302_io_m0(
	.clk			(clk),
	.rst			(rst),
	.ds1302_ce		(ds1302_ce),
	.ds1302_sclk	(ds1302_sclk),
	.ds1302_io		(ds1302_io),
	.cmd_read		(cmd_read),
	.cmd_write		(cmd_write),
	.cmd_read_ack	(cmd_read_ack),
	.cmd_write_ack	(cmd_write_ack),
	.read_addr		(read_addr),
	.write_addr		(write_addr),
	.read_data		(read_data),
	.write_data		(write_data)
);
endmodule