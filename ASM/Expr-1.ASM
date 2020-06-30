data    segment;数据段定义
num     db 0EEH;同时有2盏灯跑马灯（11101110）
data    ends
stack   segment stack 'stack'';堆栈段定义
        db 100 dup(?);定义100个字节
stack   ends
code    segment
        assume cs:code,ds:data,ss:stack

start   proc far
        push ds
        mov ax,0
        push ax;返回DOS
        mov ax,data
        mov ds,ax
        mov dx,0E8E0H;输出端口
lop0:   in al,dx
        mov ah,al
        test al,01H;第0位为1，则停止
        jz over
        test al,02H;第1位为1，则暂停
        jz lop0
        test al,04H;第2位为1，则逆向
        jz rt
        rol num,1;向左跑马灯
        jmp lop1
rt:     ror num,1;向右跑马灯
lop1:   and ah,1FH
        mov cl,ah;设置循环次数
        mov ch,0
        mov al,num;设置亮灯盏数
        out dx,al
        inc cx
lop2:   test al,08H;第3位为1，则保持原速
        jnz delay
slow:   push cx;否则减速
        mov cx,006FFH;设置外循环次数
d1:     push cx
        mov cx,003FFH;设置内循环次数
d2:     loop d2
        pop cx
        loop d1
        pop cx
        loop lop2
        jmp lop0
delay:  push cx
        mov cx,008FFH;设置外循环次数
d3:     push cx
        mov cx,004FFH;设置内循环次数
d4:     loop d4
        pop cx
        loop d3
        pop cx
        loop lop2
        jmp lop0;回到判断拨码状态
over:   retf
start   endp
code    ends
        end start