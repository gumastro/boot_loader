	org 0x7c00

    bits 16

	xor ax, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

    mov ah, 0xe				; define modo de impressão (write text in teletype mode)
    mov bx, 0				; define offset da string como 0

; Pede para digitar um numeor entre 0 e 9
string_Digite_um_numero:
    mov al, [digite + bx]	; Define posição da string
	int 0x10				; imprime na tela
	cmp al, 0x0				; Se igual, string já foi toda impressa
	je leitura_numero
	add bx, 0x1				; percorre a string a ser impressa
	jmp string_Digite_um_numero

; Leitura do numero da Tabuada
leitura_numero:
    mov ah, 0x0     ; define leitura do numero
    int 0x16		; leitura do número (wait for keypress and read character)
    mov dl, al      ; dl = al(numero da tabuada)
    mov ah, 0xe     ; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela

    mov al, 0xd     ; impressao quebra linha
    mov ah, 0xe		; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela
    mov al, 0xa		; caracter impresso
    mov ah, 0xe     ; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela

    mov bl, 0       ; bl = 0 = i (iterador)
    mov cl, 10      ; divisao para verificar a existencia de 2 caracteres
    sub dl, '0'     ; dl = numero da tabuada, (ascii)->(numero)
    jmp imprimir_quebra_linha

; Calculo da Tabuada
calculo_tabuada:
    mov al, dl		; al = dl
    mul bl          ; realizacao da multiplicacao (al = al * bl)
    div cl			; ax / cl = al (quociente), ah (resto)
    add ah, '0'     ; ah (ch) = resto da divisao, (numero)->(ascii)
    add al, '0'     ; al = quociente da divisao, (numero)->(ascii)
    mov ch, ah		; ch = ah (resto)
    mov dh, al		; dh = al (quociente)

    cmp bl, 10
    je verificacao_10
    mov al, bl		; impressao do numero multiplicando
    add al, '0'		; numero -> ascii
    mov ah, 0xe		; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela
    jmp continuacao_calculo_tabuada

continuacao_calculo_tabuada:
    mov al, 'X'     ; impressao do simbolo de multiplicacao
    mov ah, 0xe		; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela

    mov al, dl		; impressao do numero da tabuada
    add al, '0'		; numero -> ascii
    mov ah, 0xe		; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela

    mov al, '='     ; impressao do simbolo de igual
    mov ah, 0xe		; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela

    mov al, dh		; move quociente para al (onde vai ser impresso)
    mov ah, 0xe     ; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela
    mov al, ch		; move resto para al (onde vai ser impresso)
    mov ah, 0xe     ; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela

    mov al, 0xd     ; impressao quebra linha
    mov ah, 0xe		; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela
    mov al, 0xa		; caracter impresso
    mov ah, 0xe		; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela

    add bl, 1       ; i++

    cmp bl, 11      ; verifica se acabou a tabuada => i > 10
    jge loop
    jmp imprimir_quebra_linha

; Imprime o caracter de inicio do 10(caso de excecao pois 10 tem 2 digitos)
verificacao_10:
    mov al, 1		; al = 1
    add al, '0'		; numero -> ascii
    mov ah, 0xe		; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela
    mov al, 0		; al = 0
    add al, '0'		; numero -> ascii
    mov ah, 0xe		; define modo de impressão (write text in teletype mode)
    int 0x10		; imprime na tela
    jmp continuacao_calculo_tabuada

; Imprime a quebra de linha
imprimir_quebra_linha:
    mov al, [quebra_linha + bx]
	int 0x10		; imprime na tela
	cmp al, 0x0		; compara até o final da string
	je calculo_tabuada
	add bx, 0x1		; bx++
	jmp imprimir_quebra_linha

; Fim
loop:
	jmp loop		; loop infinito

; String pedindo para digitar um numeor entre 0 e 9
digite:
    db 'TABUADA',0xd,0xa,'Digite um numero entre 0 e 9:', 0xd, 0xa

; Quebra de linha
quebra_linha:

    ;Finalizar o programa
	times 510 - ($-$$) db 0	; Pad with zeros
	dw 0xaa55		; Boot signature




    ; Ler um caracter
    ; mov ah, 0x0
    ; int 0x16

    ; Printar um caracter
    ; mov ah, 0xe
    ; int 0x10

    ; Multiplicacao
    ; mov al, "numero 1"
    ; mov bl, "numero 2"
    ; mul bl
    ; Resultado -> al * bl = ax(al)

    ; Divisao
    ; mov ax, "dividendo"
    ; mov bl, "divisor"
    ; div bl
    ; Resultado -> ax / bl -> al(quociente) e ah(resto)

    ; 8-bit para 16-bit
    ; movzx ax, al
