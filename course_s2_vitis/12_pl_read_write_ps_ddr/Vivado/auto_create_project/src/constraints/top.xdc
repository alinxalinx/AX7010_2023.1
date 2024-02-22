
set_property IOSTANDARD LVCMOS33 [get_ports error]
set_property PACKAGE_PIN M14 [get_ports error]






connect_debug_port u_ila_0/probe0 [get_nets [list {u_aq_axi_master/wr_state[0]} {u_aq_axi_master/wr_state[1]} {u_aq_axi_master/wr_state[2]}]]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list M_AXI_ACLK]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {mem_test_m0/state[0]} {mem_test_m0/state[1]} {mem_test_m0/state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {mem_test_m0/wr_cnt[0]} {mem_test_m0/wr_cnt[1]} {mem_test_m0/wr_cnt[2]} {mem_test_m0/wr_cnt[3]} {mem_test_m0/wr_cnt[4]} {mem_test_m0/wr_cnt[5]} {mem_test_m0/wr_cnt[6]} {mem_test_m0/wr_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {mem_test_m0/rd_cnt[0]} {mem_test_m0/rd_cnt[1]} {mem_test_m0/rd_cnt[2]} {mem_test_m0/rd_cnt[3]} {mem_test_m0/rd_cnt[4]} {mem_test_m0/rd_cnt[5]} {mem_test_m0/rd_cnt[6]} {mem_test_m0/rd_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 64 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {wr_burst_data[0]} {wr_burst_data[1]} {wr_burst_data[2]} {wr_burst_data[3]} {wr_burst_data[4]} {wr_burst_data[5]} {wr_burst_data[6]} {wr_burst_data[7]} {wr_burst_data[8]} {wr_burst_data[9]} {wr_burst_data[10]} {wr_burst_data[11]} {wr_burst_data[12]} {wr_burst_data[13]} {wr_burst_data[14]} {wr_burst_data[15]} {wr_burst_data[16]} {wr_burst_data[17]} {wr_burst_data[18]} {wr_burst_data[19]} {wr_burst_data[20]} {wr_burst_data[21]} {wr_burst_data[22]} {wr_burst_data[23]} {wr_burst_data[24]} {wr_burst_data[25]} {wr_burst_data[26]} {wr_burst_data[27]} {wr_burst_data[28]} {wr_burst_data[29]} {wr_burst_data[30]} {wr_burst_data[31]} {wr_burst_data[32]} {wr_burst_data[33]} {wr_burst_data[34]} {wr_burst_data[35]} {wr_burst_data[36]} {wr_burst_data[37]} {wr_burst_data[38]} {wr_burst_data[39]} {wr_burst_data[40]} {wr_burst_data[41]} {wr_burst_data[42]} {wr_burst_data[43]} {wr_burst_data[44]} {wr_burst_data[45]} {wr_burst_data[46]} {wr_burst_data[47]} {wr_burst_data[48]} {wr_burst_data[49]} {wr_burst_data[50]} {wr_burst_data[51]} {wr_burst_data[52]} {wr_burst_data[53]} {wr_burst_data[54]} {wr_burst_data[55]} {wr_burst_data[56]} {wr_burst_data[57]} {wr_burst_data[58]} {wr_burst_data[59]} {wr_burst_data[60]} {wr_burst_data[61]} {wr_burst_data[62]} {wr_burst_data[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 10 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {wr_burst_len[0]} {wr_burst_len[1]} {wr_burst_len[2]} {wr_burst_len[3]} {wr_burst_len[4]} {wr_burst_len[5]} {wr_burst_len[6]} {wr_burst_len[7]} {wr_burst_len[8]} {wr_burst_len[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {rd_burst_addr[0]} {rd_burst_addr[1]} {rd_burst_addr[2]} {rd_burst_addr[3]} {rd_burst_addr[4]} {rd_burst_addr[5]} {rd_burst_addr[6]} {rd_burst_addr[7]} {rd_burst_addr[8]} {rd_burst_addr[9]} {rd_burst_addr[10]} {rd_burst_addr[11]} {rd_burst_addr[12]} {rd_burst_addr[13]} {rd_burst_addr[14]} {rd_burst_addr[15]} {rd_burst_addr[16]} {rd_burst_addr[17]} {rd_burst_addr[18]} {rd_burst_addr[19]} {rd_burst_addr[20]} {rd_burst_addr[21]} {rd_burst_addr[22]} {rd_burst_addr[23]} {rd_burst_addr[24]} {rd_burst_addr[25]} {rd_burst_addr[26]} {rd_burst_addr[27]} {rd_burst_addr[28]} {rd_burst_addr[29]} {rd_burst_addr[30]} {rd_burst_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 64 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {rd_burst_data[0]} {rd_burst_data[1]} {rd_burst_data[2]} {rd_burst_data[3]} {rd_burst_data[4]} {rd_burst_data[5]} {rd_burst_data[6]} {rd_burst_data[7]} {rd_burst_data[8]} {rd_burst_data[9]} {rd_burst_data[10]} {rd_burst_data[11]} {rd_burst_data[12]} {rd_burst_data[13]} {rd_burst_data[14]} {rd_burst_data[15]} {rd_burst_data[16]} {rd_burst_data[17]} {rd_burst_data[18]} {rd_burst_data[19]} {rd_burst_data[20]} {rd_burst_data[21]} {rd_burst_data[22]} {rd_burst_data[23]} {rd_burst_data[24]} {rd_burst_data[25]} {rd_burst_data[26]} {rd_burst_data[27]} {rd_burst_data[28]} {rd_burst_data[29]} {rd_burst_data[30]} {rd_burst_data[31]} {rd_burst_data[32]} {rd_burst_data[33]} {rd_burst_data[34]} {rd_burst_data[35]} {rd_burst_data[36]} {rd_burst_data[37]} {rd_burst_data[38]} {rd_burst_data[39]} {rd_burst_data[40]} {rd_burst_data[41]} {rd_burst_data[42]} {rd_burst_data[43]} {rd_burst_data[44]} {rd_burst_data[45]} {rd_burst_data[46]} {rd_burst_data[47]} {rd_burst_data[48]} {rd_burst_data[49]} {rd_burst_data[50]} {rd_burst_data[51]} {rd_burst_data[52]} {rd_burst_data[53]} {rd_burst_data[54]} {rd_burst_data[55]} {rd_burst_data[56]} {rd_burst_data[57]} {rd_burst_data[58]} {rd_burst_data[59]} {rd_burst_data[60]} {rd_burst_data[61]} {rd_burst_data[62]} {rd_burst_data[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 10 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {rd_burst_len[0]} {rd_burst_len[1]} {rd_burst_len[2]} {rd_burst_len[3]} {rd_burst_len[4]} {rd_burst_len[5]} {rd_burst_len[6]} {rd_burst_len[7]} {rd_burst_len[8]} {rd_burst_len[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {wr_burst_addr[0]} {wr_burst_addr[1]} {wr_burst_addr[2]} {wr_burst_addr[3]} {wr_burst_addr[4]} {wr_burst_addr[5]} {wr_burst_addr[6]} {wr_burst_addr[7]} {wr_burst_addr[8]} {wr_burst_addr[9]} {wr_burst_addr[10]} {wr_burst_addr[11]} {wr_burst_addr[12]} {wr_burst_addr[13]} {wr_burst_addr[14]} {wr_burst_addr[15]} {wr_burst_addr[16]} {wr_burst_addr[17]} {wr_burst_addr[18]} {wr_burst_addr[19]} {wr_burst_addr[20]} {wr_burst_addr[21]} {wr_burst_addr[22]} {wr_burst_addr[23]} {wr_burst_addr[24]} {wr_burst_addr[25]} {wr_burst_addr[26]} {wr_burst_addr[27]} {wr_burst_addr[28]} {wr_burst_addr[29]} {wr_burst_addr[30]} {wr_burst_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list mem_test_m0/error]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list error_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list M_AXI_ARREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list M_AXI_AWREADY]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list rd_burst_data_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list rd_burst_finish]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list rd_burst_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list wr_burst_data_req]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list wr_burst_finish]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list wr_burst_req]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets M_AXI_ACLK]
