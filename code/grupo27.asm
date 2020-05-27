; Grupo 27
; Joao Nunes, 96745
; Francisco Paiva, 96737
; Goncalo Costa, 92881


DEFINE_PIXEL    		EQU 6008H   ; endereco do comando para escrever um pixel
DEFINE_LINHA	    	EQU 600AH   ; endereco do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH   ; endereco do comando para definir a coluna
DEFINE_CENARIO  		EQU 600EH   ; endereco do comando para definir o cenario         
DEFINE_VERMELHO 		EQU 6000H   ; endereco do comando para definir a cor vermelha
DEFINE_VERDE    		EQU 6002H   ; endereco do comando para definir a cor azul
DEFINE_AZUL     		EQU 6004H   ; endereco do comando para definir a cor verde
DEFINE_SOM      		EQU 6012H	; endereco do comando para definir o som

DISPLAYS   				EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN    				EQU 0C000H  ; endereço das linhas do teclado (periférico POUT-2)
TEC_COL    				EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)

DELAY 					EQU 5000 	; usado para atrasar o aumento do contador (rotina atraso)

BALA                    EQU 4       ; valor na tabela de funcionalidades que equiivale a: disparar bala
NOVO_JOGO				EQU 5		; valor na tabela de funcionalidades que equiivale a: novo jogo
TERMINA_JOGO			EQU 6		; valor na tabela de funcionalidades que equiivale a: termina jogo
PAUSA					EQU 7		; valor na tabela de funcionalidades que equiivale a: pausa
AJUDA                   EQU 8
NAO_FAZ_NADA			EQU 9		; valor na tabela de funcionalidades que equiivale a: nao faz nada


N_LINHAS        		EQU  32     ; número de linhas do ecrã (altura)
N_COLUNAS       		EQU  64     ; número de colunas do ecrã (largura)

POS_INI_NAVE_X			EQU  29		; linha onde a nave comeca o jogo
POS_INI_NAVE_Y			EQU  29		; coluna onde a nave comeca o jogo

CENARIO_JOGO 			EQU  0
CENARIO_INICIO			EQU  1
CENARIO_PAUSA 			EQU  2
CENARIO_PERDEU 			EQU  3
CENARIO_AJUDA           EQU  4

PLACE           1000H
pilha:          TABLE 100H  ;espaço reservado para a pilha 
                            ; (200H bytes, pois são 100H words)
SP_inicial:                 ; este é o endereço (1200H) com que o SP deve ser 
                            ; inicializado. O 1.º end. de retorno será 
                            ; armazenado em 11FEH (1200H-2)


dimensoes_nave: 			STRING 05, 07, 29, 29  
; primeiro valor: numero de linhas da nave; segundo valor: numero de colunas da nave; coordenadas da posicao nave (canto inf. esq.)

pixeis:    					STRING 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 
; cada valor diz se o pixel esta aceso (1) ou apagado (0)



; Existem sempre 3 naves inimigas, podem ser de tres tipos (e, d, c)

nave_inimiga1:				WORD dimensoes_nave_inimiga_c
							STRING 6, 29
; primeiro valor: tipo de nave inimiga (e, d, c); segundo e terceiro: coordenadas da posicao da nave (canto inf. esq.)

nave_inimiga2:				WORD dimensoes_nave_inimiga_e
							STRING 6, 8

nave_inimiga3:				WORD dimensoes_nave_inimiga_d
							STRING 6, 50

; caracteristicas dos tres tipos de naves inimigas (dimensoes, posicao inicial, movimento e forma)

dimensoes_nave_inimiga_c: 	STRING 06, 07, 6, 29, 1, 0
; primeiro valor: numero de linhas da nave inimiga central; segundo valor: numero de colunas da nave
; terceiro e quarto: coordenadas da posicao da nave; quinto: movimento em y; sexto: movimento em x

pixeis_base_inimiga_c: 		STRING 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0
; cada valor diz se o pixel esta aceso (1) ou apagado (0). Da a forma do desenho


dimensoes_nave_inimiga_e: 	STRING 06, 06, 6, 8, 1, 1

pixeis_base_inimiga_e: 		STRING 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0


dimensoes_nave_inimiga_d: 	STRING 06, 06, 6, 50, 1, -1

pixeis_base_inimiga_d: 		STRING 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0

;coordenadas da posicao da bala a cada momento
posicao_bala:             	STRING 15,32


; tabela com a funcao que cada botao desempenha. A cada botao correspondem 2 valores desta tabela
; i.e. ao botao 0 correspondem os valores 5, 5; ao botao 1 os valores 7,7 etc.
tabela_funcionalidades: 	STRING 5, 5, 6, 6, 7, 7, 8, 8, 9, 9, -1, -1, 0, -1, 1, -1, 9, 9, -1, 0, 4, 4, 1, 0, 9, 9, -1, 1, 0, 1, 1, 1, 9, 9


; variável que indica qual a ultima tecla que foi carregada (00H a 0FH) se nenhuma tecla foi carregada, fica 10
tecla_carregada:			STRING 0

; variável que indica qual a funcao da ultima tecla que foi carregada (tabela_funcionalidades)
funcao_escolhida:			STRING 8, 8

; usado em apaga desnho
zero:						STRING 0

; usado em desenha bala
um:                         STRING 1

; variavel de estado. Indica se o jogo esta em pausa (1) ou nao (0)
modo_pausa:                 STRING 0

; variavel de estado. Indica se o jogodor perdeu (1) ou nao (0)
modo_perdeu:                STRING 0

; variavel de estado. Indica se o jogo ja comecou(i.e. se esta a decorrer) (1) ou nao (0)
modo_comeca:                STRING 0

; variavel de estado. Indica se esta no ecra ajuda (1) ou nao (0)
modo_ajuda:                 STRING 0

; variavel que guarda um numero aleatorio, que vai sendo incrementado, para a colocacao das inimigas em posicoes aleatorias
aleatorio:					STRING 0

; variavel que guarda o score do jogo
contador:					WORD   0

; variavel que diz se existe uma bala em movimento(1) ou nao(0)
bala_em_movimento:          STRING 0

; variavel que permite que quando uma tecla e premida (a excecao das de movimento) a respetiva rotina nao continue a ser
; feita enquanto nao se larga o botao
tecla_presa: 				STRING 0


tab:      WORD rot_int_0      ; rotina de atendimento da interrupção 0
          WORD rot_int_1 	  ; rotina de atendimento da interrupção 1


evento_int:
          WORD 0            ; se for 1, indica que a interrupção 0 ocorreu
          WORD 0			; se for 1, indica que a interrupção 1 ocorreu

                              
; INICIO

PLACE   0                     ; o código tem de começar em 0000H
inicio:
    
    MOV  BTE, tab            ; inicializa BTE (registo de Base da Tabela de Exceções)
    MOV  SP, SP_inicial      ; inicializa SP para a palavra a seguir
                              ; à última da pilha
    EI0
    EI1   
    EI 

    MOV  R2, CENARIO_INICIO     ; Nmr cenario
    CALL escreve_cenario		; chama a rotina para por o cenario de fundo

    ; inicializações
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays

