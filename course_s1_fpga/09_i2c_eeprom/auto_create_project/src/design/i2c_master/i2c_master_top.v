module i2c_master_top
(
	input       rst,
	input       clk,
	input[15:0] clk_div_cnt,
	
	// I2C signals
	// i2c clock line
	input      			scl_pad_i,              // SCL-line input
	output     			scl_pad_o,              // SCL-line output(always 1'b0)
	output     			scl_padoen_o,           // SCL-line output enable(active low)

	// i2c data line
	input      			sda_pad_i,              // SDA-line input
	output     			sda_pad_o,              // SDA-line output (always 1'b0)
	output     			sda_padoen_o,           // SDA-line output enable (active low)
				
	input      			i2c_addr_2byte,		   	//register address 1: 2 bytes; 0: 1 byte
	input      			i2c_read_req,		   	//read request
	output     			i2c_read_req_ack,	   	//read request respond
	input      			i2c_write_req,		   	//write request
	output     			i2c_write_req_ack,	   	//write request respond
	input[7:0] 			i2c_slave_dev_addr, 	//device address
	input[15:0]			i2c_slave_reg_addr, 	//word address
	input[7:0] 			i2c_write_data,			//i2c write data
	output reg[7:0]		i2c_read_data,			//i2c read data
	output reg 			error					//if i2c not respond, assert error
);

reg 		start;					//i2c start signal
reg 		stop;               	//i2c stop signal
reg 		read;               	//read signal
reg 		write;              	//write signal
reg 		ack_in;             	//master ack, contant 1	
reg[7:0] 	txr;                	//i2c tx data 
wire[7:0] 	rxr;                	//i2c rx data
wire 		i2c_busy;            	//It was high level after start signal and low level after stop signal
wire 		i2c_al;              	//arbitrament lose(The stop signal is detected but no signal is requested.The host setting SDA is high,Actual SDA is low) 
wire 		done;					//transfer done
wire 		irxack;              	//slave receive the respond 1: nack; 0: ack

localparam S_IDLE             =  0;
localparam S_WR_DEV_ADDR      =  1;
localparam S_WR_REG_ADDR      =  2;
localparam S_WR_DATA          =  3;
localparam S_WR_ACK           =  4;
localparam S_WR_ERR_NACK      =  5;
localparam S_RD_DEV_ADDR0     =  6;
localparam S_RD_REG_ADDR      =  7;
localparam S_RD_DEV_ADDR1     =  8;
localparam S_RD_DATA          =  9;
localparam S_RD_STOP          = 10;
localparam S_WR_STOP          = 11;
localparam S_WAIT             = 12;
localparam S_WR_REG_ADDR1     = 13;
localparam S_RD_REG_ADDR1     = 14;
localparam S_RD_ACK           = 15;


reg[3:0] state,next_state;

assign i2c_read_req_ack 	= (state == S_RD_ACK);
assign i2c_write_req_ack 	= (state == S_WR_ACK);

always@(posedge clk or posedge rst)
begin
	if(rst==1)
		state <= S_IDLE;
	else
		state <= next_state;	
end
always@(*)
begin
	case(state)
		S_IDLE:
			if(i2c_write_req)					//if i2c write request, switch to write device address state
				next_state <= S_WR_DEV_ADDR;
			else if(i2c_read_req)				//if i2c read request, switch to write device address state
				next_state <= S_RD_DEV_ADDR0;
			else
				next_state <= S_IDLE;
		S_WR_DEV_ADDR:
			if(done && irxack)					//done and not ack, error
				next_state <= S_WR_ERR_NACK;
			else if(done)
				next_state <= S_WR_REG_ADDR;
			else
				next_state <= S_WR_DEV_ADDR;
		S_WR_REG_ADDR:
			if(done)
				next_state <= i2c_addr_2byte?S_WR_REG_ADDR1:S_WR_DATA;		//check if register address is 2 bytes or not
			else
				next_state <= S_WR_REG_ADDR;
		S_WR_REG_ADDR1:
			if(done)
				next_state <= S_WR_DATA;
			else
				next_state <= S_WR_REG_ADDR1;				
		S_WR_DATA:								//write data
			if(done)
				next_state <= S_WR_STOP;
			else
				next_state <= S_WR_DATA;
		S_WR_ERR_NACK:							//slave not ack
			next_state <= S_WR_STOP;
		S_RD_ACK,S_WR_ACK:						//slave ack
			next_state <= S_WAIT;
		S_WAIT:
			next_state <= S_IDLE;
		S_RD_DEV_ADDR0:
			if(done && irxack)					//done and not ack, error
				next_state <= S_WR_ERR_NACK;
			else if(done)
				next_state <= S_RD_REG_ADDR;
			else
				next_state <= S_RD_DEV_ADDR0;
		S_RD_REG_ADDR:
			if(done)
				next_state <= i2c_addr_2byte ? S_RD_REG_ADDR1 : S_RD_DEV_ADDR1;		//check if register address is 2 bytes or not
			else
				next_state <= S_RD_REG_ADDR;
		S_RD_REG_ADDR1:
			if(done)
				next_state <= S_RD_DEV_ADDR1;
			else
				next_state <= S_RD_REG_ADDR1;				
		S_RD_DEV_ADDR1:
			if(done)
				next_state <= S_RD_DATA;
			else
				next_state <= S_RD_DEV_ADDR1;	
		S_RD_DATA:
			if(done)
				next_state <= S_RD_STOP;
			else
				next_state <= S_RD_DATA;
		S_RD_STOP:
			if(done)
				next_state <= S_RD_ACK;
			else
				next_state <= S_RD_STOP;
		S_WR_STOP:
			if(done)
				next_state <= S_WR_ACK;
			else
				next_state <= S_WR_STOP;				
		default:
			next_state <= S_IDLE;
	endcase
