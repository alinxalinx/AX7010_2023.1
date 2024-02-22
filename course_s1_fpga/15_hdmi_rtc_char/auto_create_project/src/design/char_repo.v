`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: myj                                                                 //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//     WEB: http://www.alinx.com/                                                //
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
//  2019/10/31     myj         1.0         Original
//*******************************************************************************/


module char_repo(
	input   			clk,
	input 	[3:0]		char_addr_sel,	//char select, value 0~9 --> number 0~9; value 10 --> :
	input 	[5:0]		char_addr,		//char address
	output 	[7:0]		char_data		//char data

    );

	
reg [7:0]	char_mem [10:0] ;	//char rom, 0~9 and :

assign char_data = char_mem[char_addr_sel] ;



//number 0 rom data	
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[0] <= 8'h00 ;
        6'd1 : char_mem[0] <= 8'h00 ;
        6'd2 : char_mem[0] <= 8'h00 ;
        6'd3 : char_mem[0] <= 8'h00 ;
        6'd4 : char_mem[0] <= 8'h00 ;
        6'd5 : char_mem[0] <= 8'h00 ;
        6'd6 : char_mem[0] <= 8'h00 ;
        6'd7 : char_mem[0] <= 8'h00 ;
        6'd8 : char_mem[0] <= 8'h00 ;
        6'd9 : char_mem[0] <= 8'h00 ;
        6'd10 : char_mem[0] <= 8'h00 ;
        6'd11 : char_mem[0] <= 8'h00 ;
        6'd12 : char_mem[0] <= 8'hE0 ;
        6'd13 : char_mem[0] <= 8'h03 ;
        6'd14 : char_mem[0] <= 8'h30 ;
        6'd15 : char_mem[0] <= 8'h06 ;
        6'd16 : char_mem[0] <= 8'h18 ;
        6'd17 : char_mem[0] <= 8'h0C ;
        6'd18 : char_mem[0] <= 8'h18 ;
        6'd19 : char_mem[0] <= 8'h18 ;
        6'd20 : char_mem[0] <= 8'h1C ;
        6'd21 : char_mem[0] <= 8'h18 ;
        6'd22 : char_mem[0] <= 8'h0C ;
        6'd23 : char_mem[0] <= 8'h18 ;
        6'd24 : char_mem[0] <= 8'h0C ;
        6'd25 : char_mem[0] <= 8'h38 ;
        6'd26 : char_mem[0] <= 8'h0E ;
        6'd27 : char_mem[0] <= 8'h38 ;
        6'd28 : char_mem[0] <= 8'h0E ;
        6'd29 : char_mem[0] <= 8'h30 ;
        6'd30 : char_mem[0] <= 8'h0E ;
        6'd31 : char_mem[0] <= 8'h30 ;
        6'd32 : char_mem[0] <= 8'h0E ;
        6'd33 : char_mem[0] <= 8'h30 ;
        6'd34 : char_mem[0] <= 8'h0E ;
        6'd35 : char_mem[0] <= 8'h30 ;
        6'd36 : char_mem[0] <= 8'h0E ;
        6'd37 : char_mem[0] <= 8'h30 ;
        6'd38 : char_mem[0] <= 8'h0E ;
        6'd39 : char_mem[0] <= 8'h38 ;
        6'd40 : char_mem[0] <= 8'h0E ;
        6'd41 : char_mem[0] <= 8'h38 ;
        6'd42 : char_mem[0] <= 8'h0C ;
        6'd43 : char_mem[0] <= 8'h38 ;
        6'd44 : char_mem[0] <= 8'h0C ;
        6'd45 : char_mem[0] <= 8'h18 ;
        6'd46 : char_mem[0] <= 8'h0C ;
        6'd47 : char_mem[0] <= 8'h18 ;
        6'd48 : char_mem[0] <= 8'h18 ;
        6'd49 : char_mem[0] <= 8'h1C ;
        6'd50 : char_mem[0] <= 8'h18 ;
        6'd51 : char_mem[0] <= 8'h0C ;
        6'd52 : char_mem[0] <= 8'h30 ;
        6'd53 : char_mem[0] <= 8'h06 ;
        6'd54 : char_mem[0] <= 8'hE0 ;
        6'd55 : char_mem[0] <= 8'h03 ;
        6'd56 : char_mem[0] <= 8'h00 ;
        6'd57 : char_mem[0] <= 8'h00 ;
        6'd58 : char_mem[0] <= 8'h00 ;
        6'd59 : char_mem[0] <= 8'h00 ;
        6'd60 : char_mem[0] <= 8'h00 ;
        6'd61 : char_mem[0] <= 8'h00 ;
        6'd62 : char_mem[0] <= 8'h00 ;
        6'd63 : char_mem[0] <= 8'h00 ;
		default: char_mem[0] <= 8'h00 ;
    endcase
end



//number 1 rom data	
always @(posedge clk)
begin
	case(char_addr)
		6'd0  : char_mem[1] <= 8'h00 ;
		6'd1  : char_mem[1] <= 8'h00 ;
		6'd2  : char_mem[1] <= 8'h00 ;
		6'd3  : char_mem[1] <= 8'h00 ;
		6'd4  : char_mem[1] <= 8'h00 ;
		6'd5  : char_mem[1] <= 8'h00 ;
		6'd6  : char_mem[1] <= 8'h00 ;
		6'd7  : char_mem[1] <= 8'h00 ;
		6'd8  : char_mem[1] <= 8'h00 ;
		6'd9  : char_mem[1] <= 8'h00 ;
		6'd10 : char_mem[1] <= 8'h00 ;
		6'd11 : char_mem[1] <= 8'h00 ;
		6'd12 : char_mem[1] <= 8'h00 ;
		6'd13 : char_mem[1] <= 8'h01 ;
		6'd14 : char_mem[1] <= 8'h80 ;
		6'd15 : char_mem[1] <= 8'h01 ;
		6'd16 : char_mem[1] <= 8'hF8 ;
		6'd17 : char_mem[1] <= 8'h01 ;
		6'd18 : char_mem[1] <= 8'h80 ;
		6'd19 : char_mem[1] <= 8'h01 ;
		6'd20 : char_mem[1] <= 8'h80 ;
		6'd21 : char_mem[1] <= 8'h01 ;
		6'd22 : char_mem[1] <= 8'h80 ;
		6'd23 : char_mem[1] <= 8'h01 ;
		6'd24 : char_mem[1] <= 8'h80 ;
		6'd25 : char_mem[1] <= 8'h01 ;
		6'd26 : char_mem[1] <= 8'h80 ;
		6'd27 : char_mem[1] <= 8'h01 ;
		6'd28 : char_mem[1] <= 8'h80 ;
		6'd29 : char_mem[1] <= 8'h01 ;
		6'd30 : char_mem[1] <= 8'h80 ;
		6'd31 : char_mem[1] <= 8'h01 ;
		6'd32 : char_mem[1] <= 8'h80 ;
		6'd33 : char_mem[1] <= 8'h01 ;
		6'd34 : char_mem[1] <= 8'h80 ;
		6'd35 : char_mem[1] <= 8'h01 ;
		6'd36 : char_mem[1] <= 8'h80 ;
		6'd37 : char_mem[1] <= 8'h01 ;
		6'd38 : char_mem[1] <= 8'h80 ;
		6'd39 : char_mem[1] <= 8'h01 ;
		6'd40 : char_mem[1] <= 8'h80 ;
		6'd41 : char_mem[1] <= 8'h01 ;
		6'd42 : char_mem[1] <= 8'h80 ;
		6'd43 : char_mem[1] <= 8'h01 ;
		6'd44 : char_mem[1] <= 8'h80 ;
		6'd45 : char_mem[1] <= 8'h01 ;
		6'd46 : char_mem[1] <= 8'h80 ;
		6'd47 : char_mem[1] <= 8'h01 ;
		6'd48 : char_mem[1] <= 8'h80 ;
		6'd49 : char_mem[1] <= 8'h01 ;
		6'd50 : char_mem[1] <= 8'h80 ;
		6'd51 : char_mem[1] <= 8'h01 ;
		6'd52 : char_mem[1] <= 8'hC0 ;
		6'd53 : char_mem[1] <= 8'h03 ;
		6'd54 : char_mem[1] <= 8'hF8 ;
		6'd55 : char_mem[1] <= 8'h1F ;
		6'd56 : char_mem[1] <= 8'h00 ;
		6'd57 : char_mem[1] <= 8'h00 ;
		6'd58 : char_mem[1] <= 8'h00 ;
		6'd59 : char_mem[1] <= 8'h00 ;
		6'd60 : char_mem[1] <= 8'h00 ;
		6'd61 : char_mem[1] <= 8'h00 ;
		6'd62 : char_mem[1] <= 8'h00 ;
		6'd63 : char_mem[1] <= 8'h00 ;
		default: char_mem[1] <= 8'h00 ;
	endcase
end	

//number 2 rom data	
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[2] <= 8'h00 ;
        6'd1 : char_mem[2] <= 8'h00 ;
        6'd2 : char_mem[2] <= 8'h00 ;
        6'd3 : char_mem[2] <= 8'h00 ;
        6'd4 : char_mem[2] <= 8'h00 ;
        6'd5 : char_mem[2] <= 8'h00 ;
        6'd6 : char_mem[2] <= 8'h00 ;
        6'd7 : char_mem[2] <= 8'h00 ;
        6'd8 : char_mem[2] <= 8'h00 ;
        6'd9 : char_mem[2] <= 8'h00 ;
        6'd10 : char_mem[2] <= 8'h00 ;
        6'd11 : char_mem[2] <= 8'h00 ;
        6'd12 : char_mem[2] <= 8'hE0 ;
        6'd13 : char_mem[2] <= 8'h07 ;
        6'd14 : char_mem[2] <= 8'h18 ;
        6'd15 : char_mem[2] <= 8'h0E ;
        6'd16 : char_mem[2] <= 8'h0C ;
        6'd17 : char_mem[2] <= 8'h1C ;
        6'd18 : char_mem[2] <= 8'h0C ;
        6'd19 : char_mem[2] <= 8'h18 ;
        6'd20 : char_mem[2] <= 8'h0C ;
        6'd21 : char_mem[2] <= 8'h18 ;
        6'd22 : char_mem[2] <= 8'h0C ;
        6'd23 : char_mem[2] <= 8'h18 ;
        6'd24 : char_mem[2] <= 8'h1C ;
        6'd25 : char_mem[2] <= 8'h18 ;
        6'd26 : char_mem[2] <= 8'h00 ;
        6'd27 : char_mem[2] <= 8'h18 ;
        6'd28 : char_mem[2] <= 8'h00 ;
        6'd29 : char_mem[2] <= 8'h18 ;
        6'd30 : char_mem[2] <= 8'h00 ;
        6'd31 : char_mem[2] <= 8'h0C ;
        6'd32 : char_mem[2] <= 8'h00 ;
        6'd33 : char_mem[2] <= 8'h06 ;
        6'd34 : char_mem[2] <= 8'h00 ;
        6'd35 : char_mem[2] <= 8'h02 ;
        6'd36 : char_mem[2] <= 8'h00 ;
        6'd37 : char_mem[2] <= 8'h01 ;
        6'd38 : char_mem[2] <= 8'h80 ;
        6'd39 : char_mem[2] <= 8'h00 ;
        6'd40 : char_mem[2] <= 8'hC0 ;
        6'd41 : char_mem[2] <= 8'h00 ;
        6'd42 : char_mem[2] <= 8'h60 ;
        6'd43 : char_mem[2] <= 8'h00 ;
        6'd44 : char_mem[2] <= 8'h30 ;
        6'd45 : char_mem[2] <= 8'h00 ;
        6'd46 : char_mem[2] <= 8'h18 ;
        6'd47 : char_mem[2] <= 8'h20 ;
        6'd48 : char_mem[2] <= 8'h0C ;
        6'd49 : char_mem[2] <= 8'h10 ;
        6'd50 : char_mem[2] <= 8'h04 ;
        6'd51 : char_mem[2] <= 8'h10 ;
        6'd52 : char_mem[2] <= 8'hFE ;
        6'd53 : char_mem[2] <= 8'h1F ;
        6'd54 : char_mem[2] <= 8'hFE ;
        6'd55 : char_mem[2] <= 8'h1F ;
        6'd56 : char_mem[2] <= 8'h00 ;
        6'd57 : char_mem[2] <= 8'h00 ;
        6'd58 : char_mem[2] <= 8'h00 ;
        6'd59 : char_mem[2] <= 8'h00 ;
        6'd60 : char_mem[2] <= 8'h00 ;
        6'd61 : char_mem[2] <= 8'h00 ;
        6'd62 : char_mem[2] <= 8'h00 ;
        6'd63 : char_mem[2] <= 8'h00 ;
		default: char_mem[2] <= 8'h00 ;
    endcase
end

//number 3 rom data
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[3] <= 8'h00 ;
        6'd1 : char_mem[3] <= 8'h00 ;
        6'd2 : char_mem[3] <= 8'h00 ;
        6'd3 : char_mem[3] <= 8'h00 ;
        6'd4 : char_mem[3] <= 8'h00 ;
        6'd5 : char_mem[3] <= 8'h00 ;
        6'd6 : char_mem[3] <= 8'h00 ;
        6'd7 : char_mem[3] <= 8'h00 ;
        6'd8 : char_mem[3] <= 8'h00 ;
        6'd9 : char_mem[3] <= 8'h00 ;
        6'd10 : char_mem[3] <= 8'h00 ;
        6'd11 : char_mem[3] <= 8'h00 ;
        6'd12 : char_mem[3] <= 8'hE0 ;
        6'd13 : char_mem[3] <= 8'h03 ;
        6'd14 : char_mem[3] <= 8'h18 ;
        6'd15 : char_mem[3] <= 8'h06 ;
        6'd16 : char_mem[3] <= 8'h0C ;
        6'd17 : char_mem[3] <= 8'h0C ;
        6'd18 : char_mem[3] <= 8'h0C ;
        6'd19 : char_mem[3] <= 8'h1C ;
        6'd20 : char_mem[3] <= 8'h0C ;
        6'd21 : char_mem[3] <= 8'h18 ;
        6'd22 : char_mem[3] <= 8'h0C ;
        6'd23 : char_mem[3] <= 8'h18 ;
        6'd24 : char_mem[3] <= 8'h00 ;
        6'd25 : char_mem[3] <= 8'h18 ;
        6'd26 : char_mem[3] <= 8'h00 ;
        6'd27 : char_mem[3] <= 8'h0C ;
        6'd28 : char_mem[3] <= 8'h00 ;
        6'd29 : char_mem[3] <= 8'h0C ;
        6'd30 : char_mem[3] <= 8'h00 ;
        6'd31 : char_mem[3] <= 8'h07 ;
        6'd32 : char_mem[3] <= 8'hC0 ;
        6'd33 : char_mem[3] <= 8'h03 ;
        6'd34 : char_mem[3] <= 8'h00 ;
        6'd35 : char_mem[3] <= 8'h06 ;
        6'd36 : char_mem[3] <= 8'h00 ;
        6'd37 : char_mem[3] <= 8'h0C ;
        6'd38 : char_mem[3] <= 8'h00 ;
        6'd39 : char_mem[3] <= 8'h18 ;
        6'd40 : char_mem[3] <= 8'h00 ;
        6'd41 : char_mem[3] <= 8'h38 ;
        6'd42 : char_mem[3] <= 8'h00 ;
        6'd43 : char_mem[3] <= 8'h38 ;
        6'd44 : char_mem[3] <= 8'h0C ;
        6'd45 : char_mem[3] <= 8'h38 ;
        6'd46 : char_mem[3] <= 8'h0E ;
        6'd47 : char_mem[3] <= 8'h38 ;
        6'd48 : char_mem[3] <= 8'h0C ;
        6'd49 : char_mem[3] <= 8'h18 ;
        6'd50 : char_mem[3] <= 8'h0C ;
        6'd51 : char_mem[3] <= 8'h1C ;
        6'd52 : char_mem[3] <= 8'h18 ;
        6'd53 : char_mem[3] <= 8'h0E ;
        6'd54 : char_mem[3] <= 8'hF0 ;
        6'd55 : char_mem[3] <= 8'h03 ;
        6'd56 : char_mem[3] <= 8'h00 ;
        6'd57 : char_mem[3] <= 8'h00 ;
        6'd58 : char_mem[3] <= 8'h00 ;
        6'd59 : char_mem[3] <= 8'h00 ;
        6'd60 : char_mem[3] <= 8'h00 ;
        6'd61 : char_mem[3] <= 8'h00 ;
        6'd62 : char_mem[3] <= 8'h00 ;
        6'd63 : char_mem[3] <= 8'h00 ;
		default: char_mem[3] <= 8'h00 ;
    endcase
end

//number 4 rom data
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[4] <= 8'h00 ;
        6'd1 : char_mem[4] <= 8'h00 ;
        6'd2 : char_mem[4] <= 8'h00 ;
        6'd3 : char_mem[4] <= 8'h00 ;
        6'd4 : char_mem[4] <= 8'h00 ;
        6'd5 : char_mem[4] <= 8'h00 ;
        6'd6 : char_mem[4] <= 8'h00 ;
        6'd7 : char_mem[4] <= 8'h00 ;
        6'd8 : char_mem[4] <= 8'h00 ;
        6'd9 : char_mem[4] <= 8'h00 ;
        6'd10 : char_mem[4] <= 8'h00 ;
        6'd11 : char_mem[4] <= 8'h00 ;
        6'd12 : char_mem[4] <= 8'h00 ;
        6'd13 : char_mem[4] <= 8'h04 ;
        6'd14 : char_mem[4] <= 8'h00 ;
        6'd15 : char_mem[4] <= 8'h06 ;
        6'd16 : char_mem[4] <= 8'h00 ;
        6'd17 : char_mem[4] <= 8'h07 ;
        6'd18 : char_mem[4] <= 8'h00 ;
        6'd19 : char_mem[4] <= 8'h07 ;
        6'd20 : char_mem[4] <= 8'h80 ;
        6'd21 : char_mem[4] <= 8'h06 ;
        6'd22 : char_mem[4] <= 8'hC0 ;
        6'd23 : char_mem[4] <= 8'h06 ;
        6'd24 : char_mem[4] <= 8'h40 ;
        6'd25 : char_mem[4] <= 8'h06 ;
        6'd26 : char_mem[4] <= 8'h60 ;
        6'd27 : char_mem[4] <= 8'h06 ;
        6'd28 : char_mem[4] <= 8'h20 ;
        6'd29 : char_mem[4] <= 8'h06 ;
        6'd30 : char_mem[4] <= 8'h10 ;
        6'd31 : char_mem[4] <= 8'h06 ;
        6'd32 : char_mem[4] <= 8'h18 ;
        6'd33 : char_mem[4] <= 8'h06 ;
        6'd34 : char_mem[4] <= 8'h08 ;
        6'd35 : char_mem[4] <= 8'h06 ;
        6'd36 : char_mem[4] <= 8'h0C ;
        6'd37 : char_mem[4] <= 8'h06 ;
        6'd38 : char_mem[4] <= 8'h04 ;
        6'd39 : char_mem[4] <= 8'h06 ;
        6'd40 : char_mem[4] <= 8'h02 ;
        6'd41 : char_mem[4] <= 8'h06 ;
        6'd42 : char_mem[4] <= 8'hFE ;
        6'd43 : char_mem[4] <= 8'h7F ;
        6'd44 : char_mem[4] <= 8'h00 ;
        6'd45 : char_mem[4] <= 8'h06 ;
        6'd46 : char_mem[4] <= 8'h00 ;
        6'd47 : char_mem[4] <= 8'h06 ;
        6'd48 : char_mem[4] <= 8'h00 ;
        6'd49 : char_mem[4] <= 8'h06 ;
        6'd50 : char_mem[4] <= 8'h00 ;
        6'd51 : char_mem[4] <= 8'h06 ;
        6'd52 : char_mem[4] <= 8'h00 ;
        6'd53 : char_mem[4] <= 8'h0E ;
        6'd54 : char_mem[4] <= 8'hC0 ;
        6'd55 : char_mem[4] <= 8'h3F ;
        6'd56 : char_mem[4] <= 8'h00 ;
        6'd57 : char_mem[4] <= 8'h00 ;
        6'd58 : char_mem[4] <= 8'h00 ;
        6'd59 : char_mem[4] <= 8'h00 ;
        6'd60 : char_mem[4] <= 8'h00 ;
        6'd61 : char_mem[4] <= 8'h00 ;
        6'd62 : char_mem[4] <= 8'h00 ;
        6'd63 : char_mem[4] <= 8'h00 ;
		default: char_mem[4] <= 8'h00 ;
    endcase
end

//number 5 rom data
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[5] <= 8'h00 ;
        6'd1 : char_mem[5] <= 8'h00 ;
        6'd2 : char_mem[5] <= 8'h00 ;
        6'd3 : char_mem[5] <= 8'h00 ;
        6'd4 : char_mem[5] <= 8'h00 ;
        6'd5 : char_mem[5] <= 8'h00 ;
        6'd6 : char_mem[5] <= 8'h00 ;
        6'd7 : char_mem[5] <= 8'h00 ;
        6'd8 : char_mem[5] <= 8'h00 ;
        6'd9 : char_mem[5] <= 8'h00 ;
        6'd10 : char_mem[5] <= 8'h00 ;
        6'd11 : char_mem[5] <= 8'h00 ;
        6'd12 : char_mem[5] <= 8'hF8 ;
        6'd13 : char_mem[5] <= 8'h1F ;
        6'd14 : char_mem[5] <= 8'hF8 ;
        6'd15 : char_mem[5] <= 8'h1F ;
        6'd16 : char_mem[5] <= 8'h08 ;
        6'd17 : char_mem[5] <= 8'h00 ;
        6'd18 : char_mem[5] <= 8'h08 ;
        6'd19 : char_mem[5] <= 8'h00 ;
        6'd20 : char_mem[5] <= 8'h08 ;
        6'd21 : char_mem[5] <= 8'h00 ;
        6'd22 : char_mem[5] <= 8'h08 ;
        6'd23 : char_mem[5] <= 8'h00 ;
        6'd24 : char_mem[5] <= 8'h08 ;
        6'd25 : char_mem[5] <= 8'h00 ;
        6'd26 : char_mem[5] <= 8'h08 ;
        6'd27 : char_mem[5] <= 8'h00 ;
        6'd28 : char_mem[5] <= 8'hEC ;
        6'd29 : char_mem[5] <= 8'h07 ;
        6'd30 : char_mem[5] <= 8'h3C ;
        6'd31 : char_mem[5] <= 8'h0E ;
        6'd32 : char_mem[5] <= 8'h0C ;
        6'd33 : char_mem[5] <= 8'h1C ;
        6'd34 : char_mem[5] <= 8'h08 ;
        6'd35 : char_mem[5] <= 8'h18 ;
        6'd36 : char_mem[5] <= 8'h00 ;
        6'd37 : char_mem[5] <= 8'h38 ;
        6'd38 : char_mem[5] <= 8'h00 ;
        6'd39 : char_mem[5] <= 8'h38 ;
        6'd40 : char_mem[5] <= 8'h00 ;
        6'd41 : char_mem[5] <= 8'h38 ;
        6'd42 : char_mem[5] <= 8'h00 ;
        6'd43 : char_mem[5] <= 8'h38 ;
        6'd44 : char_mem[5] <= 8'h0C ;
        6'd45 : char_mem[5] <= 8'h38 ;
        6'd46 : char_mem[5] <= 8'h0E ;
        6'd47 : char_mem[5] <= 8'h18 ;
        6'd48 : char_mem[5] <= 8'h0C ;
        6'd49 : char_mem[5] <= 8'h18 ;
        6'd50 : char_mem[5] <= 8'h0C ;
        6'd51 : char_mem[5] <= 8'h1C ;
        6'd52 : char_mem[5] <= 8'h18 ;
        6'd53 : char_mem[5] <= 8'h0E ;
        6'd54 : char_mem[5] <= 8'hE0 ;
        6'd55 : char_mem[5] <= 8'h03 ;
        6'd56 : char_mem[5] <= 8'h00 ;
        6'd57 : char_mem[5] <= 8'h00 ;
        6'd58 : char_mem[5] <= 8'h00 ;
        6'd59 : char_mem[5] <= 8'h00 ;
        6'd60 : char_mem[5] <= 8'h00 ;
        6'd61 : char_mem[5] <= 8'h00 ;
        6'd62 : char_mem[5] <= 8'h00 ;
        6'd63 : char_mem[5] <= 8'h00 ;
		default: char_mem[5] <= 8'h00 ;
    endcase
end



//number 6 rom data
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[6] <= 8'h00 ;
        6'd1 : char_mem[6] <= 8'h00 ;
        6'd2 : char_mem[6] <= 8'h00 ;
        6'd3 : char_mem[6] <= 8'h00 ;
        6'd4 : char_mem[6] <= 8'h00 ;
        6'd5 : char_mem[6] <= 8'h00 ;
        6'd6 : char_mem[6] <= 8'h00 ;
        6'd7 : char_mem[6] <= 8'h00 ;
        6'd8 : char_mem[6] <= 8'h00 ;
        6'd9 : char_mem[6] <= 8'h00 ;
        6'd10 : char_mem[6] <= 8'h00 ;
        6'd11 : char_mem[6] <= 8'h00 ;
        6'd12 : char_mem[6] <= 8'hC0 ;
        6'd13 : char_mem[6] <= 8'h07 ;
        6'd14 : char_mem[6] <= 8'h60 ;
        6'd15 : char_mem[6] <= 8'h0C ;
        6'd16 : char_mem[6] <= 8'h10 ;
        6'd17 : char_mem[6] <= 8'h1C ;
        6'd18 : char_mem[6] <= 8'h18 ;
        6'd19 : char_mem[6] <= 8'h1C ;
        6'd20 : char_mem[6] <= 8'h0C ;
        6'd21 : char_mem[6] <= 8'h00 ;
        6'd22 : char_mem[6] <= 8'h0C ;
        6'd23 : char_mem[6] <= 8'h00 ;
        6'd24 : char_mem[6] <= 8'h0C ;
        6'd25 : char_mem[6] <= 8'h00 ;
        6'd26 : char_mem[6] <= 8'h0E ;
        6'd27 : char_mem[6] <= 8'h00 ;
        6'd28 : char_mem[6] <= 8'hCE ;
        6'd29 : char_mem[6] <= 8'h07 ;
        6'd30 : char_mem[6] <= 8'h6E ;
        6'd31 : char_mem[6] <= 8'h0E ;
        6'd32 : char_mem[6] <= 8'h1E ;
        6'd33 : char_mem[6] <= 8'h18 ;
        6'd34 : char_mem[6] <= 8'h0E ;
        6'd35 : char_mem[6] <= 8'h38 ;
        6'd36 : char_mem[6] <= 8'h0E ;
        6'd37 : char_mem[6] <= 8'h30 ;
        6'd38 : char_mem[6] <= 8'h0E ;
        6'd39 : char_mem[6] <= 8'h30 ;
        6'd40 : char_mem[6] <= 8'h0E ;
        6'd41 : char_mem[6] <= 8'h30 ;
        6'd42 : char_mem[6] <= 8'h0E ;
        6'd43 : char_mem[6] <= 8'h30 ;
        6'd44 : char_mem[6] <= 8'h0C ;
        6'd45 : char_mem[6] <= 8'h30 ;
        6'd46 : char_mem[6] <= 8'h0C ;
        6'd47 : char_mem[6] <= 8'h30 ;
        6'd48 : char_mem[6] <= 8'h1C ;
        6'd49 : char_mem[6] <= 8'h18 ;
        6'd50 : char_mem[6] <= 8'h18 ;
        6'd51 : char_mem[6] <= 8'h18 ;
        6'd52 : char_mem[6] <= 8'h30 ;
        6'd53 : char_mem[6] <= 8'h0C ;
        6'd54 : char_mem[6] <= 8'hE0 ;
        6'd55 : char_mem[6] <= 8'h03 ;
        6'd56 : char_mem[6] <= 8'h00 ;
        6'd57 : char_mem[6] <= 8'h00 ;
        6'd58 : char_mem[6] <= 8'h00 ;
        6'd59 : char_mem[6] <= 8'h00 ;
        6'd60 : char_mem[6] <= 8'h00 ;
        6'd61 : char_mem[6] <= 8'h00 ;
        6'd62 : char_mem[6] <= 8'h00 ;
        6'd63 : char_mem[6] <= 8'h00 ;
		default: char_mem[6] <= 8'h00 ;
    endcase
end
//number 7 rom data
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[7] <= 8'h00 ;
        6'd1 : char_mem[7] <= 8'h00 ;
        6'd2 : char_mem[7] <= 8'h00 ;
        6'd3 : char_mem[7] <= 8'h00 ;
        6'd4 : char_mem[7] <= 8'h00 ;
        6'd5 : char_mem[7] <= 8'h00 ;
        6'd6 : char_mem[7] <= 8'h00 ;
        6'd7 : char_mem[7] <= 8'h00 ;
        6'd8 : char_mem[7] <= 8'h00 ;
        6'd9 : char_mem[7] <= 8'h00 ;
        6'd10 : char_mem[7] <= 8'h00 ;
        6'd11 : char_mem[7] <= 8'h00 ;
        6'd12 : char_mem[7] <= 8'hFC ;
        6'd13 : char_mem[7] <= 8'h3F ;
        6'd14 : char_mem[7] <= 8'hFC ;
        6'd15 : char_mem[7] <= 8'h3F ;
        6'd16 : char_mem[7] <= 8'h0C ;
        6'd17 : char_mem[7] <= 8'h10 ;
        6'd18 : char_mem[7] <= 8'h04 ;
        6'd19 : char_mem[7] <= 8'h08 ;
        6'd20 : char_mem[7] <= 8'h04 ;
        6'd21 : char_mem[7] <= 8'h08 ;
        6'd22 : char_mem[7] <= 8'h00 ;
        6'd23 : char_mem[7] <= 8'h04 ;
        6'd24 : char_mem[7] <= 8'h00 ;
        6'd25 : char_mem[7] <= 8'h06 ;
        6'd26 : char_mem[7] <= 8'h00 ;
        6'd27 : char_mem[7] <= 8'h02 ;
        6'd28 : char_mem[7] <= 8'h00 ;
        6'd29 : char_mem[7] <= 8'h02 ;
        6'd30 : char_mem[7] <= 8'h00 ;
        6'd31 : char_mem[7] <= 8'h03 ;
        6'd32 : char_mem[7] <= 8'h00 ;
        6'd33 : char_mem[7] <= 8'h01 ;
        6'd34 : char_mem[7] <= 8'h80 ;
        6'd35 : char_mem[7] <= 8'h01 ;
        6'd36 : char_mem[7] <= 8'h80 ;
        6'd37 : char_mem[7] <= 8'h01 ;
        6'd38 : char_mem[7] <= 8'hC0 ;
        6'd39 : char_mem[7] <= 8'h00 ;
        6'd40 : char_mem[7] <= 8'hC0 ;
        6'd41 : char_mem[7] <= 8'h00 ;
        6'd42 : char_mem[7] <= 8'hC0 ;
        6'd43 : char_mem[7] <= 8'h00 ;
        6'd44 : char_mem[7] <= 8'hC0 ;
        6'd45 : char_mem[7] <= 8'h00 ;
        6'd46 : char_mem[7] <= 8'hE0 ;
        6'd47 : char_mem[7] <= 8'h00 ;
        6'd48 : char_mem[7] <= 8'hE0 ;
        6'd49 : char_mem[7] <= 8'h00 ;
        6'd50 : char_mem[7] <= 8'hE0 ;
        6'd51 : char_mem[7] <= 8'h00 ;
        6'd52 : char_mem[7] <= 8'hE0 ;
        6'd53 : char_mem[7] <= 8'h00 ;
        6'd54 : char_mem[7] <= 8'hC0 ;
        6'd55 : char_mem[7] <= 8'h00 ;
        6'd56 : char_mem[7] <= 8'h00 ;
        6'd57 : char_mem[7] <= 8'h00 ;
        6'd58 : char_mem[7] <= 8'h00 ;
        6'd59 : char_mem[7] <= 8'h00 ;
        6'd60 : char_mem[7] <= 8'h00 ;
        6'd61 : char_mem[7] <= 8'h00 ;
        6'd62 : char_mem[7] <= 8'h00 ;
        6'd63 : char_mem[7] <= 8'h00 ;
		default: char_mem[7] <= 8'h00 ;
    endcase
end
//number 8 rom data
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[8] <= 8'h00 ;
        6'd1 : char_mem[8] <= 8'h00 ;
        6'd2 : char_mem[8] <= 8'h00 ;
        6'd3 : char_mem[8] <= 8'h00 ;
        6'd4 : char_mem[8] <= 8'h00 ;
        6'd5 : char_mem[8] <= 8'h00 ;
        6'd6 : char_mem[8] <= 8'h00 ;
        6'd7 : char_mem[8] <= 8'h00 ;
        6'd8 : char_mem[8] <= 8'h00 ;
        6'd9 : char_mem[8] <= 8'h00 ;
        6'd10 : char_mem[8] <= 8'h00 ;
        6'd11 : char_mem[8] <= 8'h00 ;
        6'd12 : char_mem[8] <= 8'hE0 ;
        6'd13 : char_mem[8] <= 8'h03 ;
        6'd14 : char_mem[8] <= 8'h18 ;
        6'd15 : char_mem[8] <= 8'h0C ;
        6'd16 : char_mem[8] <= 8'h0C ;
        6'd17 : char_mem[8] <= 8'h18 ;
        6'd18 : char_mem[8] <= 8'h0C ;
        6'd19 : char_mem[8] <= 8'h18 ;
        6'd20 : char_mem[8] <= 8'h06 ;
        6'd21 : char_mem[8] <= 8'h30 ;
        6'd22 : char_mem[8] <= 8'h06 ;
        6'd23 : char_mem[8] <= 8'h30 ;
        6'd24 : char_mem[8] <= 8'h0C ;
        6'd25 : char_mem[8] <= 8'h10 ;
        6'd26 : char_mem[8] <= 8'h1C ;
        6'd27 : char_mem[8] <= 8'h18 ;
        6'd28 : char_mem[8] <= 8'h38 ;
        6'd29 : char_mem[8] <= 8'h08 ;
        6'd30 : char_mem[8] <= 8'hF0 ;
        6'd31 : char_mem[8] <= 8'h06 ;
        6'd32 : char_mem[8] <= 8'hE0 ;
        6'd33 : char_mem[8] <= 8'h03 ;
        6'd34 : char_mem[8] <= 8'h98 ;
        6'd35 : char_mem[8] <= 8'h07 ;
        6'd36 : char_mem[8] <= 8'h0C ;
        6'd37 : char_mem[8] <= 8'h0E ;
        6'd38 : char_mem[8] <= 8'h0C ;
        6'd39 : char_mem[8] <= 8'h1C ;
        6'd40 : char_mem[8] <= 8'h06 ;
        6'd41 : char_mem[8] <= 8'h38 ;
        6'd42 : char_mem[8] <= 8'h06 ;
        6'd43 : char_mem[8] <= 8'h30 ;
        6'd44 : char_mem[8] <= 8'h06 ;
        6'd45 : char_mem[8] <= 8'h30 ;
        6'd46 : char_mem[8] <= 8'h06 ;
        6'd47 : char_mem[8] <= 8'h30 ;
        6'd48 : char_mem[8] <= 8'h06 ;
        6'd49 : char_mem[8] <= 8'h10 ;
        6'd50 : char_mem[8] <= 8'h0C ;
        6'd51 : char_mem[8] <= 8'h18 ;
        6'd52 : char_mem[8] <= 8'h18 ;
        6'd53 : char_mem[8] <= 8'h0C ;
        6'd54 : char_mem[8] <= 8'hE0 ;
        6'd55 : char_mem[8] <= 8'h03 ;
        6'd56 : char_mem[8] <= 8'h00 ;
        6'd57 : char_mem[8] <= 8'h00 ;
        6'd58 : char_mem[8] <= 8'h00 ;
        6'd59 : char_mem[8] <= 8'h00 ;
        6'd60 : char_mem[8] <= 8'h00 ;
        6'd61 : char_mem[8] <= 8'h00 ;
        6'd62 : char_mem[8] <= 8'h00 ;
        6'd63 : char_mem[8] <= 8'h00 ;
		default: char_mem[8] <= 8'h00 ;
    endcase
end
//number 9 rom data
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[9] <= 8'h00 ;
        6'd1 : char_mem[9] <= 8'h00 ;
        6'd2 : char_mem[9] <= 8'h00 ;
        6'd3 : char_mem[9] <= 8'h00 ;
        6'd4 : char_mem[9] <= 8'h00 ;
        6'd5 : char_mem[9] <= 8'h00 ;
        6'd6 : char_mem[9] <= 8'h00 ;
        6'd7 : char_mem[9] <= 8'h00 ;
        6'd8 : char_mem[9] <= 8'h00 ;
        6'd9 : char_mem[9] <= 8'h00 ;
        6'd10 : char_mem[9] <= 8'h00 ;
        6'd11 : char_mem[9] <= 8'h00 ;
        6'd12 : char_mem[9] <= 8'hE0 ;
        6'd13 : char_mem[9] <= 8'h03 ;
        6'd14 : char_mem[9] <= 8'h18 ;
        6'd15 : char_mem[9] <= 8'h06 ;
        6'd16 : char_mem[9] <= 8'h0C ;
        6'd17 : char_mem[9] <= 8'h0C ;
        6'd18 : char_mem[9] <= 8'h0C ;
        6'd19 : char_mem[9] <= 8'h18 ;
        6'd20 : char_mem[9] <= 8'h0E ;
        6'd21 : char_mem[9] <= 8'h18 ;
        6'd22 : char_mem[9] <= 8'h06 ;
        6'd23 : char_mem[9] <= 8'h38 ;
        6'd24 : char_mem[9] <= 8'h06 ;
        6'd25 : char_mem[9] <= 8'h38 ;
        6'd26 : char_mem[9] <= 8'h06 ;
        6'd27 : char_mem[9] <= 8'h38 ;
        6'd28 : char_mem[9] <= 8'h06 ;
        6'd29 : char_mem[9] <= 8'h38 ;
        6'd30 : char_mem[9] <= 8'h0E ;
        6'd31 : char_mem[9] <= 8'h38 ;
        6'd32 : char_mem[9] <= 8'h0E ;
        6'd33 : char_mem[9] <= 8'h3C ;
        6'd34 : char_mem[9] <= 8'h0C ;
        6'd35 : char_mem[9] <= 8'h3C ;
        6'd36 : char_mem[9] <= 8'h38 ;
        6'd37 : char_mem[9] <= 8'h3B ;
        6'd38 : char_mem[9] <= 8'hF0 ;
        6'd39 : char_mem[9] <= 8'h39 ;
        6'd40 : char_mem[9] <= 8'h00 ;
        6'd41 : char_mem[9] <= 8'h38 ;
        6'd42 : char_mem[9] <= 8'h00 ;
        6'd43 : char_mem[9] <= 8'h18 ;
        6'd44 : char_mem[9] <= 8'h00 ;
        6'd45 : char_mem[9] <= 8'h18 ;
        6'd46 : char_mem[9] <= 8'h00 ;
        6'd47 : char_mem[9] <= 8'h0C ;
        6'd48 : char_mem[9] <= 8'h1C ;
        6'd49 : char_mem[9] <= 8'h0C ;
        6'd50 : char_mem[9] <= 8'h1C ;
        6'd51 : char_mem[9] <= 8'h06 ;
        6'd52 : char_mem[9] <= 8'h1C ;
        6'd53 : char_mem[9] <= 8'h03 ;
        6'd54 : char_mem[9] <= 8'hF0 ;
        6'd55 : char_mem[9] <= 8'h01 ;
        6'd56 : char_mem[9] <= 8'h00 ;
        6'd57 : char_mem[9] <= 8'h00 ;
        6'd58 : char_mem[9] <= 8'h00 ;
        6'd59 : char_mem[9] <= 8'h00 ;
        6'd60 : char_mem[9] <= 8'h00 ;
        6'd61 : char_mem[9] <= 8'h00 ;
        6'd62 : char_mem[9] <= 8'h00 ;
        6'd63 : char_mem[9] <= 8'h00 ;
		default: char_mem[9] <= 8'h00 ;
    endcase
end


//colon rom data
always @(posedge clk)
begin
    case(char_addr)
        6'd0 : char_mem[10] <= 8'h00 ;
        6'd1 : char_mem[10] <= 8'h00 ;
        6'd2 : char_mem[10] <= 8'h00 ;
        6'd3 : char_mem[10] <= 8'h00 ;
        6'd4 : char_mem[10] <= 8'h00 ;
        6'd5 : char_mem[10] <= 8'h00 ;
        6'd6 : char_mem[10] <= 8'h00 ;
        6'd7 : char_mem[10] <= 8'h00 ;
        6'd8 : char_mem[10] <= 8'h00 ;
        6'd9 : char_mem[10] <= 8'h00 ;
        6'd10 : char_mem[10] <= 8'h00 ;
        6'd11 : char_mem[10] <= 8'h00 ;
        6'd12 : char_mem[10] <= 8'h00 ;
        6'd13 : char_mem[10] <= 8'h00 ;
        6'd14 : char_mem[10] <= 8'h00 ;
        6'd15 : char_mem[10] <= 8'h00 ;
        6'd16 : char_mem[10] <= 8'h00 ;
        6'd17 : char_mem[10] <= 8'h00 ;
        6'd18 : char_mem[10] <= 8'h00 ;
        6'd19 : char_mem[10] <= 8'h00 ;
        6'd20 : char_mem[10] <= 8'h00 ;
        6'd21 : char_mem[10] <= 8'h00 ;
        6'd22 : char_mem[10] <= 8'h00 ;
        6'd23 : char_mem[10] <= 8'h00 ;
        6'd24 : char_mem[10] <= 8'h00 ;
        6'd25 : char_mem[10] <= 8'h00 ;
        6'd26 : char_mem[10] <= 8'hC0 ;
        6'd27 : char_mem[10] <= 8'h01 ;
        6'd28 : char_mem[10] <= 8'hC0 ;
        6'd29 : char_mem[10] <= 8'h01 ;
        6'd30 : char_mem[10] <= 8'hC0 ;
        6'd31 : char_mem[10] <= 8'h01 ;
        6'd32 : char_mem[10] <= 8'hC0 ;
        6'd33 : char_mem[10] <= 8'h01 ;
        6'd34 : char_mem[10] <= 8'h00 ;
        6'd35 : char_mem[10] <= 8'h00 ;
        6'd36 : char_mem[10] <= 8'h00 ;
        6'd37 : char_mem[10] <= 8'h00 ;
        6'd38 : char_mem[10] <= 8'h00 ;
        6'd39 : char_mem[10] <= 8'h00 ;
        6'd40 : char_mem[10] <= 8'h00 ;
        6'd41 : char_mem[10] <= 8'h00 ;
        6'd42 : char_mem[10] <= 8'h00 ;
        6'd43 : char_mem[10] <= 8'h00 ;
        6'd44 : char_mem[10] <= 8'h00 ;
        6'd45 : char_mem[10] <= 8'h00 ;
        6'd46 : char_mem[10] <= 8'h00 ;
        6'd47 : char_mem[10] <= 8'h00 ;
        6'd48 : char_mem[10] <= 8'hC0 ;
        6'd49 : char_mem[10] <= 8'h01 ;
        6'd50 : char_mem[10] <= 8'hC0 ;
        6'd51 : char_mem[10] <= 8'h01 ;
        6'd52 : char_mem[10] <= 8'hC0 ;
        6'd53 : char_mem[10] <= 8'h01 ;
        6'd54 : char_mem[10] <= 8'hC0 ;
        6'd55 : char_mem[10] <= 8'h01 ;
        6'd56 : char_mem[10] <= 8'h00 ;
        6'd57 : char_mem[10] <= 8'h00 ;
        6'd58 : char_mem[10] <= 8'h00 ;
        6'd59 : char_mem[10] <= 8'h00 ;
        6'd60 : char_mem[10] <= 8'h00 ;
        6'd61 : char_mem[10] <= 8'h00 ;
        6'd62 : char_mem[10] <= 8'h00 ;
        6'd63 : char_mem[10] <= 8'h00 ;
		default: char_mem[10] <= 8'h00 ;
    endcase
end

	
endmodule
