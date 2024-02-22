//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: myj                                                                 //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.com/                                               //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2019,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2019/10/30     myj          1.0         Original
//*******************************************************************************/
`timescale 1ns / 1ps
module pwm_test(
                 input 		clk,		//50MHz
                 input 		rst_n,		//low active
	             output 	led			//high-off, low-on
                );
					  
localparam CLK_FREQ = 50 ; 				//50MHz
localparam US_COUNT = CLK_FREQ ; 		//1 us counter
localparam MS_COUNT = CLK_FREQ*1000 ; 	//1 ms counter

localparam DUTY_STEP	  = 32'd100000 ;	//duty step
localparam DUTY_MIN_VALUE = 32'h6fffffff ;	//duty minimum value
localparam DUTY_MAX_VALUE = 32'hffffffff ;	//duty maximum value
					  
localparam IDLE    		= 0;	//IDLE state
localparam PWM_PLUS  	= 1;    //PWM duty plus state
localparam PWM_MINUS  	= 2;    //PWM duty minus state
localparam PWM_GAP  	= 3;    //PWM duty adjustment gap

wire 		pwm_out;	//pwm output
reg[31:0] 	period;		//pwm step value
reg[31:0] 	duty;		//duty value
reg			pwm_flag ;	//duty value plus and minus flag, 0: plus; 1: minus

reg[3:0] 	state;
reg[31:0] 	timer;		//duty adjustment counter

assign led = ~pwm_out ; //led low active

always@(posedge clk or negedge rst_n)
begin
	if(rst_n == 1'b0)
	begin
		period 		<= 32'd0;
		timer 		<= 32'd0;
		duty 		<= 32'd0;
		pwm_flag 	<= 1'b0 ;
		state 		<= IDLE;
	end
	else
		case(state)
			IDLE:
			begin
				period 		<= 32'd17179;   //The pwm step value, pwm 200Hz(period = 200*2^32/50000000)
				state  		<= PWM_PLUS;
				duty   		<= DUTY_MIN_VALUE;				
			end
			PWM_PLUS :
			begin
				if (duty > DUTY_MAX_VALUE - DUTY_STEP)	//if duty is bigger than DUTY MAX VALUE minus DUTY_STEP , begin to minus duty value
				begin
					pwm_flag 	<= 1'b1 ;
					duty   		<= duty - DUTY_STEP ;
				end
				else
				begin
					pwm_flag 	<= 1'b0 ;					
					duty   		<= duty + DUTY_STEP ;	
				end
				
				state  		<= PWM_GAP ;
			end
			PWM_MINUS :
			begin
				if (duty < DUTY_MIN_VALUE + DUTY_STEP)	//if duty is little than DUTY MIN VALUE plus duty step, begin to add duty value
				begin
					pwm_flag 	<= 1'b0 ;
					duty   		<= duty + DUTY_STEP ;
				end
				else
				begin
					pwm_flag 	<= 1'b1 ;
					duty   		<= duty - DUTY_STEP ;	
				end	
				state  		<= PWM_GAP ;
			end
			PWM_GAP:
			begin
				if(timer >= US_COUNT*100)      //adjustment gap is 100us
				begin
					if (pwm_flag)
						state <= PWM_MINUS ;
					else
						state <= PWM_PLUS ;
						
					timer <= 32'd0;
				end
				else
				begin
					timer <= timer + 32'd1;
				end
			end
			default:
			begin
				state <= IDLE;		
			end			
		endcase
end

//Instantiate pwm module
ax_pwm
#(
  .N(32)
 ) 
ax_pwm_m0(
    .clk      (clk),
    .rst      (~rst_n),
    .period   (period),
    .duty     (duty),
    .pwm_out  (pwm_out)
    );
	
endmodule 