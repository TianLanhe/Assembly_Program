assume cs:code
data segment
   db 16 dup (0)
data ends
code segment
  start:mov ax,0b800h
	mov es,ax
	mov di,160*12+10
	mov al,'s'
	mov es:[di],al
	mov al,10
	mov es:[di+1],al

	call delay

	mov al,'a'
	mov es:[di],al
	mov al,12
	mov es:[di+1],al
	
	mov ax,4c00h
	int 21h

  delay:push dx
	push ax
	mov dx,10h
	mov ax,0
      s:sub ax,1
	sbb dx,0
	cmp ax,0
	jne s
	cmp dx,0
	jne s

	pop ax
	pop dx
	ret

 delay2:push ax
	mov ah,0
	int 16h
	pop ax
	ret

code ends
end start