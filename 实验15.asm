assume cs:code
data segment
   db 16 dup (0)
data ends
code segment
  start:mov ax,cs
	mov es,ax
	mov di,offset data2		;����es:diָ��Ŀ�ĵ�ַ

	mov ax,0
	mov ds,ax
	mov si,9*4			;����ds:siָ��9���ж�����

	mov cx,2
     lo:mov ax,[si]
	mov es:[di],ax
	add di,2
	add si,2
	loop lo				;��ԭint9�ĵ�ַ���Ƶ�Ŀ�ĵ�ַ
	
	mov ax,cs
	mov ds,ax
	mov si,offset int9
	
	mov ax,5000h
	mov es,ax
	mov di,0			;���µ��ж����̰�װ��5000:0��

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
  data2:db 4 dup (0)		;����ԭint9�ĵ�ַ
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
	je ok			;���бȽϣ���ɨ�����ǡ�A������ת����ӡ�ĵط�
	mov ah,82h
	mov cx,9
	mov dh,'1'
      l:cmp al,ah
	mov dl,dh
	je ok			;����1~9�з��ϵģ�����ת����ӡ�ĵط�
	inc ah
	inc dh
	loop l
	jmp intret		;����û�з��ϵģ���������ӡ����ת�������ĵط�
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