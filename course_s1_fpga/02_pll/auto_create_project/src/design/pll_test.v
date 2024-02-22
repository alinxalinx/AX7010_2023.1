`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    pll_test                                                      //
 //                                                                              //
 //  Author: lhj                                                                //
 //                                                                             //
 //          ALINX(shanghai) Technology Co.,Ltd                                  //
 //          heijin                                                              //
 //     WEB: http://www.alinx.cn/                                                //
 //     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
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
//  2018/01/03     lhj          1.0         Original
//*******************************************************************************/
//////////////////////////////////////////////////////////////////////////////////
module pll_test(
 input      sys_clk,            //system clock 50Mhz on board
input       rst_n,             //reset ,low active
output      clk_out           //pll clock output J8_Pin3

    );
    
wire        locked;


/////////////////////PLL IP call////////////////////////////
clk_wiz_0 clk_wiz_0_inst
   (// Clock in ports
    .clk_in1(sys_clk),            // IN 50Mhz
    // Clock out ports
    .clk_out1(),                // OUT 200Mhz
    .clk_out2(),               // OUT 100Mhz
    .clk_out3(),              // OUT 50Mhz
    .clk_out4(clk_out),    // OUT 25Mhz	 
    // Status and control signals	 
    .reset(~rst_n),        // pll reset, high-active
    .locked(locked));     // OUT

 

endmodule