ciclo:
    
    CALL tecla

    CALL funcoes

    CALL comeca

    CALL ajuda

    CALL pausa

    CALL termina

    CALL nave

    CALL inimigas

    CALL bala

    JMP ciclo






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hexa2dec - Rotina que le teclado, e guarda tecla carregada na variavel			    ;; 
;; Argumentos:                                                                          ;;
;;               R2 - endereço do periférico das linhas                                 ;; 
;;               R3 - endereço do periférico das colunas                                ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
tecla:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R7

    MOV  R1, 16			; começa na 5 pq tira 1 no inicio, para ler linha 4

espera_tecla:         	; neste ciclo espera-se até uma tecla ser premida
    SHR  R1, 1			; passsar para a linha de baixo
    MOV  R5, R1
    CMP  R1, 0			
    JZ   nao_ha_tecla	; se for zero e porque ja leu as 4 linhas e nenhuma tecla foi premida
    MOVB [R2], R1      	; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      	; ler do periférico de entrada (colunas)
    CMP  R0, 0         	; há tecla premida?
    JZ   espera_tecla  	; se nenhuma tecla premida, repete
                       	; vai mostrar a linha e a coluna da tecla
    SHL  R1, 4         	; coloca linha no nibble high
    OR   R1, R0        	; junta coluna (nibble low)

    CALL conta 			; chama rotina para por o valor correto da tecla (de 0 a F)

    JMP  sai_teclado

nao_ha_tecla:
    MOV  R7, 10H 		; se nao houve tecla, vai guardar na variavel tecla_carregada 10H (escolhido para representar que nao ha tecla)

; assinala que ja nao ha nenhuma tecla a ser carregada
    MOV  R0, tecla_presa
    MOV  R1, 0
    MOVB [R0], R1

sai_teclado:
    MOV R0, tecla_carregada

    MOVB [R0], R7 		; guarda na variavel tecla_carregada


	POP R7
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0

    RET




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; conta - Rotina que faz a conversao do valor da tecla 							    ;; 
;; Argumentos:                                                                          ;;
;;               R1 - valor da tecla no formato lido (ex. 24)                           ;;
;; Saidas:																				;; 
;;               R7 - valor da tecla apos a conversao (ex. 6)                           ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

conta:
	PUSH R0
	PUSH R6
	PUSH R8

	MOV  R6, -1		    ; CONTADOR_coluna
	MOV  R7, -1			; CONTADOR_LINHA

	MOV  R0, R1
	MOV  R8, 0FH
	AND  R0, R8
descobre_coluna:
	SHR  R0, 1
	ADD  R6, 1
	CMP  R0, 0
	JNZ  descobre_coluna

	MOV  R0, R1
	MOV  R8, 0F0H
	AND  R0, R8
	SHR  R0, 4
descobre_linha:
	SHR  R0, 1
	ADD  R7, 1
	CMP  R0, 0
	JNZ  descobre_linha


	MOV  R8, 4
	MUL  R7, R8
	ADD  R7, R6

;fim_conta:
	POP	 R8
	POP  R6
	POP  R0

	RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																									   ;;
;; funcoes - Rotina que ve qual a funcionalidade da tecla carregada e guarda numa variavel na memoria  ;;
;;			(Aumenta tambem o numero aleatorio)														   ;;	
;;               															                           ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
funcoes:

	PUSH R0
	PUSH R1
	PUSH R2
    PUSH R3
	
	MOV  R0, tecla_carregada
	MOV  R1, tabela_funcionalidades

	MOVB R2, [R0]							; R2 - valor da tecla carregada
    SHL  R2, 1								; multiplica por 2, pois a cada tecla correspondem 2 valores na tabela_funcionalidades

	ADD  R1, R2								; vai buscar posicao na tabela_funcionalidades correspondente a tecla carregada

	MOV  R0, funcao_escolhida
    
	MOVB  R2, [R1]
	MOVB  [R0], R2 							; coloca na primeira posicao de funcao_escolhida o valor lido

	ADD  R0, 1								; posicao seguinte
	ADD  R1, 1
	
	MOVB R2, [R1]
	MOVB [R0], R2							; coloca na segunda posicao de funcao_escolhida o valor lido

	CALL aumenta_aleatorio

    POP  R3
	POP  R2
	POP  R1
	POP  R0

	RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																									   ;;
;; comeca - Rotina que inicia novo jogo(quando a respetiva tecla for carregada)  					   ;;	
;;               															                           ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
comeca:

    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7         ;r6 e r7 usados em apaga nave inimiga


; garantir que o jogo nao esta constantemente a recomecar enquanto a tecla nao e largada
    MOV  R0, tecla_presa
    MOVB R0, [R0]
    CMP  R0, 1
    JZ   fim_comeca

; verfica se a tecla COMECA foi carregada, se nao foi nao faz nada
    MOV  R0, funcao_escolhida
    MOVB R1, [R0]

    CMP  R1, NOVO_JOGO
    JNZ  fim_comeca

; assinala, na memoria, que o jogo foi iniciado
    MOV  R0, modo_comeca
    MOV  R1, 1
    MOVB [R0], R1

; assinala que uma tecla foi carregada
	MOV  R0, tecla_presa
	MOV  R1, 1
    MOVB [R0], R1

; coloca o modo pausa a zero (so e relevante se este estivesse ativado)
    MOV  R0, modo_pausa
    MOV  R1, 0
    MOVB [R0], R1


; comecas
    
    CALL apaga_ecra

; reinicia coordenadas das naves (principal e inimigas)
    MOV  R0, dimensoes_nave
    ADD  R0, 2
    MOV  R1, POS_INI_NAVE_X
    MOVB [R0], R1

    ADD  R0, 1

    MOV  R1, POS_INI_NAVE_Y  
    MOVB [R0], R1

; inicialmente a nave_inimiga1 fica no centro, a 2 a esquerda e a 3 a direita

    MOV  R0, nave_inimiga1
    MOV  R2, dimensoes_nave_inimiga_c
    MOV  [R0], R2								; na primeira posicao poe o tipo de nave

; coloca as coordenadas iniciais
    ADD  R0, 2
    ADD  R2, 2
    MOVB R1, [R2]								
    MOVB [R0], R1

    ADD  R0, 1
    ADD  R2, 1
    MOVB R1, [R2]
    MOVB [R0], R1


; igual para as seguintes naves, so muda o tipo
    MOV  R0, nave_inimiga2
    MOV  R2, dimensoes_nave_inimiga_e
    MOV  [R0], R2

    ADD  R0, 2
    ADD  R2, 2
    MOVB R1, [R2]
    MOVB [R0], R1

    ADD  R0, 1
    ADD  R2, 1
    MOVB R1, [R2]
    MOVB [R0], R1

    MOV  R0, nave_inimiga3
    MOV  R2, dimensoes_nave_inimiga_d
    MOV  [R0], R2

    ADD  R0, 2
    ADD  R2, 2
    MOVB R1, [R2]
    MOVB [R0], R1

    ADD  R0, 1
    ADD  R2, 1
    MOVB R1, [R2]
    MOVB [R0], R1


; poe o contador de pontos a 0
    MOV  R3, contador
    MOV  R0, 0
    MOV  R4, DISPLAYS
    MOV  [R4], R0
    MOV  [R3], R0

; poe balas a 0
    MOV  R3, bala_em_movimento
    MOV  R4, 0
    MOVB [R3], R4

; poe modo perdeu a 0
    MOV  R3, modo_perdeu
    MOV  R4, 0
    MOVB [R3], R4

    
