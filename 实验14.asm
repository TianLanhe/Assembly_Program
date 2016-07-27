assume cs:code
data segment
   db 16 dup (0)
data ends
code segment
  start:mov ax,data
	mov ds,ax
	mov bx,0
	mov si,0

	mov al,9
	mov ah,'/'
	call output
	mov al,8
	call output
	mov al,7
	mov ah,' '
	call output
	mov al,4
	mov ah,':'
	call output
	mov al,2
	call output
	mov al,0
	call output
	mov dl,0
	mov [bx+si-1],dl

	mov dh,10
	mov dl,16
	mov cl,10
	mov si,bx
	call show_str

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

   split:push ax
	 push cx
	 mov cl,4
	 mov ah,0
	 shl ax,cl
	 mov dh,ah
	 mov ah,0
	 shl ax,cl
	 mov dl,ah
	 add dh,30h
	 add dl,30h
	 pop cx
	 pop ax
	 ret

  output:push ax
	 push bx
	 push dx

	 out 70h,al
	 in al,71h
	 call split
	 mov [bx+si],dh
	 inc si
	 mov [bx+si],dl
	 mov dl,ah
	 inc si
	 mov [bx+si],dl
	 inc si

	 pop dx
	 pop bx
	 pop ax
	 ret

code ends
end start
