//*************************************************************************\
//Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd,All rights reserved
//
//                   File Name  :  ds1302_test.v
//                Project Name  :  
//                      Author  :  meisq
//                       Email  :  msq@qq.com
//                     Company  :  ALINX(shanghai) Technology Co.,Ltd
//                      taobao  :  https://oshcn.taobao.com/
//                         WEB  :  http://www.alinx.cn/
//==========================================================================
//   Description:   
//
//   
//==========================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------
//  2017/6/19     meisq         1.0         Original
//*************************************************************************/
module ds1302_test(
	input       rst,
	input       clk,
	output      ds1302_ce,
	output      ds1302_sclk,
	inout       ds1302_io,
	output[7:0] read_second,
	output[7:0] read_minute,
	output[7:0] read_hour,
	output[7:0] read_date,
	output[7:0] read_month,
	output[7:0] read_week,
	output[7:0] read_year
);
localparam S_IDLE    	=   0;
localparam S_READ    	=   1;
localparam S_WRITE   	=   2;
localparam S_READ_CH 	=   3;
localparam S_WRITE_CH 	=   4;
localparam S_WAIT     	=   5;
reg[2:0] 	state,next_state;

reg 		write_time_req;
reg 		write_time_req_latch;
wire 		write_time_ack;
reg 		read_time_req;
wire 		read_time_ack;
reg[7:0] 	write_second_reg;
reg[7:0] 	write_minute_reg;
reg[7:0] 	write_hour_reg;
reg[7:0] 	write_date_reg;
reg[7:0] 	write_month_reg;
reg[7:0] 	write_week_reg;
reg[7:0] 	write_year_reg;
wire 		CH;


always@(*)
begin
	case(state)		
		S_IDLE:
				next_state <= S_READ_CH;
		S_READ_CH:
			if(read_time_ack)
				next_state <= CH ? S_WRITE_CH : S_READ;	//check CH high or not, if it is high, go to write CH state, or read state
			else
				next_state <= S_READ_CH;
		S_WRITE_CH:
			if(write_time_ack)
				next_state <= S_WAIT;
			else
				next_state <= S_WRITE_CH;
		S_WAIT:
			next_state <= S_READ;
		S_READ:
			if(read_time_ack)
				next_state <= S_IDLE;
			else
				next_state <= S_READ;
		default:
			next_state <= S_IDLE;
	endcase
end



/* bit 7 of the seconds register is defined as the clock halt flag, when 1, ds1302 is stopped,
   when write to 0, ds1302 will start */
assign CH = read_second[7];  					



always@(posedge clk)
begin
	if(write_time_ack)
		write_time_req <= 1'b0;
	else if(state == S_WRITE_CH)		//when CH is high, ds1302 is stopped, need to write to 0 to start it
		write_time_req <= 1'b1;
end

always@(posedge clk)
begin
	if(read_time_ack)
		read_time_req <= 1'b0;
	else if(state == S_READ || state == S_READ_CH)
		read_time_req <= 1'b1;
end
always@(posedge clk or posedge rst)
begin
	if(rst)
		state <= S_IDLE;
	else
		state <= next_state;	
end


always@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		write_second_reg <= 8'h00;
		write_minute_reg <= 8'h00;
		write_hour_reg <= 8'h00;
		write_date_reg <= 8'h00;
		write_month_reg <= 8'h00;
		write_week_reg <= 8'h00;
		write_year_reg <= 8'h00;
	end
	else if(state == S_WRITE_CH)		//initial ds1302 register value
	begin
		write_second_reg <= 8'h01;
		write_minute_reg <= 8'h10;
		write_hour_reg <= 8'h13;
		write_date_reg <= 8'h13;
		write_month_reg <= 8'h12;
		write_week_reg <= 8'h02;
		write_year_reg <= 8'h16;//2016-12-13 13:10:01
	end
end


ds1302 ds1302_m0(
	.rst				(rst),
	.clk				(clk),
	.ds1302_ce			(ds1302_ce),
	.ds1302_sclk		(ds1302_sclk),
	.ds1302_io			(ds1302_io),
	.write_time_req		(write_time_req),
	.write_time_ack		(write_time_ack),
	.write_second		(write_second_reg),
	.write_minute		(write_minute_reg),
	.write_hour			(write_hour_reg),
	.write_date			(write_date_reg),
	.write_month		(write_month_reg),
	.write_week			(write_week_reg),
	.write_year			(write_year_reg),
	.read_time_req		(read_time_req),
	.read_time_ack		(read_time_ack),
	.read_second		(read_second),
	.read_minute		(read_minute),
	.read_hour			(read_hour),
	.read_date			(read_date),
	.read_month			(read_month),
	.read_week			(read_week),
	.read_year			(read_year)
	
);


endmodule 