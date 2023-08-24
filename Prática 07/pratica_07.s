# Atividade 7 - PIHS
# RA117306 - Felipe Scheffel
# RA117741 - Douglas Kenji

.section .data
	pi:			.float	3.14159

	base:		.int	0
	altura:		.int	0
	raio:		.int	0
	area:		.int	0
	opcao:		.int	0

	abertura:	.asciz	"\nCalculo de Areas de Figuras Geometricas\n\n"
	abertRet:	.asciz	"\nCalculo da Area do Retangulo\n"
	abertTri:	.asciz	"\nCalculo da Area do Triangulo\n"
	abertCir:	.asciz	"\nCalculo da Area da Circuferencia\n"

	menuOpcao:	.asciz	"Menu de Opcao:\n<1> Area do Retangulo\n<2> Area do Triangulo\n<3> Area da Circunferencia\n<0> Sair"

	pedeBase:	.asciz	"\nDigite o valor da base => "
	pedeAltura:	.asciz	"\nDigite o valor da altura => "
	pedeRaio:	.asciz	"\nDigite o valor do raio => "
	pedeOpcao:	.asciz	"\nDigite a opcao => "

	mostraRet:	.asciz	"\nArea do Retangulo = %d\n"
	mostraTri:	.asciz	"\nArea do Triangulo = %d\n"
	mostraCir:	.asciz	"\nArea da Circuferencia = %f\n"

	tipoDado:	.asciz	"%d"

.section .text
.globl _start
_start:
	nop
	finit

	pushl	$abertura
	call	printf

	pushl	$menuOpcao
	call	printf

	pushl	$pedeOpcao
	call	printf
	pushl	$opcao
	pushl	$tipoDado
	call	scanf

	addl	$20, %esp

	movl	opcao, %eax
	cmpl	$1, %eax
	je	_calcRet
	cmpl	$2, %eax
	je	_calcTri
	cmpl	$3, %eax # se a opção 3 for selecionada, realiza o fluxo de circuferencia
	je	_calcCir
	cmpl	$0, %eax  # se a opção 0 for selecionada, sai do programa
	je	_fim

	jmp	_start   # se qualquer outro número for selecionado, mostra o menu novamente

_calcCir:
	pushl	$abertCir
	call	printf
	addl	$4, %esp
	jmp _contRaio

_calcRet:
	pushl	$abertRet
	call	printf
	addl	$4, %esp
	jmp	_contBaseAltura

_calcTri:
	pushl	$abertTri
	call	printf
	addl	$4, %esp

_contBaseAltura: # fluxo para as formas que usam base e altura
	pushl	$pedeBase
	call	printf
	pushl	$base
	pushl	$tipoDado
	call	scanf

	pushl	$pedeAltura
	call	printf
	pushl	$altura
	pushl	$tipoDado
	call	scanf

	addl	$24, %esp

	movl	base, %eax
	mull	altura		# multiplica %eax pelo operando e coloca o resultado em %edx:%eax
	movl	%eax, area

	movl	opcao, %ecx
	cmpl	$1, %ecx
	je	_mostraRet

	movl	$0, %edx
	movl	$2, %ebx
	divl	%ebx		# divide o par %edx:%eax e coloca o resultado em %eax
	movl	%eax, area
	jmp	_mostraTri

_contRaio:	# fluxo para as formas que usam raio
	pushl	$pedeRaio # lê valor inteiro para o raio
	call	printf
	pushl	$raio
	pushl	$tipoDado
	call	scanf

	movl	raio, %eax
	mull	raio # multiplica raio por ele mesmo (ou seja, eleva ao quadrdo)
	movl	%eax, raio # armazena raio ao quadrado na variavel 'raio'

	filds	raio # carrega o valor inteiro de raio ao quadrado na FPU
	flds	pi # carrega o valor float de pi na FPU
	fmul	%st(1), %st(0) # Multiplica pi pelo raio ao quadrado, e o resultado ficará em st0
	addl	$12, %esp

_mostraCir:
	subl	$8, %esp # reserva espaço para um float na pilha
	fstpl	(%esp) # faz o push do resultado para a pilha
	pushl	$mostraCir
	call	printf
	addl	$12, %esp
	jmp _start

_mostraTri:
	pushl	area
	pushl	$mostraTri
	call	printf
	addl	$8, %esp
	jmp	_start

_mostraRet:
	pushl	area
	pushl	$mostraRet
	call	printf
	addl	$8, %esp
	jmp	_start

_fim:
	pushl	$0
	call	exit
