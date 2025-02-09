#INCLUDE <P16F628A.INC>
	    
;Configuração dos Fuses bits do microcontrolador
    __CONFIG _FOSC_INTOSCIO & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

    CBLOCK 0x20         ; Define um bloco de memória RAM para variáveis
        d1              ; Primeiro contador do loop externo
        d2              ; Segundo contador do loop intermediário
        d3              ; Terceiro contador do loop interno
    ENDC  
    
#DEFINE SENSOR_ESQUERDO	PORTB,	5
#DEFINE	SENSOR_MEIO	PORTB,	6
#DEFINE	SENSOR_DIREITO	PORTB,	7
    
; IESTADOS DE PORTA TAL QUE OCORREM AS SEGUINTES AÇÕES
; ESSES ESTADOS SERÃO INSERIDOS EM PORTA
    
#DEFINE	VIRA_ESQUERDA	b'00000110'	;DEFINE O BYTE DE TAL FORMA QUE O MOTOR DIREITO SEJA ACIONADO
#DEFINE	FRENTE		b'00001010'	;DEFINE O BYTE DE TAL FORMA QUE AMBOS OS MOTORES SEJAM ACIONADOS
#DEFINE	VIRA_DIREITA	b'00001001'	;DEFINE O BYTE DE TAL FORMA QUE O MOTOR ESQUERDO SEJA ACIONADO

    
    
; PINAGEM DA PONTE H
;#DEFINE	INPUT_1		PORTA,	0
;#DEFINE	INPUT_2		PORTA,	1
;#DEFINE	INPUT_3		PORTA,	2
;#DEFINE	INPUT_4		PORTA,	3
    
; FRENTE --> 
	    ;INPUT_1 = 1, 
	    ;INPUT_2 = 0, 
	    ;INPUT_3 = 1, 
	    ;INPUT_4 = 0
    
; DIREITA --> 
	    ;INPUT_1 = 1, 
	    ;INPUT_2 = 0, 
	    ;INPUT_3 = 0, 
	    ;INPUT_4 = 1
    
; ESQUERDA -->	
	    ;INPUT_1 = 0, 
	    ;INPUT_2 = 1, 
	    ;INPUT_3 = 1, 
	    ;INPUT_4 = 0

    ORG 0x00
    GOTO INICIO

    ORG 0x04
    RETFIE

INICIO:
    BANKSEL TRISA
    CLRF    TRISA
    
    BANKSEL PORTA
    
    CLRF    PORTA
    
    BANKSEL TRISB
    
    MOVLW   0xFF
    MOVWF   TRISB
    
LOOP:
    
    MOVLW   FRENTE
    
    ;LÓGICA SENSOR_ESQUERDO
    
    BANKSEL PORTB
    
    BTFSC   SENSOR_ESQUERDO
    MOVLW   VIRA_ESQUERDA
    
    ;LÓGICA SENSOR DIREITO
    
    BTFSC   SENSOR_DIREITO
    MOVLW   VIRA_DIREITA
    
    BANKSEL PORTA
    
    MOVWF   PORTA
    
    CALL    Delay_1s
 
    GOTO    LOOP
    
    
Delay_1s
    movlw   0x5        ; Carrega 12 (0x0C) no registrador W
    movwf   d1          ; Armazena em d1

Loop1
    movlw   0x5        ; Carrega 255 (0xFF) no registrador W
    movwf   d2          ; Armazena em d2

Loop2
    movlw   0x5        ; Carrega 255 (0xFF) no registrador W
    movwf   d3          ; Armazena em d3

Loop3
    nop                 ; Nenhuma operação (Ajuste fino)
    nop
    nop
    decfsz  d3, f       ; Decrementa d3, se zero, sai do loop
    goto    Loop3       ; Se não zero, repete Loop3

    decfsz  d2, f       ; Decrementa d2, se zero, sai do loop
    goto    Loop2       ; Se não zero, repete Loop2

    decfsz  d1, f       ; Decrementa d1, se zero, sai do loop
    goto    Loop1       ; Se não zero, repete Loop1

    return              ; Retorna para o programa principal
    
    
    END



