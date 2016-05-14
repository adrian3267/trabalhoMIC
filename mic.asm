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
    ;---------------PROCEDIMENTOS---------------;
    config_interrupt PROC  ;Configura as interrupcoes
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
    
    
    generate_random PROC ;Gera numero aleatorio entre 1 e 8
        MOV AH, 00  ;INT 1A-00
        INT 1AH     ;CX:DX recebe o numero de ticks do clock desde a meia noite   
        
        MOV AX, DX
        XOR DX, DX ;DX = 0
        MOV CX, 8  ;CX = 8
        DIV CX     ;AX = AX/CX -> resto vai para DX->numero entre 0 e 7
        INC DX     ;Agora DX esta entre 1 e 8
        
        RET
    generate_random ENDP
    
    atraso PROC ;Gera atraso
        PUSH CX
        MOV CX, 20h
        CALL atraso2
        POP CX
        ret
    atraso ENDP
    
    atraso2 PROC ;Funcao auxiliar do atraso
        loop atraso2
        ret
    atraso2 ENDP
    
    
    transforma PROC  ;Precisa transforma o numero inteiro 1~8
        CMP AL, 0011b ;em uma saida de LED
        JE arruma3    ;Esse jeito ta bem chato, tentem ver se 
                      ;existe uma forma melhor, sem ter que tratar
        CMP AL, 0100b ;caso a caso.
        JE arruma4
        
        CMP AL, 0101b    ;Note que no caso 1 e 2 nao mexi pq nao precisa.
        JE arruma5
        
        CMP AL, 0110b
        JE arruma6
        
        CMP AL, 0111b
        JE arruma7
        
        CMP AL, 1000b
        JE arruma8
        
        RET
    
    arruma3:
        MOV AL, 100b
        RET
    
    arruma4:
        MOV AL, 1000b
        RET
    
    arruma5:
        MOV AL, 10000b
        RET
        
    arruma6:
        MOV AL, 100000b
        RET
        
    arruma7:
        MOV AL, 1000000b
        RET
        
    arruma8:
        MOV AL, 10000000b
        RET   
    ;---------------Programa Principal---------------;
START:
    CALL config_interrupt ;configura interrupcoes
    
    MOV AX, data ;aponta DS e ES para o data segment
    MOV DS, AX
    MOV ES, AX
    
    MOV SI, 00 ;inicia SI em 0. *ponteiro de lista*
    
STANDBY:
    CMP iniciou, 1 ;espera iniciar
    JNE STANDBY
    
ADD_SEQ:
    CALL generate_random  ;gera random
    MOV sequencia[SI], DL ;poe na sequencia
    INC SI
    
PISCA_LED:
    PUSH SI        ;salva SI
    MOV SI, 00h         
    MOV CL, nivel ;vai piscar nivel leds
    
pisca1:
    MOV AL, sequencia[SI]
    CALL transforma    ;transforma o numero inteiro em uma saida pros leds       
    OUT 21h, AL
    INC SI
    CALL atraso
    loop pisca1   ;pisca nivel vezes.
    

INPUT:
    POP SI  ;recupera SI 
    
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


