###############################################################################
# This subroutine checks if two sets of four vertices (two squares) intersect #
###############################################################################

.global intersectingSquares

# checks if three given vertices are in a clockwise formation or not
ccw:
        pushq   %rbp # prologe
        movq    %rsp, %rbp

        # save all input points A,B,C
        movq    %xmm0, -24(%rbp)
        movq    %xmm1, -32(%rbp)
        movq    %xmm2, -40(%rbp)

        # getting C.y
        movss   -36(%rbp), %xmm0
        # getting A.y
        movss   -20(%rbp), %xmm1

        # subtract C.y-A.y
        subss   %xmm1, %xmm0

        # move the output to stack
        movss   %xmm0, -4(%rbp)
        # getting B.x
        movss   -32(%rbp), %xmm0
        # getting A.x
        movss   -24(%rbp), %xmm1
        # B.x-A.x
        subss   %xmm1, %xmm0

        # multoply both subtractions
        mulss   -4(%rbp), %xmm0
        # save output
        movss   %xmm0, -8(%rbp)

        # getting B.y
        movss   -28(%rbp), %xmm0
        # getting A.y
        movss   -20(%rbp), %xmm1
        # B.y-A.y
        subss   %xmm1, %xmm0
        # store result
        movss   %xmm0, -4(%rbp)

        # get C.x
        movss   -40(%rbp), %xmm0
        # get A.x
        movss   -24(%rbp), %xmm1
        # C.x - A.x
        subss   %xmm1, %xmm0

        # multiply both subtraction
        mulss   -4(%rbp), %xmm0

        # save result
        movss   %xmm0, -12(%rbp)
        movss   -8(%rbp), %xmm0

        # compare single-precision floats
        comiss  -12(%rbp), %xmm0
        # set al to 1 if greater than
        movl $0, %eax
        seta    %al

        popq    %rbp
        ret

# checks if two line segments are intersecting or not
intersect:
    pushq %rbp
    movq %rsp, %rbp

    # r8 = xmm0 = point A
    # r9 = xmm1 = point B
    # r10 = xmm2 = point C
    # r11 = xmm3 = point D

    # first, save to r8-r11
    movq %xmm0, %r8
    movq %xmm1, %r9
    movq %xmm2, %r10
    movq %xmm3, %r11

    # call ccw with A,C,D
    movq %r10, %xmm1
    movq %r11, %xmm2
    movl %eax, %ecx
    call ccw
    # result stored in eax (1 or 0)
    # save to r12d
    movl %eax, %r12d
    
    # call ccw with B,C,D
    movq %r9, %xmm0
    movq %r10, %xmm1
    movq %r11, %xmm2
    call ccw
    # save to ecx
    movl %eax, %ecx

    # compare ccw(A,C,D) and ccw(B,C,D)
    cmpl %r12d, %ecx
    # not equal ? rdx = 1 : rdx = 0
    setne %dl

    # call ccw with A,B,C
    movq %r8, %xmm0
    movq %r9, %xmm1
    movq %r10, %xmm2
    call ccw
    # save to r12d
    movl %eax, %r12d
    
    # call ccw with A,B,D
    movq %r8, %xmm0
    movq %r9, %xmm1
    movq %r11, %xmm2
    call ccw
    # save to ecx
    movl %eax, %ecx

    # compre the two ccw
    # not equal ? rcx = 1 : rdx = 0
    cmpl %r12d, %ecx
    setne %cl

    andb %dl, %cl
    cmpb $0, %cl
    jne notZero
    movl $0, %eax
    jmp zero
    notZero:
        movl $1, %eax
    zero:


    movq %rbp, %rsp
    popq %rbp
    ret

# checks if two squares are intersecting or not
# input: 16 consecutive vertices in {(x1,y1), ...} format stored as longs
# output: al = 1 if intersecting, 0 if not
intersectingSquares:
    pushq %rbp
    movq %rsp, %rbp

    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    movq %rdi, %r14
    movq %rsi, %r15

    movq $0, %r12 # current player vertex
    
    loopThroughPlayerVertices:
        cmpq $4, %r12
        jge endLoopThroughPlayerVertices

        movq $0, %r13 # current obstacle vertex
        loopThroughObstacleVertices:
            cmpq $4, %r13
            je endLoopThroughObstacleVertices

            # point 1
            movq %r12, %r8
            shlq $3, %r8
            addq %r14, %r8
            movq (%r8), %xmm0

            # point 2
            subq %r14, %r8
            shrq $3, %r8
            incq %r8
            # module math: 
            # a % b == a & (b-1)
            # r8 % 4
            andq $3, %r8
            shlq $3, %r8
            addq %r14, %r8
            movq (%r8), %xmm1

            # point 3
            movq %r13, %r8
            shlq $3, %r8
            addq %r15, %r8
            movq (%r8), %xmm2

            # point 4
            subq %r15, %r8
            shrq $3, %r8
            incq %r8
            # module math: 
            # a % b == a & (b-1)
            # r8 % 4
            andq $3, %r8
            shlq $3, %r8
            addq %r15, %r8
            movq (%r8), %xmm3

            # check if they intersect
            pushq %r12
            call intersect
            popq %r12

            # now, if they intersect, 
            # end the program
            cmpl $1, %eax
            je endLoopThroughPlayerVertices

            incq %r13
            jmp loopThroughObstacleVertices
        endLoopThroughObstacleVertices:

        incq %r12
        jmp loopThroughPlayerVertices 
    endLoopThroughPlayerVertices:

    popq %r15
    popq %r14
    popq %r13
    popq %r12

    movq %rbp, %rsp
    popq %rbp
    ret
