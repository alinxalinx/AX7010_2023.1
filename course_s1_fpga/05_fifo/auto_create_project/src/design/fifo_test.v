`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module fifo_test
	(
		input 		clk,		         //50MHz时钟
		input 		rst_n	             //复位信号，低电平有效	
	);


reg	 [15:0] 		w_data			;	   		//FIFO写数据
wire      			wr_en			;	   		//FIFO写使能
wire      			rd_en			;	   		//FIFO读使能
wire [15:0] 		r_data			;			//FIFO读数据
wire       			full			;  			//FIFO满信号 
wire       			empty			;  			//FIFO空信号 
wire [8:0]  		rd_data_count	;  			//可读数据数量	
wire [8:0]  		wr_data_count	;  			//已写入数据数量
	
wire				clk_100M 		;			//PLL产生100MHz时钟
wire				clk_75M 		;			//PLL产生100MHz时钟
wire				locked 			;			//PLL lock信号，可作为系统复位信号，高电平表示lock住
wire				fifo_rst_n 		;			//fifo复位信号, 低电平有效

wire				wr_clk 			;			//写FIFO时钟
wire				rd_clk 			;			//读FIFO时钟
reg	[7:0]			wcnt 			;			//写FIFO复位后等待计数器
reg	[7:0]			rcnt 			;			//读FIFO复位后等待计数器

//例化PLL，产生100MHz和75MHz时钟
clk_wiz_0 fifo_pll
 (
  // Clock out ports
  .clk_out1(clk_100M),     	 	// output clk_out1
  .clk_out2(clk_75M),    		// output clk_out2
  // Status and control signals
  .reset(~rst_n), 			 	// input reset
  .locked(locked),       		// output locked
  // Clock in ports
  .clk_in1(clk)					// input clk_in1
  );      			

assign fifo_rst_n 	= locked	;	//将PLL的LOCK信号赋值给fifo的复位信号
assign wr_clk 		= clk_100M 	;	//将100MHz时钟赋值给写时钟
assign rd_clk 		= clk_75M 	;	//将75MHz时钟赋值给读时钟


/* 写FIFO状态机 */
localparam      W_IDLE      = 1	;
localparam      W_FIFO     	= 2	; 

reg[2:0]  write_state;
reg[2:0]  next_write_state;

always@(posedge wr_clk or negedge fifo_rst_n)
begin 
	if(!fifo_rst_n)
		write_state <= W_IDLE;
	else
		write_state <= next_write_state;
end

always@(*)
begin
	case(write_state)
		W_IDLE:
			begin
				if(wcnt == 8'd79)               //复位后等待一定时间，safety circuit模式下的最慢时钟60个周期
					next_write_state <= W_FIFO;
				else
					next_write_state <= W_IDLE;
			end
		W_FIFO:
			next_write_state <= W_FIFO;			//一直在写FIFO状态
		default:
			next_write_state <= W_IDLE;
	endcase
end
//在IDLE状态下，也就是复位之后，计数器计数
always@(posedge wr_clk or negedge fifo_rst_n)
begin 
	if(!fifo_rst_n)
		wcnt <= 8'd0;
	else if (write_state == W_IDLE)
		wcnt <= wcnt + 1'b1 ;
	else
		wcnt <= 8'd0;
end
//在写FIFO状态下，如果不满就向FIFO中写数据
assign wr_en = (write_state == W_FIFO) ? ~full : 1'b0; 
//在写使能有效情况下，写数据值加1
always@(posedge wr_clk or negedge fifo_rst_n)
begin
	if(!fifo_rst_n)
		w_data <= 16'd1;
	else if (wr_en)
		w_data <= w_data + 1'b1;
end

/* 读FIFO状态机 */

localparam      R_IDLE      = 1	;
localparam      R_FIFO     	= 2	; 
reg[2:0]  read_state;
reg[2:0]  next_read_state;

///产生FIFO读的数据
always@(posedge rd_clk or negedge fifo_rst_n)
begin
	if(!fifo_rst_n)
		read_state <= R_IDLE;
	else
		read_state <= next_read_state;
end

always@(*)
begin
	case(read_state)
		R_IDLE:
			begin
				if (rcnt == 8'd59)             	//复位后等待一定时间，safety circuit模式下的最慢时钟60个周期
					next_read_state <= R_FIFO;
				else
					next_read_state <= R_IDLE;
			end
		R_FIFO:	
			next_read_state <= R_FIFO ;			//一直在读FIFO状态
		default:
			next_read_state <= R_IDLE;
	endcase
end

//在IDLE状态下，也就是复位之后，计数器计数
always@(posedge rd_clk or negedge fifo_rst_n)
begin 
	if(!fifo_rst_n)
		rcnt <= 8'd0;
	else if (write_state == W_IDLE)
		rcnt <= rcnt + 1'b1 ;
	else
		rcnt <= 8'd0;
end
//在读FIFO状态下，如果不空就从FIFO中读数据
assign rd_en = (read_state == R_FIFO) ? ~empty : 1'b0; 

//-----------------------------------------------------------
//实例化FIFO
fifo_ip fifo_ip_inst 
(
  .rst            (~fifo_rst_n    	),   // input rst
  .wr_clk         (wr_clk          	),   // input wr_clk
  .rd_clk         (rd_clk          	),   // input rd_clk
  .din            (w_data       	),   // input [15 : 0] din
  .wr_en          (wr_en        	),   // input wr_en
  .rd_en          (rd_en        	),   // input rd_en
  .dout           (r_data       	),   // output [15 : 0] dout
  .full           (full         	),   // output full
  .empty          (empty        	),   // output empty
  .rd_data_count  (rd_data_count	),   // output [8 : 0] rd_data_count
  .wr_data_count  (wr_data_count	)    // output [8 : 0] wr_data_count
);

//写通道逻辑分析仪
ila_m0 ila_wfifo (
	.clk		(wr_clk			), 
	.probe0		(w_data			), 	
	.probe1		(wr_en			), 	
	.probe2		(full			), 		
	.probe3		(wr_data_count	)
);
//读通道逻辑分析仪
ila_m0 ila_rfifo (
	.clk		(rd_clk			), 
	.probe0		(r_data			), 	
	.probe1		(rd_en			), 	
	.probe2		(empty			), 		
	.probe3		(rd_data_count	)
);
 	
endmodule

