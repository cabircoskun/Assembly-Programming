mys       SEGMENT PARA 'butun'
          ORG 100h
          ASSUME CS:mys,DS:mys,SS:mys
main:     JMP HIPOTENUS
a                 DB   1
b                 DB   1
c                 DB   0
tmp               DW   0
primeOddSum       DB 15 DUP(0)
index1            DB 0
nonPrimeOrEvenSum DB 15 DUP(0)
index2            DB 0
primeEdges        DB 12 DUP(0)

HIPOTENUS  PROC NEAR

           MOV BL,1 ; a
           MOV BH,1 ; b
          
           XOR SI,SI
           XOR DI,DI

DIS_DONGU: MOV BH,BL
           INC BH; b = a+1 den baslatıyoruz her seferinde.
          
IC_DONGU : MOV DX,0
           MOV tmp,DX ; her seferinde a^2 + b^2 degeri tmp de tutulcak o yuzden her seferinde sıfırlanmalı
           
           MOV AL,BL
           MUL BL  ; AX = a^2 oldu
           ADD tmp,AX

           MOV AL,BH ; 
           MUL BH; AX = b^2 oldu
           ADD tmp, AX

           ;c^2 tamkare mi ? kontrol
           MOV CL,0

TAMKARE :  INC CL ;CL dongu degiskeni
           MOV AL,CL
           MUL CL
           CMP AX,tmp
           JB TAMKARE
           JA NTAMKARE
           
           CMP CL,50
           JA NTAMKARE
           
           MOV c,CL; TAMSAYI OLAN BİR HİPOTENUS YAKALADIYSAK BURADAYIZ.
           
           XOR AH,AH
           MOV AL,c
           MOV DH,2
           DIV DH ; AL NİN İCİNDE C/2 OLUŞUYOR, (BOLUM)
           MOV DH,AL
           MOV CL,1

ASALCHECK: INC CL ;c^2 asal mı? kontrol
           XOR AH,AH
           MOV AL,c
           DIV CL
           CMP CL,DH
           JA ASAL
           CMP AH,0
           JE NASAL ;
           JMP ASALCHECK        

DIS_DONGU1:JMP DIS_DONGU;BUNU YUKARIYA DOĞRU ZIPLAMA LİMİTİ OLDUGUNDAN YAPTIM.
IC_DONGU1 :JMP IC_DONGU;BUNU YUKARIYA DOĞRU ZIPLAMA LİMİTİ OLDUGUNDAN YAPTIM.

ASAL:      MOV AL,c     ; HİPOTENÜS DEĞERİNİ AL REGİSTERINDA GONDERİYORUM
           CALL CH_EXIST; İLGİLİ HİPOTENÜS ZATEN VAR MI YOK MU DİYE KONTROL EDİLİYOR.
           CMP AH,1
           JE NTAMKARE
           XOR AX,AX ;teklik kontrolü yapılıyor.
           ADD AL,BL
           ADD AL,BH
           MOV DL,2
           DIV DL
           CMP AH,0 ; (A+B)%2 == 0 kontrolü
           JE NASAL ;eger % 2 sıfır ise not asal label ına gonderiliyor.
           MOV DL,c
           MOV primeOddSum[SI],DL
           MOV AX,SI; BURADA PRİME EDGES DİZİSİNE EKLEME YAPACAGIM İCİN İNDİS AYARLIYORUM. HER SEFERİNDE 2İ VE 2İ+1. İNDİSLERE KENARLARI KOYUYORUM.
           MOV CL,2
           MUL CL
           MOV CX,DI ; DI REGİSTERINI DİZİYE ERİŞMEK İCİN KULLANACAGIMDAN ORJİNAL DEGERİNİ CX DE SAKLYIORUM
           MOV DI,AX ; AX DE 2*SI VARDI
           MOV primeEdges[DI],BL
           INC SI
           MOV primeEdges[DI+1],BH
           MOV DI,CX

           JMP NTAMKARE
           
NASAL:     MOV AL,c     ; HİPOTENÜS DEĞERİNİ AL REGİSTERINDA GONDERİYORUM
           CALL CH_EXIST; İLGİLİ HİPOTENÜS ZATEN VAR MI YOK MU DİYE KONTROL EDİLİYOR.
           CMP AH,1
           JE NTAMKARE
           MOV DL,c
           MOV nonPrimeOrEvenSum[DI],DL
           INC DI

NTAMKARE : INC BH
           CMP BH,50
           JB IC_DONGU1

           INC BL; dış dongu degiskeni (a) yı bir arttır
           CMP BL,48
           JBE DIS_DONGU1

           RET

HIPOTENUS ENDP
CH_EXIST PROC NEAR
MOV DX, SI ; ASAL DİZİ İNDİSİ
MOV CX, DI ; NONASAL DİZİ İNDİSİ

XOR SI,SI
XOR DI,DI
MOV AH,1
DONGU   : CMP AL,primeOddSum[SI]
          JE SON
          INC SI
          CMP SI,DX
          JBE DONGU

          
DONGU2  : CMP AL,nonPrimeOrEvenSum[DI]
          JE SON
          INC DI
          CMP DI,CX
          JBE DONGU2
          MOV AH,0
SON:     MOV SI,DX
         MOV DI,CX
         RET
CH_EXIST ENDP         
mys ENDS
    END main
         