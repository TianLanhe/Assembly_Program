assume cs:code,ss:stack
stack segment
	dw 8 dup (0)
stack ends
code segment
   start:mov ax,cs
	 mov ds,ax
	 mov si,offset do0			;设置ds:si指向do0程序的首地址

	 mov ax,5000H
	 mov es,ax
	 mov di,200H				;设置es:di指向目的地址

	 mov ax,stack
	 mov ss,ax
	 mov sp,10H

	 mov cx,offset end_all - offset do0	;设置cx长度，即要复制的数据长度
	 cld
	 rep movsb				;将程序复制到5000:0200处

	 mov ax,0
	 mov ds,ax
	 mov ax,200H
	 mov bx,0
	 mov [bx],ax
	 mov ax,5000H
	 add bx,2
	 mov [bx],ax			;设置中断向量表中0号向量为5000:0200
	 
	 mov ax,4c00H
         int 21h

    do0:jmp do0_start
	db 'SOORY,OVERFLOW!',0
do0_start:mov ax,cs
	mov ds,ax
	mov si,203H
	mov dh,10
	mov dl,0
	mov cl,00001100B
	call show_str
	
	mov ax,4c00H
	int 21h

show_str:push bx
	 push es
	 push si
	 push ax
	 push cx
	 push dx		;保存寄存器

	 mov ax,0B800H
	 mov es,ax		;设置es：bx为输出首地址
	 mov al,cl		;设置al为颜色，以空出cx来控制循环

	 mov cl,dh
	 mov ch,0		;设置cx为dh，bx累加到要输出的行
	 mov bx,0
       l:add bx,160
	 loop l
	 mov dh,0
	 add bx,dx
	 add bx,dx		;bx累加到输出的列，至此，输出位置设置完毕
	 
      lo:mov cl,ds:[si]
	 mov ch,0		;逐个读取ds：si指向的内容，如果是0则跳出循环，否则进行相关输出操作
	 inc si
	 jcxz loo		;如果内容为0，则跳出
	 mov es:[bx],cl		;输出内容
	 inc bx
	 mov es:[bx],al		;输出样式
	 inc bx
	 loop lo

     loo:pop dx			;恢复寄存器
	 pop cx
	 pop ax
	 pop si
	 pop es
	 pop bx

	 ret
end_all:nop
	
code ends
end start