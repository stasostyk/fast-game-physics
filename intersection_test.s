###################################################
# Tests the square intersection algorithm.        #
# Desired output is 1001 (1=intersects, 0=doesn't #
###################################################

.data

  pointsA:
          .long   0
          .long   0
          .long   1073741824
          .long   0
          .long   0
          .long   1073741824
          .long   1073741824
          .long   1073741824
  pointsB:
          .long   1065353216
          .long   1065353216
          .long   1065353216
          .long   1073741824
          .long   1077936128
          .long   1077936128
          .long   1077936128
          .long   1077936128

  pointsC:
          .long   0
          .long   0
          .long   1065353216
          .long   0
          .long   1065353216
          .long   1065353216
          .long   0
          .long   1065353216
  pointsD:
          .long   1073741824
          .long   0
          .long   1073741824
          .long   1065353216
          .long   1077936128
          .long   1065353216
          .long   1077936128
          .long   0

  pointsE:
          .long   1073741824
          .long   0
          .long   1073741824
          .long   1065353216
          .long   1077936128
          .long   1065353216
          .long   1077936128
          .long   0
  pointsF:
          .long   0
          .long   0
          .long   1065353216
          .long   0
          .long   1065353216
          .long   1065353216
          .long   0
          .long   1065353216
  pointsG:
          .long   1065353216
          .long   1065353216
          .long   1065353216
          .long   1077936128
          .long   1077936128
          .long   1077936128
          .long   1077936128
          .long   1065353216
  pointsH:
          .long   0
          .long   0
          .long   1073741824
          .long   0
          .long   1073741824
          .long   1073741824
          .long   0
          .long   1073741824

  formatString:
          .string "%d"
.text
.global main

main:
        pushq   %rbp
        movq    %rsp, %rbp

        movq    $pointsB, %rsi
        movq    $pointsA, %rdi
        call    intersectingSquares

        movl    %eax, %esi
        movl    $formatString, %edi
        movl    $0, %eax
        call    printf


        movq    $pointsD, %rsi
        movq    $pointsC, %rdi
        call    intersectingSquares

        movl    %eax, %esi
        movl    $formatString, %edi
        movl    $0, %eax
        call    printf


        movq    $pointsF, %rsi
        movq    $pointsE, %rdi
        call    intersectingSquares

        movl    %eax, %esi
        movl    $formatString, %edi
        movl    $0, %eax
        call    printf


        movq    $pointsH, %rsi
        movq    $pointsG, %rdi
        call    intersectingSquares

        movl    %eax, %esi
        movl    $formatString, %edi
        movl    $0, %eax
        call    printf

        movq %rbp, %rsp
        popq %rbp

        ret
