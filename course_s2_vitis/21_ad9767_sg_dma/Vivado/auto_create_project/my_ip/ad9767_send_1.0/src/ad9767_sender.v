`timescale 1 ns/1 ns
module ad9767_sender(
    input                       dac_clk,
    input                       dac_rst_n,
    output reg [13:0]           dac_data,
	input                       send_start,    // send start signal, start to send data to DAC
    //axis interface
    input [15:0]                S_AXIS_tdata,
    input [1:0]                 S_AXIS_tkeep,
    input                       S_AXIS_tlast,
    output                      S_AXIS_tready,
    input                       S_AXIS_tvalid,
    input [0:0]                 S_AXIS_RSTN,
	input                       S_AXIS_CLK
);

wire         almost_full ;   //almost full signal, when asset, there is only one data can be written into FIFO.
wire         empty ;         //fifo empty signal
wire [10:0]   rd_data_count ; //data count can be read out of fifo

reg  [31:0]  send_cnt ;   //send counter for debug

reg          send_start_d0 ;
reg          send_start_d1 ;
reg          send_start_d2 ;

wire         dac_buf_rd ;     //fifo read enable
wire [15:0]  dac_buf_data ;   //fifo read data
reg          fifo_wr_en   ;   //fifo write enable
reg [15:0]   fifo_wr_data ;   //fifo write data


localparam       S_IDLE      = 0;
localparam       S_SEND      = 1;
reg [1:0]      state ;

/* When almost_full is not valid, S_AXIS_tready valid */
assign  S_AXIS_tready = ~almost_full ;
/* When in send state and fifo not empty, read valid */
assign  dac_buf_rd = (state == S_SEND)  & ~empty ;

/* Asynchronous data register for clock domain crossing */
always@(posedge dac_clk or negedge dac_rst_n)
begin
	if(dac_rst_n == 1'b0)
	begin
		send_start_d0 <= 1'b0;
		send_start_d1 <= 1'b0;
		send_start_d2 <= 1'b0;
	end	
	else 
	begin
         send_start_d0 <= send_start;
         send_start_d1 <= send_start_d0;
         send_start_d2 <= send_start_d1;
     end    
end


always@(posedge dac_clk or negedge dac_rst_n)
begin
	if(dac_rst_n == 1'b0)
	begin
		state        <= S_IDLE;
		send_cnt     <= 32'd0;
	end
	else
		case(state)
			S_IDLE:
			begin
			  if (send_start_d2 && rd_data_count > 11'd256)  /* When there are some data in fifo, start to read fifo data for DAC  */
			  begin
				state  <= S_SEND ;
			  end		    
			end
			/* always in send state */
			S_SEND :
            begin
                  send_cnt <= send_cnt + 32'd1;     	
            end
			default:
				state <= S_IDLE;
		endcase
end

/* dac data from fifo, use lower 14 bits */
always@(posedge dac_clk or negedge dac_rst_n)
begin
	if(dac_rst_n == 1'b0)
	begin
        dac_data <= 14'd0 ;
    end
    else if (state == S_SEND)
    begin
        dac_data <= dac_buf_data[13:0] ;
    end
end

/* When S_AXIS_tready and S_AXIS_tvalid both valid, write data from  AXI4-Stream to fifo*/
always@(posedge S_AXIS_CLK or negedge S_AXIS_RSTN)
begin
	if(S_AXIS_RSTN == 1'b0)
	begin
	  fifo_wr_en   <= 1'b0 ;
	  fifo_wr_data <= 16'd0 ;
	end
	else if (S_AXIS_tready & S_AXIS_tvalid)
	begin
	  fifo_wr_en   <= 1'b1 ;
      fifo_wr_data <= S_AXIS_tdata ;
	end
	else
	begin
	  fifo_wr_en   <= 1'b0 ;
	end
end

/*
* Instantiate async fifo by using Xilinx parameterized Macros. For ultrasclae, refer to ug974, for 7 series ug953
* write and read depth is 1024, write and read data width is 16 
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
   .READ_DATA_WIDTH      (16),        
   .READ_MODE            ("std"),    
   .RELATED_CLOCKS       (0),        
   .USE_ADV_FEATURES     ("070F"),   
   .WAKEUP_TIME          (0),        
   .WRITE_DATA_WIDTH     (16),        
   .WR_DATA_COUNT_WIDTH  (11)        
)
xpm_fifo_async_inst (
   .rst            (~S_AXIS_RSTN),
   .wr_clk         (S_AXIS_CLK),
   .wr_en          (fifo_wr_en),
   .din            (fifo_wr_data),
   .rd_clk         (dac_clk),
   .rd_en          (dac_buf_rd),
   .dout           (dac_buf_data),
   .empty          (empty),
   .full           (),
   .almost_empty   (),
   .almost_full    (almost_full),
   .wr_data_count  (),
   .rd_data_count  (rd_data_count),    
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

endmodule