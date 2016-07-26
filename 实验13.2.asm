assume cs:code
data segment
   db 16 dup (0)
data ends
code segment
  start:mov ax,cs
	mov ds,ax
	mov si,offset int7ch
	
	mov ax,5000h
	mov es,ax
	mov di,0

	mov cx,offset int7end - offset int7ch
	cld
	rep movsb

	mov ax,0
	mov es,ax
	mov es:[7ch*4],ax
	mov ax,5000h
	mov es:[7ch*4+2],ax

	mov ax,4c00h
	int 21h

 int7ch:push bp
	dec cx
	jcxz ok
	mov bp,sp
	add [bp+2],bx

     ok:pop bp
	iret
int7end:nop

code ends
end start