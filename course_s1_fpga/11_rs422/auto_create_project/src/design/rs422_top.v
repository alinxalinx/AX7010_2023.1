`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/01 10:54:17
// Design Name: 
// Module Name: rs422_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//Y-->TXD+   Z-->TXD-   A-->RXD+    B-->RXD-

module rs422_top(
	input                        sys_clk,       //system clock 50Mhz on board
    input                        rst_n,        //reset ,low active
	input 						 rs422_rx1,	
	output                       rs422_tx1,
	input 						 rs422_rx2,	
	output                       rs422_tx2
    );
	
	
uart_test	rs422_inst1
(
    .sys_clk		(sys_clk),       //system clock 50Mhz on board
    .rst_n			(rst_n	),        //reset ,low active
	.uart_rx		(rs422_rx1),
	.uart_tx		(rs422_tx1)
);	
	
	
uart_test	rs422_inst2
(
    .sys_clk		(sys_clk),       //system clock 50Mhz on board
    .rst_n			(rst_n	),        //reset ,low active
	.uart_rx		(rs422_rx2),
	.uart_tx		(rs422_tx2)
);		
	
endmodule
