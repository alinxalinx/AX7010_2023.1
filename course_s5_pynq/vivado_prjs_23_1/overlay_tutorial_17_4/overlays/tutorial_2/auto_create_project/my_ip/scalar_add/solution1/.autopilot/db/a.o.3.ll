; ModuleID = 'D:/test/overlay_tutorial_17_4/ip/scalar_add/solution1/.autopilot/db/a.o.3.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-w64-mingw32"

@add_str = internal unnamed_addr constant [4 x i8] c"add\00" ; [#uses=1 type=[4 x i8]*]
@p_str2 = private unnamed_addr constant [10 x i8] c"s_axilite\00", align 1 ; [#uses=3 type=[10 x i8]*]
@p_str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=24 type=[1 x i8]*]
@p_str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1 ; [#uses=1 type=[13 x i8]*]

; [#uses=5]
declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

; [#uses=0]
define void @add(i32 %a, i32 %b, i32* %c) nounwind uwtable {
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %a) nounwind, !map !7
  call void (...)* @_ssdm_op_SpecBitsMap(i32 %b) nounwind, !map !13
  call void (...)* @_ssdm_op_SpecBitsMap(i32* %c) nounwind, !map !17
  call void (...)* @_ssdm_op_SpecTopModule([4 x i8]* @add_str) nounwind
  %b_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %b) nounwind ; [#uses=1 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %b_read}, i64 0, metadata !23), !dbg !32 ; [debug line = 3:21] [debug variable = b]
  %a_read = call i32 @_ssdm_op_Read.s_axilite.i32(i32 %a) nounwind ; [#uses=1 type=i32]
  call void @llvm.dbg.value(metadata !{i32 %a_read}, i64 0, metadata !33), !dbg !34 ; [debug line = 3:14] [debug variable = a]
  call void @llvm.dbg.value(metadata !{i32 %a}, i64 0, metadata !33), !dbg !34 ; [debug line = 3:14] [debug variable = a]
  call void @llvm.dbg.value(metadata !{i32 %b}, i64 0, metadata !23), !dbg !32 ; [debug line = 3:21] [debug variable = b]
  call void @llvm.dbg.value(metadata !{i32* %c}, i64 0, metadata !35), !dbg !36 ; [debug line = 3:29] [debug variable = c]
  call void (...)* @_ssdm_op_SpecInterface(i32 0, [13 x i8]* @p_str, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !37 ; [debug line = 4:1]
  call void (...)* @_ssdm_op_SpecInterface(i32 %a, [10 x i8]* @p_str2, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !39 ; [debug line = 5:1]
  call void (...)* @_ssdm_op_SpecInterface(i32 %b, [10 x i8]* @p_str2, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !40 ; [debug line = 6:1]
  call void (...)* @_ssdm_op_SpecInterface(i32* %c, [10 x i8]* @p_str2, i32 0, i32 0, [1 x i8]* @p_str1, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1, [1 x i8]* @p_str1, i32 0, i32 0, i32 0, i32 0, [1 x i8]* @p_str1, [1 x i8]* @p_str1) nounwind, !dbg !41 ; [debug line = 7:1]
  %c_assign = add nsw i32 %b_read, %a_read, !dbg !42 ; [#uses=1 type=i32] [debug line = 9:2]
  call void @_ssdm_op_Write.s_axilite.i32P(i32* %c, i32 %c_assign) nounwind, !dbg !42 ; [debug line = 9:2]
  ret void, !dbg !43                              ; [debug line = 10:1]
}

; [#uses=1]
define weak void @_ssdm_op_Write.s_axilite.i32P(i32*, i32) {
entry:
  store i32 %1, i32* %0
  ret void
}

; [#uses=1]
define weak void @_ssdm_op_SpecTopModule(...) {
entry:
  ret void
}

; [#uses=4]
define weak void @_ssdm_op_SpecInterface(...) nounwind {
entry:
  ret void
}

; [#uses=3]
define weak void @_ssdm_op_SpecBitsMap(...) {
entry:
  ret void
}

; [#uses=2]
define weak i32 @_ssdm_op_Read.s_axilite.i32(i32) {
entry:
  ret i32 %0
}

!opencl.kernels = !{!0}
!hls.encrypted.func = !{}
!llvm.map.gv = !{}

!0 = metadata !{void (i32, i32, i32*)* @add, metadata !1, metadata !2, metadata !3, metadata !4, metadata !5, metadata !6}
!1 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0, i32 0}
!2 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!3 = metadata !{metadata !"kernel_arg_type", metadata !"int", metadata !"int", metadata !"int &"}
!4 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !""}
!5 = metadata !{metadata !"kernel_arg_name", metadata !"a", metadata !"b", metadata !"c"}
!6 = metadata !{metadata !"reqd_work_group_size", i32 1, i32 1, i32 1}
!7 = metadata !{metadata !8}
!8 = metadata !{i32 0, i32 31, metadata !9}
!9 = metadata !{metadata !10}
!10 = metadata !{metadata !"a", metadata !11, metadata !"int", i32 0, i32 31}
!11 = metadata !{metadata !12}
!12 = metadata !{i32 0, i32 0, i32 0}
!13 = metadata !{metadata !14}
!14 = metadata !{i32 0, i32 31, metadata !15}
!15 = metadata !{metadata !16}
!16 = metadata !{metadata !"b", metadata !11, metadata !"int", i32 0, i32 31}
!17 = metadata !{metadata !18}
!18 = metadata !{i32 0, i32 31, metadata !19}
!19 = metadata !{metadata !20}
!20 = metadata !{metadata !"c", metadata !21, metadata !"int", i32 0, i32 31}
!21 = metadata !{metadata !22}
!22 = metadata !{i32 0, i32 0, i32 1}
!23 = metadata !{i32 786689, metadata !24, metadata !"b", metadata !25, i32 33554435, metadata !28, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!24 = metadata !{i32 786478, i32 0, metadata !25, metadata !"add", metadata !"add", metadata !"_Z3addiiRi", metadata !25, i32 3, metadata !26, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32, i32, i32*)* @add, null, null, metadata !30, i32 3} ; [ DW_TAG_subprogram ]
!25 = metadata !{i32 786473, metadata !"scalar_add/add.cpp", metadata !"D:\5Ctest\5Coverlay_tutorial_17_4\5Cip", null} ; [ DW_TAG_file_type ]
!26 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !27, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!27 = metadata !{null, metadata !28, metadata !28, metadata !29}
!28 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!29 = metadata !{i32 786448, null, null, null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !28} ; [ DW_TAG_reference_type ]
!30 = metadata !{metadata !31}
!31 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!32 = metadata !{i32 3, i32 21, metadata !24, null}
!33 = metadata !{i32 786689, metadata !24, metadata !"a", metadata !25, i32 16777219, metadata !28, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!34 = metadata !{i32 3, i32 14, metadata !24, null}
!35 = metadata !{i32 786689, metadata !24, metadata !"c", metadata !25, i32 50331651, metadata !29, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!36 = metadata !{i32 3, i32 29, metadata !24, null}
!37 = metadata !{i32 4, i32 1, metadata !38, null}
!38 = metadata !{i32 786443, metadata !24, i32 3, i32 32, metadata !25, i32 0} ; [ DW_TAG_lexical_block ]
!39 = metadata !{i32 5, i32 1, metadata !38, null}
!40 = metadata !{i32 6, i32 1, metadata !38, null}
!41 = metadata !{i32 7, i32 1, metadata !38, null}
!42 = metadata !{i32 9, i32 2, metadata !38, null}
!43 = metadata !{i32 10, i32 1, metadata !38, null}
