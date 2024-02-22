//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
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
//2017/8/28                   1.0          Original
//*******************************************************************************/
module ad7606_sample(
	input                       adc_clk,
	input                       adc_rst_n,
	
	(* MARK_DEBUG="true" *)input[15:0]                 ad7606_data,             //ad7606 data
	(* MARK_DEBUG="true" *)input                       ad7606_busy,             //ad7606 busy
	(* MARK_DEBUG="true" *)input                       ad7606_first_data,       //ad7606 first data
	(* MARK_DEBUG="true" *)output[2:0]                 ad7606_os,               //ad7606
	(* MARK_DEBUG="true" *)output                      ad7606_cs,               //ad7606 AD cs
	(* MARK_DEBUG="true" *)output                      ad7606_rd,               //ad7606 AD data read
	output                      ad7606_reset,            //ad7606 AD reset
	(* MARK_DEBUG="true" *)output                      ad7606_convstab,         //ad7606 AD convert start
	
    input  [31:0]               sample_len,
	input                       sample_start,
	output reg                  st_clr,
	input  [7:0]                ch_sel,
	
    output [15:0]               DMA_AXIS_tdata,
    output [1:0]                DMA_AXIS_tkeep,
    output                      DMA_AXIS_tlast,
    input                       DMA_AXIS_tready,
    output                      DMA_AXIS_tvalid,
    input [0:0]                 DMA_RST_N,
	input                       DMA_CLK
);


localparam       S_IDLE    = 0;
localparam       S_SAMPLE  = 1;
localparam       S_SAMP_WAIT    = 2;


(* MARK_DEBUG="true" *)reg[31:0]         sample_cnt;
reg[7:0]          wait_cnt;
(* MARK_DEBUG="true" *)reg[2:0]          state;

(* MARK_DEBUG="true" *)reg          adc_buf_wr   ;
(* MARK_DEBUG="true" *)reg signed[15:0]   adc_buf_data ;

reg          sample_start_d0 ;
reg          sample_start_d1 ;
(* MARK_DEBUG="true" *)reg          sample_start_d2 ;
reg [31:0]   sample_len_d0 ;
reg [31:0]   sample_len_d1 ;
(* MARK_DEBUG="true" *)reg [31:0]   sample_len_d2 ;
reg [7:0]    ch_sel_d0 ;
reg [7:0]    ch_sel_d1 ;
(* MARK_DEBUG="true" *)reg [7:0]    ch_sel_d2 ;

reg [31:0]   dma_len_d0 ;
reg [31:0]   dma_len_d1 ;
reg [31:0]   dma_len_d2 ;
reg [31:0]   dma_len ;
reg [31:0]   dma_cnt ;

reg         tvalid_en ;
wire[9:0]   rd_data_count ;
wire        adc_buf_rd  ;
reg         adc_buf_rd_d0 ;
wire        empty;

(* MARK_DEBUG="true" *)reg          adc_buf_en ;
(* MARK_DEBUG="true" *)reg [3:0]    write_cnt  ; 


(* MARK_DEBUG="true" *)wire                            ad_data_valid;
wire signed[15:0]               ad_ch1;
wire signed[15:0]               ad_ch2;
wire signed[15:0]               ad_ch3;
wire signed[15:0]               ad_ch4;
wire signed[15:0]               ad_ch5;
wire signed[15:0]               ad_ch6;
wire signed[15:0]               ad_ch7;
wire signed[15:0]               ad_ch8;