; desenha cenario e todas as naves, nas posicoes iniciais
    MOV  R2, CENARIO_JOGO           ; Nmr cenario
    CALL escreve_cenario            ; chama a rotina para por o cenario de fundo
    CALL desenha_nave               ; chama a rotina que desenha a nave principal
    CALL desenha_naves_inimigas     ; chama a rotina que desenha todas as naves inimigas
 
fim_comeca:

    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2
    POP  R1
    POP  R0

    RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                                                     ;;
;; ajuda - Rotina que poe o jogo / ou sai no ecra ajuda(quando a respetiva tecla for carregada)        ;;   
;;                                                                                                     ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ajuda:
    PUSH R0
    PUSH R1
    PUSH R2


; garantir que o jogo nao esta constantemente a ir para pausa enquanto a tecla nao e largada
    MOV  R0, tecla_presa
    MOVB R0, [R0]
    CMP  R0, 1
    JZ   sai_ajuda

; se a tecla ajuda nao foi carregada, entao nao faz nada
    MOV  R0, funcao_escolhida
    MOVB R1, [R0]
    MOV  R2, AJUDA
    CMP  R2, R1
    JNZ  sai_ajuda

; assinala que uma tecla foi carregada
    MOV  R0, tecla_presa
    MOV  R1, 1
    MOVB [R0], R1

; se ja esta a jogar nao faz nada
    MOV  R0, modo_comeca
    MOVB R1, [R0]
    CMP  R1, 0
    JNZ  sai_ajuda

; se perdeu, entao o modo comeca esta 0, mas nao esta no ecra inicial, entao nao faz nada
    MOV  R0, modo_perdeu
    MOVB R1, [R0]
    CMP  R1, 0
    JNZ  sai_ajuda

; se ja estava no modo ajuda, volta para o inicio se nao poe no ecra ajuda
    MOV  R0, modo_ajuda
    MOVB R1, [R0]
    CMP  R1, 1
    JZ   ja_estava_ajuda

    MOV  R1, 1
    MOVB [R0], R1

    MOV  R2, CENARIO_AJUDA
    CALL escreve_cenario
    JMP  sai_ajuda

ja_estava_ajuda:
    MOV  R1, 0
    MOVB [R0], R1

    MOV  R2, CENARIO_INICIO
    CALL escreve_cenario

sai_ajuda: 
    POP  R2
    POP  R1
    POP  R0

    RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																									   ;;
;; pausa - Rotina que poe o jogo em pausa, ou retoma o jogo(quando a respetiva tecla for carregada)	   ;;	
;;               															                           ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pausa:

	PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7


; garantir que o jogo nao esta constantemente a entrar e sair de pausa enquanto a tecla nao e largada
    MOV  R0, tecla_presa
    MOVB R0, [R0]
    CMP  R0, 1
    JZ   sai_pausa

; verifica se a tecla foi carregada, se nao foi nao faz nada
    MOV  R3, funcao_escolhida
    MOVB R4, [R3]

    CMP  R4, PAUSA
    JNZ  sai_pausa

; assinala que a tecla foi carregada 	
 	MOV  R0, tecla_presa
 	MOV  R1, 1
    MOVB [R0], R1

; verifica se o jogo ja comecou, se nao tiver comecado, nao faz nada
    MOV  R3, modo_comeca
    MOVB R4, [R3]
    CMP  R4, 0
    JZ   sai_pausa

; se ja estava em pausa salta
    MOV  R3, modo_pausa
    MOVB R4, [R3]
    CMP  R4, 0
    JNZ  esta_em_pausa

; se nao estava, passa a estar
    MOV  R3, modo_pausa
    MOV  R4, 1
    MOVB [R3], R4

; apaga todas as naves do ecrã
    CALL apaga_ecra
 
; poe cenario do modo pausa   
    MOV  R2, CENARIO_PAUSA  ; Nmr cenario
    CALL escreve_cenario    ; chama a rotina para por o cenario de fundo
    JMP  sai_pausa


; se estava em pausa
esta_em_pausa:

; deixa de estar (muda a variavel de 0 para 1)
    MOV  R3, modo_pausa
    MOV  R4, 0
    MOVB [R3], R4

; desenha todas as naves nas posicoes onde estavam antes da pausa
    MOV  R2, CENARIO_JOGO                                           ; Nmr cenario
    CALL escreve_cenario                                            ; chama a rotina para por o cenario de fundo
    CALL desenha_nave                                               ; chama a rotina que desenha a nave principal
    CALL desenha_naves_inimigas                                     ; chama a rotina que desenha todas as naves inimigas

sai_pausa:
	POP  R7
	POP  R6
	POP  R5
	POP  R4
    POP  R3
    POP  R2

    RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																									   ;;
;; termina - Rotina que termina jogo(quando a respetiva tecla for carregada)  						   ;;	
;;               															                           ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
termina:
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7


; garantir que o jogo nao esta constantemente a terminar enquanto a tecla nao e largada
    MOV  R3, tecla_presa
    MOVB R3, [R3]
    CMP  R3, 1
    JZ   sai_termina

; verifica se a tecla foi carregada, se nao foi nao faz nada
    MOV  R3, funcao_escolhida
    MOVB R4, [R3]
    CMP  R4, TERMINA_JOGO
    JNZ  sai_termina

; assinala que uma tecla foi carregada
	MOV  R3, tecla_presa
	MOV  R4, 1
    MOVB [R3], R4

; verifica se o jogo ja comecou, se nao entao nao faz nada
    MOV  R3, modo_comeca
    MOVB R4, [R3]
    CMP  R4, 0
    JZ   sai_termina


; nao e relevante se esta em pausa ou nao, pois em ambos os casos pode terminar


; muda o endereco de modo_comeca para 0 (deixa de estar um jogo a decorrer)
    MOV  R3, modo_comeca
    MOV  R4, 0
    MOVB [R3], R4


; apaga todas as naves do ecrã
	CALL apaga_ecra
 
    MOV  R2, CENARIO_INICIO
    CALL escreve_cenario

sai_termina:

    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R3
    POP  R2

    RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																									   ;;
;; nave - Rotina que move a nave principal(quando uma das teclas de movimento for carregada)		   ;;	
;;               															                           ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
nave:
    PUSH R3
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    
; Ve se o jogo ja comecou, se ainda nao entao nao faz nada
    MOV  R3, modo_comeca
    MOVB R4, [R3]
    CMP  R4, 0
    JZ   sai_nave

; Ve se estas em pausa, se sim nao mexe
    MOV  R3, modo_pausa
    MOVB R4, [R3]
    CMP  R4, 1
    JZ   sai_nave

; ve se foi carregada uma das teclas de movimento (entre -1 e 1)
    MOV  R3, funcao_escolhida
    MOVB R4, [R3]

; ve se o valor e 0FFH(-1), porque usamos string, logo nao e possivel trabalhar em complemeto para 2
    MOV  R6, 0FFH
    CMP  R6, R4
    JZ   inicia_nave

; ve se e menor ou igual a 1
    MOV  R6, 1
    CMP  R6, R4
    JN   sai_nave

; como nunca vai haver valores menores que -1 (de acordo com a nossa tabela de funcionalidades), estas verificacoes sao suficientes

