GIRIS_DIZI	MACRO 
		LOCAL L1
		
		POP DI ; DİZİNİN ADRESİ
                POP CX ; N DEĞERİ
		
L1:		CALL GETN
                MOV [DI],AX
                ADD DI,2; WORD TİPLİ DİZİ
		LOOP L1

		ENDM
myss SEGMENT PARA STACK 'stack'
DW 32 DUP (?)
myss ENDS

myds SEGMENT PARA 'veri'

SAYILAR DW 10 DUP (3)
n       DW  4
sonuc   DW  4
CR	EQU 13
LF	EQU 10
MSG1	DB 'dizi boyutunu giriniz(0-10):',0
MSG2	DB CR, LF, 'dizi elemanlarini giriniz(0-255):',0
HATA	DB CR, LF, 'Dikkat !!! Sayi vermediniz yeniden giris yapiniz.!!!  ', 0
MSG3	DB CR, LF, 'Mod_Sonucu :  ', 0
myds ENDS

		
mycs SEGMENT PARA 'kod'
ASSUME CS:mycs, DS:myds, SS: myss

ANA PROC FAR
PUSH DS 
XOR AX,AX
PUSH AX
MOV AX,myds
MOV DS,AX

MOV AX, OFFSET MSG1
CALL PUT_STR
CALL GETN
MOV n,AX
MOV AX, OFFSET MSG2
CALL PUT_STR

PUSH n
LEA DI,SAYILAR
PUSH DI
GIRIS_DIZI

PUSH n
LEA DI,SAYILAR
PUSH DI

CALL MOD_AL
XOR AL,AL
MOV AL,AH
XOR AH,AH

MOV sonuc,AX
MOV AX, OFFSET MSG3
CALL PUT_STR
MOV AX,sonuc
CALL PUTN

RETF

ANA ENDP

MOD_AL PROC NEAR
PUSH CX
PUSH DX
PUSH BX
PUSH BP
MOV BP,SP
MOV CX,[BP+12];n değerini cx e al
MOV SI,[BP+10];SAYILAR DİZİSİNİN ADRESİ.


MOV AH,0 ; MOD OLAN SAYI
MOV AL,0 ; MOD OLAN SAYI ADEDİ
XOR DL,DL;
ADD SI,CX
ADD SI,CX
SUB SI,2
MOV AH,[SI]
MOV SI,[BP+10];SI yı dizinin en başı olan adresi tekrar ata.

DONGU1 : 
XOR DL,DL;COUNTER
ADD SI,CX
ADD SI,CX
SUB SI,2

MOV BL,[SI];N. ELEMANA ERİŞİP BAŞLIYORUZ.
PUSH AX
XOR AX,AX
MOV AL,BL
CALL PUTN
POP AX
MOV DI,SI ;İC DONGU DEGİSKENİ
XOR DH,DH
DONGU2 : 
         XOR BH,BH
         CMP BX,[DI]
         JNE DEVAM
         INC DL
DEVAM :  INC DH
         SUB DI,2
         CMP DH,[BP+12]; N İLE KARŞILAŞTIR
         JB DONGU2
         CMP DL,AL
         JBE ATLA
         MOV AL,DL
         MOV AH,BL

ATLA: MOV SI,[BP+10];

LOOP DONGU1

POP BP
POP BX
POP DX
POP CX

RET 4 ; n ve sayılar dizisinin adresi için  4 byte daha stackten pop ettim.
MOD_AL ENDP






;BURADAN SONRASI HAZIR ALINDI



GETC	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan karakteri AL yazmacına alır ve ekranda gösterir. 
        ; işlem sonucunda sadece AL etkilenir. 
        ;------------------------------------------------------------------------
        MOV AH, 1h
        INT 21H
        RET 
GETC	ENDP 

PUTC	PROC NEAR
        ;------------------------------------------------------------------------
        ; AL yazmacındaki değeri ekranda gösterir. DL ve AH değişiyor. AX ve DX 
        ; yazmaçlarının değerleri korumak için PUSH/POP yapılır. 
        ;------------------------------------------------------------------------
        PUSH AX
        PUSH DX
        MOV DL, AL
        MOV AH,2
        INT 21H
        POP DX
        POP AX
        RET 
PUTC 	ENDP 

GETN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; Klavyeden basılan sayiyi okur, sonucu AX yazmacı üzerinden dondurur. 
        ; DX: sayının işaretli olup/olmadığını belirler. 1 (+), -1 (-) demek 
        ; BL: hane bilgisini tutar 
        ; CX: okunan sayının islenmesi sırasındaki ara değeri tutar. 
        ; AL: klavyeden okunan karakteri tutar (ASCII)
        ; AX zaten dönüş değeri olarak değişmek durumundadır. Ancak diğer 
        ; yazmaçların önceki değerleri korunmalıdır. 
        ;------------------------------------------------------------------------
        PUSH BX
        PUSH CX
        PUSH DX
GETN_START:
        MOV DX, 1	                        ; sayının şimdilik + olduğunu varsayalım 
        XOR BX, BX 	                        ; okuma yapmadı Hane 0 olur. 
        XOR CX,CX	                        ; ara toplam değeri de 0’dır. 
