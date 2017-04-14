; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512F

define i32 @sad8_32bit_icmp_sge(i8* nocapture readonly %cur, i8* nocapture readonly %ref, i32 %stride) local_unnamed_addr #0 {
; SSE2-LABEL: sad8_32bit_icmp_sge:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: sad8_32bit_icmp_sge:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: sad8_32bit_icmp_sge:
; AVX512F:       # BB#0: # %entry
; AVX512F-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512F-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512F-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    vmovd %xmm0, %eax
; AVX512F-NEXT:    retq

entry:
  %idx.ext = zext i32 %stride to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = bitcast i8* %cur to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i32>
  %3 = bitcast i8* %ref to <8 x i8>*
  %4 = load <8 x i8>, <8 x i8>* %3, align 1
  %5 = zext <8 x i8> %4 to <8 x i32>
  %6 = sub nsw <8 x i32> %2, %5
  %7 = icmp sgt <8 x i32> %6, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %6, <8 x i32> %8
  %rdx.shuf = shufflevector <8 x i32> %9, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %9, %rdx.shuf
  %rdx.shuf229 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx230 = add <8 x i32> %bin.rdx, %rdx.shuf229
  %rdx.shuf231 = shufflevector <8 x i32> %bin.rdx230, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx232 = add <8 x i32> %bin.rdx230, %rdx.shuf231
  %10 = extractelement <8 x i32> %bin.rdx232, i32 0
  ret i32 %10
}

define i32 @sad8_32bit_icmp_sgt(i8* nocapture readonly %cur, i8* nocapture readonly %ref, i32 %stride) local_unnamed_addr #1 {
; SSE2-LABEL: sad8_32bit_icmp_sgt:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: sad8_32bit_icmp_sgt:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: sad8_32bit_icmp_sgt:
; AVX512F:       # BB#0: # %entry
; AVX512F-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512F-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512F-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    vmovd %xmm0, %eax
; AVX512F-NEXT:    retq
entry:
  %idx.ext = zext i32 %stride to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = bitcast i8* %cur to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i32>
  %3 = bitcast i8* %ref to <8 x i8>*
  %4 = load <8 x i8>, <8 x i8>* %3, align 1
  %5 = zext <8 x i8> %4 to <8 x i32>
  %6 = sub nsw <8 x i32> %2, %5
  %7 = icmp sgt <8 x i32> %6, zeroinitializer
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %6, <8 x i32> %8
  %rdx.shuf = shufflevector <8 x i32> %9, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %9, %rdx.shuf
  %rdx.shuf229 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx230 = add <8 x i32> %bin.rdx, %rdx.shuf229
  %rdx.shuf231 = shufflevector <8 x i32> %bin.rdx230, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx232 = add <8 x i32> %bin.rdx230, %rdx.shuf231
  %10 = extractelement <8 x i32> %bin.rdx232, i32 0
  ret i32 %10
}

define i32 @sad8_32bit_icmp_sle(i8* nocapture readonly %cur, i8* nocapture readonly %ref, i32 %stride) local_unnamed_addr #2 {
; SSE2-LABEL: sad8_32bit_icmp_sle:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: sad8_32bit_icmp_sle:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: sad8_32bit_icmp_sle:
; AVX512F:       # BB#0: # %entry
; AVX512F-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512F-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512F-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    vmovd %xmm0, %eax
; AVX512F-NEXT:    retq
entry:
  %idx.ext = zext i32 %stride to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = bitcast i8* %cur to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i32>
  %3 = bitcast i8* %ref to <8 x i8>*
  %4 = load <8 x i8>, <8 x i8>* %3, align 1
  %5 = zext <8 x i8> %4 to <8 x i32>
  %6 = sub nsw <8 x i32> %2, %5
  %7 = icmp slt <8 x i32> %6, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %8, <8 x i32> %6
  %rdx.shuf = shufflevector <8 x i32> %9, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %9, %rdx.shuf
  %rdx.shuf229 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx230 = add <8 x i32> %bin.rdx, %rdx.shuf229
  %rdx.shuf231 = shufflevector <8 x i32> %bin.rdx230, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx232 = add <8 x i32> %bin.rdx230, %rdx.shuf231
  %10 = extractelement <8 x i32> %bin.rdx232, i32 0
  ret i32 %10
}

