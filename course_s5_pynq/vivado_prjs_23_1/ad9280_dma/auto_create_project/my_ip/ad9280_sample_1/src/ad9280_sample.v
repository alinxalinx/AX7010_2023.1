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
module ad9280_sample(
    input                       adc_clk,
    input                       adc_rst_n,
	input[7:0]                  adc_data,
	input                       adc_data_valid,
	
	input  [31:0]               sample_len,
	input                       sample_start,
	output reg                  st_clr,
	
    output [7:0]                DMA_AXIS_tdata,
    output [0:0]                DMA_AXIS_tkeep,
    output                      DMA_AXIS_tlast,
    input                       DMA_AXIS_tready,
    output                      DMA_AXIS_tvalid,
    input [0:0]                 DMA_RST_N,
	input                       DMA_CLK
);


localparam       S_IDLE      = 0;
localparam       S_SAMP_WAIT = 1;
localparam       S_SAMPLE    = 2;


reg[31:0]   sample_cnt;
reg  [31:0] wait_cnt;
reg [2:0]   state;
reg         adc_buf_wr ;
reg [7:0]   adc_buf_data ;
wire[9:0]   rd_data_count ;
wire        adc_buf_rd  ;
reg         adc_buf_rd_d0 ;
wire        empty;

reg  sample_start_d0 ;
reg  sample_start_d1 ;
reg [31:0]   sample_len_d0 ;
reg [31:0]   sample_len_d1 ;
reg [31:0]   sample_len_d2 ;

reg [31:0]   dma_len_d0 ;
reg [31:0]   dma_len_d1 ;
reg [31:0]   dma_len_d2 ;
reg [31:0]   dma_len ;
reg [31:0]   dma_cnt ;

reg  tvalid_en ;

reg  sample_start_d2 ;



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
	end	
	else 
	begin
         sample_start_d0 <= sample_start;
         sample_start_d1 <= sample_start_d0;
         sample_start_d2 <= sample_start_d1;
         sample_len_d0   <= sample_len ;
         sample_len_d1   <= sample_len_d0 ;
         sample_len_d2   <= sample_len_d1 ;
     end    
end

always@(posedge adc_clk or negedge adc_rst_n)
begin
	if(adc_rst_n == 1'b0)
	begin
		state        <= S_IDLE;
		wait_cnt     <= 32'd0;
		sample_cnt   <= 32'd0;
		adc_buf_data <= 8'd0 ;
		adc_buf_wr   <= 1'b0 ;
		st_clr       <= 1'b0 ;
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
			  if(wait_cnt == 32'd20)
			  begin
				state    <= S_SAMPLE;
				wait_cnt <= 32'd0;
			  end
			  else
			  begin
			  	wait_cnt <= wait_cnt + 32'd1;
			  end
			  st_clr <= 1'b0 ;
			end
			S_SAMPLE:
			begin
				if(adc_data_valid == 1'b1)
				begin
					if(sample_cnt == sample_len_d2)
					begin
						sample_cnt <= 32'd0;
						adc_buf_wr  <= 1'b0 ;
						state <= S_IDLE;
					end
					else
					begin
					    adc_buf_data <= adc_data ; 
					    adc_buf_wr  <= 1'b1 ;
						sample_cnt <= sample_cnt + 32'd1;
					end
				end
			end		
			default:
				state <= S_IDLE;
		endcase
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
assign DMA_AXIS_tkeep  = 1'b1 ;
assign DMA_AXIS_tlast  = DMA_AXIS_tvalid & (dma_cnt == dma_len - 1) ;

endmodule