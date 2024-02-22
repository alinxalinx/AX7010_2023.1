`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: vtf_led_test
//////////////////////////////////////////////////////////////////////////////////

module vtf_pll_test;
	// Inputs
	reg sys_clk;
	reg rst_n;

	// Outputs
    wire clk_out;

	// Instantiate the Unit Under Test (UUT)
	pll_test uut (
		.sys_clk(sys_clk), 		
		.rst_n(rst_n), 
		.clk_out(clk_out)
	);

	initial begin
		// Initialize Inputs
		sys_clk = 0;
		rst_n = 0;

		// Wait 100 ns for global reset to finish
		#100;
          rst_n = 1;        
		// Add stimulus here
		#20000;
      //  $stop;
	 end
   
    always #10 sys_clk = ~ sys_clk;   //5ns一个周期，产生50MHz时钟源
   
endmodule
