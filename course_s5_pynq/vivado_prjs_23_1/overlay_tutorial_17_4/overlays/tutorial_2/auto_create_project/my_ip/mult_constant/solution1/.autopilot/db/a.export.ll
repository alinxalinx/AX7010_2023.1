; ModuleID = 'D:/test/overlay_tutorial_17_4/ip/mult_constant/solution1/.autopilot/db/a.o.2.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-w64-mingw32"

@mult_constant_str = internal unnamed_addr constant [14 x i8] c"mult_constant\00"
@llvm_global_ctors_1 = appending global [0 x void ()*] zeroinitializer
@llvm_global_ctors_0 = appending global [0 x i32] zeroinitializer
@p_str4 = private unnamed_addr constant [5 x i8] c"both\00", align 1
@p_str3 = private unnamed_addr constant [5 x i8] c"axis\00", align 1
@p_str2 = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1
@p_str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@p_str = private unnamed_addr constant [10 x i8] c"s_axilite\00", align 1

define void @mult_constant(i32* %in_data_data_V, i4* %in_data_keep_V, i4* %in_data_strb_V, i1* %in_data_user_V, i1* %in_data_last_V, i1* %in_data_id_V, i1* %in_data_dest_V, i32* %out_data_data_V, i4* %out_data_keep_V, i4* %out_data_strb_V, i1* %out_data_user_V, i1* %out_data_last_V, i1* %out_data_id_V, i1* %out_data_dest_V, i32 %constant_V) {
  %constant_V_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %constant_V)
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %in_data_data_V), !map !43
  call void (...)* @_ssdm_op_SpecBitsMap(i4* %in_data_keep_V), !map !47
  call void (...)* @_ssdm_op_SpecBitsMap(i4* %in_data_strb_V), !map !51
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %in_data_user_V), !map !55
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %in_data_last_V), !map !59
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %in_data_id_V), !map !63
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %in_data_dest_V), !map !67
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %out_data_data_V), !map !71
  call void (...)* @_ssdm_op_SpecBitsMap(i4* %out_data_keep_V), !map !75
  call void (...)* @_ssdm_op_SpecBitsMap(i4* %out_data_strb_V), !map !79
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %out_data_user_V), !map !83
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %out_data_last_V), !map !87
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %out_data_id_V), !map !91
  call void (...)* @_ssdm_op_SpecBitsMap(i1* %out_data_dest_V), !map !95
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %constant_V), !map !99
  call void (...)* @_ssdm_op_SpecTopModule([14 x i8]* @mult_constant_str) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 %constant_V, [10 x i8]* @p_str, i32 1, i32 1, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [13 x i8]* @p_str2, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %in_data_data_V, i4* %in_data_keep_V, i4* %in_data_strb_V, i1* %in_data_user_V, i1* %in_data_last_V, i1* %in_data_id_V, i1* %in_data_dest_V, [5 x i8]* @p_str3, i32 1, i32 1, [5 x i8]* @p_str4, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  call void (...)* @_ssdm_op_SpecInterface(i32* %out_data_data_V, i4* %out_data_keep_V, i4* %out_data_strb_V, i1* %out_data_user_V, i1* %out_data_last_V, i1* %out_data_id_V, i1* %out_data_dest_V, [5 x i8]* @p_str3, i32 1, i32 1, [5 x i8]* @p_str4, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind
  %empty = call { i32, i4, i4, i1, i1, i1, i1 } @_ssdm_op_Read.axis.volatile.i32P.i4P.i4P.i1P.i1P.i1P.i1P(i32* %in_data_data_V, i4* %in_data_keep_V, i4* %in_data_strb_V, i1* %in_data_user_V, i1* %in_data_last_V, i1* %in_data_id_V, i1* %in_data_dest_V)
  %in_data_data_V_tmp = extractvalue { i32, i4, i4, i1, i1, i1, i1 } %empty, 0
  %in_data_keep_V_tmp = extractvalue { i32, i4, i4, i1, i1, i1, i1 } %empty, 1
  %in_data_strb_V_tmp = extractvalue { i32, i4, i4, i1, i1, i1, i1 } %empty, 2
  %in_data_user_V_tmp = extractvalue { i32, i4, i4, i1, i1, i1, i1 } %empty, 3
  %in_data_last_V_tmp = extractvalue { i32, i4, i4, i1, i1, i1, i1 } %empty, 4
  %in_data_id_V_tmp = extractvalue { i32, i4, i4, i1, i1, i1, i1 } %empty, 5
  %in_data_dest_V_tmp = extractvalue { i32, i4, i4, i1, i1, i1, i1 } %empty, 6
  %out_data_data_V_tmp = mul i32 %in_data_data_V_tmp, %constant_V_read
  call void @_ssdm_op_Write.axis.volatile.i32P.i4P.i4P.i1P.i1P.i1P.i1P(i32* %out_data_data_V, i4* %out_data_keep_V, i4* %out_data_strb_V, i1* %out_data_user_V, i1* %out_data_last_V, i1* %out_data_id_V, i1* %out_data_dest_V, i32 %out_data_data_V_tmp, i4 %in_data_keep_V_tmp, i4 %in_data_strb_V_tmp, i1 %in_data_user_V_tmp, i1 %in_data_last_V_tmp, i1 %in_data_id_V_tmp, i1 %in_data_dest_V_tmp)
  ret void
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define weak void @_ssdm_op_Write.axis.volatile.i32P.i4P.i4P.i1P.i1P.i1P.i1P(i32*, i4*, i4*, i1*, i1*, i1*, i1*, i32, i4, i4, i1, i1, i1, i1) {
entry:
  store i32 %7, i32* %0
  store i4 %8, i4* %1
  store i4 %9, i4* %2
  store i1 %10, i1* %3
  store i1 %11, i1* %4
  store i1 %12, i1* %5
  store i1 %13, i1* %6
  ret void
}

define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

define weak i32 @_ssdm_op_Read.s_axilite.i32(i32) {
entry:
  ret i32 %0
}

define weak { i32, i4, i4, i1, i1, i1, i1 } @_ssdm_op_Read.axis.volatile.i32P.i4P.i4P.i1P.i1P.i1P.i1P(i32*, i4*, i4*, i1*, i1*, i1*, i1*) {
entry:
  %empty = load i32* %0
  %empty_2 = load i4* %1
  %empty_3 = load i4* %2
  %empty_4 = load i1* %3
  %empty_5 = load i1* %4
  %empty_6 = load i1* %5
  %empty_7 = load i1* %6
  %mrv_0 = insertvalue { i32, i4, i4, i1, i1, i1, i1 } undef, i32 %empty, 0
  %mrv1 = insertvalue { i32, i4, i4, i1, i1, i1, i1 } %mrv_0, i4 %empty_2, 1
  %mrv2 = insertvalue { i32, i4, i4, i1, i1, i1, i1 } %mrv1, i4 %empty_3, 2
  %mrv3 = insertvalue { i32, i4, i4, i1, i1, i1, i1 } %mrv2, i1 %empty_4, 3
  %mrv4 = insertvalue { i32, i4, i4, i1, i1, i1, i1 } %mrv3, i1 %empty_5, 4
  %mrv5 = insertvalue { i32, i4, i4, i1, i1, i1, i1 } %mrv4, i1 %empty_6, 5
  %mrv6 = insertvalue { i32, i4, i4, i1, i1, i1, i1 } %mrv5, i1 %empty_7, 6
  ret { i32, i4, i4, i1, i1, i1, i1 } %mrv6
}

!opencl.kernels = !{!0, !7, !13, !15, !15, !18, !18, !24, !26, !18, !18, !18, !32, !32, !34, !34}
!hls.encrypted.func = !{}
!llvm.map.gv = !{!36}

!0 = metadata !{null, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 1, i32 1, i32 0}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"stream_type*", metadata !"stream_type*", metadata !"ap_int<32>"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_name", metadata !"in_data", metadata !"out_data", metadata !"constant"}
!6 = metadata !{metadata !"reqd_work_group_size", i32 1, i32 1, i32 1}
!7 = metadata !{null, metadata !8, metadata !9, metadata !10, metadata !11, metadata !12, metadata !6}
!8 = metadata !{metadata !"kernel_arg_addr_space", i32 0}
!9 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none"}
!10 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<4> &"}
!11 = metadata !{metadata !"kernel_arg_type_qual", metadata !""}
!12 = metadata !{metadata !"kernel_arg_name", metadata !"op2"}
!13 = metadata !{null, metadata !8, metadata !9, metadata !14, metadata !11, metadata !12, metadata !6}
!14 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<1> &"}
!15 = metadata !{null, metadata !8, metadata !9, metadata !16, metadata !11, metadata !17, metadata !6}
!16 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<64, true> &"}
!17 = metadata !{metadata !"kernel_arg_name", metadata !"op"}
!18 = metadata !{null, metadata !19, metadata !20, metadata !21, metadata !22, metadata !23, metadata !6}
!19 = metadata !{metadata !"kernel_arg_addr_space"}
!20 = metadata !{metadata !"kernel_arg_access_qual"}
!21 = metadata !{metadata !"kernel_arg_type"}
!22 = metadata !{metadata !"kernel_arg_type_qual"}
!23 = metadata !{metadata !"kernel_arg_name"}
!24 = metadata !{null, metadata !8, metadata !9, metadata !25, metadata !11, metadata !12, metadata !6}
!25 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_uint<32> &"}
!26 = metadata !{null, metadata !27, metadata !28, metadata !29, metadata !30, metadata !31, metadata !6}
!27 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0}
!28 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none"}
!29 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<32, false> &", metadata !"const ap_int_base<32, true> &"}
!30 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !""}
!31 = metadata !{metadata !"kernel_arg_name", metadata !"op", metadata !"op2"}
!32 = metadata !{null, metadata !8, metadata !9, metadata !33, metadata !11, metadata !17, metadata !6}
!33 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<32, true> &"}
!34 = metadata !{null, metadata !8, metadata !9, metadata !35, metadata !11, metadata !17, metadata !6}
!35 = metadata !{metadata !"kernel_arg_type", metadata !"const ap_int_base<32, false> &"}
!36 = metadata !{metadata !37, [0 x i32]* @llvm_global_ctors_0}
!37 = metadata !{metadata !38}
!38 = metadata !{i32 0, i32 31, metadata !39}
!39 = metadata !{metadata !40}
!40 = metadata !{metadata !"llvm.global_ctors.0", metadata !41, metadata !"", i32 0, i32 31}
!41 = metadata !{metadata !42}
!42 = metadata !{i32 0, i32 0, i32 1}
!43 = metadata !{metadata !44}
!44 = metadata !{i32 0, i32 31, metadata !45}
!45 = metadata !{metadata !46}
!46 = metadata !{metadata !"in_data.data.V", metadata !41, metadata !"uint32", i32 0, i32 31}
!47 = metadata !{metadata !48}
!48 = metadata !{i32 0, i32 3, metadata !49}
!49 = metadata !{metadata !50}
!50 = metadata !{metadata !"in_data.keep.V", metadata !41, metadata !"uint4", i32 0, i32 3}
!51 = metadata !{metadata !52}
!52 = metadata !{i32 0, i32 3, metadata !53}
!53 = metadata !{metadata !54}
!54 = metadata !{metadata !"in_data.strb.V", metadata !41, metadata !"uint4", i32 0, i32 3}
!55 = metadata !{metadata !56}
!56 = metadata !{i32 0, i32 0, metadata !57}
!57 = metadata !{metadata !58}
!58 = metadata !{metadata !"in_data.user.V", metadata !41, metadata !"uint1", i32 0, i32 0}
!59 = metadata !{metadata !60}
!60 = metadata !{i32 0, i32 0, metadata !61}
!61 = metadata !{metadata !62}
!62 = metadata !{metadata !"in_data.last.V", metadata !41, metadata !"uint1", i32 0, i32 0}
!63 = metadata !{metadata !64}
!64 = metadata !{i32 0, i32 0, metadata !65}
!65 = metadata !{metadata !66}
!66 = metadata !{metadata !"in_data.id.V", metadata !41, metadata !"uint1", i32 0, i32 0}
!67 = metadata !{metadata !68}
!68 = metadata !{i32 0, i32 0, metadata !69}
!69 = metadata !{metadata !70}
!70 = metadata !{metadata !"in_data.dest.V", metadata !41, metadata !"uint1", i32 0, i32 0}
!71 = metadata !{metadata !72}
!72 = metadata !{i32 0, i32 31, metadata !73}
!73 = metadata !{metadata !74}
!74 = metadata !{metadata !"out_data.data.V", metadata !41, metadata !"uint32", i32 0, i32 31}
!75 = metadata !{metadata !76}
!76 = metadata !{i32 0, i32 3, metadata !77}
!77 = metadata !{metadata !78}
!78 = metadata !{metadata !"out_data.keep.V", metadata !41, metadata !"uint4", i32 0, i32 3}
!79 = metadata !{metadata !80}
!80 = metadata !{i32 0, i32 3, metadata !81}
!81 = metadata !{metadata !82}
!82 = metadata !{metadata !"out_data.strb.V", metadata !41, metadata !"uint4", i32 0, i32 3}
!83 = metadata !{metadata !84}
!84 = metadata !{i32 0, i32 0, metadata !85}
!85 = metadata !{metadata !86}
!86 = metadata !{metadata !"out_data.user.V", metadata !41, metadata !"uint1", i32 0, i32 0}
!87 = metadata !{metadata !88}
!88 = metadata !{i32 0, i32 0, metadata !89}
!89 = metadata !{metadata !90}
!90 = metadata !{metadata !"out_data.last.V", metadata !41, metadata !"uint1", i32 0, i32 0}
!91 = metadata !{metadata !92}
!92 = metadata !{i32 0, i32 0, metadata !93}
!93 = metadata !{metadata !94}
!94 = metadata !{metadata !"out_data.id.V", metadata !41, metadata !"uint1", i32 0, i32 0}
!95 = metadata !{metadata !96}
!96 = metadata !{i32 0, i32 0, metadata !97}
!97 = metadata !{metadata !98}
!98 = metadata !{metadata !"out_data.dest.V", metadata !41, metadata !"uint1", i32 0, i32 0}
!99 = metadata !{metadata !100}
!100 = metadata !{i32 0, i32 31, metadata !101}
!101 = metadata !{metadata !102}
!102 = metadata !{metadata !"constant.V", metadata !103, metadata !"int32", i32 0, i32 31}
!103 = metadata !{metadata !104}
!104 = metadata !{i32 0, i32 0, i32 0}