end
//when slave not ack, then assert error signal
always@(posedge clk or posedge rst)
begin
	if(rst==1)
		error <= 1'b0;
	else if(state == S_IDLE)
		error <= 1'b0;
	else if(state == S_WR_ERR_NACK)
		error <= 1'b1;
end
//when write device address or read device address, then assert start signal
always@(posedge clk or posedge rst)
begin
	if(rst==1)
		start <= 1'b0;
	else if(done)
		start <= 1'b0;
	else if(state == S_WR_DEV_ADDR || state == S_RD_DEV_ADDR0 || state == S_RD_DEV_ADDR1)
		start <= 1'b1;
end
//when write stop or read stop, then assert stop signal
always@(posedge clk or posedge rst)
begin
	if(rst==1)
		stop <= 1'b0;
	else if(done)
		stop <= 1'b0;
	else if(state == S_WR_STOP || state == S_RD_STOP)
		stop <= 1'b1;
end
//master ack always is high
always@(posedge clk or posedge rst)
begin
	if(rst==1)
		ack_in <= 1'b0;
	else 
		ack_in <= 1'b1;
end
//write signal control
always@(posedge clk or posedge rst)
begin
	if(rst==1)
		write <= 1'b0;
	else if(done)
		write <= 1'b0;
	else if(state == S_WR_DEV_ADDR || state == S_WR_REG_ADDR || state == S_WR_REG_ADDR1|| state == S_WR_DATA || state == S_RD_DEV_ADDR0 || state == S_RD_DEV_ADDR1 || state == S_RD_REG_ADDR || state == S_RD_REG_ADDR1)
		write <= 1'b1;
end
//read signal control
always@(posedge clk or posedge rst)
begin
	if(rst==1)
		read <= 1'b0;
	else if(done)
		read <= 1'b0;
	else if(state == S_RD_DATA)
		read <= 1'b1;
end
//when in read data state and done signal asserted, then read data 
always@(posedge clk or posedge rst)
begin
	if(rst==1)
		i2c_read_data <= 8'h00;
	else if(state == S_RD_DATA && done)
		i2c_read_data <= rxr;
end
//write data control
always@(posedge clk or posedge rst)
begin
	if(rst==1)
		txr <= 8'd0;
	else 
		case(state)
			S_WR_DEV_ADDR,S_RD_DEV_ADDR0:
				txr <= {i2c_slave_dev_addr[7:1],1'b0};  	//bit0 control write or read, 0: write, 1: read
			S_RD_DEV_ADDR1:
				txr <= {i2c_slave_dev_addr[7:1],1'b1}; 
			S_WR_REG_ADDR,S_RD_REG_ADDR:
				txr <= i2c_slave_reg_addr[7:0];     		//register address, byte 0
			S_WR_REG_ADDR1,S_RD_REG_ADDR1:
				txr <= i2c_slave_reg_addr[15:8];			//register address, byte 1	
			S_WR_DATA:
				txr <= i2c_write_data;						//write data
			default:
				txr <= 8'hff;                            	//invalid                     
		endcase
end


i2c_master_byte_ctrl byte_controller (
	.clk      ( clk          ),
	.rst      ( rst          ),
	.nReset   ( 1'b1         ),     
	.ena      ( 1'b1         ),  
	.clk_cnt  ( clk_div_cnt  ),
	.start    ( start        ),
	.stop     ( stop         ),
	.read     ( read         ),
	.write    ( write        ),
	.ack_in   ( ack_in       ),
	.din      ( txr          ),
	.cmd_ack  ( done         ),
	.ack_out  ( irxack       ),
	.dout     ( rxr          ),
	.i2c_busy ( i2c_busy     ),
	.i2c_al   ( i2c_al       ),
	.scl_i    ( scl_pad_i    ),
	.scl_o    ( scl_pad_o    ),
	.scl_oen  ( scl_padoen_o ),
	.sda_i    ( sda_pad_i    ),
	.sda_o    ( sda_pad_o    ),
	.sda_oen  ( sda_padoen_o )
);
endmodule 