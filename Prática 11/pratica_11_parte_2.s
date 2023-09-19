#Douglas Kenji Sakakibara RA117741
#Felipe Gabriel Comin Scheffel RA117306
.section .data
	
	abertura:	.asciz	"\nPrograma para operar vetores\n"
	abertura2:	.asciz	"Leitura do Vetor %d\n"

	pedeTam:	.asciz	"Qual o tamanho dos vetores? => "
	pedeElem:	.asciz	"Digite o elemento %d => "

	msgIguais:	.asciz	"Vetores Iguais!\n"

	msgDiferentes:	.asciz	"Vetores Diferentes a partir do indice %d!\n"

	menuOp:		.asciz	"Menu de Opcoes\n<1> Ler Vetores\n<2> Comparar Vetores\n<3> Achar Intersecao\n<4> Finalizar\nDigite opcao => "

	msgIntersecao:	.asciz "Interseção dos conjuntos: "
	msgNenhumaIntersecao:	.asciz "Nenhum elemento em comum nos conjuntos."
	elVetor:	.asciz "%d, "

	tamVet:		.int	0
	tamVet3:		.int	0
	opcao:		.int	0
	vetor1:		.int	0
	vetor2:		.int	0
	vetor3:		.int	0

	tipoNum:	.asciz "%d"


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
	
	call	malloc							# aloca memoria para 3 vetor com o mesmo tamanho de vetor1 e vetor2, que seria o tamanho maximo da interseção
	movl	%eax, vetor3

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

_volta:

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

	loop	_volta

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
	call	achaIntersecao
	RET

achaIntersecao:
// for i in v1:
//	 if verificaElementoNoVetor(i, v2) and not verificaElementoNoVetor(i, v3):
//	    adicionaElemento(i, v3)
	movl	vetor1, %edi					# carrega vetor 1 para o loop
	movl	tamVet, %ecx					# carrega tamanho do vetor 1

	movl	$0, tamVet3						# reinicia tamanho do vetor que armazena a interseção

_percorreVetor1:
	movl	(%edi), %ebx					# carrega elemento do vetor 1

	pushl	%edi							# backup edi
	pushl	%ecx							# backup ecx

	movl	vetor2, %edi					# carrega posição do vetor 2 para a chamada da função
	movl	tamVet,	%ecx					# carrega tamanho do vetor 2  para a chamada da função
	call	verificaElementoNoVetor			# verifica se elemento do vetor 1 também está no vetor 2

	cmpl	$0, %eax						# veririca se o resultado da chamada foi 1, ou seja, se o elemento faz parte da interseção
	je	_terminouVolta						# se o elemento não estiver no vetor 2, não faz nada

_encontradoVetor2:							# se estiver em vetor 2, faz parte da interseção
	movl	vetor3,	%edi					# carrega posição do vetor 3 para a chamada da função
	movl	tamVet3, %ecx					# carrega tamanho do vetor 3  para a chamada da função
	call	verificaElementoNoVetor			# verifica se o elemento já está no vetor 3

	cmpl	$1, %eax						# verifica se o resultado da chamada foi 1, ou seja, se o elemento já foi inserido no vetor 3
	je	_terminouVolta						# se já está, não faz nada

_adicionarElementoVetor3:					# se não, adiciona o elemento no vetor 3
	movl	tamVet3, %eax					# move o tamanho até agora para eax
	movl	$4, %ecx						# move 4 (tamanho de um int) para ecx
	mull	%ecx							# multiplica o tamanho de vetor 3 (eax) por 4 (ecx) para obter o offset do novo elemento
	movl	vetor3,	%edi					# carrega posição inicial do vetor 3
	addl	%eax, %edi						# soma o offset pra posição do elemento
	movl	%ebx, (%edi)					# salva o elemento na posição calculada
	
	movl	tamVet3, %eax					# move o tamanho antigo do vetor 3 para eax
	incl	%eax							# incrementa o tamanho do vetor 3 em 1
	movl	%eax, tamVet3					# salva o novo valor na variável

_terminouVolta:
	popl	%ecx							# backup ecx
	popl	%edi							# backup edi
	addl	$4, %edi						# próximo elemento de vetor 1
	loop	_percorreVetor1					# próxima iteração

_imprimeIntersecao:
	cmpl	$0, tamVet3						# se o tamanho do vetor 3 não foi incrementado, nenhum elemento em comum
	je	_nenhumElementoIntersecao

	movl 	tamVet3, %ecx					# move tamanho do vetor 3 para ecx
	movl 	vetor3, %edi					# move a posição inicial do vetor 3 para edi

	pushl 	%edi							# backup edi
	pushl 	%ecx							# backup ecx

	pushl	$msgIntersecao					# push da mensagem fixa para apresentar a interseção
	call	printf							# imprime mensagem no console
	addl	$4, %esp						# desfaz push

	popl 	%ecx							# backup ecx
	popl 	%edi							# backup edi

_imprimeElemento:
	pushl 	%edi							# backup edi
	pushl 	%ecx							# backup ecx

	movl	(%edi), %ebx					# move elemento do vetor para ebx

	pushl	%ebx							# push de ebx para impressão
	pushl	$elVetor						# push da string de formatação
	call	printf							# imprime elemento no console
	addl	$8, %esp						# desfaz últimos 2 push

	popl	%ecx							# backup edi
	popl	%edi							# backup ecx

	addl	$4, %edi						# posição do próximo elemento
	loop	_imprimeElemento				# próxima iteração do loop para imprimir próximo elemento

	RET

_nenhumElementoIntersecao:
	pushl	$msgNenhumaIntersecao			# push da mensagem sobre nenhum elemento em comum
	call	printf							# imprime mensagem no console
	addl	$4, %esp						# desfaz push
	
	RET

verificaElementoNoVetor:					# %edi: Vetor, %ecx: Tamanho do vetor, %ebx: Elemento a ser encontrado -> %eax: 1 se encontrou
	cmpl	$0, %ecx						# se o vetor estiver vazio (tam 0), não será possível encontrar o elemento
	je	_naoEncontrouElemento				

_percorreVetor:
	cmpl	(%edi), %ebx					# se o elemento na posição for o que está sendo buscado, encontrou
	je	_encontrouElemento

	addl	$4, %edi						# posição do próximo elemento
	loop _percorreVetor						# próxima iteração para comparar com próximo elemento

_naoEncontrouElemento:
	movl	$0, %eax						# retorna 0 se não encontrou
	RET

_encontrouElemento:
	movl	$1,	%eax						# retorna 1 se encontrou
	RET
