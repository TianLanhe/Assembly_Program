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
	mov sp,16		;初始化栈

	mov ax,data
	mov ds,ax
	mov si,0		;初始化ds:si指向首地址

	mov dh,10
	mov dl,0
	mov cl,00001100B	;设置第10行第0列，颜色为红色
	call show_str		;打印字符串

	mov ax,4c00h
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

code ends
end start
