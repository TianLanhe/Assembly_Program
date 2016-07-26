assume cs:code
data segment
   db 16 dup (0)
data ends
code segment
  start:mov ax,cs
	mov es,ax
	mov di,offset data2		;设置es:di指向目的地址

	mov ax,0
	mov ds,ax
	mov si,9*4			;设置ds:si指向9号中断向量

	mov cx,2
     lo:mov ax,[si]
	mov es:[di],ax
	add di,2
	add si,2
	loop lo				;将原int9的地址复制到目的地址
	
	mov ax,cs
	mov ds,ax
	mov si,offset int9
	
	mov ax,5000h
	mov es,ax
	mov di,0			;将新的中断例程安装在5000:0处

	mov cx,offset int9end - offset int9
	cld
	rep movsb

	mov ax,0
	mov es,ax
	cli
	mov es:[9*4],ax
	mov ax,5000h
	mov es:[9*4+2],ax
	sti

	mov ax,4c00h
	int 21h

   int9:jmp short start_9
  data2:db 4 dup (0)		;储存原int9的地址
start_9:push ax
	push bx
	push cx
	push dx
	push ds
	
	mov ax,cs
	mov ds,ax
	mov bx,2
	in al,60h
	pushf
	call dword ptr ds:[bx]

	cmp al,9eh
	mov dl,'A'
	je ok			;进行比较，若扫描码是‘A’则跳转到打印的地方
	mov ah,82h
	mov cx,9
	mov dh,'1'
      l:cmp al,ah
	mov dl,dh
	je ok			;若与1~9有符合的，则跳转到打印的地方
	inc ah
	inc dh
	loop l
	jmp intret		;若都没有符合的，则跳过打印，跳转到结束的地方
     ok:mov ax,0b800h
	mov ds,ax
	mov bx,0
	mov cx,2000
    loo:mov [bx],dl
	add bx,2
	loop loo

 intret:pop ds
	pop dx
	pop cx
	pop bx
	pop ax
	iret
int9end:nop

code ends
end start