always@(posedge adc_clk or negedge adc_rst_n)
begin
	if(adc_rst_n == 1'b0)
	begin
		sample_start_d0 <= 1'b0;
		sample_start_d1 <= 1'b0;
		sample_start_d2 <= 1'b0;
		sample_len_d0   <= 32'd0 ;
		sample_len_d1   <= 32'd0 ;
		sample_len_d2   <= 32'd0 ;
		ch_sel_d0       <= 8'd0 ;
		ch_sel_d1       <= 8'd0 ;
		ch_sel_d2       <= 8'd0 ;
	end	
	else 
	begin
         sample_start_d0 <= sample_start;
         sample_start_d1 <= sample_start_d0;
         sample_start_d2 <= sample_start_d1;
         sample_len_d0   <= sample_len ;
         sample_len_d1   <= sample_len_d0 ;
         sample_len_d2   <= sample_len_d1 ;
         ch_sel_d0       <= ch_sel ;
         ch_sel_d1       <= ch_sel_d0 ;
         ch_sel_d2       <= ch_sel_d1 ;
     end    
end






always@(posedge adc_clk or negedge adc_rst_n)
begin
	if(adc_rst_n == 1'b0)
	begin
		state <= S_IDLE;
		wait_cnt <= 8'd0;
		sample_cnt <= 32'd0;
	end
	else
		case(state)
			S_IDLE:
			begin
			  if (sample_start_d2)
			  begin
				state  <= S_SAMP_WAIT ;
				st_clr <= 1'b1 ;
			  end		    
			end
			S_SAMP_WAIT :
			begin
			  if(wait_cnt == 8'd20)
			  begin
				state    <= S_SAMPLE;
				wait_cnt <= 8'd0;
			  end
			  else
			  begin
			  	wait_cnt <= wait_cnt + 8'd1;
			  end
			  st_clr <= 1'b0 ;
			end
			S_SAMPLE:
			begin
			  if (ad_data_valid)
			  begin
				if(sample_cnt == sample_len_d2 - 1)
				begin
					sample_cnt <= 32'd0;
					state <= S_IDLE;
				end
				else
				begin
					sample_cnt <= sample_cnt + 32'd1;
				end
			  end				
			end		
			default:
				state <= S_IDLE;
		endcase
end


always@(posedge adc_clk or negedge adc_rst_n)
begin
	if(adc_rst_n == 1'b0)
	   adc_buf_en <= 1'b0 ;
	else if (state == S_SAMPLE && ad_data_valid)
	   adc_buf_en <= 1'b1 ;
	else if (write_cnt == 4'd7) 
	   adc_buf_en <= 1'b0 ;
end

always@(posedge adc_clk or negedge adc_rst_n)
begin
	if(adc_rst_n == 1'b0)
	   write_cnt <= 4'd0 ;
	else if (adc_buf_en)
	   write_cnt <= write_cnt + 1'b1 ;
	else
	   write_cnt <= 4'd0 ;
end

always@(posedge adc_clk or negedge adc_rst_n)
begin
	if(adc_rst_n == 1'b0)
	begin
      adc_buf_data <= 16'd0 ;
	end
	else
	begin
	  case(write_cnt)
	    4'd0   :  adc_buf_data <= ad_ch1 ;
	    4'd1   :  adc_buf_data <= ad_ch2 ;
	    4'd2   :  adc_buf_data <= ad_ch3 ;
	    4'd3   :  adc_buf_data <= ad_ch4 ;
	    4'd4   :  adc_buf_data <= ad_ch5 ;
	    4'd5   :  adc_buf_data <= ad_ch6 ;
	    4'd6   :  adc_buf_data <= ad_ch7 ;
	    4'd7   :  adc_buf_data <= ad_ch8 ;
	    default :  adc_buf_data <= ad_ch1 ;
	  endcase
	end
end

always@(posedge adc_clk or negedge adc_rst_n)
begin
	if(adc_rst_n == 1'b0)
	   adc_buf_wr <= 1'b0 ;
	else
	   adc_buf_wr <= adc_buf_en ;
end

afifo afifo_inst
(
  .rst                (~DMA_RST_N),
  .wr_clk             (adc_clk   ),
  .rd_clk             (DMA_CLK   ),
  .din                (adc_buf_data   ),
  .wr_en              (adc_buf_wr     ),
  .rd_en              (adc_buf_rd     ),
  .dout               (DMA_AXIS_tdata      ),
  .full               (          ), 
  .empty              (empty         ),
  .rd_data_count      (rd_data_count  ),
  .wr_data_count      (          ) 

) ;

ad7606_if ad7606_if_m0(
	.clk                   (adc_clk                    ),
	.rst_n                 (adc_rst_n                  ),
	.ad_data               (ad7606_data                ), //ad7606 data
	.ad_busy               (ad7606_busy                ), //ad7606 busy
	.first_data            (ad7606_first_data          ), //ad7606 first data
	.ad_os                 (ad7606_os                  ), //ad7606
	.ad_cs                 (ad7606_cs                  ), //ad7606 AD cs
	.ad_rd                 (ad7606_rd                  ), //ad7606 AD data read
	.ad_reset              (ad7606_reset               ), //ad7606 AD reset
	.ad_convstab           (ad7606_convstab            ), //ad7606 AD convert start
	.ad_data_valid         (ad_data_valid              ),
	.ad_ch1                (ad_ch1                     ),
	.ad_ch2                (ad_ch2                     ),
	.ad_ch3                (ad_ch3                     ),
	.ad_ch4                (ad_ch4                     ),
	.ad_ch5                (ad_ch5                     ),
	.ad_ch6                (ad_ch6                     ),
	.ad_ch7                (ad_ch7                     ),
	.ad_ch8                (ad_ch8                     )
);


assign adc_buf_rd = DMA_AXIS_tready && ~empty ;

always@(posedge DMA_CLK or negedge DMA_RST_N)
begin
	if(DMA_RST_N == 1'b0)
		adc_buf_rd_d0 <= 1'b0;
	else 
	    adc_buf_rd_d0 <= adc_buf_rd ;
end

always@(posedge DMA_CLK or negedge DMA_RST_N)
begin
	if(DMA_RST_N == 1'b0)
		tvalid_en <= 1'b0;
	else if (adc_buf_rd_d0 & ~DMA_AXIS_tready)
	    tvalid_en <= 1'b1 ;
	else if (DMA_AXIS_tready)
	    tvalid_en <= 1'b0;
end

always@(posedge DMA_CLK or negedge DMA_RST_N)
begin
	if(DMA_RST_N == 1'b0)
	begin
		dma_len_d0   <= 32'd0 ;
		dma_len_d1   <= 32'd0 ;
		dma_len_d2   <= 32'd0 ;
	end	
	else 
	begin
         dma_len_d0   <= sample_len ;
         dma_len_d1   <= dma_len_d0 ;
         dma_len_d2   <= dma_len_d1 ;
     end    
end


always@(posedge DMA_CLK or negedge DMA_RST_N)
begin
	if(DMA_RST_N == 1'b0)
		dma_len <= 32'd0;
	else if (rd_data_count > 10'd0)
	    dma_len <= dma_len_d2 ;
end

always@(posedge DMA_CLK or negedge DMA_RST_N)
begin
	if(DMA_RST_N == 1'b0)
		dma_cnt <= 32'd0;
	else if (DMA_AXIS_tvalid & ~DMA_AXIS_tlast)
	    dma_cnt <= dma_cnt + 1'b1 ;
	else if (DMA_AXIS_tvalid & DMA_AXIS_tlast)
	    dma_cnt <= 32'd0 ;
end


assign DMA_AXIS_tvalid =  DMA_AXIS_tready & (tvalid_en | adc_buf_rd_d0)  ;
assign DMA_AXIS_tkeep  = 2'b11 ;
assign DMA_AXIS_tlast  = DMA_AXIS_tvalid & (dma_cnt == 8*dma_len - 1) ;

endmodule