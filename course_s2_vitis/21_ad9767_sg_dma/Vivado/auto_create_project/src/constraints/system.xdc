set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

set_property IOSTANDARD LVCMOS33 [get_ports {key_tri_i[0]}]
set_property PACKAGE_PIN N15 [get_ports {key_tri_i[0]}]







#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list top_i/processing_system7_0/inst/FCLK_CLK1]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 14 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[0]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[1]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[2]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[3]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[4]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[5]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[6]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[7]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[8]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[9]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[10]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[11]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[12]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[13]}]]
#create_debug_core u_ila_1 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
#set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_1]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
#set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_1]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
#set_property port_width 1 [get_debug_ports u_ila_1/clk]
#connect_debug_port u_ila_1/clk [get_nets [list top_i/processing_system7_0/inst/FCLK_CLK0]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
#set_property port_width 2 [get_debug_ports u_ila_1/probe0]
#connect_debug_port u_ila_1/probe0 [get_nets [list {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tkeep[0]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tkeep[1]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 32 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[0]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[1]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[2]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[3]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[4]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[5]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[6]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[7]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[8]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[9]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[10]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[11]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[12]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[13]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[14]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[15]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[16]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[17]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[18]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[19]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[20]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[21]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[22]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[23]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[24]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[25]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[26]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[27]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[28]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[29]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[30]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
#set_property port_width 10 [get_debug_ports u_ila_0/probe2]
#connect_debug_port u_ila_0/probe2 [get_nets [list {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[0]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[1]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[2]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[3]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[4]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[5]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[6]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[7]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[8]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[9]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
#set_property port_width 32 [get_debug_ports u_ila_0/probe3]
#connect_debug_port u_ila_0/probe3 [get_nets [list {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[0]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[1]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[2]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[3]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[4]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[5]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[6]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[7]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[8]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[9]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[10]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[11]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[12]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[13]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[14]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[15]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[16]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[17]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[18]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[19]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[20]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[21]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[22]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[23]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[24]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[25]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[26]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[27]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[28]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[29]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[30]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/send_cnt[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
#set_property port_width 10 [get_debug_ports u_ila_0/probe4]
#connect_debug_port u_ila_0/probe4 [get_nets [list {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[0]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[1]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[2]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[3]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[4]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[5]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[6]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[7]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[8]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/rd_data_count[9]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
#set_property port_width 14 [get_debug_ports u_ila_0/probe5]
#connect_debug_port u_ila_0/probe5 [get_nets [list {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[0]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[1]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[2]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[3]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[4]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[5]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[6]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[7]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[8]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[9]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[10]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[11]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[12]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_data[13]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
#set_property port_width 1 [get_debug_ports u_ila_0/probe6]
#connect_debug_port u_ila_0/probe6 [get_nets [list top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_buf_rd]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
#set_property port_width 1 [get_debug_ports u_ila_0/probe7]
#connect_debug_port u_ila_0/probe7 [get_nets [list top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dac_buf_rd]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
#set_property port_width 1 [get_debug_ports u_ila_0/probe8]
#connect_debug_port u_ila_0/probe8 [get_nets [list top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/empty]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
#set_property port_width 1 [get_debug_ports u_ila_0/probe9]
#connect_debug_port u_ila_0/probe9 [get_nets [list top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/empty]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
#set_property port_width 16 [get_debug_ports u_ila_1/probe1]
#connect_debug_port u_ila_1/probe1 [get_nets [list {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[0]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[1]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[2]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[3]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[4]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[5]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[6]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[7]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[8]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[9]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[10]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[11]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[12]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[13]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[14]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[15]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
#set_property port_width 16 [get_debug_ports u_ila_1/probe2]
#connect_debug_port u_ila_1/probe2 [get_nets [list {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[0]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[1]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[2]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[3]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[4]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[5]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[6]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[7]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[8]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[9]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[10]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[11]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[12]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[13]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[14]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[15]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
#set_property port_width 32 [get_debug_ports u_ila_1/probe3]
#connect_debug_port u_ila_1/probe3 [get_nets [list {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[0]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[1]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[2]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[3]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[4]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[5]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[6]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[7]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[8]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[9]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[10]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[11]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[12]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[13]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[14]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[15]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[16]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[17]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[18]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[19]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[20]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[21]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[22]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[23]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[24]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[25]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[26]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[27]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[28]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[29]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[30]} {top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[31]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
#set_property port_width 16 [get_debug_ports u_ila_1/probe4]
#connect_debug_port u_ila_1/probe4 [get_nets [list {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[0]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[1]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[2]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[3]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[4]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[5]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[6]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[7]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[8]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[9]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[10]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[11]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[12]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[13]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[14]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_data[15]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
#set_property port_width 16 [get_debug_ports u_ila_1/probe5]
#connect_debug_port u_ila_1/probe5 [get_nets [list {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[0]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[1]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[2]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[3]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[4]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[5]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[6]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[7]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[8]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[9]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[10]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[11]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[12]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[13]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[14]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tdata[15]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
#set_property port_width 32 [get_debug_ports u_ila_1/probe6]
#connect_debug_port u_ila_1/probe6 [get_nets [list {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[0]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[1]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[2]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[3]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[4]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[5]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[6]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[7]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[8]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[9]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[10]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[11]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[12]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[13]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[14]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[15]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[16]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[17]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[18]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[19]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[20]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[21]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[22]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[23]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[24]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[25]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[26]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[27]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[28]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[29]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[30]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/dma_cnt[31]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe7]
#set_property port_width 2 [get_debug_ports u_ila_1/probe7]
#connect_debug_port u_ila_1/probe7 [get_nets [list {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tkeep[0]} {top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tkeep[1]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe8]
#set_property port_width 1 [get_debug_ports u_ila_1/probe8]
#connect_debug_port u_ila_1/probe8 [get_nets [list {top_i/xlconcat_0/In1[0]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe9]
#set_property port_width 1 [get_debug_ports u_ila_1/probe9]
#connect_debug_port u_ila_1/probe9 [get_nets [list {top_i/xlconcat_0/In0[0]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe10]
#set_property port_width 1 [get_debug_ports u_ila_1/probe10]
#connect_debug_port u_ila_1/probe10 [get_nets [list top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/almost_full]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe11]
#set_property port_width 1 [get_debug_ports u_ila_1/probe11]
#connect_debug_port u_ila_1/probe11 [get_nets [list top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/almost_full]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe12]
#set_property port_width 1 [get_debug_ports u_ila_1/probe12]
#connect_debug_port u_ila_1/probe12 [get_nets [list top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tlast]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe13]
#set_property port_width 1 [get_debug_ports u_ila_1/probe13]
#connect_debug_port u_ila_1/probe13 [get_nets [list top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tlast]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe14]
#set_property port_width 1 [get_debug_ports u_ila_1/probe14]
#connect_debug_port u_ila_1/probe14 [get_nets [list top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tready]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe15]
#set_property port_width 1 [get_debug_ports u_ila_1/probe15]
#connect_debug_port u_ila_1/probe15 [get_nets [list top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tready]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe16]
#set_property port_width 1 [get_debug_ports u_ila_1/probe16]
#connect_debug_port u_ila_1/probe16 [get_nets [list top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tvalid]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe17]
#set_property port_width 1 [get_debug_ports u_ila_1/probe17]
#connect_debug_port u_ila_1/probe17 [get_nets [list top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/DMA_AXIS_tvalid]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe18]
#set_property port_width 1 [get_debug_ports u_ila_1/probe18]
#connect_debug_port u_ila_1/probe18 [get_nets [list top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_en]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe19]
#set_property port_width 1 [get_debug_ports u_ila_1/probe19]
#connect_debug_port u_ila_1/probe19 [get_nets [list top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/fifo_wr_en]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe20]
#set_property port_width 1 [get_debug_ports u_ila_1/probe20]
#connect_debug_port u_ila_1/probe20 [get_nets [list top_i/ad9767_send_1/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/full]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe21]
#set_property port_width 1 [get_debug_ports u_ila_1/probe21]
#connect_debug_port u_ila_1/probe21 [get_nets [list top_i/ad9767_send_0/inst/ad9767_send_v1_0_S00_AXI_inst/send_inst/full]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets u_ila_1_FCLK_CLK0]
