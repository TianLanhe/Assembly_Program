assume cs:code,ds:data,ss:stack
data segment
   db '1975','1976','1977','1978','1979','1980','1981','1982','1983','1984','1985'
   db '1986','1987','1988','1989','1990','1991','1992','1993','1994','1995'
   dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514,345980,590827
   dd 803530,1183000,1843000,2759000,3753000,4649000,5937000
   dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226,11542
   dw 14430,15257,17800
data ends
table segment
   db 21 dup ('year summ ne ?? ')
table ends
stack segment
   dw 24 dup (0)
stack ends
tmp segment
   dw 16 dup (0)
tmp ends
code segment
  start:mov ax,data
	mov ds,ax	;设置ds指向源数据地址
	 
	mov ax,table
	mov es,ax	;设置es指向目的地址

	mov ax,stack
	mov ss,ax
	mov sp,30H	;设置栈

	mov bp,0	;bp为源数据(两字节)当前读取位置
	mov bx,0	;bx为行数
	mov di,0	;di为源数据(四字节)当前读取位置
	mov cx,21	;设置外层循环21次

      s:mov si,0
	push cx
	mov cx,2	;入栈并设置循环2次，将年份和收入分两次读取

     s0:mov ax,[di]
	mov es:[bx].[si],ax	;将年份转移到目的地址
	mov ax,84[di]
	mov es:[bx].5[si],ax	;将收入转移到目的地址
	add si,2
  	add di,2
	loop s0
	mov byte ptr es:[bx].[si],0	;在年份后加上0，表示字符产结束

	mov ax,ds:168[bp]
	mov es:[bx].10,ax	;将雇员数转移到目的地址
	mov ax,es:[bx].5
	mov dx,es:[bx].7
	mov cx,ds:168[bp]
	call divdw		;进行除法，计算人均收入
	mov es:[bx].13,ax	;将结果转移到目的地址
	add bp,2
	pop cx
	add bx,10H
	loop s
	
	mov dh,-1
	mov bx,0
	mov cx,21	;设置cx循环21次
    pri:push cx
	mov ax,es
	mov ds,ax
	mov si,bx
	add dh,1
	mov dl,0
	mov cl,12
	call show_str		;输出年份

	mov ax,es:[bx].5
	mov di,es:[bx].7
	mov dl,5
	call print		;输出收入
	
	mov ax,es:[bx].10
	mov di,0
	mov dl,13
	call print		;输出雇员数

	mov ax,es:[bx].13
	mov di,0
	mov dl,19
	call print		;输出人均收入

	add bx,10h		;bx累加，进入下一行
	pop cx
	loop pri

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
	 mov bx,160
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

   dtoc:push ax
	push bx
	push cx
	push dx
	push si

	mov bx,0
	push bx
    dto:mov cx,10
	call divdw
	add cx,48
	push cx
	mov cx,dx
	inc cx
	loop dto
	mov cx,ax
	inc cx
	loop dto

  dtoc2:pop cx
	mov ds:[si],cl
	inc si
	jcxz dot
	jmp dtoc2

    dot:pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret

  print:push ds
	push si
	push ax
	push bx
	push dx
	
	mov bx,tmp
	mov ds,bx
	mov si,0
	mov bx,dx
	mov dx,di
	call dtoc
	mov dx,bx
	call show_str

	pop dx
	pop bx
	pop ax
	pop si
	pop ds
	ret
code ends
end start
