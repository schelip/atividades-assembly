.section .data

	abertura:	.asciz	"PROGRAMA BUSCA ELEMENTO EM VETOR\n"

	pedeNElem:	.asciz	"Digite o numero de elementos do vetor => "

	pedeElem:	.asciz	"Digite o elemento %d => "

	pedeX:		.asciz	"Digite o elemento a ser buscado => "

	mostraVetor:	.asciz	"Vetor Lido: "

	mostraElem:	.asciz	"Elemento %d localizado na posicao %d\n"

	msgInexiste:	.asciz	"Elemento Inexistente!\n"

	msgReexecucao:	.asciz	"Deseja Reexecutar <1>Sim <2>Nao? "

	nElem:		.int	0
	elem:		.int	0
	X:		.int	0
	resp:		.int	0

	tipoNum:	.asciz	"%d"

	mostraNum:	.asciz	"%d, "

	vetor:		.space	200

	pulaLinha:	.asciz	"\n"


	

.section .text

.globl _start

_start:

	pushl	$abertura
	call	printf

	call	leNElem
	call	leVetor
	call	mostraVet

_subrotinasBusca:           # chamadas que serão reexecutadas se desejado
	call	leX				# chama sub-rotina leX - em que X é o elemento a ser buscado
	call	buscaX			# chama sub-rotina para buscar o elemento X no vetor
	call	mostraRes		# chama sub-rotina para apresentar o resultado da busca

    pushl   $msgReexecucao  # push da mensagem de reexecução
    call    printf          # imprime mensagem de execução na tela

    pushl	$resp           # push da variável para conter a resposta
	pushl	$tipoNum        # push do formato da entrada
	call	scanf           # lê a resposta do usuário

    movl    resp, %eax      # move a resposta para eax
    cmpl    $1, %eax        # verifica se a resposta foi 1
    je  _subrotinasBusca    # se foi, recomeça as chamadas de busca

_fim:

	pushl 	$0
	call	exit

leNElem:

	pushl	$pedeNElem
	call	printf

	pushl	$nElem
	pushl	$tipoNum
	call	scanf

	addl	$12, %esp   

	movl	nElem, %eax
	cmpl	$0, %eax
	jle	leNElem

	cmpl	$50, %eax
	jg	leNElem

	RET

leVetor:

	movl	$vetor, %edi
	movl	$1, %ebx
	movl	nElem, %ecx

_leMaisUm:

	pushl	%ecx
	pushl	%edi
	pushl	%ebx
	pushl	$pedeElem
	call	printf

	pushl	%edi
	pushl	$tipoNum
	call	scanf

	addl	$12, %esp
	
	popl	%ebx
	popl	%edi
	popl	%ecx

	incl	%ebx
	addl	$4, %edi

	loop	_leMaisUm

	RET

mostraVet:


	movl	$vetor, %edi
	movl	nElem, %ecx

_mostraMaisUm:

	pushl	%ecx
	pushl	%edi

	pushl	$mostraVetor
	call	printf
	addl	$4, %esp
	
	popl	%edi
	popl	%ecx
	
_volta1:

	pushl	%ecx
	pushl	%edi

	movl	(%edi), %eax
	pushl	%eax
	pushl	$mostraNum
	call	printf
	
	addl	$8, %esp

	popl	%edi
	popl	%ecx

	addl	$4, %edi

	loop	_volta1

	pushl	$pulaLinha
	call	printf
	addl	$4, %esp

	RET

leX:
    pushl	$pedeX          # push da mensagem pedindo o elemento X
	call	printf          # imprime mensagem pedindo o elemento X

	pushl	$X              # push do endereço da variável que conterá X
	pushl	$tipoNum        # push do formato de entrada
	call	scanf           # lê X informado pelo usuário

	addl	$12, %esp   	# limpa pilha (3 ultimos push)
	
	RET

buscaX:
    movl	$vetor, %edi	# valor inicial do espaço reservado é movido para EDI
	movl	nElem, %ecx		# ECX = nElem (nº de elementos do vetor
    movl    $1, %ebx        # inicia índice da procura em 1 (será incrementado para cada iter onde o elemento não é encontrado).
                            # EBX Não é usado para o loop (apenas EXC e EDI), apenas mantém os índices em ordem crescente

_buscaMaisUm:
	pushl	%ecx		    # backup ECX
	pushl	%edi            # backup edi

	movl	(%edi), %eax	# move conteúdo apontado por edi para EAX (1º elemento do vetor)		
	
    cmpl    X, %eax         # verifica se o elemento na posição é o elemento sendo buscado
    je  _encontrado         # se for, encontrou

	popl	%edi			# backup edi
	popl	%ecx			# backup ECX

	addl	$4, %edi		# soma 4 ao endereço do EDI, para pegar o próx. elemento do vetor

    inc %ebx                # elemento não foi encontrado, então incrementa índice da busca
	loop	_buscaMaisUm    # ECX = ECX - 1

    movl    $-1, elem       # se não foi encontrado, usa -1 para sinalizar
    RET

_encontrado:
    movl    %ebx, elem      # move o índice da posição para a variável elem
	addl    $8, %esp        # limpa pilha (2 últimos push)
	RET

mostraRes:
    movl    elem, %eax      # move posição encontrada para EAX
    cmpl    $1, %eax        # verifica se foi encontrado
    jl  _mostraNaoEncontrou # se não foi encontrado, mostra mensagem alternativa

    pushl	elem    	    # coloca a posição encontrada na pilha
    pushl   X               # coloca o valor buscado na pilha
	pushl	$mostraElem		# mensagem com valor e onde foi encontrado
	call	printf          # imprime mensagem na tela
    addl	$12, %esp		# remove os 3 ultimos push
    RET

_mostraNaoEncontrou:
	pushl   $msgInexiste    # mensagem dizendo que elemento não foi encontrado
    call	printf          # imprime mensagem na tela
	addl	$4, %esp		# remove o ultimo push
	RET	
	


