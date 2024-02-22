`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: vtf_led_test
//////////////////////////////////////////////////////////////////////////////////

module vtf_uart_test;
	// Inputs
	reg sys_clk;
	reg rst_n;
	reg uart_rx;


	// Outputs
    wire uart_tx;

	// Instantiate the Unit Under Test (UUT)
    uart_test uut (
        .sys_clk                    (sys_clk            ),
        .rst_n                      (rst_n              ),
        .uart_rx                    (uart_rx            ),
        .uart_tx                    (uart_tx            )

    );

	initial begin
		// Initialize Inputs
		sys_clk = 0;
		rst_n = 0;

		// Wait 1000 ns for global reset to finish
		#100;
          rst_n = 1;        
		// Add stimulus here
		#20000;
      //  $stop;
	 end
   
    always #10 sys_clk = ~ sys_clk;   //20ns一个周期，产生50MHz时钟源
   
    parameter                        BPS_115200 = 8680;//每个比特的时间
    parameter                        SEND_DATA = 8'b1010_0011;//要发送的数据     
    
    integer i = 0;
       
      initial begin
        uart_rx = 1'b1;    //bus idle
        #1000 uart_rx = 1'b0;     //transmit start bit
        
        for (i=0;i<8;i=i+1)
        #BPS_115200 uart_rx = SEND_DATA[i];     //transmit data bit
      
        #BPS_115200 uart_rx = 1'b0;     //transmit stop bit
        #BPS_115200 uart_rx = 1'b1;     //bus idle
        
       end   
   	  
   	      
endmodule
