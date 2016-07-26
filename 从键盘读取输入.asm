assume cs:code,ds:data
data segment
   db 32 dup (0)
data ends
code segment
  start:mov ax,data
	mov ds,ax
	mov si,0
	mov dh,10
	mov dl,5

	call gets

	mov ax,4c00h
	int 21h

   gets:push ax
	push bx
	mov bx,offset top
	mov word ptr cs:[bx],0

getsstr:mov ah,0
	int 16h

	cmp al,20
	jb control
	cmp al,126
	ja control
	
	mov ah,0
	call charstack
	mov ah,2
	call charstack
	jmp getsstr

control:cmp ah,1ch
	je enter
	cmp ah,0eh
	jne getsstr
	
	mov ah,1
	call charstack
	mov ah,2
	call charstack
	jmp getsstr

  enter:mov al,0
	mov ah,0
	call charstack
	mov ah,2
	call charstack

	pop bx
	pop ax
	ret


charstack:jmp short char_str
	table dw pushc,popc,showc
	top dw 0
char_str:push bx

	cmp ah,2
	ja charret

	mov bl,ah
	mov bh,0
	add bx,bx
	call word ptr table[bx]
charret:pop bx
	ret

  pushc:push bx
	mov bx,top
	mov [si+bx],al
	inc top
	pop bx
	ret

   popc:push bx
	mov bx,top
	cmp bx,0
	je popcret
	dec top
	mov al,[si+bx]
popcret:pop bx
	ret

  showc:push bx
	push cx
	push dx
	push es
	push di

	mov bx,0b800h
	mov es,bx
	mov cl,dh
	mov dh,0
	mov ch,0
	mov di,0
showclo:add di,160
	loop showclo
	add di,dx
	add di,dx

	mov bx,0
	cmp bx,top
	je show_no
 showcl:mov cl,[si+bx]
	mov es:[di],cl
	mov byte ptr es:[di+2],' '
	add di,2
	inc bx
	cmp bx,top
	jne showcl
	jmp showret
show_no:mov byte ptr es:[di],' '
showret:pop di
	pop es
	pop dx
	pop cx
	pop bx
	ret

code ends
end start