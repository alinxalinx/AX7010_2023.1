set C_TypeInfoList {{ 
"mult_constant" : [[], { "return": [[], "void"]} , [{"ExternC" : 0}], [ {"in_data": [[],{ "pointer": "0"}] }, {"out_data": [[],{ "pointer": "0"}] }, {"constant": [[],"1"] }],[],""], 
"0": [ "stream_type", {"typedef": [[[],"2"],""]}], 
"1": [ "ap_int<32>", {"hls_type": {"ap_int": [[[[], {"scalar": { "int": 32}}]],""]}}], 
"2": [ "ap_axiu<32, 1, 1, 1>", {"struct": [[],[{"D":[[], {"scalar": { "int": 32}}]},{"U":[[], {"scalar": { "int": 1}}]},{"TI":[[], {"scalar": { "int": 1}}]},{"TD":[[], {"scalar": { "int": 1}}]}],[{ "data": [[], "3"]},{ "keep": [[], "4"]},{ "strb": [[], "4"]},{ "user": [[], "5"]},{ "last": [[], "5"]},{ "id": [[], "5"]},{ "dest": [[], "5"]}],""]}], 
"5": [ "ap_uint<1>", {"hls_type": {"ap_uint": [[[[], {"scalar": { "int": 1}}]],""]}}], 
"4": [ "ap_uint<4>", {"hls_type": {"ap_uint": [[[[], {"scalar": { "int": 4}}]],""]}}], 
"3": [ "ap_uint<32>", {"hls_type": {"ap_uint": [[[[], {"scalar": { "int": 32}}]],""]}}]
}}
set moduleName mult_constant
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_none
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set C_modelName {mult_constant}
set C_modelType { void 0 }
set C_modelArgList {
	{ in_data_data_V int 32 regular {axi_s 0 volatile  { in_data Data } }  }
	{ in_data_keep_V int 4 regular {axi_s 0 volatile  { in_data Keep } }  }
	{ in_data_strb_V int 4 regular {axi_s 0 volatile  { in_data Strb } }  }
	{ in_data_user_V int 1 regular {axi_s 0 volatile  { in_data User } }  }
	{ in_data_last_V int 1 regular {axi_s 0 volatile  { in_data Last } }  }
	{ in_data_id_V int 1 regular {axi_s 0 volatile  { in_data ID } }  }
	{ in_data_dest_V int 1 regular {axi_s 0 volatile  { in_data Dest } }  }
	{ out_data_data_V int 32 regular {axi_s 1 volatile  { out_data Data } }  }
	{ out_data_keep_V int 4 regular {axi_s 1 volatile  { out_data Keep } }  }
	{ out_data_strb_V int 4 regular {axi_s 1 volatile  { out_data Strb } }  }
	{ out_data_user_V int 1 regular {axi_s 1 volatile  { out_data User } }  }
	{ out_data_last_V int 1 regular {axi_s 1 volatile  { out_data Last } }  }
	{ out_data_id_V int 1 regular {axi_s 1 volatile  { out_data ID } }  }
	{ out_data_dest_V int 1 regular {axi_s 1 volatile  { out_data Dest } }  }
	{ constant_V int 32 regular {axi_slave 0}  }
}
set C_modelArgMapList {[ 
	{ "Name" : "in_data_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "in_data.data.V","cData": "uint32","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "in_data_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "in_data.keep.V","cData": "uint4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "in_data_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "in_data.strb.V","cData": "uint4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "in_data_user_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "in_data.user.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "in_data_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "in_data.last.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "in_data_id_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "in_data.id.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "in_data_dest_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "in_data.dest.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "out_data_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "out_data.data.V","cData": "uint32","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "out_data_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "out_data.keep.V","cData": "uint4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "out_data_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":3,"cElement": [{"cName": "out_data.strb.V","cData": "uint4","bit_use": { "low": 0,"up": 3},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "out_data_user_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "out_data.user.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "out_data_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "out_data.last.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "out_data_id_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "out_data.id.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "out_data_dest_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY", "bitSlice":[{"low":0,"up":0,"cElement": [{"cName": "out_data.dest.V","cData": "uint1","bit_use": { "low": 0,"up": 0},"cArray": [{"low" : 0,"up" : 0,"step" : 1}]}]}]} , 
 	{ "Name" : "constant_V", "interface" : "axi_slave", "bundle":"AXILiteS","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "bitSlice":[{"low":0,"up":31,"cElement": [{"cName": "constant.V","cData": "int32","bit_use": { "low": 0,"up": 31},"cArray": [{"low" : 0,"up" : 0,"step" : 0}]}]}], "offset" : {"in":16}, "offset_end" : {"in":23}} ]}
# RTL Port declarations: 
set portNum 37
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ in_data_TDATA sc_in sc_lv 32 signal 0 } 
	{ in_data_TVALID sc_in sc_logic 1 invld 6 } 
	{ in_data_TREADY sc_out sc_logic 1 inacc 6 } 
	{ in_data_TKEEP sc_in sc_lv 4 signal 1 } 
	{ in_data_TSTRB sc_in sc_lv 4 signal 2 } 
	{ in_data_TUSER sc_in sc_lv 1 signal 3 } 
	{ in_data_TLAST sc_in sc_lv 1 signal 4 } 
	{ in_data_TID sc_in sc_lv 1 signal 5 } 
	{ in_data_TDEST sc_in sc_lv 1 signal 6 } 
	{ out_data_TDATA sc_out sc_lv 32 signal 7 } 
	{ out_data_TVALID sc_out sc_logic 1 outvld 13 } 
	{ out_data_TREADY sc_in sc_logic 1 outacc 13 } 
	{ out_data_TKEEP sc_out sc_lv 4 signal 8 } 
	{ out_data_TSTRB sc_out sc_lv 4 signal 9 } 
	{ out_data_TUSER sc_out sc_lv 1 signal 10 } 
	{ out_data_TLAST sc_out sc_lv 1 signal 11 } 
	{ out_data_TID sc_out sc_lv 1 signal 12 } 
	{ out_data_TDEST sc_out sc_lv 1 signal 13 } 
	{ s_axi_AXILiteS_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_AWADDR sc_in sc_lv 5 signal -1 } 
	{ s_axi_AXILiteS_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_AXILiteS_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_AXILiteS_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_ARADDR sc_in sc_lv 5 signal -1 } 
	{ s_axi_AXILiteS_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_AXILiteS_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_AXILiteS_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_AXILiteS_BRESP sc_out sc_lv 2 signal -1 } 
}
set NewPortList {[ 
	{ "name": "s_axi_AXILiteS_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "AXILiteS", "role": "AWADDR" },"address":[{"name":"constant_V","role":"data","value":"16"}] },
	{ "name": "s_axi_AXILiteS_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "AWVALID" } },
	{ "name": "s_axi_AXILiteS_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "AWREADY" } },
	{ "name": "s_axi_AXILiteS_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "WVALID" } },
	{ "name": "s_axi_AXILiteS_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "WREADY" } },
	{ "name": "s_axi_AXILiteS_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "AXILiteS", "role": "WDATA" } },
	{ "name": "s_axi_AXILiteS_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "AXILiteS", "role": "WSTRB" } },
	{ "name": "s_axi_AXILiteS_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":5, "type": "signal", "bundle":{"name": "AXILiteS", "role": "ARADDR" },"address":[] },
	{ "name": "s_axi_AXILiteS_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "ARVALID" } },
	{ "name": "s_axi_AXILiteS_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "ARREADY" } },
	{ "name": "s_axi_AXILiteS_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "RVALID" } },
	{ "name": "s_axi_AXILiteS_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "RREADY" } },
	{ "name": "s_axi_AXILiteS_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "AXILiteS", "role": "RDATA" } },
	{ "name": "s_axi_AXILiteS_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "AXILiteS", "role": "RRESP" } },
	{ "name": "s_axi_AXILiteS_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "BVALID" } },
	{ "name": "s_axi_AXILiteS_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "AXILiteS", "role": "BREADY" } },
	{ "name": "s_axi_AXILiteS_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "AXILiteS", "role": "BRESP" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "in_data_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_data_data_V", "role": "default" }} , 
 	{ "name": "in_data_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_data_dest_V", "role": "default" }} , 
 	{ "name": "in_data_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_data_dest_V", "role": "default" }} , 
 	{ "name": "in_data_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_data_keep_V", "role": "default" }} , 
 	{ "name": "in_data_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_data_strb_V", "role": "default" }} , 
 	{ "name": "in_data_TUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_user_V", "role": "default" }} , 
 	{ "name": "in_data_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_last_V", "role": "default" }} , 
 	{ "name": "in_data_TID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_id_V", "role": "default" }} , 
 	{ "name": "in_data_TDEST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_dest_V", "role": "default" }} , 
 	{ "name": "out_data_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_data_data_V", "role": "default" }} , 
 	{ "name": "out_data_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_data_dest_V", "role": "default" }} , 
 	{ "name": "out_data_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_data_dest_V", "role": "default" }} , 
 	{ "name": "out_data_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_data_keep_V", "role": "default" }} , 
 	{ "name": "out_data_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_data_strb_V", "role": "default" }} , 
 	{ "name": "out_data_TUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_data_user_V", "role": "default" }} , 
 	{ "name": "out_data_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_data_last_V", "role": "default" }} , 
 	{ "name": "out_data_TID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_data_id_V", "role": "default" }} , 
 	{ "name": "out_data_TDEST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_data_dest_V", "role": "default" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1"],
		"CDFG" : "mult_constant",
		"ControlExist" : "0", "ap_start" : "0", "ap_ready" : "0", "ap_done" : "0", "ap_continue" : "0", "ap_idle" : "0",
		"FunctionPipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"VariableLatency" : "1",
		"Port" : [
			{"Name" : "in_data_data_V", "Type" : "Axis", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "in_data_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "in_data_keep_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "in_data_strb_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "in_data_user_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "in_data_last_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "in_data_id_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "in_data_dest_V", "Type" : "Axis", "Direction" : "I"},
			{"Name" : "out_data_data_V", "Type" : "Axis", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "out_data_TDATA_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "out_data_keep_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "out_data_strb_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "out_data_user_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "out_data_last_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "out_data_id_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "out_data_dest_V", "Type" : "Axis", "Direction" : "O"},
			{"Name" : "constant_V", "Type" : "None", "Direction" : "I"}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.mult_constant_AXILiteS_s_axi_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	mult_constant {
		in_data_data_V {Type I LastRead 0 FirstWrite -1}
		in_data_keep_V {Type I LastRead 0 FirstWrite -1}
		in_data_strb_V {Type I LastRead 0 FirstWrite -1}
		in_data_user_V {Type I LastRead 0 FirstWrite -1}
		in_data_last_V {Type I LastRead 0 FirstWrite -1}
		in_data_id_V {Type I LastRead 0 FirstWrite -1}
		in_data_dest_V {Type I LastRead 0 FirstWrite -1}
		out_data_data_V {Type O LastRead -1 FirstWrite 2}
		out_data_keep_V {Type O LastRead -1 FirstWrite 2}
		out_data_strb_V {Type O LastRead -1 FirstWrite 2}
		out_data_user_V {Type O LastRead -1 FirstWrite 2}
		out_data_last_V {Type O LastRead -1 FirstWrite 2}
		out_data_id_V {Type O LastRead -1 FirstWrite 2}
		out_data_dest_V {Type O LastRead -1 FirstWrite 2}
		constant_V {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "3", "Max" : "3"}
	, {"Name" : "Interval", "Min" : "4", "Max" : "4"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_data_data_V { axis {  { in_data_TDATA in_data 0 32 } } }
	in_data_keep_V { axis {  { in_data_TKEEP in_data 0 4 } } }
	in_data_strb_V { axis {  { in_data_TSTRB in_data 0 4 } } }
	in_data_user_V { axis {  { in_data_TUSER in_data 0 1 } } }
	in_data_last_V { axis {  { in_data_TLAST in_data 0 1 } } }
	in_data_id_V { axis {  { in_data_TID in_data 0 1 } } }
	in_data_dest_V { axis {  { in_data_TVALID in_vld 0 1 }  { in_data_TREADY in_acc 1 1 }  { in_data_TDEST in_data 0 1 } } }
	out_data_data_V { axis {  { out_data_TDATA out_data 1 32 } } }
	out_data_keep_V { axis {  { out_data_TKEEP out_data 1 4 } } }
	out_data_strb_V { axis {  { out_data_TSTRB out_data 1 4 } } }
	out_data_user_V { axis {  { out_data_TUSER out_data 1 1 } } }
	out_data_last_V { axis {  { out_data_TLAST out_data 1 1 } } }
	out_data_id_V { axis {  { out_data_TID out_data 1 1 } } }
	out_data_dest_V { axis {  { out_data_TVALID out_vld 1 1 }  { out_data_TREADY out_acc 0 1 }  { out_data_TDEST out_data 1 1 } } }
}

set busDeadlockParameterList { 
}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