define i32 @sad8_32bit_icmp_slt(i8* nocapture readonly %cur, i8* nocapture readonly %ref, i32 %stride) local_unnamed_addr #3 {
; SSE2-LABEL: sad8_32bit_icmp_slt:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %eax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: sad8_32bit_icmp_slt:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vmovd %xmm0, %eax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: sad8_32bit_icmp_slt:
; AVX512F:       # BB#0: # %entry
; AVX512F-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512F-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512F-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    vmovd %xmm0, %eax
; AVX512F-NEXT:    retq
entry:
  %idx.ext = zext i32 %stride to i64
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = bitcast i8* %cur to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i32>
  %3 = bitcast i8* %ref to <8 x i8>*
  %4 = load <8 x i8>, <8 x i8>* %3, align 1
  %5 = zext <8 x i8> %4 to <8 x i32>
  %6 = sub nsw <8 x i32> %2, %5
  %7 = icmp slt <8 x i32> %6, zeroinitializer
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %8, <8 x i32> %6
  %rdx.shuf = shufflevector <8 x i32> %9, <8 x i32> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i32> %9, %rdx.shuf
  %rdx.shuf229 = shufflevector <8 x i32> %bin.rdx, <8 x i32> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx230 = add <8 x i32> %bin.rdx, %rdx.shuf229
  %rdx.shuf231 = shufflevector <8 x i32> %bin.rdx230, <8 x i32> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx232 = add <8 x i32> %bin.rdx230, %rdx.shuf231
  %10 = extractelement <8 x i32> %bin.rdx232, i32 0
  ret i32 %10
}

define i64 @sad8_64bit_icmp_sext_slt(i8* nocapture readonly %cur, i8* nocapture readonly %ref, i64 %stride) local_unnamed_addr #4 {
; SSE2-LABEL: sad8_64bit_icmp_sext_slt:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %rax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: sad8_64bit_icmp_sext_slt:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vmovq %xmm0, %rax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: sad8_64bit_icmp_sext_slt:
; AVX512F:       # BB#0: # %entry
; AVX512F-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512F-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512F-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    vmovq %xmm0, %rax
; AVX512F-NEXT:    retq
entry:
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = bitcast i8* %cur to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i32>
  %3 = bitcast i8* %ref to <8 x i8>*
  %4 = load <8 x i8>, <8 x i8>* %3, align 1
  %5 = zext <8 x i8> %4 to <8 x i32>
  %6 = sub nsw <8 x i32> %2, %5
  %7 = icmp slt <8 x i32> %6, zeroinitializer
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %8, <8 x i32> %6
  %10 = sext <8 x i32> %9 to <8 x i64>
  %rdx.shuf = shufflevector <8 x i64> %10, <8 x i64> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i64> %rdx.shuf, %10
  %rdx.shuf236 = shufflevector <8 x i64> %bin.rdx, <8 x i64> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx237 = add <8 x i64> %bin.rdx, %rdx.shuf236
  %rdx.shuf238 = shufflevector <8 x i64> %bin.rdx237, <8 x i64> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx239 = add <8 x i64> %bin.rdx237, %rdx.shuf238
  %11 = extractelement <8 x i64> %bin.rdx239, i32 0
  ret i64 %11
}

