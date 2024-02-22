`timescale 1ns / 1ps

module pwm_lcd(
	input clk,
	input rst,
	output lcd_bl_pwm
    );
pwm pwm_m0(
	.clk(clk),
	.rst(rst),
	.period(16'd2),
	.duty(16'h8000),
	.pwm_out(lcd_bl_pwm)
);
endmodule