; comeca movimento da nave
inicia_nave:
    
    MOV  R5, dimensoes_nave     
    MOVB R3, [R5]           ; R3 - max linhas navs

    ADD  R5, 1
    MOVB R4, [R5]           ; R4 - max colunas navs

    ADD  R5, 1
    MOVB R6, [R5]           ; R6 - posicao atual (linha)

    ADD  R5, 1
    MOVB R7, [R5]           ; R7 - posicao atual (coluna)

    CALL apaga_desenho

; vai buscar qual e o movimento que tem de fazer de acordo com a tecla carreada
    MOV  R3, funcao_escolhida
    MOVB R4, [R3]           ; movimento da nave na coluna

    ADD  R3, 1
    MOVB R5, [R3]           ; movimento da nave na linha

    

    ADD  R6, R5             ; muda a linha da nave
    MOV  R5, 0FFH
    AND  R6, R5             ; limpa os bits de maior peso (para o caso de se ter feito -1), porque estamos a usar string


;verificar que a nave nai vai sair dos limites (R6 tem os valores atualizados da linha onde esta a nave apos o movimento)

    CMP  R6, 4              ; como usamos como referencia o canto inf esq. a posicao mais acima possivel e na linha 4
    JN   nao_move           ; se a linha for menor do que 4, a nave nao sai do sitio

    MOV  R5, 31             ; a nave pode estar no maximo na linha 31, mais abaixo ja sai fora dos limites
    CMP  R5, R6
    JN   nao_move           ; nave vai voltar a ser desenhada no sitio onde estava

; esta dentro dos limites das linhas, agora passamos as colunas

    ADD  R7, R4             ; muda a coluna da nave
    MOV  R5, 0FFH           ; limpa os bits de maior peso (para o caso de se ter feito -1), porque estamos a usar string
    AND  R7, R5

; verificar que a nave nai vai sair dos limites (R7 tem os valores atualizados da coluna onde se situa a nave apos o movimento)
    CMP  R7, 0              
    JN   nao_move

    MOV  R5, 57             ; como usamos como referencia o canto inf esq. a posicao mais a direita possivel e na coluna 57
    CMP  R5, R7             ; se a coluna for maior do que 57, a nave nao sai do sitio
    JN   nao_move

; a nave, depois de ter efetuado o movimento, esta dentro dos limites, logo vamos alterar a sua posicao no respetivo endereco de memoria

    MOV  R3, dimensoes_nave
    ADD  R3, 2
    MOVB [R3], R6
    ADD  R3, 1
    MOVB [R3], R7

nao_move:
    CALL desenha_nave

    CALL atraso 			; para a nave nao se mexer demasiado rapido

sai_nave:

    POP  R7
    POP  R6 
    POP  R5
    POP  R4
    POP  R3

    RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																									   ;;
;; inimigas - Rotina que move as naves inimigas 								  					   ;;	
;;				(alem dissoe, se for o caso, retira pontos e ativa o modo perdeu)					   ;;
;;               															                           ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
inimigas:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R5

; Ve se o jogo ja comecou, se ainda nao nao faz nada
    MOV  R0, modo_comeca
    MOVB R1, [R0]
    CMP  R1, 0
    JZ   sai_inimigas

; Ve se esta em pausa, se sim entao nao faz nada
    MOV  R0, modo_pausa
    MOVB R1, [R0]
    CMP  R1, 1
    JZ  sai_inimigas

; Ve se houve interturpcao (atraves do endereco de memoria da interrupcao 1)
	MOV  R4, evento_int
	MOV  R2,[R4 + 2]
	CMP  R2, 0
	JZ   sai_inimigas  					; se não houve interrupção, vai-se embora
	MOV  R2, 0                          ; se houve
	MOV  [R4 + 2], R2 					; coloca o valor da variável que diz se houve uma interrupção a zero (consome evento)


; Move as naves inimigas

	MOV  R5, nave_inimiga1
	CALL move_nave_inimiga
; ve se perdeu, se sim sai da rotina
    MOV  R4, modo_perdeu
    MOVB R2, [R4]
    CMP  R2, 1
    JZ   sai_inimigas

	MOV  R5, nave_inimiga2
	CALL move_nave_inimiga
; ve se perdeu
    MOV  R4, modo_perdeu
    MOVB R2, [R4]
    CMP  R2, 1
    JZ   sai_inimigas

	MOV  R5, nave_inimiga3
	CALL move_nave_inimiga
; ve se perdeu
    MOV  R4, modo_perdeu
    MOVB R2, [R4]
    CMP  R2, 1
    JZ   sai_inimigas

; volta a desenha-las nas novas posicoes
escreve:
	CALL desenha_naves_inimigas

sai_inimigas:
	POP  R5
	POP  R4
	POP  R2
	POP  R1
	POP  R0

	RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																									   ;;
;; bala - Rotina que move/dispara balas			 								  					   ;;
;;               															                           ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bala:
    PUSH R2
    PUSH R3
    PUSH R4
    PUSH R5

; Ve se o jogo ja comecou, se ainda nao nao faz nada
    MOV  R4, modo_comeca
    MOVB R5, [R4]
    CMP  R5, 0
    JZ   sai_bala

; Ve se esta em pausa, se sim entao nao faz nada
    MOV  R4, modo_pausa
    MOVB R5, [R4]
    CMP  R5, 1
    JZ  sai_bala

; se ja ha uma bala em movimento so a vai mover
    MOV  R3, bala_em_movimento
    MOVB R4, [R3]
    MOV  R3, 1
    CMP  R4, R3
    JZ   move

; garantir que o jogo nao esta constantemente a recomecar enquanto a tecla nao e largada
    MOV  R3, tecla_presa
    MOVB R3, [R3]
    CMP  R3, 1
    JZ   sai_bala

; se nao ha bala e a tecla nao foi carregada nao faz nada
    MOV  R3, funcao_escolhida
    MOVB R4, [R3]
    MOV  R3, BALA
    CMP  R4, R3
    JNZ  sai_bala

; assinala que uma tecla foi carregada
	MOV  R3, tecla_presa
	MOV  R4, 1
    MOVB [R3], R4


; se a tecla foi carreada

    MOV  R2, 0
    CALL som 							; dispara som

    CALL atualiza_bala 					; vai ver onde a bala vai 'aparecer'

; coloca a variavel bala_em_movimento a 1
    MOV  R3, bala_em_movimento
    MOV  R4, 1
    MOVB [R3], R4

move:
    MOV  R4, evento_int
    MOV  R2, [R4]
    CMP  R2, 0
    JZ   sai_bala                 ; se não houve interrupção, vai-se embora
    MOV  R2, 0 					  ; se houve, ; coloca o valor da variável que diz se houve uma interrupção a zero (consome evento)
    MOV  [R4], R2

    CALL apaga_bala

    ; Anda com a bala para a frente 
    MOV  R4, posicao_bala
    MOVB R2, [R4]
    SUB  R2, 1
    MOVB [R4], R2


    ADD  R2, 1

    ;Chegou ao topo?
    MOV  R5, 0
    CMP  R2, R5
    JNZ  colisao    		; se nao, vai verificar se houve colisao    
 
 ; se sim, entao nao desenha e poe bala_em_movimento a 0   
    MOV  R3, bala_em_movimento
    MOV  R4, 0
    MOVB [R3],R4
    
    JMP sai_bala


; verificar se a bala colidiu com alguma nave inimiga
colisao:
    CALL verifica_colisoes 				; esta rotina retorna 1 se nao houve colisao
    CMP  R3, 1
    JZ   escreve_bala 					; se nao houve, vai desenhar a bala na nova posicao
    JMP  sai_bala 						; se houve colisao, o score e a nave inimiga ja foram alterados noutra rotina, logo nao faz mais nada  

