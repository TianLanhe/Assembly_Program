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
	mov sp,16		;��ʼ��ջ

	mov ax,data
	mov ds,ax
	mov si,0		;��ʼ��ds:siָ���׵�ַ

	mov dh,10
	mov dl,0
	mov cl,00001100B	;���õ�10�е�0�У���ɫΪ��ɫ
	call show_str		;��ӡ�ַ���

	mov ax,4c00h
	int 21h

show_str:push bx
	 push es
	 push si
	 push ax
	 push cx
	 push dx		;����Ĵ���

	 mov ax,0B800H
	 mov es,ax		;����es��bxΪ����׵�ַ
	 mov al,cl		;����alΪ��ɫ���Կճ�cx������ѭ��

	 mov cl,dh
	 mov ch,0		;����cxΪdh��bx�ۼӵ�Ҫ�������
	 mov bx,0
       l:add bx,160
	 loop l
	 mov dh,0
	 add bx,dx
	 add bx,dx		;bx�ۼӵ�������У����ˣ����λ���������
	 
      lo:mov cl,ds:[si]
	 mov ch,0		;�����ȡds��siָ������ݣ������0������ѭ���������������������
	 inc si
	 jcxz loo		;�������Ϊ0��������
	 mov es:[bx],cl		;�������
	 inc bx
	 mov es:[bx],al		;�����ʽ
	 inc bx
	 loop lo

     loo:pop dx			;�ָ��Ĵ���
	 pop cx
	 pop ax
	 pop si
	 pop es
	 pop bx

	 ret

code ends
end start








