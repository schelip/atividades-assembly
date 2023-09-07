#Douglas Kenji Sakakibara RA117741
#Felipe Gabriel Comin Scheffel RA117306
.section .data
	
	abertura:	.asciz	"Programa para operar vetores\n"
	abertura2:	.asciz	"Leitura do Vetor %d\n"

	pedeTam:	.asciz	"Qual o tamanho dos vetores? => "
	pedeElem:	.asciz	"Digite o elemento %d => "

	msgIguais:	.asciz	"Vetores Iguais!\n"
	mostraVetor:	.asciz	"Vetor Intersecao: "
	
	msgDiferentes:	.asciz	"Vetores Diferentes a partir do indice %d!\n"

	
	menuOp:		.asciz	"Menu de Opcoes\n<1> Ler Vetores\n<2> Comparar Vetores\n<3> Achar Intersecao\n<4> Finalizar\nDigite opcao => "

	tamVet:		.int	0
	opcao:		.int	0
	vetor1:		.int	0
	vetor2:		.int	0
	vetor3:     .int    0


	tipoNum:	.asciz "%d"
	mostraNum:	.asciz	"%d, "

	

	pulaLinha:	.asciz	"\n"


.section .text
.globl _start
_start:

	pushl	$abertura
	call	printf
	addl	$4, %esp
	
	call	menuOpcoes

	cmpl	$4, opcao
	je	_fim

	call	trataOpcoes
	
	jmp	_start

_fim:
	pushl $0
	call exit

menuOpcoes:

	pushl	$menuOp
	call	printf

	pushl	$opcao
	pushl	$tipoNum
	call	scanf

	addl	$12, %esp

	RET

trataOpcoes:

	cmpl	$1, opcao
	je	_leVetores

	cmpl	$2, opcao
	je	_comparaVetores
	
	cmpl	$3, opcao
	je	_achaIntersecao


	RET

_leVetores:
	
	pushl	$pedeTam
	call	printf

	pushl	$tamVet
	pushl	$tipoNum
	call	scanf

	addl	$12, %esp

	cmpl	$0, tamVet
	jle	_leVetores

	movl	tamVet, %eax
	movl 	$4, %ebx
	mull	%ebx

	pushl	%eax
	call	malloc
	movl	%eax, vetor1

	call	malloc
	movl	%eax, vetor2

	call    malloc
	movl    %eax, vetor3

	addl	$4, %esp

	movl	vetor1, %edi
	movl	$1, %ebx
	call	leVetor

	movl	vetor2, %edi
	movl	$2, %ebx
	call	leVetor
	
	RET

leVetor:

	pushl	%ebx
	pushl	$abertura2
	call	printf
	addl	$8, %esp

	movl	tamVet, %ecx
	movl	$1, %ebx

_voltaVetor:

	pushl	%ecx
	pushl	%ebx
	pushl	%edi

	pushl	%ebx
	pushl	$pedeElem
	call	printf
	addl	$8, %esp

	pushl	$tipoNum
	call	scanf
	addl	$4, %esp

	popl	%edi
	popl	%ebx
	popl	%ecx

	incl	%ebx
	addl	$4, %edi

	loop	_voltaVetor

	RET



_comparaVetores:

	movl	vetor1, %edi
	movl	vetor2, %esi
	movl	tamVet, %ecx
	movl	$1, %ebx

_volta2:

	movl	(%esi), %eax
	cmpl	(%edi), %eax
	jne	_vetDiferentes
	
	addl	$4, %edi
	addl	$4, %esi
	incl	%ebx

	loop	_volta2

_vetIguais:

	pushl	$msgIguais
	call	printf
	addl	$4, %esp

	RET

_vetDiferentes:

	pushl	%ebx
	pushl	$msgDiferentes
	call	printf
	addl	$8, %esp

	RET

_achaIntersecao:
	movl	vetor1, %edi # valor inicial do espaço reservado para o vetor 1 é movido para EDI
	movl	vetor2, %esi # valor inicial do espaço reservado para o vetor 2 é movido para ESI
	movl    vetor3, %edx # valor inicial do espaço reservado para o vetor 3 é movido para EDX
	movl	tamVet, %ecx # ECX = nElem (nº de elementos do vetor)
	movl	$1, %ebx
	

_continua:
	movl	(%edi), %eax # move conteúdo apontado por edi para EAX (1º elemento do vetor)		
	cmpl	(%esi), %eax # compara o valor do ESI que seria o primeiro elemento do vetor 2 com o valor de EAX
	je      _insere # caso o valor seja igual ele direciona para o bloco _insere, caso não seja ele continua a percorrer os elementos

_continua2:	
	addl	$4, %edi # soma 4 ao endereço do EDI, para pegar o próx. elemento do vetor
	addl	$4, %esi # soma 4 ao endereço do ESI, para pegar o próx. elemento do vetor
	incl	%ebx # incrementa índice da busca

	loop	_continua # ECX = ECX - 1
	jmp     _mostraVet # quando termina a varredura dos vetores ele direciona_mostraVet que vai mostrar os elementos de Intersecao dos dois vetores


_insere:
	call    insere
	jmp     _continua2

insere:
	movl   %eax, (%edx) #move o valor de EAX para EDX    
	addl	$4, %edx  #soma 4 ao endereço do EDX
	RET

_mostraVet: 
	movl	vetor3, %edx # move o endereco reservado para o vetor 3 é movido para o EDX
	movl	tamVet, %ecx # ECX = nElem (nº de elementos do vetor)

_mostraMaisUm:

	pushl	%ecx # backup do ECX
	pushl	%edx # backup do EDX
 
	pushl	$mostraVetor
	call	printf
	addl	$4, %esp
	
	popl	%edx # backup do EDX
	popl	%ecx # backup do ECX

_volta1:

	pushl	%ecx
	pushl	%edx

	movl	(%edx), %eax
	pushl	%eax
	pushl	$mostraNum
	call	printf
	
	addl	$8, %esp

	popl	%edx
	popl	%ecx

	addl	$4, %edx

	loop	_volta1

	pushl	$pulaLinha
	call	printf
	addl	$4, %esp

	RET	
	

