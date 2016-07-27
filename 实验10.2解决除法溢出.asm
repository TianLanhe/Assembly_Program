assume cs:code,ss:stack
data segment
   db 'welcome to masm!',0
data ends
stack segment
   dw 8 dup (0)
stack ends
code segment
  start:mov ax,stack
	mov ss,ax
	mov sp,10H

	mov dx,1eH
	mov ax,8480H
	mov cx,13
	call divdw

	mov ax,4c00h
	int 21h


  divdw:push bx

	mov bx,ax
	mov ax,dx
	mov dx,0
	div cx
	push ax
	mov ax,bx
	div cx
	mov cx,dx
	pop dx

	pop bx
	ret

code ends
end start