escreve_bala:
    CALL desenha_bala


sai_bala:
    POP  R5
    POP  R4
    POP  R3
    POP  R2

    RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																									   			;;
;; verifica_colisoes - Rotina que verifica se, apos o movimento da bala, houve alguma colisao com qualquer		;;
;;   	 uma das naves inimigas. Se sim desenha naves inimigas nas novas posicoes e altera bala_em_movimento	;;
;; Saida:																										;;
;;			R3 - diz se houve colisao com alguma nave inimiga. se sim retorna 0 se nao retorna 1 				;;
;;               															                           			;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
verifica_colisoes:
    PUSH R4
    PUSH R5

    MOV  R5, nave_inimiga1
    CALL colisao_inimiga  	; chama rotina para ver se a bala colidiu com a nave_inimiga1. Esta retorna 1 se nao houve colisao
    CMP  R3, 1
    JZ   verifica2 			; se nao houve colisao, vai verificar com a nave_inimiga2

; se houve colisao, a bala_em_movimento passa a 0 e faz som
	MOV  R2, 3
    CALL som

    MOV  R3, bala_em_movimento
    MOV  R4, 0
    MOVB [R3],R4

    CALL desenha_naves_inimigas			; desenha naves inimigas na nova posicao. score e nave_inimiga1 foram alterados em colisao_inimiga
    JMP  sai_verifica

; Igual para as outras duas naves inimigas

verifica2:
    MOV  R5, nave_inimiga2
    CALL colisao_inimiga
    CMP  R3, 1
    JZ   verifica3

; se houve colisao, a bala_em_movimento passa a 0 e faz som
	MOV  R2, 3
    CALL som

    MOV  R3, bala_em_movimento
    MOV  R4, 0
    MOVB [R3],R4

    CALL desenha_naves_inimigas
    JMP  sai_verifica

verifica3:
    MOV  R5, nave_inimiga3
    CALL colisao_inimiga
    CMP  R3, 1
    JZ   sai_verifica
; se houve colisao, a bala_em_movimento passa a 0 e faz som
	MOV  R2, 3
    CALL som

    MOV  R3, bala_em_movimento
    MOV  R4, 0
    MOVB [R3],R4
    CALL desenha_naves_inimigas
    
sai_verifica:
    POP R5
    POP R4

    RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																							;;
;; colisao_inimiga - Rotina que verifica se houve colisao entre a bala e 					;;
;;   	 				uma nave inimiga especifica, recebida como argumento				;;
;; Argumentos:																				;;
;;				R5 - nave inimiga a verificar se colidiu									;;
;;																							;;
;; Saida:																					;;
;;				R3 - indica se houve colisao ou nao. se sim retorna 0 se nao retorna 1 		;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
colisao_inimiga:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7


    MOV  R0, posicao_bala
    MOVB R1, [R0]           	; R1 - linha da bala

    ADD  R0, 1
    MOVB R2, [R0]           	; R2 - coluna bala

    MOV  R0, [R5]           	; R0 - tipo de nave inimiga (e, c ou d)

    ADD  R5, 2
    MOVB R6, [R5]           	; R6 - linha da nave inimiga

    ADD  R5, 1
    MOVB R7, [R5]           	; R7 - coluna da nave inimiga

    MOVB R3, [R0]           	; R3 - Dimensao da nave inimiga - linhas

    ADD  R0, 1
    MOVB R4, [R0]           	; R4 - Dimensao da nave inimiga - colunas

; compara linhas
    CMP  R1, R6
    JP   nao_ha_colisao     	; se estiver abaixo da nave nao ha colisao

    SUB  R6, R3

    CMP  R1, R6
    JNP  nao_ha_colisao     	; se estiver acima da nave nao ha colisao


; compara colunas
    CMP  R2, R7
    JN   nao_ha_colisao     	; se estiver a esquerda da nave nao ha colisao

    ADD  R7, R4
    CMP  R2, R7
    JNN  nao_ha_colisao 		; se estiver a direita da nave nao ha colisao

; se nao saltou, e porque houve colisao
; entao, apaga nave inimiga e altera score

    SUB  R5, 3              	; endereco da primeira posicao da nave inimiga
    CALL apaga_nave_inimiga

    CALL repoe_inimiga 			; chama rotina para recolocar a nave inimiga que morreu no topo do ecra (aleatoriamente)
    
    MOV  R3, 0 					; poe R3 (registo de saida) a 0, pois houve colisao

; adiciona 5 pontos ao score (variavel contador) e muda para hexadecimal
    MOV  R4, contador
    MOV  R7, [R4]
    MOV  R2, 5
    ADD  R7, R2
    CALL hexa2dec
    MOV  [R4], R7

    JMP sai_colisao

nao_ha_colisao:
    MOV  R3, 1 					; nao gouve colisao logo poe registo de saida a 1

sai_colisao:
    POP  R7
    POP  R6
    POP  R5
    POP  R4
    POP  R2
    POP  R1
    POP  R0

    RET




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																							;;
;; atualiza_bala - Rotina que atualiza, na variavel posicao_bala, as coordenadas 			;;
;;   	 				onde a bala vai aparecer apos ser disparada 						;;
;;																							;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
atualiza_bala:
    
    PUSH R3
    PUSH R4
    PUSH R5

    MOV  R3,dimensoes_nave
    MOV  R4,posicao_bala
    
    ADD  R3, 2
    MOVB R5, [R3]		; R5 - linha da nave (canto inf. esq.)
    SUB  R5, 5       	; adiciona 5 (dimensao da nave) para por na linha correta onde a bala vai ser disparada
    MOVB [R4], R5		; atualiza posicao_bala
    

    ADD  R4,1            
    ADD  R3,1

    MOVB R5,[R3]		; R5 - linha da nave (canto inf. esq.)						
    ADD  R5,3			; adiciona 3 para por na coluna (dimensoes da nave) correta onde a bala vai ser disparada
    MOVB [R4],R5		; atualiza posicao_bala

    POP  R5
    POP  R4
    POP  R3

    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																							;;
;; apaga_bala - Rotina que apaga a bala 													;;
;;																							;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
apaga_bala:
    PUSH R3
    PUSH R6
    PUSH R5
    PUSH R7

    MOV  R3, posicao_bala
    MOVB R6, [R3] 						; R6 - linha da bala
    ADD  R3, 1
    MOVB R7, [R3] 						; R7 - coluna da bala

    MOV  R5, zero
    CALL escreve_pixel 					; apaga a bala

    
    POP R7
    POP R5
    POP R6
    POP R3

    RET




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;																							;;
;; desenha_bala - Rotina que desenha a bala 												;;
;;																							;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
desenha_bala:
    PUSH R0
    PUSH R3
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    
    MOV  R3, posicao_bala

    MOV  R8, 200                 ;QTD COR
    MOV  R0, DEFINE_VERMELHO     ;COR VERM
    MOV  [R0], R8                ;DEFINE A COR

    MOV  R8, 150                 ;QTD COR
    MOV  R0, DEFINE_VERDE        ;COR VERM
    MOV  [R0], R8                ;DEFINE A COR

    MOV  R8, 250                 ;QTD COR
    MOV  R0, DEFINE_AZUL         ;COR VERM
    MOV  [R0], R8                ;DEFINE A COR


    MOVB R6, [R3] 				; R6 - linha da bala
    ADD  R3, 1
    MOVB R7, [R3] 				; R7 - coluna da bala
    
    MOV  R5, um
    CALL escreve_pixel 			; escreve a bala


    POP  R8
    POP  R7
    POP  R6
    POP  R5
    POP  R3
    POP  R0
    RET






