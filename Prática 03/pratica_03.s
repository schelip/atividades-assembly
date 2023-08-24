.section .data
    saida: .asciz "Soma: %d + %d - %d + %d - %d = %d\n"
    n1: .int 10
    n2: .int 25
    n3: .int 5
    n4: .int 8
    n5: .int 4
    v1: .int 10, 25, 5, 8, 4

.section .bss
    .lcomm res, 4

.section .text
.globl _start
_start:
    movl n1, %eax
    addl n2, %eax
    subl n3, %eax
    addl n4, %eax
    subl n5, %eax
    movl %eax, res

    pushl res
    pushl n5
    pushl n4
    pushl n3
    pushl n2
    push n1
    pushl $saida
    call printf
    addl $20, %esp

    movl $v1, %edi
    movl (%edi), %eax # n1
    addl $4, %edi
    addl (%edi), %eax # n1 + n2
    addl $4, %edi
    subl (%edi), %eax # n1 + n2 - n3
    addl $4, %edi
    addl (%edi), %eax # n1 + n2 - n3 + n4
    addl $4, %edi
    subl (%edi), %eax # n1 + n2 - n3 + n4 - n5
    movl %eax, res

    pushl res
    pushl n5
    pushl n4
    pushl n3
    pushl n2
    pushl n1
    pushl $saida
    call printf
    pushl $0
    call exit
    