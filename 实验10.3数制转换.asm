assume cs:code,ss:stack
data segment
   dw 16 dup (0)
data ends
stack segment
   dw 16 dup (0)
stack ends
code segment
  start:mov ax,stack
	mov ss,ax
	mov sp,20H

	mov ax,data
	mov ds,ax
	mov si,0

	mov ax,12666
	mov bx,10

	call dtoc

	mov dh,8
	mov dl,3
	mov cl,00001010B
	call show_str

	mov ax,4c00h
	int 21h

   dtoc:push ax
	push cx
	push dx
	push si

	mov dx,0
	push dx
      d:mov dx,0
	mov cx,bx
	call divdw
	add cx,48
	push cx
	mov cx,ax
	jcxz dto
	jmp d

    dto:pop cx
	mov ds:[si],cl
	inc si
	jcxz dot
	jmp dto

    dot:pop si
	pop dx
	pop cx
	pop ax
	ret

show_str:push bx
	 push es
	 push si
	 push ax
	 push cx
	 push dx

	 mov ax,0B800H
	 mov es,ax
	 mov al,cl
	 mov bx,160

	 mov cl,dh
	 mov ch,0
       l:add bx,160
	 loop l
	 mov dh,0
	 add bx,dx
	 add bx,dx
	 
      lo:mov cl,ds:[si]
	 mov ch,0
	 inc si
	 jcxz loo
	 mov ah,cl
	 mov es:[bx],ah
	 inc bx
	 mov es:[bx],al
	 inc bx
	 loop lo

     loo:pop dx
	 pop cx
	 pop ax
	 pop si
	 pop es
	 pop bx

	 ret

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