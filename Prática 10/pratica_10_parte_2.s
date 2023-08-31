.section .data

	abertura:	.asciz	"PROGRAMA BUSCA ELEMENTO EM VETOR\n"

	pedeNElem:	.asciz	"Digite o numero de elementos do vetor => "

	pedeElem:	.asciz	"Digite o elemento %d => "

	pedeX:		.asciz	"Digite o elemento a ser buscado => "

	mostraVetor:	.asciz	"Vetor Lido: "

	mostraElem:	.asciz	"Elemento %d localizado na posicao %d\n"

	msgInexiste:	.asciz	"Elemento Inexistente!\n"

	msgReexecucao:	.asciz	"Deseja Reexecutar <1>Sim <2>Nao? "

    mostraMaior:	.asciz	"Maior elemento do vetor = %d (Pos: %d)\n"
	
    mostraMenor:	.asciz	"Menor elemento do vetor = %d (Pos: %d)\n"

	nElem:		.int	0
	elem:		.int	0
	X:			.int	0
	maior:		.int	0
	posMaior:	.int	0
	menor:		.int	0
	posMenor:	.int	0
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
	call	mostraMai	# função que encontra e mostra maior elemento e sua posição
	call	mostraMen	# função que encontra e mostra menor elemento e sua posição

_subrotinasBusca:
	call	leX
	call	buscaX
	call	mostraRes

    pushl   $msgReexecucao
    call    printf

    pushl	$resp
	pushl	$tipoNum
	call	scanf

    movl    resp, %eax
    cmpl    $1, %eax
    je  _subrotinasBusca

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
	
mostraMai:
    movl	$vetor, %edi	# valor inicial do espaço reservado é movido para EDI
	movl	nElem, %ecx		# ECX = nElem (nº de elementos do vetor
    movl    $1, %ebx        # inicia índice da procura em 1 (será incrementado para cada iter onde o elemento não é encontrado).
                            # EBX Não é usado para o loop (apenas EXC e EDI), apenas mantém os índices em ordem crescente

	movl	(%edi), %eax	# move conteúdo apontado por edi para EAX (1º elemento do vetor)
	movl	%eax, maior		# salva primeiro elemento como maior já encontrado (prox elementos serão comparados a ele)
	movl	%ebx, posMaior	# salva posição do primeiro elemento

_buscaProxMai:
	pushl	%ecx		    # backup ECX
	pushl	%edi            # backup edi

	movl	(%edi), %eax	# move conteúdo apontado por edi para EAX (1º elemento do vetor)		
	
    cmpl    maior, %eax     # verifica se o elemento na posição é maior que o maior encontrado até agora
    jle  _naoMaior			# se não for, não faz nada
							# se for,
    movl	%eax, maior		# elemento é o maior encontrado
	movl	%ebx, posMaior	# e a posição sendo analisada é salva como posição do maior

_naoMaior:
	popl	%edi			# backup edi
	popl	%ecx			# backup ECX

	addl	$4, %edi		# soma 4 ao endereço do EDI, para pegar o próx. elemento do vetor

    inc %ebx                # incrementa índice da busca
	loop	_buscaProxMai	# ECX = ECX - 1

	pushl	posMaior		# coloca posição do maior elemento na piha
	pushl	maior			# coloca maior elemento na piha
	pushl	$mostraMaior	# mensagem mostrando maior elemento e sua posição
	call	printf			# imprime mensagem para o usuário
    addl	$12, %esp		# desfaz últimos 3 push

    RET
	
mostraMen:
    movl	$vetor, %edi	# valor inicial do espaço reservado é movido para EDI
	movl	nElem, %ecx		# ECX = nElem (nº de elementos do vetor
    movl    $1, %ebx        # inicia índice da procura em 1 (será incrementado para cada iter onde o elemento não é encontrado).
                            # EBX Não é usado para o loop (apenas EXC e EDI), apenas mantém os índices em ordem crescente

	movl	(%edi), %eax	# move conteúdo apontado por edi para EAX (1º elemento do vetor)
	movl	%eax, menor		# salva primeiro elemento como menor já encontrado (prox elementos serão comparados a ele)
	movl	%ebx, posMenor	# salva posição do primeiro elemento

_buscaProxMen:
	pushl	%ecx		    # backup ECX
	pushl	%edi            # backup edi

	movl	(%edi), %eax	# move conteúdo apontado por edi para EAX (1º elemento do vetor)
	
    cmpl    menor, %eax     # verifica se o elemento na posição é menor que o menor até agora
    jge  _naoMenor  		# se não for, não faz nada
							# se for,
    movl	%eax, menor		# elemento é o menor encontrado
	movl	%ebx, posMenor	# e a posição sendo analisada é salva como posição do menor

_naoMenor:
	popl	%edi			# backup edi
	popl	%ecx			# backup ECX

	addl	$4, %edi		# soma 4 ao endereço do EDI, para pegar o próx. elemento do vetor

    inc %ebx                # elemento não foi encontrado, então incrementa índice da busca
	loop	_buscaProxMen	# ECX = ECX - 1

	pushl	posMenor		# coloca posição do menor elemento na piha
	pushl	menor			# coloca menor elemento na piha
	pushl	$mostraMenor	# mensagem mostrando menor elemento e sua posição	
	call	printf			# imprime mensagem para o usuário
    addl	$12, %esp		# desfaz últimos 3 push

    RET

leX:
    pushl	$pedeX
	call	printf

	pushl	$X
	pushl	$tipoNum
	call	scanf

	addl	$12, %esp
	
	RET

buscaX:
    movl	$vetor, %edi
	movl	nElem, %ecx
    movl    $1, %ebx


_buscaMaisUm:
	pushl	%ecx
	pushl	%edi

	movl	(%edi), %eax
	
    cmpl    X, %eax
    je  _encontrado

	popl	%edi
	popl	%ecx

	addl	$4, %edi

    inc %ebx
	loop	_buscaMaisUm

    movl    $-1, elem
    RET

_encontrado:
    movl    %ebx, elem
	addl    $8, %esp
	RET

mostraRes:
    movl    elem, %eax
    cmpl    $1, %eax
    jl  _mostraNaoEncontrou

    pushl	elem
    pushl   X
	pushl	$mostraElem
	call	printf
    addl	$12, %esp
    RET

_mostraNaoEncontrou:
	pushl   $msgInexiste
    call	printf
	addl	$4, %esp
	RET
