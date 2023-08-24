.section .data
    saida: .asciz "Teste %d: O valor do registrador é: %X\n\n"
    saida2: .asciz "Teste %d: Os valores dos registradores sao: %X e %X\n\n"
    saida3: .asciz "Teste %d:\n EAX = %X\n EBX = %X\n ECX = %X\n EDX = %X\n ESI = %X\n EDI = %X\n\n"
    saidaOpcional: .asciz "Teste opcional: O valor do registrador é: %d\n\n"
    perguntaValor: .asciz "\nDigite o valor: "
    perguntaN: .asciz "\nDigite n: "
    resultadoSoma: .asciz "\nO valor da soma é: %d\n"
    formato: .asciz "%d"
    valor: .int 0
    n: .int 0

.section .text
.globl _start
_start:
_teste1:
    movl    $0x12345678, %ebx
    pushl   %ebx
    pushl   $1
    pushl   $saida
    call    printf

_teste2:
    movw    $0xABCD, %bx
    pushl   %ebx
    pushl   $2
    pushl   $saida
    call    printf

_teste3:
    movb    $0xEE, %bh
    movb    $0xFF, %bl
    pushl   %ebx
    pushl   $3
    pushl   $saida
    call    printf

    addl    $36, %esp   # desfazendo todos os últimos 9 pushs
                        # para limpar a pilha

_teste4:
    movl $0xAAAAAAAA, %eax
    movl $0xBBBBBBBB, %ebx
    movl $0xCCCCCCCC, %ecx
    movl $0xDDDDDDDD, %edx
    movl $0xEEEEEEEE, %esi
    movl $0xFFFFFFFF, %edi
    pushl %edi
    pushl %esi
    pushl %edx
    pushl %ecx
    pushl %ebx
    pushl %eax
    pushl $4
    pushl $saida3
    call printf

_teste5:
    pushl %edi
    pushl %esi
    pushl %edx
    pushl %ecx
    pushl %ebx
    pushl %eax
    pushl $5
    pushl $saida3
    call printf
    addl $40, %esp  # desempilha os últimos 10 pushs
                    # para liberar os registradores backupeados

_teste6:
    popl %eax
    popl %ebx
    popl %ecx
    popl %edx
    popl %esi
    popl %edi
    pushl %edi
    pushl %esi
    pushl %edx
    pushl %ecx
    pushl %ebx
    pushl %eax
    pushl $6
    pushl $saida3
    call printf
    addl $32, %esp # desempilha os 8 últimos pushs                  

_teste7:
    movl $0x12345678, %eax
    roll $16, %eax  # 56781234
    rolw $8, %ax    # 56783412
    rolb $4, %al    # 56783421
    pushl %eax
    pushl $7
    pushl $saida
    call printf

_teste8:
    movl $0x12345678, %eax
    roll $8, %eax   # 34567812
    rolw $4, %ax    # 34568127
    rolb $4, %al    # 34568172
    pushl %eax
    pushl $8
    pushl $saida
    call printf
    addl $24, %esp # desempilha os 6 últimos pushs

_teste9:
    movl $0x12345678, %eax
    rorl $16, %eax  # 56781234
    rorw $8, %ax    # 56783412
    rorb $4, %al    # 56783421
    pushl %eax
    pushl $9
    pushl $saida
    call printf

_teste10:
    movl $0x12345678, %eax
    rorl $8, %eax   # 78123456
    rorw $4, %ax    # 78126345
    rorb $4, %al    # 78126354
    pushl %eax
    pushl $10
    pushl $saida
    call printf
    addl $24, %esp  # desempilha os 6 últimos pushs

_teste11:
    movl $0x12345678, %eax
    salb $4, %al    # 12345680
    salw $8, %ax    # 12348000
    sall $16, %eax  # 80000000
    pushl %eax
    pushl $11
    pushl $saida
    call printf

_teste12:
    movl $0x12345678, %eax
    salb $4, %al    # 12345680
    salw $4, %ax    # 12346800
    sall $8, %eax   # 34680000
    pushl %eax
    pushl $12
    pushl $saida
    call printf
    addl $24, %esp  # desempilha os 6 últimos pushs

_teste13:
    movl $0x12345678, %eax
    sarl $16, %eax  # 00001234
    sarw $8, %ax    # 00000012
    sarb $4, %al    # 00000001
    pushl %eax
    pushl $13
    pushl $saida
    call printf

_teste14:
    movl $0x12345678, %eax
    sarl $8, %eax   # 00123456
    sarw $4, %ax    # 00120345
    sarb $4, %al    # 00120304
    pushl %eax
    pushl $14
    pushl $saida
    call printf

_teste15:
    movl $0x12341234, %eax
    movl $0xabcdabcd, %ebx
    xchgb %al, %bl      # 123412cd abcdab34
    xchgw %ax, %bx      # 1234ab34 abcd12cd
    xchgl %eax, %ebx    # abcd12cd 1234ab34

    pushl %ebx
    pushl %eax

    pushl $15
    pushl $saida2
    call printf
    addl $16, %esp # desempilha os 4 últimos pushs

    addl $24, %esp # desempilha os 6 últimos pushs

_opcional:
    _opcional1:         # le o decimal da entrada
    pushl $perguntaValor
    call printf
    pushl $valor
    pushl $formato
    call scanf

    _opcional2:
    movl valor, %eax    # move o dado lido para eax, que será interpretado como a palavra mais a direita
    movl valor, %ebx    # move o dado lido para ebx, e então...
    sarl $16, %ebx          # faz o shift para que ebx contenha a palavra da esquerda
    addw %ax, %bx       # realiza a adição

    _opcional3:         # imprime ebx na tela
    pushl %ebx
    pushl $resultadoSoma
    call printf

    _opcional4:         # le o decimal n da entrada
    pushl $perguntaN
    call printf
    pushl $n
    pushl $formato
    call scanf

    _opcional5:
    movl n, %ecx        # salva n em ecx
    sall %cl, %ebx      # multiplica ebx por 2^n por bitshift, considerando apenas os 8 primeiros bits de n

    _opcional6:         # imprime o resultado na tela
    pushl %ebx
    pushl $saidaOpcional
    call printf

    addl $40, %esp       # desempilha os 10 últimos pushs

    pushl   $0
    call    exit
