
datasg		SEGMENT PARA 'veri'
vize        DB 77, 85, 64, 96       
final       DB 56, 63, 86, 74
temp        DW ?       
obp         DB 4 DUP(0)     
datasg		ENDS

stacksg		SEGMENT PARA STACK 'yigin'
			DW 32 DUP(?)
stacksg		ENDS

codesg		SEGMENT PARA 'kod'
			ASSUME DS:datasg, SS:stacksg, CS:codesg
ana         PROC FAR
			PUSH DS
			XOR AX, AX
			PUSH AX
			MOV AX, datasg
			MOV DS, AX

            MOV CX,4
obp_loop:   MOV temp, 0
            MOV AX,CX
            DEC AX
            MOV SI,AX

            MOV AL, vize[SI]
            MOV DL, 4
            MUL DL
            ADD temp,AX
            MOV AL, final[SI]
            MOV DL,6
            MUL DL
            ADD temp,AX
            MOV AX,temp
            
            MOV BL,10
            DIV BL
            MOV obp[SI],AL

            CMP AH , 4
            JNA etiket
            ADD obp[SI],1
            
etiket:     LOOP obp_loop

sort_obp: MOV CX, 4         
          DEC CX            
out_loop: MOV SI, 0           

in_loop: MOV DI, SI
            INC DI            
            MOV AL, obp[SI]  
            CMP AL, obp[DI]   
            JAE skip_swap     
           
            MOV  BL, obp[SI]
            XCHG BL, obp[DI]
            MOV obp[SI],BL 

skip_swap:  INC SI            
            CMP SI, CX        
            JL in_loop     

            DEC CX            
            CMP CX, 0         
            JG out_loop 
    		RETF
ana		    ENDP
codesg		ENDS
			END ana