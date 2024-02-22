`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/01 13:02:50
// Design Name: 
// Module Name: rs485_top
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


module rs485_top(
	input                        sys_clk,       //system clock 50Mhz on board
    input                        rst_n,        //reset ,low active
	input 						 rs485_rx1,	
	output                       rs485_tx1,
	output                       rs485_de1,
	input 						 rs485_rx2,	
	output                       rs485_tx2,
	output                       rs485_de2
    );


rs485_test rs485_m0
(
    .sys_clk	(sys_clk),       //system clock 50Mhz on board
    .rst_n		(rst_n	),        //reset ,low active
	.rs485_rx	(rs485_rx1),
	.rs485_tx	(rs485_tx1),
	.rs485_de   (rs485_de1)
);
	
rs485_test rs485_m1
(
    .sys_clk	(sys_clk),       //system clock 50Mhz on board
    .rst_n		(rst_n	),        //reset ,low active
	.rs485_rx	(rs485_rx2),
	.rs485_tx	(rs485_tx2),
	.rs485_de   (rs485_de2)
);
	
endmodule
