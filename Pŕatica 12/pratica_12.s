#Douglas Kenji Sakakibara RA117741
#Felipe Gabriel Comin Scheffel RA117306
.section .data
    filename: .asciz "leitura.txt"
    filewrite: .asciz "escrita.txt"
.section .bss
    .lcomm buffer, 10
    .lcomm infilehandle, 4
    .lcomm outfilehandle, 4
.section .text
.globl _start
_start:
    #abertura do arquivo de leitura
    movl $5, %eax
    movl $filename, %ebx
    movl $00, %ecx
    movl $0444, %edx
    int $0x80
    test %eax, %eax #seta as flags 
    js badfile  #pula para badfile pula se o sinal no registrador SF for setada
    movl %eax, infilehandle

    #abertura do arquivo de escrita
    movl $5, %eax
    movl $filewrite, %ebx
    movl $01101, %ecx
    movl $0644, %edx
    int $0x80
    test %eax, %eax #seta as flags 
    js badfile  #pula para badfile pula se o sinal no registrador SF for setada
    movl %eax, outfilehandle

read_loop:
    movl $3, %eax
    movl infilehandle, %ebx
    movl $buffer, %ecx
    movl  $10,%edx
    int $0x80
    test %eax, %eax #seta as flags 
    jz done
    js done

    
    movl %eax, %edx
    movl $4, %eax
    movl $1, %ebx
    movl $buffer, %ecx #escrita dos dados lidos pelo buffer no console
    int $0x80

    movl $4, %eax
    movl outfilehandle, %ebx
    movl $buffer, %ecx  #escreve o que esta armazenado no buffer a partir da leitura do arquivo
    int $0x80
    test %eax, %eax #seta as flags 
    js badfile  #pula para badfile pula se o sinal no registrador SF for setada
    
    test %eax, %eax #seta as flags 
    js badfile  #pula para badfile pula se o sinal no registrador SF for setada
    jmp read_loop

    
done:
    #fecha o arquivo de leitura 
    movl $6, %eax
    movl infilehandle, %ebx
    int $0x80

    #fecha o arquivo de escrita
    movl $6, %eax
    movl outfilehandle, %ebx
    int $0x80

badfile:
    movl %eax, %ebx
    movl $1, %eax
    int $0x80
