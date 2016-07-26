assume cs:code
code segment
  start:mov ax,cs
	mov ds,ax
	mov si,offset copy_str
	
	mov ax,0
	mov es,ax
	mov di,200H

	mov cx,offset copy_str_e - offset copy_str
	cld
	rep movsb

	mov ax,0
	mov es,ax
	mov word ptr es:[7ch*4],200h
	mov word ptr es:[7ch*4+2],0

	mov ax,4c00h
	int 21h

copy_str:push bx
	push ax
	push cx
	push dx
	push si
	push es

	mov ax,0b800h
	mov es,ax
	mov bx,0
	mov al,cl
	mov cl,dh
	mov ch,0
      s:add bx,160
	loop s
	mov dh,0
	add bx,dx
	add bx,dx

   copy:mov cl,ds:[si]
	mov ch,0
	jcxz ok
	mov es:[bx],cl
	inc bx
	mov es:[bx],al
	inc bx
	inc si
	jmp copy

     ok:pop es
	pop si
	pop dx
	pop cx
	pop ax
	pop bx
	iret
copy_str_e:nop

code ends
end start