; **********************************************************************
; ROT_INT_0 - Rotina de atendimento da interrupção 0
;             Assinala o evento na componente 0 da variável evento_int
; **********************************************************************
rot_int_0:
	PUSH R0
	PUSH R1
	MOV  R0, evento_int
	MOV  R1, 1              ; assinala que houve uma interrupção 0
	MOV  [R0], R1            ; na componente 0 da variável evento_int
	POP  R1
	POP  R0
	RFE

; **********************************************************************
; ROT_INT_1 - Rotina de atendimento da interrupção 1
;             Assinala o evento na componente 1 da variável evento_int
; **********************************************************************
rot_int_1:
	PUSH R0
	PUSH R1
	MOV  R0, evento_int
	MOV  R1, 1               ; assinala que houve uma interrupção 0
	MOV  [R0 + 2], R1          ; na componente 1 da variável evento_int
	                      ; Usa-se 2 porque cada word tem 2 bytes
	POP  R1
	POP  R0
	RFE



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                       									;;
;;  apaga_desenho - rotina que apaga algo passado como argumento     		;;
;;  Argumentos:            													;;
;;				R3 - maximo de linhas 										;;
;;				R4 - maximo de colunas 										;;
;;				R6 - linha onde comeca a desenhar 							;;
;;				R7 - coluna onde comeca a desenhar 							;;
;;					 														;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
apaga_desenho:
	
	PUSH    R0
    PUSH    R1
    PUSH    R2
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7

    MOV     R0, R7  		; r7 vais ser alterado, logo temos que o gravar
    MOV     R2, 0   		; contador de colunas
    MOV     R1, 0   		; contador de linhas

    MOV 	R5, zero
inicio_apaga:
    CALL    escreve_pixel 	; desenha um pixel
    ADD     R7, 1			; passa para a proxima coluna (a direita)
    ADD     R2, 1			; aumenta contador
    CMP     R2, R4			; verifica se ja chegou ao maximo de colunas
    JNZ     inicio_apaga	; se nao, volta a desenhar
    ADD     R1, 1			; se ja, aumenta contadro linhas
    CMP     R1, R3			; verifica se ja chegou ao maximo de linhas
    JZ      fim_apaga_desenho	; se ja, termina
    MOV     R2, 0			; se nao, poe o contador de colunas a zero, para comecar a desenhar nova linha
    MOV     R7, R0			; volta a coluna inicial, para comecar a desenhar nova linha
    SUB     R6, 1			; anda uma linha para cima
    JMP     inicio_apaga
 fim_apaga_desenho:
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R2
    POP     R1
    POP     R0

    RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                       										;;
;;  move_nave_inimiga - rotina que move uma nave inimiga 		     			;;
;;  (Termina o jogo se a nave colidir com a principal ou se ficar sem pontos)	;;
;;																				;;
;;  Argumentos:            														;;
;;				R5 - nave inimiga 1, 2 ou 3 (nave_inimiga_[1/2/3])				;;
;;					 															;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_nave_inimiga:
	
	PUSH R0
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7

	CALL apaga_nave_inimiga 	; retorna r6 (linha da nave inimiga) e r7(coluna da nave inimiga)

	MOV  R0, [R5]

	ADD  R0, 4 		; Para ir buscar o tipo de movimento desta nave inimiga
	MOVB R3, [R0]
	ADD  R6, R3		; Muda a linha da nave

	ADD  R0, 1
	MOVB R3, [R0]
	ADD  R7, R3		; Muda a coluna da nave
	MOV  R0, 0FFH
	AND  R7, R0 	; para limpar bits de maior peso se o movimento for para a esquerda(-1). estamos a usar string

	ADD  R5, 2		; adiciona 2 porque a primeira posicao e word
	MOVB [R5], R6 	; GUARDA NO ENDERECO (linha)

	ADD  R5, 1
	MOVB [R5], R7	; GUARDA NO ENDERECO (coluna)


    SUB  R5, 3      ; primeira posicao de nave_inimiga_[1/2/3]

    MOV  R3, R5
    CALL colisao_internave 		; verifica se houve colisao entre a nave inimiga e a nave principal. retorna 0 se houve
    CMP  R3, 0
    JZ   perdeu_internave		; se houve colisao perdeu o jogo

	;Ve se chegou ao fim
	MOV  R3, N_LINHAS
	CMP  R6, R3              ; já estava na linha do fundo?
	JLT  fim_move 			 ; se nao salta

; se sim:
; reduzir contador e aparecer nova nave aleatoria

	MOV  R2, 1
    CALL som
	
    CALL repoe_inimiga 		; 'cria' nova nave numa posicao aleatoria

; retira 10 pontos ao score (variavel contador). se ficar menor que 0 perdeu. Passa valor para decimal
	MOV  R4, contador
	MOV  R7, [R4]
	MOV  R2, 10
	SUB  R7, R2
    MOV  R6, 0
    CMP  R6, R7
    JP   perdeu
	CALL hexa2dec
	MOV  [R4], R7
    JMP  fim_move



perdeu_internave:
;faz som
    MOV  R2, 2
    CALL som


; se perdeu
perdeu:
    CALL apaga_ecra

; modo perdeu fica 1    
    MOV  R4, modo_perdeu
    MOV  R5, 1
    MOVB [R4], R5

; modo comeca fica 0 (ja nao esta a decorrer um jogo)
    MOV  R4, modo_comeca
    MOV  R5, 0
    MOVB [R4], R5

; muda cenario
    MOV  R2, CENARIO_PERDEU
    CALL escreve_cenario


fim_move:


	POP  R7
	POP  R6
	POP  R5
	POP  R4
	POP  R3
	POP  R0

	RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                       										;;
