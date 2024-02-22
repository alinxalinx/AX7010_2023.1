; ModuleID = 'D:/test/overlay_tutorial_17_4/ip/scalar_add/solution1/.autopilot/db/a.o.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-w64-mingw32"

@.str = private unnamed_addr constant [13 x i8] c"ap_ctrl_none\00", align 1 ; [#uses=1 type=[13 x i8]*]
@.str1 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1 ; [#uses=1 type=[1 x i8]*]
@.str2 = private unnamed_addr constant [10 x i8] c"s_axilite\00", align 1 ; [#uses=1 type=[10 x i8]*]

; [#uses=0]
define void @_Z3addiiRi(i32 %a, i32 %b, i32* %c) nounwind uwtable {
  %1 = alloca i32, align 4                        ; [#uses=3 type=i32*]
  %2 = alloca i32, align 4                        ; [#uses=3 type=i32*]
  %3 = alloca i32*, align 8                       ; [#uses=3 type=i32**]
  store i32 %a, i32* %1, align 4
  call void @llvm.dbg.declare(metadata !{i32* %1}, metadata !20), !dbg !21 ; [debug line = 3:14] [debug variable = a]
  store i32 %b, i32* %2, align 4
  call void @llvm.dbg.declare(metadata !{i32* %2}, metadata !22), !dbg !23 ; [debug line = 3:21] [debug variable = b]
  store i32* %c, i32** %3, align 8
  call void @llvm.dbg.declare(metadata !{i32** %3}, metadata !24), !dbg !25 ; [debug line = 3:29] [debug variable = c]
  call void (...)* @_ssdm_op_SpecInterface(i32 0, i8* getelementptr inbounds ([13 x i8]* @.str, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i32 0, i32 0, i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0)) nounwind, !dbg !26 ; [debug line = 4:1]
  %4 = load i32* %1, align 4, !dbg !28            ; [#uses=1 type=i32] [debug line = 5:1]
  call void (...)* @_ssdm_op_SpecInterface(i32 %4, i8* getelementptr inbounds ([10 x i8]* @.str2, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i32 0, i32 0, i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0)) nounwind, !dbg !28 ; [debug line = 5:1]
  %5 = load i32* %2, align 4, !dbg !29            ; [#uses=1 type=i32] [debug line = 6:1]
  call void (...)* @_ssdm_op_SpecInterface(i32 %5, i8* getelementptr inbounds ([10 x i8]* @.str2, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i32 0, i32 0, i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0)) nounwind, !dbg !29 ; [debug line = 6:1]
  %6 = load i32** %3, align 8, !dbg !30           ; [#uses=1 type=i32*] [debug line = 7:1]
  %7 = load i32* %6, align 4, !dbg !30            ; [#uses=1 type=i32] [debug line = 7:1]
  call void (...)* @_ssdm_op_SpecInterface(i32 %7, i8* getelementptr inbounds ([10 x i8]* @.str2, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i32 0, i32 0, i32 0, i32 0, i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8]* @.str1, i32 0, i32 0)) nounwind, !dbg !30 ; [debug line = 7:1]
  %8 = load i32* %1, align 4, !dbg !31            ; [#uses=1 type=i32] [debug line = 9:2]
  %9 = load i32* %2, align 4, !dbg !31            ; [#uses=1 type=i32] [debug line = 9:2]
  %10 = add nsw i32 %8, %9, !dbg !31              ; [#uses=1 type=i32] [debug line = 9:2]
  %11 = load i32** %3, align 8, !dbg !31          ; [#uses=1 type=i32*] [debug line = 9:2]
  store i32 %10, i32* %11, align 4, !dbg !31      ; [debug line = 9:2]
  ret void, !dbg !32                              ; [debug line = 10:1]
}

; [#uses=3]
declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

; [#uses=4]
declare void @_ssdm_op_SpecInterface(...) nounwind

!llvm.dbg.cu = !{!0}
!opencl.kernels = !{!13}
!hls.encrypted.func = !{}

!0 = metadata !{i32 786449, i32 0, i32 4, metadata !"D:/test/overlay_tutorial_17_4/ip/scalar_add/solution1/.autopilot/db/add.pragma.2.cpp", metadata !"D:\5Ctest\5Coverlay_tutorial_17_4\5Cip", metadata !"clang version 3.1 ", i1 true, i1 false, metadata !"", i32 0, metadata !1, metadata !1, metadata !3, metadata !1} ; [ DW_TAG_compile_unit ]
!1 = metadata !{metadata !2}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{metadata !5}
!5 = metadata !{i32 786478, i32 0, metadata !6, metadata !"add", metadata !"add", metadata !"_Z3addiiRi", metadata !6, i32 3, metadata !7, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32, i32, i32*)* @_Z3addiiRi, null, null, metadata !11, i32 3} ; [ DW_TAG_subprogram ]
!6 = metadata !{i32 786473, metadata !"scalar_add/add.cpp", metadata !"D:\5Ctest\5Coverlay_tutorial_17_4\5Cip", null} ; [ DW_TAG_file_type ]
!7 = metadata !{i32 786453, i32 0, metadata !"", i32 0, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !8, i32 0, i32 0} ; [ DW_TAG_subroutine_type ]
!8 = metadata !{null, metadata !9, metadata !9, metadata !10}
!9 = metadata !{i32 786468, null, metadata !"int", null, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 786448, null, null, null, i32 0, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_reference_type ]
!11 = metadata !{metadata !12}
!12 = metadata !{i32 786468}                      ; [ DW_TAG_base_type ]
!13 = metadata !{void (i32, i32, i32*)* @_Z3addiiRi, metadata !14, metadata !15, metadata !16, metadata !17, metadata !18, metadata !19}
!14 = metadata !{metadata !"kernel_arg_addr_space", i32 0, i32 0, i32 0}
!15 = metadata !{metadata !"kernel_arg_access_qual", metadata !"none", metadata !"none", metadata !"none"}
!16 = metadata !{metadata !"kernel_arg_type", metadata !"int", metadata !"int", metadata !"int &"}
!17 = metadata !{metadata !"kernel_arg_type_qual", metadata !"", metadata !"", metadata !""}
!18 = metadata !{metadata !"kernel_arg_name", metadata !"a", metadata !"b", metadata !"c"}
!19 = metadata !{metadata !"reqd_work_group_size", i32 1, i32 1, i32 1}
!20 = metadata !{i32 786689, metadata !5, metadata !"a", metadata !6, i32 16777219, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!21 = metadata !{i32 3, i32 14, metadata !5, null}
!22 = metadata !{i32 786689, metadata !5, metadata !"b", metadata !6, i32 33554435, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!23 = metadata !{i32 3, i32 21, metadata !5, null}
!24 = metadata !{i32 786689, metadata !5, metadata !"c", metadata !6, i32 50331651, metadata !10, i32 0, i32 0} ; [ DW_TAG_arg_variable ]
!25 = metadata !{i32 3, i32 29, metadata !5, null}
!26 = metadata !{i32 4, i32 1, metadata !27, null}
!27 = metadata !{i32 786443, metadata !5, i32 3, i32 32, metadata !6, i32 0} ; [ DW_TAG_lexical_block ]
!28 = metadata !{i32 5, i32 1, metadata !27, null}
!29 = metadata !{i32 6, i32 1, metadata !27, null}
!30 = metadata !{i32 7, i32 1, metadata !27, null}
!31 = metadata !{i32 9, i32 2, metadata !27, null}
!32 = metadata !{i32 10, i32 1, metadata !27, null}