define i64 @sad8_64bit_icmp_zext_slt(i8* nocapture readonly %cur, i8* nocapture readonly %ref, i64 %stride) local_unnamed_addr #4 {
; SSE2-LABEL: sad8_64bit_icmp_zext_slt:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %rax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: sad8_64bit_icmp_zext_slt:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vmovq %xmm0, %rax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: sad8_64bit_icmp_zext_slt:
; AVX512F:       # BB#0: # %entry
; AVX512F-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512F-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512F-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    vmovq %xmm0, %rax
; AVX512F-NEXT:    retq
entry:
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = bitcast i8* %cur to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i32>
  %3 = bitcast i8* %ref to <8 x i8>*
  %4 = load <8 x i8>, <8 x i8>* %3, align 1
  %5 = zext <8 x i8> %4 to <8 x i32>
  %6 = sub nsw <8 x i32> %2, %5
  %7 = icmp slt <8 x i32> %6, zeroinitializer
  %8 = sub nsw <8 x i32> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i32> %8, <8 x i32> %6
  %10 = zext <8 x i32> %9 to <8 x i64>
  %rdx.shuf = shufflevector <8 x i64> %10, <8 x i64> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i64> %rdx.shuf, %10
  %rdx.shuf236 = shufflevector <8 x i64> %bin.rdx, <8 x i64> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx237 = add <8 x i64> %bin.rdx, %rdx.shuf236
  %rdx.shuf238 = shufflevector <8 x i64> %bin.rdx237, <8 x i64> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx239 = add <8 x i64> %bin.rdx237, %rdx.shuf238
  %11 = extractelement <8 x i64> %bin.rdx239, i32 0
  ret i64 %11
}

define i64 @sad8_early_64bit_icmp_zext_slt(i8* nocapture readonly %cur, i8* nocapture readonly %ref, i64 %stride) local_unnamed_addr #4 {
; SSE2-LABEL: sad8_early_64bit_icmp_zext_slt:
; SSE2:       # BB#0: # %entry
; SSE2-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE2-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE2-NEXT:    psadbw %xmm0, %xmm1
; SSE2-NEXT:    movd %xmm1, %rax
; SSE2-NEXT:    retq
;
; AVX2-LABEL: sad8_early_64bit_icmp_zext_slt:
; AVX2:       # BB#0: # %entry
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX2-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX2-NEXT:    vmovq %xmm0, %rax
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: sad8_early_64bit_icmp_zext_slt:
; AVX512F:       # BB#0: # %entry
; AVX512F-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512F-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; AVX512F-NEXT:    vpsadbw %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    vmovq %xmm0, %rax
; AVX512F-NEXT:    retq
entry:
  br label %for.body

for.body:                                         ; preds = %entry
  %0 = bitcast i8* %cur to <8 x i8>*
  %1 = load <8 x i8>, <8 x i8>* %0, align 1
  %2 = zext <8 x i8> %1 to <8 x i64>
  %3 = bitcast i8* %ref to <8 x i8>*
  %4 = load <8 x i8>, <8 x i8>* %3, align 1
  %5 = zext <8 x i8> %4 to <8 x i64>
  %6 = sub nsw <8 x i64> %2, %5
  %7 = icmp slt <8 x i64> %6, zeroinitializer
  %8 = sub nsw <8 x i64> zeroinitializer, %6
  %9 = select <8 x i1> %7, <8 x i64> %8, <8 x i64> %6
  %rdx.shuf = shufflevector <8 x i64> %9, <8 x i64> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx = add <8 x i64> %rdx.shuf, %9
  %rdx.shuf236 = shufflevector <8 x i64> %bin.rdx, <8 x i64> undef, <8 x i32> <i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx237 = add <8 x i64> %bin.rdx, %rdx.shuf236
  %rdx.shuf238 = shufflevector <8 x i64> %bin.rdx237, <8 x i64> undef, <8 x i32> <i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %bin.rdx239 = add <8 x i64> %bin.rdx237, %rdx.shuf238
  %10 = extractelement <8 x i64> %bin.rdx239, i32 0
  ret i64 %10
}
