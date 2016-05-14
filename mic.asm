; multi-segment executable file template.

data segment
    iniciou DB 0
    standby DB 0 
    NIVELMAX DB 50d
    nivel DB 1
    ;adiciona uma lista de tamanho X, com tudo 0
ends

stack segment
    dw   16  dup(0)
ends       

interrupt segment
    ;90h comeca -> seta iniciou=1; verificar se esta em standby
    ;91h reinicia
    
interrupt ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax
    
    ;Adicionar config das interrupcoes
    
standby:
    MOV standby, 1
    CMP iniciou, 1
    JNE standby
    
pisca:
    ;gerar numero aleatorio, adicionar a lista
    ;pega NIVEL elementos da lista e joga no led, sequencialmente

input:
    ;Ve o que o jogador botou, compara com a lista
    ;Se acertou, continua verificando, ate chegar em NIVEL vezes, quando da delay e pula pra pisca
    ;Se errou, pisca e reinicia
     
delay:
    ;CALL atraso
    ;nivel +1
    ;atualizar LED Display
    ;if(nivel<nivelmax):
    ;JMP Pisca   ]
    ;else parabens e reinciia
    

reinicia:
    ;Nivel = 1
    ;Atualiza nivel display
    ;Zera lista (ou nao) -> tem que ver como lidar com a lista
    ;JMP standby
    
            
    
ends

end start ; set entry point and stop the assembler.


