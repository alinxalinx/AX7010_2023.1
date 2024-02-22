############## clock and reset define##################
create_clock -period 20.000 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property PACKAGE_PIN U18 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN N15 [get_ports rst_n]
############## AX7020/AX7010 J11##################
set_property IOSTANDARD LVCMOS33 [get_ports rs485_rx1]
set_property PACKAGE_PIN F20 [get_ports rs485_rx1]
set_property IOSTANDARD LVCMOS33 [get_ports rs485_tx1]
set_property PACKAGE_PIN G20 [get_ports rs485_tx1]
set_property IOSTANDARD LVCMOS33 [get_ports rs485_de1]
set_property PACKAGE_PIN F19 [get_ports rs485_de1]

set_property IOSTANDARD LVCMOS33 [get_ports rs485_rx2]
set_property PACKAGE_PIN L20 [get_ports rs485_rx2]
set_property IOSTANDARD LVCMOS33 [get_ports rs485_tx2]
set_property PACKAGE_PIN M20 [get_ports rs485_tx2]
set_property IOSTANDARD LVCMOS33 [get_ports rs485_de2]
set_property PACKAGE_PIN L19 [get_ports rs485_de2]

