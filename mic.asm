#start=DAS5332_Temp.exe#      
      
data segment
    iniciou DB 0
    
    NIVELMAX EQU 50d
    nivel DB 1
    
    sequencia DB NIVELMAX DUP(0)
    fim_sequenecia DB ?
ends

stack segment
    dw   16  dup(0)
ends       

interrupt segment   
    trata90h:
        MOV iniciou, 1
        IRET
        
    trata91h:
        ;reinicia
        IRET
        
    
interrupt ends

code segment
    ;---------------CONFIGURACAO---------------;
    config_interrupt PROC
        MOV AX, interrupt
        MOV DS, AX
        
        MOV DX, offset trata90h
        MOV AL, 90h
        MOV AH, 25h  ;;21/25 usa DS:DX
        INT 21h
        
        MOV DX, offset trata91h
        MOV AL, 91h
        MOV AH, 25h
        INT 21h
        
        RET
    config_interrupt ENDP
    
    generate_random PROC
        MOV AH, 00  ;Interrupcao 1A/00
        INT 1AH     ;CX:DX recebe o numero de ticks do clock desde a meia noite   
        
        MOV AX, DX
        XOR DX, DX ;DX = 0
        MOV CX, 8  ;CX = 10
        DIV CX     ;AX = AX/CX -> resto vai para DX->numero entre 0 e 7
        INC DX     ;Agora DX esta entre 1 e 8
        
        RET
    generate_random ENDP
    
    
    ;---------------Programa Principal---------------;
START:
    CALL config_interrupt
    MOV AX, data
    MOV DS, AX
    MOV ES, AX
    MOV SI, 00
    
    
STANDBY:
    CMP iniciou, 1
    JNE STANDBY
    
PISCA:
    CALL generate_random
    MOV sequencia[SI], DL
    INC SI
    
    ;Jogar esses numeros no led sequencialmente
    
    JMP STANDBY

INPUT:
    ;Ve o que o jogador botou, compara com a lista
    ;Se acertou, continua verificando, ate chegar em NIVEL vezes, quando da delay e pula pra pisca
    ;Se errou, pisca e reinicia
     
DELAY:
    ;CALL atraso
    ;nivel +1
    ;atualizar LED Display
    ;if(nivel<nivelmax):
    ;JMP Pisca   ]
    ;else parabens e reinciia
    

REINICIA:
    ;Nivel = 1
    ;Atualiza nivel display
    ;Zera lista (ou nao) -> tem que ver como lidar com a lista
    ;JMP standby
    
            
    
ends

end START ; set entry point and stop the assembler.


