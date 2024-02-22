`timescale 1ps/1ps
module cmos_in_axi4s_formatter (
  // System signals
  input  wire VID_IN_CLK,           // Native video clock 


  // Video input signals
  input  wire VID_ACTIVE_VIDEO,     // Native video input data enable
  input  wire VID_VBLANK,           // Native video input vertical blank
  input  wire VID_HBLANK,           // Native video input horizontal blank
  input  wire VID_VSYNC,            // Native video input vertical sync
  input  wire VID_HSYNC,            // Native video input horizontal sync
  input  wire [PIXELS_WIDTH - 1:0] VID_DATA, // Native video input data 
  
  // Video timing detector signals
  output wire VTD_ACTIVE_VIDEO,     // Native video output data enable
  output wire VTD_VBLANK,           // Native video output vertical blank
  output wire VTD_HBLANK,           // Native video output horizontal blank
  output wire VTD_VSYNC,            // Native video output vertical sync
  output wire VTD_HSYNC,            // Native video output horizontal sync
 
  // FIFO write signals
  output wire [PIXELS_WIDTH + 2 - 1 :0] FIFO_WR_DATA, // FIFO write data
  output wire FIFO_WR_EN            // FIFO write enable
);
localparam PIXELS_WIDTH	 = 16;
  // Wire and register declarations
  reg  de_1 = 0;         
  reg  vblank_1 = 0;
  reg  hblank_1 = 0;
  reg  hblank_2 = 0;
  reg  vsync_1 = 0;  
  reg  hsync_1 = 0;
  reg  [PIXELS_WIDTH - 1:0] data_1 = 0;  
  reg  de_2 = 0;  
  reg  v_blank_sync_2 = 0;  
  reg  [PIXELS_WIDTH - 1:0] data_2 = 0;  
  reg  de_3 = 0;  // DE output register
  reg  [PIXELS_WIDTH - 1:0] data_3 = 0;  // data output register
  reg  vert_blanking_intvl = 0; // SR, reset by DE rising

 
  wire v_blank_sync_1;  // vblank or vsync
  wire de_rising;                   
  wire de_falling;      
  wire vsync_rising;
  reg  sof;
  reg  sof_1;
  reg  eol;   
  reg  vtd_locked;
  wire sof_rising;
  wire hblank_falling;

  // Assignments
  assign FIFO_WR_DATA     = {sof_1,eol,data_3};
  assign FIFO_WR_EN       = de_3  & vtd_locked;
  assign VTD_ACTIVE_VIDEO = de_1;
  assign VTD_VBLANK       = vblank_1;
  assign VTD_HBLANK       = hblank_1;
  assign VTD_VSYNC        = vsync_1;
  assign VTD_HSYNC        = hsync_1;


  assign v_blank_sync_1 = vblank_1 || vsync_1;
  assign de_rising  = de_1  && !de_2;  
  assign de_falling = !de_1 && de_2;  
  assign vsync_rising = v_blank_sync_1 && !v_blank_sync_2;    
  assign sof_rising = sof & ~sof_1;
  assign hblank_falling = !hblank_1 && hblank_2;

  // VTD locked process
  always @(posedge VID_IN_CLK) begin
      vtd_locked <= (sof_rising) ? 1'b1 : vtd_locked;
  end
  
  // input, output, and delay registers
  always @ (posedge VID_IN_CLK) begin
      de_1           <= VID_ACTIVE_VIDEO;
      de_2           <= de_1;    
      de_3           <= de_2;    
      vblank_1       <= VID_VBLANK;
      hblank_1       <= VID_HBLANK;
      vsync_1        <= VID_VSYNC;
      hsync_1        <= VID_HSYNC;
      data_1         <= VID_DATA; 
      data_2         <= data_1;
      data_3         <= data_2;
      v_blank_sync_2 <= v_blank_sync_1; 
      //eol            <= de_falling;
	  eol            <= hblank_falling;
      sof            <= de_rising && vert_blanking_intvl;
      sof_1          <= sof;
	  hblank_2       <= hblank_1;    
  end 
  
  // Vertical back porch SR register
  always @ (posedge VID_IN_CLK) begin
      if (vsync_rising)   // falling edge of vsync
        vert_blanking_intvl <= 1;
      else if (de_rising)        // rising edge of data enable
        vert_blanking_intvl <= 0;
    end
endmodule


