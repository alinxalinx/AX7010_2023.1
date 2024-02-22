`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: vtf_led_test
//////////////////////////////////////////////////////////////////////////////////

module vtf_led_test;
// Inputs
reg sys_clk;
reg rst_n ;
// Outputs
wire [3:0] led;

// Instantiate the Unit Under Test (UUT)
led uut (
    .sys_clk(sys_clk),   
    .rst_n(rst_n),
    .led(led)
 );

initial 
begin
// Initialize Inputs
    sys_clk = 0;
    rst_n = 0 ;
    #1000 ;
    rst_n = 1; 
end
//Create clock
always #10 sys_clk = ~ sys_clk;  

endmodule

