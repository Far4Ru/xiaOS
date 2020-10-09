[bits 16]
org 0x7C00
start:
	cli
	
	call reader
	mov bx, str16
    call print16
    call hitkey16
	cli
	call init_lba
	call SetSuperVGA
	
	xor ax, ax
	mov ss, ax
	mov ds, ax
	mov fs, ax
	mov gs, ax
	mov es, ax
	mov sp, 0xffc
	lgdt[desk_table]
	call init_PM
	jmp SEG_CODE:0x8000
ret

SetSuperVGA:
	mov ax, 0x4f02
	mov bx, 0x4100 
	int 0x10
ret

SetVideo:
	mov ah,0 ;установка видеорежима
	mov al,3
	int 0x10
ret
SetWideVideo:
    mov ax, 0x4f01
    mov cx, 0x118; 1024x768 16.8M (8:8:8)
    mov di, buffer ;di -прерывание 256 bytes ModeInfoBlock technical details
    int 0x10 ; ax - status
    mov ax, 0x4f02 ;set VBE Mode
    mov bx, 0x4118;4 перед видеорежимом - фреймбуфер
    int 0x10
    mov eax, dword[buffer+0x28];+40 или +0x28 адрес фреймбуфера
    mov dword[lfb], eax
ret
	
init_lba:
	mov ah, 42h     
	mov si, EDD_Packet32       
	mov dl, 80h      
	int 13h
ret

[bits 32]
init_PM:
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
ret

[bits 16]
print16:
    pusha
    mov ax, 0xB800
    mov es, ax
    mov ah, 5
    mov si, 0
    rep16:
    mov al, byte[bx]
    cmp al, 0
    jz exit16
    mov word[es:si], ax
    inc bx
    add si, 2
    jmp rep16
    exit16:
    popa
ret
initkey16:
    pusha
    xor ax, ax
    int exit16
    popa
ret
hitkey16:
    pusha
    xor ax, ax
    int 0x16
    popa
ret
reader:
	mov ah, 0x2
	mov al, 0x1
	mov dh, 0x0
	mov dl, 0x80
	mov bx, 0x8000
	mov ch, 0x0
	mov cl, 0x2
	int 0x13
ret
	
start_table:
    null_desk:
       dd 0
       dd 0
    code_desk:
       dw 0xffff
       dw 0
       db 0
       db 10011010b
       db 11001111b
       db 0
    data_desk:
       dw 0xffff
       dw 0
       db 0
       db 10010010b
       db 11001111b
       db 0
	end_table:
	desk_table:
	   dw end_table - start_table
	   dd start_table
SEG_CODE equ code_desk - start_table
SEG_DATA equ data_desk - start_table
buffer times 60 dd 0
lfb dd 0
str16 db 'starting xiaOS', 0

EDD_Packet32:
	EDD32_Size db 0x10 ;размер пакета
	EDD32_Reserved1 db 0x0;резерв
	EDD32_LoadSectors dw 0x7F;количество секторов для загрузки
	EDD32_BufOffset dd 0xFFFFFFFF; смещение
	EDD32_NumberSector dq 0x3F; номер сектора