`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//  Author: myj                                                                 //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//     WEB: http://www.alinx.cn/                                                //
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
//   Description:  pl read and write bram
//
//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//  2018/7/27     myj          1.0         Original
//  2019/2/28     myj          2.0         Adding some comments
//********************************************************************************/


module ram_read_write
    (
	 input              clk,
	 input              rst_n,
	 //bram port
     input      [31:0]  din,	 
	 output reg [31:0]  dout,
	 output reg         en,
	 output reg [3:0]   we,
	 output             rst,
	 output reg [31:0]  addr,
	 //control signal
	 input              start,       //start to read and write bram
	 input      [31:0]  init_data,   //initial data defined by software
	 output reg         start_clr,   //clear start register
	 input      [31:0]  len,         //data count
	 input      [31:0]  start_addr,   //start bram address
	 //Interrupt
	 input              intr_clr,    //clear interrupt
	 output reg         intr         //interrupt
    );


assign rst = 1'b0 ;
	
localparam IDLE      = 3'd0 ;
localparam READ_RAM  = 3'd1 ;
localparam READ_END  = 3'd2 ;
localparam WRITE_RAM = 3'd3 ;
localparam WRITE_END = 3'd4 ;

reg [2:0] state ;
reg [31:0] len_tmp ;
reg [31:0] start_addr_tmp ;


//Main statement
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
  begin
    state      <= IDLE  ;
	dout       <= 32'd0 ;
	en         <= 1'b0  ;
	we         <= 4'd0  ;
	addr       <= 32'd0 ;
	intr       <= 1'b0  ;
	start_clr  <= 1'b0  ;
	len_tmp    <= 32'd0 ;
	start_addr_tmp <= 32'd0 ;
  end
	
  else
  begin
    case(state)
	IDLE            : begin
			            if (start)
						begin
			              state <= READ_RAM     ;
						  addr  <= start_addr   ;
						  start_addr_tmp <= start_addr ;
						  len_tmp <= len ;
						  dout <= init_data ;
						  en    <= 1'b1 ;
						  start_clr <= 1'b1 ;
						end			
						if (intr_clr)
							intr <= 1'b0 ;
			          end

    
    READ_RAM        : begin
	                    if ((addr - start_addr_tmp) == len_tmp - 4)      //read completed
						begin
						  state <= READ_END ;
						  en    <= 1'b0     ;
						end
						else
						begin
						  addr <= addr + 32'd4 ;				  //address is byte based, for 32bit data width, adding 4		  
						end
						start_clr <= 1'b0 ;
					  end
					  
    READ_END        : begin
	                    addr  <= start_addr_tmp ;
	                    en <= 1'b1 ;
                        we <= 4'hf ;
					    state <= WRITE_RAM  ;					    
					  end
    
	WRITE_RAM       : begin
	                    if ((addr - start_addr_tmp) == len_tmp - 4)   //write completed
						begin
						  state <= WRITE_END ;
						  dout  <= 32'd0 ;
						  en    <= 1'b0  ;
						  we    <= 4'd0  ;
						end
						else
						begin
						  addr <= addr + 32'd4 ;
						  dout <= dout + 32'd1 ;						  
						end
					  end
					  
	WRITE_END       : begin
	                    addr <= 32'd0 ;
						intr <= 1'b1 ;
					    state <= IDLE ;					    
					  end	
	default         : state <= IDLE ;
	endcase
  end
end	



	
endmodule