;; colisao_internave - rotina que verifica se houve colisao entre a nave		;;
;;  					principal e uma nave inimiga (recebida como argumento)	;;
;;																				;;
;; Argumentos:            														;;
;;		   R3 - nave inimiga 1, 2 ou 3 (nave_inimiga_[1/2/3])					;;
;;					 															;;
;; Saidas:	            														;;
;;		   R3 - diz se houve colisao, se houve retorna 0 se nao houve retorna 1	;;
;;					 															;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
colisao_internave:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R4
    PUSH R5
    PUSH R6
    PUSH R7
    PUSH R8
    PUSH R9
    PUSH R10



    MOV R0, [R3]


    ADD  R3, 2
    MOVB R4, [R3]    ; R4 - linha nave inimiga

    ADD  R3, 1
    MOVB R5, [R3]    ; R5 - coluna nave inimiga

    MOVB R1, [R0]    ; R1 - tamanho da inimgia(linhas)

    ADD  R0, 1
    MOVB R2, [R0]    ; R2 - tamanho da inimgia(colunas)


    MOV  R7, dimensoes_nave
    MOVB R6, [R7]      ; R6 - tamanho da principal(linhas)

    ADD  R7, 1
    MOVB R8, [R7]      ; R8 - tamanho da principal(colunas)

    ADD  R7, 1
    MOVB R9, [R7]      ; R9 - linha nave principal

    ADD  R7, 1
    MOVB R10, [R7]     ; R10 - coluna nave principal

    ;Vamos verificar as linhas
    SUB  R9, R6 					; R9 - linha superior da principal
    CMP  R4, R9 					; comparar linha inferior da inimiga com linha superior da principal 
    JNP  nao_ha_colisao_internave	; se nao for maior e porque nao houve colisao

    SUB  R4, R1 					; R4 - linha superior da inimiga
    ADD  R9, R6 					; R9 - linha inferior da principal
    CMP  R4, R9						; comparar linha superior da inimiga com linha infeior da principal
    JNN  nao_ha_colisao_internave 	; se nao for menor e porque nao houve colisao


    ;Se chegou aqui e porque as linhas colidem 

    ADD  R8, R10 					; R8 - coluna direita da principal
    CMP  R8, R5 					; comparar coluna direita da principal com coluna esquerda da inimiga 
    JNP  nao_ha_colisao_internave 	; se nao for maior e porque nao houve colisao

    ADD  R5, R2 					; R5 - coluna direita da inimiga
    CMP  R10, R5 					; comparar coluna esquerda da principal com coluna direita da inimiga 
    JNN  nao_ha_colisao_internave 	; se nao for menor e porque nao houve colisao


    ;Se chegou aqui ha colisao com a central

    MOV  R3, 0 						; poe registo de saida com 0 (houve colisao)
    JMP  sai_colisao_internave

nao_ha_colisao_internave:
    MOV  R3, 1 						; poe registo de saida a 1 (nao houve colisao)

sai_colisao_internave:
    POP  R10 
    POP  R9
    POP  R8
    POP  R7
    POP  R6 
    POP  R5
    POP  R4
    POP  R2
    POP  R1
    POP  R0

    RET







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                       										;;
;; apaga_ecra - rotina que apaga todas as naves e a bala do ecra 				;;
;;																				;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
apaga_ecra:
    PUSH R3
    PUSH R5
    PUSH R7

    MOV  R5, dimensoes_nave                 ;apaga nave
    MOVB R3, [R5]

    ADD  R5, 1
    MOVB R4, [R5]

    ADD  R5, 1
    MOVB R6, [R5]

    ADD  R5, 1
    MOVB R7, [R5]
    CALL apaga_desenho

    MOV  R5, nave_inimiga1          ; apaga nave inimiga
    CALL apaga_nave_inimiga

    MOV  R5, nave_inimiga2          ; apaga nave inimiga
    CALL apaga_nave_inimiga

    MOV  R5, nave_inimiga3          ; apaga nave inimiga
    CALL apaga_nave_inimiga

    CALL apaga_bala

    POP  R7
    POP  R5
    POP  R3

    RET




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                       												;;
;; apaga_nave_inimiga - rotina que apaga uma nave inimiga (recebida como argumento)		;;
;;																						;;
;; Argumentos:            																;;
;;		   R5 - nave inimiga 1, 2 ou 3 (nave_inimiga_[1/2/3])							;;
;;					 																	;;
;; Saidas:	            																;;
;;		   R6 - linha da nave inimiga que foi apagada 									;;
;;		   R7 - linha da nave inimiga que foi apagada 									;;
;;					 																	;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
apaga_nave_inimiga:
	PUSH R0
	PUSH R3
	PUSH R4
	PUSH R5

	MOV  R0, [R5]
	MOVB R3, [R0]	; MAX LINHAS

	ADD  R0, 1
	MOVB R4, [R0]	; MAX COLUNAS

	ADD  R5, 2
	MOVB R6, [R5]	; linha atual

	ADD  R5, 1
	MOVB R7, [R5]	; coluna ATUAL 

	CALL apaga_desenho

	POP  R5
	POP  R4
	POP  R3
	POP  R0

	RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                       										;;
;; colisao_internave - rotina que verifica se houve colisao entre a nave		;;
;;  					principal e uma nave inimiga (recebida como argumento)	;;
;;																				;;
;; Argumentos:            														;;
;;		   R5 - nave inimiga 1, 2 ou 3 (nave_inimiga_[1/2/3])					;;
;;					 															;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
repoe_inimiga:
    PUSH R0
    PUSH R3
    PUSH R4
    PUSH R5

; vai buscar o numero aleatorio    
    MOV  R3, aleatorio
    MOVB R3, [R3]
    MOV  R4, 3
    MOD  R3, R4 					; R3 - resto da divisao do nr. aleatorio por 3


; Se R3 for 0 a nova nave inimiga fica na esquerda, se for 1 fica no centro e se for 2 fica na direita


    CMP  R3, 0
    JNZ  compara1 					; se nao e 0 ve se e 1
    MOV  R0, dimensoes_nave_inimiga_e
    JMP  repoe
    

compara1:
    CMP  R3, 1
    JNZ  compara2 					; se nao e 1 ve se e 2
    MOV  R0, dimensoes_nave_inimiga_c
    JMP  repoe

compara2:
    MOV  R0, dimensoes_nave_inimiga_d
    JMP  repoe


repoe:

; altera nave inimiga
    MOV  [R5], R0 					; [R5] - tipo de nave (c, e ou d)

    ADD  R5, 2 						; anda 2 porque e word
    ADD  R0, 2 						; anda 2 para ir buscar posicoes iniciais
    MOVB R4, [R0]
    MOVB [R5], R4 					; [R5] - linha inicial da nova nave inimiga

    ADD  R5, 1
    ADD  R0, 1
    MOVB R4, [R0]
    MOVB [R5], R4 					; [R5] - coluna inicial da nova nave inimiga

    CALL aumenta_aleatorio 			;para nao nascerem no mesmo sitio 2 naves se chegarem ao fundo ao mesmo tempo

    POP  R5
    POP  R4
    POP  R3
    POP  R0

    RET




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                       								;;
;;  desenha_nave - rotina que desenha nave principal	 			   	;;
;;	Argumentos:       Nao tem              								;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 desenha_nave:
    PUSH    R0
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    PUSH    R8

 	; INICIALIZACOES DA ROTINA
    MOV		R5, dimensoes_nave
 	MOVB	R3, [R5]	; MAX LINHAS
 	ADD		R5, 1		
 	MOVB	R4, [R5]	; MAX COLUNAS
 	ADD 	R5, 1
 	MOVB	R6, [R5]
    ADD     R5, 1
 	MOVB 	R7, [R5]

    MOV     R5, pixeis

    ; DEFINIR COR DA NAVE
    MOV     R8, 255                 ;QTD COR
    MOV     R0, DEFINE_VERMELHO     ;COR VERM
    MOV     [R0], R8                ;DEFINE A COR

    MOV     R8, 0                   ;QTD COR
    MOV     R0, DEFINE_VERDE        ;COR VERM
    MOV     [R0], R8                ;DEFINE A COR

    MOV     R8, 0                   ;QTD COR
    MOV     R0, DEFINE_AZUL         ;COR VERM
    MOV     [R0], R8                ;DEFINE A COR

    CALL    escreve_desenho

    POP     R8
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R0
 	
    RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                      ;;
;;  desenha_naves_inimigas - rotina que desenha todas as naves inimigas ;;
;;  Argumentos:        Nao tem                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
desenha_naves_inimigas:
    PUSH    R0
    PUSH    R1
    PUSH    R3
    PUSH    R4
    PUSH    R5
    PUSH    R6
    PUSH    R7
    PUSH    R8

