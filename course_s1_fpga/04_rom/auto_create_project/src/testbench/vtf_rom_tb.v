`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/28 17:01:15
// Design Name: 
// Module Name: vtf_rom_tb
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


module vtf_rom_tb;
// Inputs
reg sys_clk;
reg rst_n;


// Instantiate the Unit Under Test (UUT)
rom_test uut (
	.sys_clk	(sys_clk), 		
	.rst_n		(rst_n)
);

initial 
begin
	// Initialize Inputs
	sys_clk = 0;
	rst_n = 0;

	// Wait 100 ns for global reset to finish
	#100;
      rst_n = 1;       

 end

always #10 sys_clk = ~ sys_clk;   //20ns一个周期，产生50MHz时钟源
   
endmodule
