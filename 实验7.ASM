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
   dw 8 dup (0)
stack ends
code segment
   start:mov ax,data
	 mov ds,ax		;设置ds指向源数据地址
	 
	 mov ax,table
	 mov es,ax		;设置es指向目的地址

	 mov ax,stack
	 mov ss,ax
	 mov sp,10H		;设置栈段

	 mov bp,0		;bp为源数据(两字节)当前读取位置
	 mov bx,0		;bx为行数
	 mov di,0		;bp为源数据(四字节)当前读取位置
	 mov cx,21		;设置外层循环21次

       s:mov si,0
	 push cx
	 mov cx,2		;入栈并设置循环2次，将年份和收入分两次读取

      s0:mov ax,[di]
	 mov es:[bx].[si],ax	;将年份转移到目的地址
	 mov ax,84[di]
	 mov es:[bx].5[si],ax	;将收入转移到目的地址
	 add si,2
  	 add di,2
	 loop s0		;内循环结束

	 mov ax,ds:168[bp]
	 mov word ptr es:[bx].10,ax	;将雇员数转移到目的地址
	 mov ax,es:[bx].5		;将收入的低16位复制到ax中，为出发做准备
	 mov dx,es:[bx].7		;将收入的高16位复制到dx中，为出发做准备
         div word ptr ds:168[bp]	;收入除以雇员人数，得到的人均收入储存在ax中
	 mov es:[bx].13,ax		;将人均收入放入目的地址
	 add bp,2
	 pop cx
	 add bx,10H
	 loop s				;外循环结束，已将21行放入目的地址
 
	 mov ax,4c00H
         int 21h
code ends
end start
