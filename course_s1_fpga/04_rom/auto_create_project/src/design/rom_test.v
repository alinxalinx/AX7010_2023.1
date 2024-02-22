`timescale 1ns / 1ps

module rom_test(
	input sys_clk,	//50MHz时钟
	input rst_n		//复位，低电平有效
    );

wire [7:0] rom_data;	  //ROM读出数据
reg	 [4:0] rom_addr;      //ROM输入地址 

//产生ROM地址读取数据
always @ (posedge sys_clk or negedge rst_n)
begin
    if(!rst_n)
        rom_addr <= 10'd0;
    else
        rom_addr <= rom_addr+1'b1;
end        
//实例化ROM
rom_ip rom_ip_inst
(
    .clka   (sys_clk    ),      //inoput clka
    .addra  (rom_addr   ),      //input [4:0] addra
    .douta  (rom_data   )       //output [7:0] douta
);
//实例化逻辑分析仪
ila_0 ila_m0
(
    .clk    (sys_clk),
    .probe0 (rom_addr),
	.probe1 (rom_data)
);

endmodule