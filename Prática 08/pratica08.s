#Douglas Kenji Sakakibara RA117741
#Felipe Gabriel Comin Scheffel RA117306
.section .data

	abert:	.asciz	"\nPrograma para Ordenar 4 Numeros\n\n\n"
	pedeN:	.asciz	"\nDigite N%d => "
	tipoN:	.asciz	"%d"

	mostra:	.asciz	"\nNumeros Ordenados: %d, %d, %d, %d\n\n"

	perg:	.asciz	"\nDeseja nova ordenacao <S>im/<N>ao? " 

	tipoC:	.asciz	" %c"	# o espaço remove <tab>s e <enter>s
				# antes do caractere a ser lido

	n1:	.int	0
	n2:	.int	0
	n3:	.int	0
	n4: .int    0
	var1: .int  0
	var2: .int  0
	var3: .int  0
	var4: .int  0
    

	resp:	.byte	'n'
	

.section .text
.globl _start

_start:

	pushl	$abert
	call	printf

	pushl	$1
	pushl	$pedeN
	call	printf
	pushl	$n1
	pushl	$tipoN
	call	scanf

	pushl	$2
	pushl	$pedeN
	call	printf
	pushl	$n2
	pushl	$tipoN
	call	scanf

	pushl	$3
	pushl	$pedeN
	call	printf
	pushl	$n3
	pushl	$tipoN
	call	scanf

	pushl	$4
	pushl	$pedeN
	call	printf
	pushl	$n4
	pushl	$tipoN
	call	scanf

	addl	$42, %esp

    #move os valores de n1,n2,n3 e n4 para as variaveis var1, var2, var3, var4
    movl n1, %eax
	movl %eax,var1
	movl n2, %eax
    movl %eax,var2
	movl n3, %eax
    movl %eax,var3
	movl n4, %eax
    movl %eax,var4

    
    

comp1:# faz a comparacao entre o n1 e o n2
    movl	var2, %eax
	cmpl	var1, %eax
    jl res1 # caso o n2 seja menor que o n1 ele direciona para o res1
	
comp2:# faz a comparacao entre o n2 e o n3
    movl	var3, %eax
	cmpl	var2, %eax
    jl res2 # caso o n3 seja menor que o n2 ele direciona para o res2

comp3:# faz a comparacao entre o n3 e o n4
    movl	var4, %eax
	cmpl	var3, %eax
    jl res3 # caso o n4 seja menor que o n3 ele direciona para o res3
    jmp n2_n1 # caso contrario ele direciona para o n2_n1 para comecar as verificacoes de ordenacao
    
res1: # troca o valor de n1 com n2
    movl  var2, %eax
	movl var1, %ebx
    xchgl var1, %eax
	xchgl var2,%ebx
    jmp comp2 # volta para a proxima comparacao 
res2: # troca o valor de n2 com n3
	movl  var3, %eax
	movl var2, %ebx
    xchgl var2, %eax
	xchgl var3,%ebx
	
    jmp comp3 # volta para a proxima comparacao 
res3: # troca o valor de n3 com n4
	movl  var4, %eax
	movl var3, %ebx
    xchgl var3, %eax
	xchgl var4,%ebx
	
    jmp n2_n1 # direciona para n2_n1 para comecar as verificacoes de ordenacao

#os 3 blocos abaixo verifica se esta ordenado    

n2_n1:
    movl	var1, %eax
	cmpl	var2, %eax
	jl	n3_n2 # caso esteja ordena ele continua para a proxima verificacao
    jmp comp1 # caso contrario ele retorna para o inicio das comparacoes(comp1)
n3_n2:
    movl	var2, %eax
	cmpl	var3, %eax
	jl	n4_n3 # caso esteja ordena ele continua para a proxima verificacao
    jmp comp2 # caso contrario ele retorna para a comp2
n4_n3:
    movl	var3, %eax
	cmpl	var4, %eax
	jl	fim # caso esteja ordena ele direciona para o fim para printar os valores ordenados
    jmp comp3 # caso contrario ele retorna para a comp3





    
fim:
    pushl var4
    pushl var3
    pushl var2
    pushl var1
    pushl $mostra
	call printf
    pushl	$0
	call	exit
	











    
