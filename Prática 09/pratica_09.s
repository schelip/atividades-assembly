
.section .data
	abertura:		.asciz	"Programa para Calculo da Media\n"

	pedeNroAlunos:	.asciz	"Digite o numero de alunos ou <0> para sair => "
	pedeNota:		.asciz	"Digite a nota %d => "
	mostraMedia:	.asciz	"Media da Turma = %f\n"
    mostraMaior:	.asciz	"Maior nota da Turma = %d\n"
    mostraMenor:	.asciz	"Menor nota da Turma = %d\n"

	nAlunos:	.int	0
	nota:		.int	0
	soma:		.int	0
	media:		.float	0						# Media é float, será o resultado de uma divisão
	maiorNota:	.int	0						# Armazena a menor nota, inicialmente 0 (será atualizada ao encontrar notas maiores)
	menorNota:	.int	10						# Armazena a maior nota, inicialmente 10 (será atualizada ao encontrar notas menores)

	tipoNum:	.asciz	"%d"
	
.section .text
.globl	_start
_start:
    nop											
    finit										# Inicializa FPU
	pushl	$abertura
	call	printf

_volta1:
	pushl	$pedeNroAlunos
	call	printf

	pushl	$nAlunos
	pushl	$tipoNum
	call	scanf

	addl	$12, %esp

	movl	nAlunos, %eax
	cmpl	$0, %eax

	je	_fim    								# Se a entrada for 0, finaliza o programa
    jl	_volta1									# Senão, se menor que 0, é uma entrada inválida
                								# Senão, executa o resto do programa

	movl	nAlunos, %ecx
	movl	$1, %ebx
												
    movl    $0, soma							# Reseta soma para 0
    movl    $0, maiorNota						# Reseta menor nota para 0 (qualquer outra nota será maior)
    movl    $10, menorNota						# Reseta menor nota para 10 (qualquer outra nota será menor)

_volta2:
	pushl	%ecx
	pushl	%ebx
	pushl	$pedeNota
	call	printf

	pushl	$nota
	pushl	$tipoNum
	call	scanf

	addl	$12, %esp
	popl	%ebx
	popl	%ecx
	
	movl	nota, %eax

	cmpl	$0, %eax
	jl	_volta2

_atualizaMaiorMenorNota:						# Verifica se a nota é maior ou menor que os valores salvos
	cmpl	menorNota, %eax
	jg	_naoAlteraMenorNota						# Se for maior que a menor nota, não altera
	movl %eax, menorNota						# Senão, é menor, então atualiza menor nota

_naoAlteraMenorNota:
	cmpl	maiorNota, %eax
	jl	_naoAlteraMaiorNota						# Se for menor que a maior nota, não altera
	movl %eax, maiorNota						# Senão, é maior, então atualiza maior nota

_naoAlteraMaiorNota:
	addl	soma, %eax
	movl	%eax, soma
	
	incl	%ebx
	loop	_volta2

_calcMedia:
	filds	soma								# Carrega soma na FPU (st0)
	fidivl	nAlunos								# Divide st0 pelo número de alunos

	subl	$8, %esp							# Subtrai 8 da pilha do programa, liberando espaço para fazer o push do float
	fstpl	(%esp)								# Faz o pop de st0 e adicona na pilha de programa

	pushl	$mostraMedia
	call	printf

    pushl	maiorNota							# Push da maior nota para impressão
	pushl	$mostraMaior						# Push da mensagem de maior nota
	call	printf								# Chamada para impressão da maior nota

    pushl	menorNota							# Push da menor nota para impressão
	pushl	$mostraMenor						# Push da mensagem de menor nota
	call	printf								# Chamada para impressão da mmenor nota
	addl	$28, %esp

    jmp _start									# Volta ao início, para verificar se o usuário deseja executar novamente
	
_fim:
	pushl	$0
	call	exit