;    MOV     R5, dimensoes_nave_inimiga
    MOV     R1, 3                   ; NUMERO DE NAVES
    
    MOV     R8, 0                   ;QTD COR
    MOV     R0, DEFINE_VERMELHO     ;COR VERM
    MOV     [R0], R8                ;DEFINE A COR

    MOV     R8, 100                 ;QTD COR
    MOV     R0, DEFINE_VERDE        ;COR VERM
    MOV     [R0], R8                ;DEFINE A COR

    MOV     R8, 200                 ;QTD COR
    MOV     R0, DEFINE_AZUL         ;COR VERM
    MOV     [R0], R8                ;DEFINE A COR

    MOV 	R5, nave_inimiga1		; vai buscar qual e a nave
    MOV     R8, R5					; guarda para usar depois
    MOV 	R5, [R5]				; vai ao endereco generico da nave (exemplo: dimensoes_nave_inimiga_c)

desenha_naves:
    MOVB    R3, [R5]    ; MAX LINHAS
    ADD     R5, 1       
    MOVB    R4, [R5]    ; MAX COLUNAS

    ADD     R8, 2						; (+2 PQ E WORD) posicao da nave esta em nave_inimiga_[numero de 1 a 3], guardado em R8 e nao no endereco generico da nave (exemplo: dimensoes_nave_inimiga_c)
    MOVB    R6, [R8]    ; LINHA INICIAL
    ADD     R8, 1
    MOVB    R7, [R8]    ; COLUNA INICIAL

    ADD     R5, 5						; avanca para os pixeis
    CALL    escreve_desenho
    SUB     R1, 1
    JZ      fim_desenha_inimigas
    ADD 	R8, 1						; vai para a proxima nave
    MOV   	R5, R8
    MOV 	R5, [R5]					; vai ao endereco generico da nave
    JMP 	desenha_naves

fim_desenha_inimigas:
    POP     R8
    POP     R7
    POP     R6
    POP     R5
    POP     R4
    POP     R3
    POP     R1
    POP     R0
    
    RET





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                       									;;
;;  escreve_desenho - rotina que desenha algo passado como argumento     	;;
;;  Argumentoa:            													;;
;;				R3 - maximo de linhas 										;;
;;				R4 - maximo de colunas 										;;
;;				R5 - endereco de memoria, que vai dar informacao necessaria ;;
;;						para desenhar (dimensoes e valores de pixeis)		;;
;;				R6 - linha onde comeca a desenhar 							;;
;;				R7 - coluna onde comeca a desenhar 							;;
;;					 														;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
escreve_desenho:
    PUSH    R0
    PUSH    R1
    PUSH    R2

    MOV     R0, R7  ; r7 vais ser alterado, logo temos que o gravar
    MOV     R2, 0   ; contador de colunas
    MOV     R1, 0   ; contador de linhas

inicio_desenho:
    CALL    escreve_pixel 	; desenha um pixel
    ADD     R5, 1			; avanca para o proximo endereco
    ADD     R7, 1			; passa para a proxima coluna (a direita)
    ADD     R2, 1			; aumenta contador
    CMP     R2, R4			; verifica se ja chegou ao maximo de colunas
    JNZ     inicio_desenho	; se nao, volta a desenhar
    ADD     R1, 1			; se ja, aumenta contadro linhas
    CMP     R1, R3			; verifica se ja chegou ao maximo de linhas
    JZ      fim_escreve_desenho	; se ja, termina
    MOV     R2, 0			; se nao, poe o contador de colunas a zero, para comecar a desenhar nova linha
    MOV     R7, R0			; volta a coluna inicial, para comecar a desenhar nova linha
    SUB     R6, 1			; anda uma linha para cima
    JMP     inicio_desenho
 fim_escreve_desenho:
    POP     R2
    POP     R1
    POP     R0

    RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ESCREVE_PIXEL - Rotina que escreve um pixel na linha e coluna indicadas.    ;; 
;; Argumentos:   R6 - linha                                                    ;;
;;               R7 - coluna                                                   ;; 
;;               R5 - endereco onde esta o valor do pixel (0 ou 1)             ;; 
;;                                                                             ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 escreve_pixel:
    PUSH R0
    PUSH R3
    
    MOV  R0, DEFINE_LINHA
    MOV  [R0], R6           ; seleciona a linha
    
    MOV  R0, DEFINE_COLUNA
    MOV  [R0], R7           ; seleciona a coluna

    MOV  R0, DEFINE_PIXEL

    MOVB R3, [R5]
    MOV  [R0], R3          ; liga ou desliga o pixel na linha e coluna selecionadas
    
    POP  R3
    POP  R0
    RET




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; escreve_cenario - Rotina que coloca cenario de fundo                        ;; 
;; Argumentos:   R2 - Nmr cenario                                              ;;
;;                                                                             ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 escreve_cenario:
    PUSH R0

    MOV R0, DEFINE_CENARIO
    MOV [R0], R2

    POP R0

    RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; som - Rotina que emite som                                                  ;; 
;; Argumentos:   R2 - Nmr do som                                               ;;
;;                                                                             ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 som:
    PUSH R0

    MOV R0, DEFINE_SOM
    MOV [R0], R2

    POP R0

    RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hexa2dec - Rotina que passa um valor hexadecimal para decimal e coloca no display    ;; 
;; Argumentos:                                                                          ;;
;;               R7 - valor em hexadecimal                                              ;; 
;;                                                                                      ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hexa2dec:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    PUSH R5
    PUSH R7

    MOV R0, R7  ; copia do valor em hexa
    MOV R1, 16  ; valores auxiliares
    MOV R2, 10  
    MOV R3, 1   ; registo que vai guardar potencias de 16
    MOV R5, 0   ; resultado decimal
ciclo_hexa:
    MOV R7, R0  ; copia o resultado da ultima divisao para R0
    MOD R7, R2  ; resto da divisao do valor por 10 (AH), que da o numero a esquerda
    MUL R7, R3  ; multiplica esse resto pela potencia de 16 equivalente a casa em que se encontra
    ADD R5, R7  ; adiciona ao resultado final
    MUL R3, R1  ; multiplica por 16, para a proxima casa
    DIV R0, R2  ; divisao inteira por 10, para obter o valor da proxima casa
    JNZ ciclo_hexa  ; se ainda nao for zero repete

    MOV R2, DISPLAYS
    MOV [R2], R5    ; coloca valor no display

    POP R7
    POP R5
    POP R3
    POP R2
    POP R1
    POP R0
    RET




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; atraso - Rotina que 'gasta' tempo									       ;; 
;; Argumentos:   Nao tem                                                       ;;
;;                                                                             ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
atraso:
    PUSH R0
    
    MOV  R0, DELAY
ciclo_atraso:
    SUB  R0, 1
    JNZ  ciclo_atraso
    POP R0

    RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                             ;; 
;; aumenta_aleatorio - Rotina que aumenta o numero aleatorio			       ;; 
;;                                                                             ;;  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
aumenta_aleatorio:

	PUSH R0
	PUSH R1
	PUSH R2

	MOV  R2, aleatorio
	MOV  R0, 1
	MOVB R1, [R2]
	ADD  R1, R0
	MOVB [R2], R1

	POP R2
	POP R1
	POP R0

	RET