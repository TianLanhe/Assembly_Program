assume cs:code,ds:data,ss:stack
data segment
   db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends
stack segment
   dw 8 dup (0)
stack ends
code segment
  start:mov ax,data
	mov ds,ax
	mov si,0

	call letterc

	mov ax,4c00h
	int 21h

letterc:push si
	push cx
	
  lette:mov cl,[si]
	mov ch,0
	jcxz let
	cmp cl,97
	jb lett
	cmp cl,122
	ja lett
	and cl,11011111B
	mov [si],cl
   lett:inc si
	jmp lette

    let:pop cx
	pop si
	ret

code ends
end start
