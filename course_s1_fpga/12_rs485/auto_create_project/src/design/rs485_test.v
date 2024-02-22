//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: lhj                                                                //
//                                                                             //
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
//	Description: transmission protocol is "s" + data counter + data
//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//2018/1/3                    1.0          Original
//*******************************************************************************/



module rs485_test(
    input                        sys_clk,       //system clock 50Mhz on board
    input                        rst_n,         //reset ,low active
	input                        rs485_rx,		//rs485 receive serial port
	output                       rs485_tx,		//rs485 transmit serial port
	output	reg					 rs485_de		//rs485 output enable port, 1-->output, 0-->input
);

parameter                        CLK_FRE = 50;	//Mhz

localparam                       IDLE 			=  0;
localparam                       RCV_HEAD 		=  1;	//receive data and check if it is "s"
localparam                       RCV_COUNT 		=  2;	//receive data counter
localparam                       RCV_DATA 		=  3;   //receive data 
localparam                       WAIT		 	=  4;   //wait 10 ms for direction changing
localparam                       SEND_WAIT 	 	=  5;   //wait before send data 
localparam                       SEND		 	=  6;	//send data



wire [7:0]                      tx_data;			//tx parallel data
reg                             tx_data_valid;		//tx data is valid to send 
wire                            tx_data_ready;		//uart tx module is ready to send data
reg  [7:0]                      tx_cnt;				//tx data counter

wire [7:0]                      rx_data;			//rx parallel data
wire                            rx_data_valid;		//rx data from uart rx module is valid
reg                             rx_data_ready;  	//ready to receive data
reg  [7:0]                      rx_cnt;         	//rx data counter
reg  [7:0]					    data_count ;    	//data counter will be transfer


reg  [31:0]                     wait_cnt;			//wait counter
reg  [3:0]                      state;		

reg								fifo_wren ;			//fifo write enable
reg  [7:0]						fifo_wdata ;		//fifo write data
reg								fifo_rden ;     	//fifo read enable
wire [7:0]						fifo_rdata ;    	//fifo read data 


assign tx_data = fifo_rdata ;

always@(posedge sys_clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		wait_cnt 		<= 32'd0;
		state 			<= IDLE	;
		tx_cnt 			<= 8'd0	;
		rx_cnt 			<= 8'd0	;
		tx_data_valid 	<= 1'b0 ;
		rx_data_ready 	<= 1'b0 ;
		data_count		<= 8'd0 ;
		fifo_wren		<= 1'b0 ;
		fifo_rden		<= 1'b0 ;
		fifo_wdata		<= 8'd0 ;
		rs485_de 		<= 1'b0 ;
	end
	else
	case(state)
		IDLE:
		begin
			state 			<= RCV_HEAD;
			rs485_de 		<= 1'b0 ;
			rx_data_ready 	<= 1'b1 ;
		end
		RCV_HEAD:
		begin
			if (rx_data_valid == 1'b1 && rx_data == 8'h55)	//when received data is valid and data is 8'h55,it means the start of data
				state <= RCV_COUNT ;				
		end
		RCV_COUNT:
		begin
			if (rx_data_valid == 1'b1)	//record data counter
			begin
				if (rx_data > 0)		//if data counter bigger than 0, then goto receive data state or goto IDLE state
					state <= RCV_DATA ;		
				else
					state <= IDLE ;
					
				data_count <= rx_data ;
			end
		end
		RCV_DATA:
		begin
			fifo_wren  <= rx_data_valid ;
			fifo_wdata <= rx_data ;
			
			if (rx_data_valid == 1'b1)
			begin
				if (rx_cnt == data_count - 1)	//the last received data
				begin
					rx_cnt 		<= 8'd0 ;
					rs485_de 	<= 1'b1 ;
					state  		<= WAIT ;
				end
				else
					rx_cnt <= rx_cnt + 1'b1 ;
			end
		end
		WAIT:
		begin						
			fifo_wren  <= 1'b0 ;
			if (wait_cnt >= CLK_FRE * 1000) // wait for 1 ms for direction change
			begin
				wait_cnt <= 32'd0 ;
				state <= SEND_WAIT;
			end
			else
			begin
				wait_cnt <= wait_cnt + 32'd1;
			end
		end
		SEND_WAIT:
		begin		
			if (tx_data_ready == 1'b1)
			begin
				if (tx_cnt == data_count)			//the last data has transferred
				begin
					tx_cnt 			<= 8'd0 ;					
					fifo_rden		<= 1'b0 ;
					state 			<= IDLE ;
				end
				else
				begin
					fifo_rden		<= 1'b1 ;		//read data from fifo
					state 			<= SEND ;
				end
			end
			tx_data_valid 	<= 1'b0 ;
		end
		SEND:
		begin
			fifo_rden		<= 1'b0 ;
			tx_data_valid 	<= 1'b1 ;
			
			if(tx_data_valid == 1'b1 && tx_data_ready == 1'b1 && tx_cnt < data_count)
			begin
				tx_cnt <= tx_cnt + 8'd1; //Send data counter
				state  <= SEND_WAIT ;
			end	
		end
		default:
			state <= IDLE;
	endcase
end


uart_rx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_rx_inst
(
	.clk                        (sys_clk                  ),
	.rst_n                      (rst_n                    ),
	.rx_data                    (rx_data                  ),
	.rx_data_valid              (rx_data_valid            ),
	.rx_data_ready              (rx_data_ready            ),
	.rx_pin                     (rs485_rx                  )
);

uart_tx#
(
	.CLK_FRE(CLK_FRE),
	.BAUD_RATE(115200)
) uart_tx_inst
(
	.clk                        (sys_clk                  ),
	.rst_n                      (rst_n                    ),
	.tx_data                    (tx_data                  ),
	.tx_data_valid              (tx_data_valid            ),
	.tx_data_ready              (tx_data_ready            ),
	.tx_pin                     (rs485_tx                  )
);


rx_fifo fifo_inst
(
   .clk 		(sys_clk),
   .srst 		(~rst_n),
   .din 		(fifo_wdata),
   .wr_en 		(fifo_wren),
   .rd_en 		(fifo_rden),
   .dout 		(fifo_rdata),
   .full 		(),
   .empty 		()
 );

endmodule
