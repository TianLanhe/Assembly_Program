assume  cs:code,ds:data,ss:stack
data segment
	db 'welcome to masm!'
data ends
stack segment
	dw 6 dup(0)
	dw 00101100B,01111001B
stack ends
code segment
  start:mov ax,0B800H
	mov es,ax
	mov ax,data
	mov ds,ax
	mov ax,stack
	mov ss,ax
	mov sp,0CH
	mov bx,0
	mov cx,11
      s:add bx,160
	loop s
	add bx,58

	mov dl,00001010B

	mov cx,3
     s0:push cx
	mov si,0
	mov di,0

	mov cx,16
     s1:mov al,[di]
	mov es:[bx][si],al
	inc si
	mov es:[bx][si],dl
	inc si
	inc di
	loop s1

	pop cx
	pop dx
	add bx,160
	loop s0

	mov ax,4c00H
	int 21h
code  ends
end start