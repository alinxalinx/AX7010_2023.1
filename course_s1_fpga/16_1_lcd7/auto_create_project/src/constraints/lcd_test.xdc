############## clock and reset define##################
create_clock -period 20 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_clk}]
set_property PACKAGE_PIN U18 [get_ports {sys_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst_n}]
set_property PACKAGE_PIN N15 [get_ports {rst_n}]
############## AN871 LCD on AX7020 and AX7010 J11##################
set_property PACKAGE_PIN F16 [get_ports {lcd_pwm}]
set_property PACKAGE_PIN G20 [get_ports {lcd_hs}]
set_property PACKAGE_PIN G19 [get_ports {lcd_vs}]
set_property PACKAGE_PIN H18 [get_ports {lcd_dclk}]
set_property PACKAGE_PIN J18 [get_ports {lcd_de}]
set_property PACKAGE_PIN L20 [get_ports {lcd_b[6]}]
set_property PACKAGE_PIN L19 [get_ports {lcd_b[7]}]
set_property PACKAGE_PIN M20 [get_ports {lcd_b[4]}]
set_property PACKAGE_PIN M19 [get_ports {lcd_b[5]}]
set_property PACKAGE_PIN K18 [get_ports {lcd_b[2]}]
set_property PACKAGE_PIN K17 [get_ports {lcd_b[3]}]
set_property PACKAGE_PIN J19 [get_ports {lcd_b[0]}]
set_property PACKAGE_PIN K19 [get_ports {lcd_b[1]}]
set_property PACKAGE_PIN H20  [get_ports {lcd_g[6]}]
set_property PACKAGE_PIN J20  [get_ports {lcd_g[7]}]
set_property PACKAGE_PIN L17  [get_ports {lcd_g[4]}]
set_property PACKAGE_PIN L16  [get_ports {lcd_g[5]}]
set_property PACKAGE_PIN M18  [get_ports {lcd_g[2]}]
set_property PACKAGE_PIN M17  [get_ports {lcd_g[3]}]
set_property PACKAGE_PIN D20 [get_ports {lcd_g[0]}]
set_property PACKAGE_PIN D19 [get_ports {lcd_g[1]}]
set_property PACKAGE_PIN E19  [get_ports {lcd_r[6]}]
set_property PACKAGE_PIN E18  [get_ports {lcd_r[7]}]
set_property PACKAGE_PIN G18 [get_ports {lcd_r[4]}]
set_property PACKAGE_PIN G17 [get_ports {lcd_r[5]}]
set_property PACKAGE_PIN H17 [get_ports {lcd_r[2]}]
set_property PACKAGE_PIN H16 [get_ports {lcd_r[3]}]
set_property PACKAGE_PIN G15 [get_ports {lcd_r[0]}]
set_property PACKAGE_PIN H15 [get_ports {lcd_r[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {lcd_pwm}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_hs}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_vs}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_dclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_de}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_r[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_g[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports {lcd_b[*]}]







