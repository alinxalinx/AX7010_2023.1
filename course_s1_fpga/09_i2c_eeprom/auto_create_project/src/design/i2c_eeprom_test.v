//*************************************************************************\
//Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd,All rights reserved
//
//                   File Name  :  i2c_eeprom_test.v
//                Project Name  :  
//                      Author  : lhj 
//                       Email  :  
//                     Company  :  ALINX(shanghai) Technology Co.,Ltd
//                         WEB  :  http://www.alinx.cn/
//==========================================================================
//   Description:   
//
//   
//==========================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------
//  2018/01/04    lhj         1.0         Original
//*************************************************************************/
module i2c_eeprom_test(
    input            sys_clk,       //system clock 50Mhz on board
    input            rst_n,         //reset ,low active
    input            key,			//data will add 1 when push key
    inout            i2c_sda,		
    inout            i2c_scl,
    output [3:0]     led

);
localparam S_IDLE       = 0;
localparam S_READ       = 1;
localparam S_WAIT       = 2;
localparam S_WRITE      = 3;
reg[3:0] state;

wire button_negedge;
reg[7:0] read_data;
reg[31:0] timer;

wire scl_pad_i;
wire scl_pad_o;
wire scl_padoen_o;

wire sda_pad_i;
wire sda_pad_o;
wire sda_padoen_o;

reg[ 7:0] 	i2c_slave_dev_addr;
reg[15:0] 	i2c_slave_reg_addr;

reg 		i2c_write_req;
wire 		i2c_write_req_ack;
reg[ 7:0] 	i2c_write_data;

reg 		i2c_read_req;
wire 		i2c_read_req_ack;
wire[7:0] 	i2c_read_data;

assign led = ~read_data[3:0];

ax_debounce ax_debounce_m0
(
    .clk             (sys_clk),
    .rst             (~rst_n),
    .button_in       (key),
    .button_posedge  (),
    .button_negedge  (button_negedge),
    .button_out      ()
);
 
always@(posedge sys_clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
    begin
        state 				<= S_IDLE;
        i2c_write_req 		<= 1'b0;
        read_data 			<= 8'h00;
        timer 				<= 32'd0;
        i2c_write_data 		<= 8'd0;
        i2c_slave_reg_addr 	<= 16'd0;
        i2c_slave_dev_addr 	<= 8'ha0;//1010 000 0, device address
        i2c_read_req 		<= 1'b0;
    end
    else
        case(state)
            S_IDLE:
            begin
                if(timer >= 32'd499_999)//wait 10ms
                    state <= S_READ;
                else
                    timer <= timer + 32'd1;
            end
            S_READ:
            begin
                if(i2c_read_req_ack)			//if read request ack, then i2c read data valid
                begin
                    i2c_read_req <= 1'b0;
                    read_data	 <= i2c_read_data;
                    state 		 <= S_WAIT;
                end
                else
                begin
                    i2c_read_req 		<= 1'b1;
                    i2c_slave_dev_addr 	<= 8'ha0;
                    i2c_slave_reg_addr 	<= 16'd0;
                end
            end
            S_WAIT:
            begin
                if(button_negedge)			//when push button, then data add 1, and switch to write state
                begin
                    state 		<= S_WRITE;
                    read_data 	<= read_data + 8'd1;
                end
            end
            S_WRITE:
            begin
                if(i2c_write_req_ack)		//if write request ack, then switch to read state
                begin
                    i2c_write_req 	<= 1'b0;
                    state 			<= S_READ;
                end
                else
                begin
                    i2c_write_req 	<= 1'b1;
                    i2c_write_data 	<= read_data;
                end
            end
            
            default:
                state <= S_IDLE;
        endcase
end
//i2c bidirection control
assign sda_pad_i = i2c_sda;
assign i2c_sda = ~sda_padoen_o ? sda_pad_o : 1'bz;

assign scl_pad_i = i2c_scl;
assign i2c_scl = ~scl_padoen_o ? scl_pad_o : 1'bz;

i2c_master_top i2c_master_top_m0
(
    .rst					(~rst_n),
    .clk					(sys_clk),
    .clk_div_cnt			(16'd99),       	//Standard mode:100Khz; prescale = 50MHz/(5*100Khz) - 1
    
    // I2C signals 
    // i2c clock line
    .scl_pad_i				(scl_pad_i),        // SCL-line input
    .scl_pad_o				(scl_pad_o),        // SCL-line output (always 1'b0)
    .scl_padoen_o			(scl_padoen_o),     // SCL-line output enable (active low)

    // i2c data line
    .sda_pad_i				(sda_pad_i),        // SDA-line input
    .sda_pad_o				(sda_pad_o),        // SDA-line output (always 1'b0)
    .sda_padoen_o			(sda_padoen_o),     // SDA-line output enable (active low)
    
    
    .i2c_addr_2byte			(1'b0),   			//register address is 1 byte
    .i2c_read_req			(i2c_read_req),
    .i2c_read_req_ack		(i2c_read_req_ack),
    .i2c_write_req			(i2c_write_req),
    .i2c_write_req_ack		(i2c_write_req_ack),
    .i2c_slave_dev_addr		(i2c_slave_dev_addr),
    .i2c_slave_reg_addr		(i2c_slave_reg_addr),
    .i2c_write_data			(i2c_write_data),
    .i2c_read_data			(i2c_read_data),
    .error					()
);
ila_0 ila_m0 (
	.clk		(sys_clk), 	// input wire clk
	.probe0		(read_data) // input wire [7:0] probe0
);
endmodule 