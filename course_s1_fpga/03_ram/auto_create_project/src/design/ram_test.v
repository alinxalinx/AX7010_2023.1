`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module ram_test(
			input clk,		          	//50MHz时钟
			input rst_n	             	//复位信号，低电平有效	
		);

//-----------------------------------------------------------
reg		[8:0]  		w_addr;	   		//RAM PORTA写地址
reg		[15:0] 		w_data;	   		//RAM PORTA写数据
reg 	      		wea;	    	//RAM PORTA使能
reg		[8:0]  		r_addr;	  	 	//RAM PORTB读地址
wire	[15:0] 		r_data;			//RAM PORTB读数据

//产生RAM PORTB读地址
always @(posedge clk or negedge rst_n)
begin
  if(!rst_n) 
	r_addr <= 9'd0;
  else if (|w_addr)			//w_addr位或，不等于0
    r_addr <= r_addr+1'b1;
  else
	r_addr <= 9'd0;	
end

//产生RAM PORTA写使能信号
always@(posedge clk or negedge rst_n)
begin	
  if(!rst_n) 
  	  wea <= 1'b0;
  else 
  begin
     if(&w_addr) 			//w_addr的bit位全为1，共写入512个数据，写入完成
        wea <= 1'b0;                 
     else               
        wea	<= 1'b1;        //ram写使能
  end 
end 

//产生RAM PORTA写入的地址及数据
always@(posedge clk or negedge rst_n)
begin	
  if(!rst_n) 
  begin
	  w_addr <= 9'd0;
	  w_data <= 16'd1;
  end
  else 
  begin
     if(wea) 					//ram写使能有效
	 begin        
		if (&w_addr)			//w_addr的bit位全为1，共写入512个数据，写入完成
		begin
			w_addr <= w_addr ;	//将地址和数据的值保持住，只写一次RAM
			w_data <= w_data ;
		end
		else
		begin
			w_addr <= w_addr + 1'b1;
			w_data <= w_data + 1'b1;
		end
	 end
  end 
end 

//-----------------------------------------------------------
//实例化RAM	
ram_ip ram_ip_inst (
  .clka      (clk          ),     // input clka
  .wea       (wea          ),     // input [0 : 0] wea
  .addra     (w_addr       ),     // input [8 : 0] addra
  .dina      (w_data       ),     // input [15 : 0] dina
  .clkb      (clk          ),     // input clkb
  .addrb     (r_addr       ),     // input [8 : 0] addrb
  .doutb     (r_data       )      // output [15 : 0] doutb
);

//实例化ila逻辑分析仪
ila_0 ila_0_inst (
	.clk	(clk	), 
	.probe0	(r_data	), 
	.probe1	(r_addr	) 
);

	
endmodule