NEW:
        CALL GETC	                        ; klavyeden ilk değeri AL’ye oku. 
        CMP AL,CR 
        JE FIN_READ	                        ; Enter tuşuna basilmiş ise okuma biter
        CMP  AL, '-'	                        ; AL ,'-' mi geldi ? 
        JNE  CTRL_NUM	                        ; gelen 0-9 arasında bir sayı mı?
NEGATIVE:
        MOV DX, -1	                        ; - basıldı ise sayı negatif, DX=-1 olur
        JMP NEW		                        ; yeni haneyi al
CTRL_NUM:
        CMP AL, '0'	                        ; sayının 0-9 arasında olduğunu kontrol et.
        JB error 
        CMP AL, '9'
        JA error		                ; değil ise HATA mesajı verilecek
        SUB AL,'0'	                        ; rakam alındı, haneyi toplama dâhil et 
        MOV BL, AL	                        ; BL’ye okunan haneyi koy 
        MOV AX, 10 	                        ; Haneyi eklerken *10 yapılacak 
        PUSH DX		                        ; MUL komutu DX’i bozar işaret için saklanmalı
        MUL CX		                        ; DX:AX = AX * CX
        POP DX		                        ; işareti geri al 
        MOV CX, AX	                        ; CX deki ara değer *10 yapıldı 
        ADD CX, BX 	                        ; okunan haneyi ara değere ekle 
        JMP NEW 		                ; klavyeden yeni basılan değeri al 
ERROR:
        MOV AX, OFFSET HATA 
        CALL PUT_STR	                        ; HATA mesajını göster 
        JMP GETN_START                          ; o ana kadar okunanları unut yeniden sayı almaya başla 
FIN_READ:
        MOV AX, CX	                        ; sonuç AX üzerinden dönecek 
        CMP DX, 1	                        ; İşarete göre sayıyı ayarlamak lazım 
        JE FIN_GETN
        NEG AX		                        ; AX = -AX
FIN_GETN:
        POP DX
        POP CX
        POP DX
        RET 
GETN 	ENDP 

PUTN 	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de bulunan sayiyi onluk tabanda hane hane yazdırır. 
        ; CX: haneleri 10’a bölerek bulacağız, CX=10 olacak
        ; DX: 32 bölmede işleme dâhil olacak. Soncu etkilemesin diye 0 olmalı 
        ;------------------------------------------------------------------------
        PUSH CX
        PUSH DX 	
        XOR DX,	DX 	                        ; DX 32 bit bölmede soncu etkilemesin diye 0 olmalı 
        PUSH DX		                        ; haneleri ASCII karakter olarak yığında saklayacağız.
                                                ; Kaç haneyi alacağımızı bilmediğimiz için yığına 0 
                                                ; değeri koyup onu alana kadar devam edelim.
        MOV CX, 10	                        ; CX = 10
        CMP AX, 0
        JGE CALC_DIGITS	
        NEG AX 		                        ; sayı negatif ise AX pozitif yapılır. 
        PUSH AX		                        ; AX sakla 
        MOV AL, '-'	                        ; işareti ekrana yazdır. 
        CALL PUTC
        POP AX		                        ; AX’i geri al 
        
CALC_DIGITS:
        DIV CX  		                ; DX:AX = AX/CX  AX = bölüm DX = kalan 
        ADD DX, '0'	                        ; kalan değerini ASCII olarak bul 
        PUSH DX		                        ; yığına sakla 
        XOR DX,DX	                        ; DX = 0
        CMP AX, 0	                        ; bölen 0 kaldı ise sayının işlenmesi bitti demek
        JNE CALC_DIGITS	                        ; işlemi tekrarla 
        
DISP_LOOP:
                                                ; yazılacak tüm haneler yığında. En anlamlı hane üstte 
                                                ; en az anlamlı hane en alta ve onu altında da 
                                                ; sona vardığımızı anlamak için konan 0 değeri var. 
        POP AX		                        ; sırayla değerleri yığından alalım
        CMP AX, 0 	                        ; AX=0 olursa sona geldik demek 
        JE END_DISP_LOOP 
        CALL PUTC 	                        ; AL deki ASCII değeri yaz
        JMP DISP_LOOP                           ; işleme devam
        
END_DISP_LOOP:
        POP DX 
        POP CX
        RET
PUTN 	ENDP 

PUT_STR	PROC NEAR
        ;------------------------------------------------------------------------
        ; AX de adresi verilen sonunda 0 olan dizgeyi karakter karakter yazdırır.
        ; BX dizgeye indis olarak kullanılır. Önceki değeri saklanmalıdır. 
        ;------------------------------------------------------------------------
	PUSH BX 
        MOV BX,	AX			        ; Adresi BX’e al 
        MOV AL, BYTE PTR [BX]	                ; AL’de ilk karakter var 
PUT_LOOP:   
        CMP AL,0		
        JE  PUT_FIN 			        ; 0 geldi ise dizge sona erdi demek
        CALL PUTC 			        ; AL’deki karakteri ekrana yazar
        INC BX 				        ; bir sonraki karaktere geç
        MOV AL, BYTE PTR [BX]
        JMP PUT_LOOP			        ; yazdırmaya devam 
PUT_FIN:
	POP BX
	RET 
PUT_STR	ENDP


mycs ENDS
END ANA