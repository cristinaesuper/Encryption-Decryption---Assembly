.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem msvcrt.lib, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern printf: proc
extern scanf: proc
extern fread: proc
extern fwrite: proc
extern fopen: proc
extern fclose: proc
extern exit: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
inceput_fisier db "Calea spre fisier: ", 0
inceput db "Scrieti algoritmul dorit ", 0
inceput_2 db "Criptare sau decriptare? ", 0
inceput_3 db "Cheia ", 0
fis db 0
a db 0
b db 0
cv dd 0
caracter db "A", 0
filefilefile dd "a", 0
filename_1 db "de_citit.txt", 0
filename_2 db "de_afisat.txt ", 0
mode_rb db "r", 0
mode_w db "w", 0
format_fisier db "%s", 0
format db "%d", 0
format_afisare db "%c", 0
buffer db "X", 0
buffer_2 dq "X", 0
buffer_cit1 dd "X", 0
buffer_cit2 dd "X", 0
cheie_21 dd 1
cheie_22 dd 1
buffer_3 dd "A", 0
buffer_4 dd "A", 0

.code
start:
	push offset inceput_fisier
	call printf
	add esp, 4
	
	push offset filefilefile
	push offset format_fisier
	call scanf
	add esp, 8

	push offset mode_rb		;apelam fopen
	push offset filefilefile
	call fopen
	add esp, 8
	mov esi, eax ;salvam pointer-ul la fisier
	
	push offset mode_w      	;deschid fisierul in care am de afisat
	push offset filename_2  	;
	call fopen                  ;
	add esp, 8                  ;
	mov edi, eax 
	
	push offset inceput
	call printf
	add esp, 4
	
	push offset a
	push offset format
	call scanf
	add esp, 8
	
	push offset inceput_2
	call printf
	add esp, 4
	
	push offset b
	push offset format
	call scanf
	add esp, 8
	
	cmp a, 1
	jne alg_2
	
	push offset inceput_3
	call printf
	add esp, 4
	push offset cv
	push offset format
	call scanf
	add esp, 8
bucla_citire:
	;punem pe stiva parametrii pentru fread
	push esi ;stream
	push 1 ;count
	push 1 ;size
	push offset buffer
	
	call fread
	
	add esp, 16
	
	test eax, eax
	jz inchidere_fisier
	xor eax, eax ;facem eax sa fie 0
	cmp b, 1
jne decript_1
	mov al, buffer
	not al
	xor ebx, ebx
	mov ebx, 1
	add eax, ebx
	mov ecx, 0
	mov ecx, cv
	ror al, cl
	add al, 1
	mov caracter, al    ;in al am hexa, in caracter vreau sa am caracterul
	jmp afisare
decript_1:
	mov al, buffer
	mov ecx, 0
	mov ecx, cv
	sub al, 1
	rol al, cl
	xor ebx, ebx
	mov ebx, 1
	sub eax, ebx
	not al
	mov caracter, al
afisare:
	push edi
	push 1
	push 1
	push offset caracter
	call fwrite
	add esp, 16
	jmp bucla_citire
	
alg_2:
	cmp a, 2
    jne inchidere_fisier
;iau cate 8 blocuri pe rand
bucla_citire_2:
	push esi     ;stream
	push 1       ;count
	push 4       ;size
	push offset buffer_cit1
	call fread
	add esp, 16
	
	push esi     ;stream
	push 1       ;count
	push 4       ;size
	push offset buffer_cit2
	call fread
	add esp, 16
	
	test eax, eax
	jz inchidere_fisier
	xor eax, eax   ;facem eax sa fie 0
	
	mov ecx, buffer_cit1
	mov edx, buffer_cit2
	
;criptare blocuri
	cmp b, 1
	jne decript_2
	push eax
	not ecx
	not edx
	mov ebp, cheie_21
	mov eax, cheie_22
	xor ecx, ebp
	xor edx, eax
	pop eax
	; afisez
	jmp afisare_2
	
decript_2:
	cmp b, 2
	jne inchidere_fisier
	push eax
	mov ebp, cheie_21
	mov eax, cheie_22
	xor ecx, ebp
	xor edx, eax
	not ecx
	not edx
	pop eax
afisare_2:
	mov buffer_3, ecx
	mov buffer_4, edx
	
	push edi
	push 1
	push 4
	push offset buffer_3
	call fwrite
	add esp, 16
	
	push edi
	push 1
	push 4
	push offset buffer_4
	call fwrite
	add esp, 16
	
	jmp bucla_citire_2
	
inchidere_fisier:
	;apelam fclose
	push esi ;stream
	call fclose
	add esp, 4
	
	add esp, 16 ;curatam stiva de la fread
	;apelam fclose
	push edi ;stream
	call fclose
	add esp, 4

	push 0
	call exit
end start
