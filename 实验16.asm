assume cs:code
code segment
  start:mov ax,cs
	mov es,ax
	mov di,offset setscreen + 2

	mov word ptr es:[di],offset sub1 - offset setscreen + 0
	mov word ptr es:[di+2],offset sub2 - offset setscreen + 0
	mov word ptr es:[di+4],offset sub3 - offset setscreen + 0
	mov word ptr es:[di+6],offset sub4 - offset setscreen + 0	;将四个子程序相对于setscreen的偏移地址保存在表中

	mov ax,cs
	mov ds,ax
	mov si,offset setscreen

	mov ax,5000h
	mov es,ax
	mov di,0			;将程序安装到5000:0

	mov cx,offset setend - offset setscreen
	cld
	rep movsb

	mov ax,0
	mov es,ax
	mov word ptr es:[7ch*4],0
	mov word ptr es:[7ch*4+2],5000h	;将int 7ch中断例程改为新程序

	mov ax,4c00h
	int 21h

setscreen:jmp short startsc
	dw 0,0,0,0
startsc:push bx

	cmp ah,3
	ja endsc
	mov bl,ah
	mov bh,0
	add bx,bx
	call word ptr cs:[bx+2]

  endsc:pop bx
	iret
	
   sub1:push ax
	push bx
	push cx
	push es

	mov bx,0b800h
	mov es,bx
	mov bx,0
	mov cx,2000
	mov al,' '
sub1loo:mov es:[bx],al
	add bx,2
	loop sub1loo
	
	pop es
	pop cx
	pop bx
	pop ax
	ret
sub1end:nop

   sub2:push es
	push cx
	push bx
	
	cmp al,7
	ja sub2ret
	mov bx,0b800h
	mov es,bx
	mov bx,1
	mov cx,2000
sub2loo:and byte ptr es:[bx],11111000b
	or es:[bx],al
	add bx,2
	loop sub2loo

sub2ret:pop bx
	pop cx
	pop es
	ret
sub2end:nop


   sub3:push es
	push cx
	push bx
	
	cmp al,7
	ja sub3ret
	mov bx,0b800h
	mov es,bx
	mov bx,1
	mov cl,4
	shl al,cl
	mov cx,2000
sub3loo:and byte ptr es:[bx],10001111b
	or es:[bx],al
	add bx,2
	loop sub3loo

sub3ret:pop bx
	pop cx
	pop es
	ret
sub3end:nop

   sub4:push es
	push cx
	push bx
	push ax
	
	mov bx,0b800h
	mov es,bx
	mov bx,0
	mov cx,2000
sub4loo:mov al,es:[bx+160]
	mov es:[bx],al
	add bx,2
	loop sub4loo

	pop ax
	pop bx
	pop cx
	pop es
	ret
sub4end:nop

 setend:nop

code ends
end start