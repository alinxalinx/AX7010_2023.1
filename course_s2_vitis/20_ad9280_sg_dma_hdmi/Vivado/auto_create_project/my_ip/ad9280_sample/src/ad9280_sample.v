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
	
	input  [31:0]               sample_len,        //sample length
	input                       sample_start,      //sample start 
	output reg                  start_clr,         //clear start register
	input                       start_clr_ack ,    //ack
	//axis interface
    output [7:0]                M_AXIS_tdata,
    output [0:0]                M_AXIS_tkeep,
    output                      M_AXIS_tlast,
    input                       M_AXIS_tready,
    output                      M_AXIS_tvalid,
    input [0:0]                 M_AXIS_RSTN,
	input                       M_AXIS_CLK
);


localparam       S_IDLE      = 0;
localparam       S_SAMP_WAIT = 1;
localparam       S_SAMPLE    = 2;
reg [2:0]        state;

reg [31:0]      sample_cnt;    //sample counter
reg [31:0]      wait_cnt;      //used for debug

reg             adc_buf_wr ;    //fifo write enable
reg [7:0]       adc_buf_data ;  //fifo write data
wire            adc_buf_rd  ;   //fifo read enable
reg             adc_buf_rd_d0 ; 
wire            empty;          //fifo empty
                
reg             sample_start_d0 ;
reg             sample_start_d1 ;
reg             sample_start_d2 ;
reg [31:0]      sample_len_d0 ;
reg [31:0]      sample_len_d1 ;
reg [31:0]      sample_len_d2 ;
reg             start_clr_ack_d0 ;
reg             start_clr_ack_d1 ;
reg             start_clr_ack_d2 ;
                
reg [31:0]      dma_len_d0 ;
reg [31:0]      dma_len_d1 ;
reg [31:0]      dma_len_d2 ;
reg [31:0]      dma_cnt ;      //dma counter
                
reg             tvalid_en ;    //tvalid enable signal




/* Async data to sync clock domain */
always@(posedge adc_clk or negedge adc_rst_n)
begin
	if(adc_rst_n == 1'b0)
	begin
		sample_start_d0    <= 1'b0;
		sample_start_d1    <= 1'b0;
		sample_start_d2    <= 1'b0;
		sample_len_d0      <= 32'd0 ;
		sample_len_d1      <= 32'd0 ;
		sample_len_d2      <= 32'd0 ;
		start_clr_ack_d0   <= 1'b0 ;
		start_clr_ack_d1   <= 1'b0 ;		
		start_clr_ack_d2   <= 1'b0 ;
	end	
	else 
	begin
         sample_start_d0    <= sample_start;
         sample_start_d1    <= sample_start_d0;
         sample_start_d2    <= sample_start_d1;
         sample_len_d0      <= sample_len ;
         sample_len_d1      <= sample_len_d0 ;
         sample_len_d2      <= sample_len_d1 ;
		 start_clr_ack_d0   <= start_clr_ack ;
         start_clr_ack_d1   <= start_clr_ack_d0 ;        
         start_clr_ack_d2   <= start_clr_ack_d1 ;
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
		start_clr    <= 1'b0 ;
	end
	else
		case(state)
			S_IDLE:
			begin
			  if (sample_start_d2)
			  begin
				state  <= S_SAMP_WAIT ;
				start_clr <= 1'b1 ;          //clear start register
			  end		    
			end
			S_SAMP_WAIT :
			begin
			  if(start_clr_ack_d2)              //wait ack signal assert
			  begin
				state     <= S_SAMPLE;
				wait_cnt  <= 32'd0;
				start_clr <= 1'b0 ;
			  end
			  else
			  begin
			  	wait_cnt <= wait_cnt + 32'd1;
			  end			  
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


/*
* Instantiate async fifo by using Xilinx parameterized Macros. For ultrasclae, refer to ug974, for 7 series ug953
* write and read depth is 1024, write and read data width is 8 
*/
xpm_fifo_async #(
   .CDC_SYNC_STAGES      (2),        
   .DOUT_RESET_VALUE     ("1"),      
   .ECC_MODE             ("no_ecc"), 
   .FIFO_MEMORY_TYPE     ("auto"),   
   .FIFO_READ_LATENCY    (1),        
   .FIFO_WRITE_DEPTH     (1024),     
   .FULL_RESET_VALUE     (0),        
   .PROG_EMPTY_THRESH    (10),       
   .PROG_FULL_THRESH     (10),       
   .RD_DATA_COUNT_WIDTH  (11),       
   .READ_DATA_WIDTH      (8),        
   .READ_MODE            ("std"),    
   .RELATED_CLOCKS       (0),        
   .USE_ADV_FEATURES     ("0707"),   
   .WAKEUP_TIME          (0),        
   .WRITE_DATA_WIDTH     (8),        
   .WR_DATA_COUNT_WIDTH  (11)        
)
xpm_fifo_async_inst (
   .rst            (~adc_rst_n),
   .wr_clk         (adc_clk),
   .wr_en          (adc_buf_wr),
   .din            (adc_buf_data),
   .rd_clk         (M_AXIS_CLK),
   .rd_en          (adc_buf_rd),
   .dout           (M_AXIS_tdata),
   .empty          (empty),
   .full           (),
   .almost_empty   (),
   .almost_full    (),
   .wr_data_count  (),
   .rd_data_count  (),    
   .prog_empty     (),
   .prog_full      (),    
   .data_valid     (),
   .dbiterr        (),
   .sbiterr        (),
   .overflow       (),
   .underflow      (),
   .wr_ack         (),   
   .wr_rst_busy    (),   
   .rd_rst_busy    (),
   .injectdbiterr  (1'b0),
   .injectsbiterr  (1'b0),   
   .sleep          (1'b0)   
   );


/* When axis slave interface ready and fifo is not empty, read fifo data */
assign adc_buf_rd = M_AXIS_tready && ~empty ;

always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN)
begin
	if(M_AXIS_RSTN == 1'b0)
		adc_buf_rd_d0 <= 1'b0;
	else 
	    adc_buf_rd_d0 <= adc_buf_rd ;
end
/* fifo data is one clock cycle later than read enable, 
When read signal and axis ready signal valid at the same time, 
enable fifo read data */
always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN)
begin
	if(M_AXIS_RSTN == 1'b0)
		tvalid_en <= 1'b0;
	else if (adc_buf_rd_d0 & ~M_AXIS_tready)
	    tvalid_en <= 1'b1 ;
	else if (M_AXIS_tready)
	    tvalid_en <= 1'b0;
end
/* Async data to sync clock domain */
always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN)
begin
	if(M_AXIS_RSTN == 1'b0)
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

/* axis interface data counter */
always@(posedge M_AXIS_CLK or negedge M_AXIS_RSTN)
begin
	if(M_AXIS_RSTN == 1'b0)
		dma_cnt <= 32'd0;
	else if (M_AXIS_tvalid & ~M_AXIS_tlast)
	    dma_cnt <= dma_cnt + 1'b1 ;
	else if (M_AXIS_tvalid & M_AXIS_tlast)
	    dma_cnt <= 32'd0 ;
end


assign M_AXIS_tvalid =  M_AXIS_tready & (tvalid_en | adc_buf_rd_d0)  ;
assign M_AXIS_tkeep  = 1'b1 ;
assign M_AXIS_tlast  = M_AXIS_tvalid & (dma_cnt == dma_len_d2 - 1) ;

endmodule