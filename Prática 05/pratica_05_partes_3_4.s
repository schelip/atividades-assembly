.section .data
    saida: .asciz "Teste %d: Resultado = Hex: %X Dec: %d\n\n"
    saida2: .asciz "Teste %d: Quoc > Hex: %X Dec: %d e Resto > Hex: %X Dec: %d\n\n"
    saida3: .asciz "Teste %d: Resultado = Hex: %X:%X\n\n"

.section .text
.globl _start
_start:
    _teste17:
    movl $0xA4, %eax
    incl %eax # %eax ← %eax + 1
    incw %ax # %ax ← %ax + 1
    incb %al # %al ← %al + 1
    pushl %eax
    pushl %eax
    pushl $17
    pushl $saida
    call printf

    _teste18:
    movl $0xA4, %eax
    decl %eax # %eax ← %eax - 1
    decw %ax # %ax ← %ax - 1
    decb %al # %al ← %al - 1
    pushl %eax
    pushl %eax
    pushl $18
    pushl $saida
    call printf

    _teste19:
    movl $0x0000A4C8, %edx
    movl $0x00001234, %eax
    movl $0xA4C80, %ebx
    divl %ebx # %eax ← %edx:%eax / %ebx
    pushl %edx
    pushl %edx
    pushl %eax
    pushl %eax
    pushl $19
    pushl $saida2
    call printf

    _teste20:
    movl $0x0000A4C8, %edx
    movl $0x00001234, %eax
    movl $-0xA4C80, %ebx
    idivl %ebx # %eax ← %edx:%eax / %ebx
    pushl %edx
    pushl %edx
    pushl %eax
    pushl %eax
    pushl $20
    pushl $saida2
    call printf

    _teste21:
    movl $-0x0000A4C8, %edx
    subl $1, %edx # anulamos o cp2 e apenas mantemos o cp1
    movl $-0x00001234, %eax
    movl $0xA4C80, %ebx
    idivl %ebx # %eax ← %edx:%eax / %ebx
    pushl %edx
    pushl %edx
    pushl %eax
    pushl %eax
    pushl $21
    pushl $saida2
    call printf

    _teste27:
    movl $0x1, %eax
    negl %eax 
    movl $0x2, %ebx
    mull %ebx # %edx:%eax ← %eax * %ebx
    pushl %eax
    pushl %edx
    pushl $27
    pushl $saida3
    call printf

    _teste28:
    movl $0, %edx # apenas para limpar antes
    movl $0, %eax # apenas para limpar antes
    movw $0x1, %ax
    negw %ax
    movw $0x2, %bx
    mulw %bx # %dx:%ax ← %ax * %bx
    pushl %eax
    pushl %edx
    pushl $28
    pushl $saida3
    call printf

    _teste29:
    movl $0, %edx # apenas para limpar antes
    movl $0, %eax # apenas para limpar antes
    movb $0x1, %al
    negb %al
    movb $0x2, %bl
    mulb %bl # %ah:%al ← %al * %bl
    pushl %eax
    pushl %eax
    pushl $29
    pushl $saida
    call printf
