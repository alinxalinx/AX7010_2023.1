`timescale 1ns/1ns
module i2c_eeprom_test_tb;
reg sys_clk;
reg rst_n;
reg key;
wire SCL;
wire SDA;
wire [3:0]	led ;
initial
begin
	sys_clk = 1'b0;
	rst_n = 1'b0;
	key = 1'b1;
	#100 rst_n = 1'b1;
	#250 key = 1'b0;
	#50000000 key = 1'b1;
end
always#10 sys_clk = ~sys_clk;//50Mhz
pullup p1(SDA);
pullup p2(SCL);
i2c_eeprom_test dut(
	.sys_clk     (sys_clk),
	.rst_n   (rst_n),
	.key   	 (key),
    .i2c_sda (SDA),
    .i2c_scl (SCL),
	.led	 (led)
);
M24AA02 memory
(
	.A0(1'b0), 
	.A1(1'b0), 
	.A2(1'b0), 
	.WP(1'b0), 
	.SDA(SDA), 
	.SCL(SCL), 
	.RESET(1'b0));
endmodule 