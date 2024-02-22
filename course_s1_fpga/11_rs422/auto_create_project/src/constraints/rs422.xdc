############## clock and reset define##################
create_clock -period 20 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_clk}]
set_property PACKAGE_PIN U18 [get_ports {sys_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]
set_property PACKAGE_PIN N15 [get_ports {rst_n}]
############## AX7020/AX7010 J11##################
set_property IOSTANDARD LVCMOS33 [get_ports rs422_rx1]
set_property PACKAGE_PIN D20 [get_ports rs422_rx1]

set_property IOSTANDARD LVCMOS33 [get_ports rs422_tx1]
set_property PACKAGE_PIN D19 [get_ports rs422_tx1]

set_property IOSTANDARD LVCMOS33 [get_ports rs422_rx2]
set_property PACKAGE_PIN L17 [get_ports rs422_rx2]

set_property IOSTANDARD LVCMOS33 [get_ports rs422_tx2]
set_property PACKAGE_PIN L16 [get_ports rs422_tx2]