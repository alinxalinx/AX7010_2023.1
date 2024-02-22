`timescale 1ns/1ns
module key_debounce_tb;
reg sys_clk;
reg rst_n;
reg key;
wire[3:0] led;


initial
begin
	sys_clk = 1'b0;
	rst_n = 1'b0;
	key = 1'b1;
	#100 rst_n = 1'b1;
	#2000 key = 1'b0;
	#({$random} %1000)
	key = ~key;
	#({$random} %1000)
	key = ~key;
	#({$random} %1000)
	key = ~key;
	#({$random} %1000)
	key = ~key;	
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;	
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = 1'b0;
	#1000000000
	key = 1'b1;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = 1'b1;
	
	#1000000000 key = 1'b0;
	#({$random} %1000)
	key = ~key;
	#({$random} %1000)
	key = ~key;
	#({$random} %1000)
	key = ~key;
	#({$random} %1000)
	key = ~key;	
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;	
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = 1'b0;
	#1000000000
	key = 1'b1;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = ~key;
	#({$random} %10000000)
	key = 1'b1;
	#10 $stop;
	
end
always #10 sys_clk = ~sys_clk;   //50Mhz

key_debounce dut
(
	.sys_clk     (sys_clk),
	.rst_n       (rst_n),
	.key         (key),
	.led         (led)

);
endmodule 