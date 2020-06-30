 ;
 ;************************ 微机原理与接口技术实验五****************************
 ;   WRITTEN BY: AMANE ICE                                                  *
 ;   DATE: 12/12/2018                                                       *
 ;   REFERENCES: TEXTBOOK OF MICRO-PROCESSOR AND INTERFACE TECHNOLOGY       *
 ;   SCHOOL OF INFORMATION AND TELECOMMUNICATION ENGINNERING,               *
 ;   BEIJING UNIVERSITY OF POSTS AND TELECOMMUNICATIONS                     *                                                                                     
 ;*************************** 实验E(中断程序设计) ****************************
 ; 测试参考:输入数据分为正常除法/除数为0/被除数溢出3种.                         *
 ; 题目要求:                                                                 *
 ; (1)编写一个32位二进制数除以16位二进制数的除法程序.                           *
 ;    观察当除数为0,或超过相应寄存器范围时,程序执行的结果.                       * 
 ; (2)修改零号中断服务程序,使它具有以下功能:                                    *
 ;    [1]判断除数是否为0,当除数为0时,显示相应的结果;                            *
 ;    [2]当除数不为0时,采用适当的方法完成商超过16位的二进制数的除法运算.          *                                                 *    
 ; (3)注意必须保护原有中断服务程序的入口地址,并在程序完毕前加以恢复.              *                                            *
 ; (4)用二进制将结果在屏幕上显示.                                              *
 ; (5)从键盘输入二进制数.                                                     *
 ;***************************************************************************
 
data     segment 
dividend dd ?;被除数
divider  dw ?;除数
temp     dw ?;临时保存变量
flag     db 0;是否溢出的标志位
str1     db 'error result! divider equals zero!','$';除数为0提示
str2     db 'quotient : ','$';输出商提示
str3     db 'residue: ','$';输出余数提示
str4     db 'please input high 16-bit of dividend:','$';输入高16比特被除数提示
str5     db 'please input low 16-bit of dividend:','$';输入低16比特被除数提示
str6     db 'please input 16-bit divider:','$';输入16比特被除数提示
str7     db 'error input! please re-input in correct form.',0dh, 0ah,'$';输入错误提示
cr       db 0dh,0ah,'$';回车换行
one      db '1','$' 
zer      db '0','$'
tab      db 09h,'$';制表符
ck       dw 0
buff     db 17 (?);输入缓冲，17字符=输入16字符+回车字符 
buff2    db 17 (?);输入
pres     db 0
char     db 17 dup (30h)
data     ends 
stack    segment stack 'stack';堆栈段定义
         db 100 dup(?);定义100个字节
stack    ends
code     segment
         assume ds: data, cs: code, es: code, ss:stack 
showstr  macro str;字符串打印宏
         push ax
         push dx
         mov ah, 09h
         mov dx, offset str
         int 21h
         pop dx
         pop ax
         endm 
main:    mov ax, data
         mov ds, ax 
         mov ax, 0
         mov es, ax
         mov ax, word ptr es: [0000h] 
         push ax
         mov ax, word ptr es: [0002h]
         push ax;堆栈方式保存原中断向量表 
         mov word ptr es: [0000h], offset int0;写入新中断子程序低位地址
         mov word ptr es: [0002h], seg int0;高位地址
         call input 
         mov dx,word ptr dividend;移入被除数高16位
         mov ax,word ptr dividend+2;移入被除数低16位
         mov bx,divider;移入除数
         div bx;除法运算
         cmp flag,0;判断是否溢出
         jne isover;溢出则跳转到扩展除法
         showstr str2;未溢出，直接计算（16->16）
         mov bx,ax
         call bin2char;字符串转换
         showstr cr
         showstr str3
         mov bx, dx
         call bin2char;字符串转换
         jmp recov
isover:  showstr str2;溢出，需要输出32位商和16位余数（32->32）
         mov bx, dx 
         call bin2char ;字符串转换
         mov bx, ax
         call bin2char;字符串转换
         showstr cr
         showstr str3
         mov bx, cx
         call bin2char ;字符串转换
recov:   pop ax;
         mov word ptr es: [0002h], ax;恢复中断向量表低位
         pop ax
         mov word ptr es: [0000h], ax;恢复中断向量表高位
         mov ax,4c00h
         int 21h 
;新的0号中断子程序
int0:    pop si
         add si,2;修改ip，指向div后的指令
         push si 
         cmp bx,0;判断除数是否为0
         je isdiv0;除数为0，跳转至isdiv0
         mov flag,1;除数不为0，置标志为1
;扩展除法运算，用除数除以被除数高16位和低16位
         push ax 
         mov ax, dx
         xor dx,dx;清零dx
         div bx;高16位除法
         mov cx,ax;保存商的高16位（ax=低16位商）
         pop ax;取出被除数低16位
         div bx;低16位除法
         xchg cx,dx;同时保存余数和商的低16位（cx=16位余数，dx=高16位商）
         jmp exit
isdiv0:  showstr str1; 打印除数为0警告，结束
         mov ax,4c00h;
         int 21h 
exit:    iret ;中断子程序返回
input    proc near
input1:  push ax
         showstr str4;输入高16位被除数
         call getin;得到输入16位二进制序列
         call char2bin;字符转换
         pushf;
         cmp ck, 0
         jne err;高16位被除数试错处理
         popf
         mov ax, temp
         mov word ptr dividend[0],ax;保存高16位被除数
         showstr cr
input2:  showstr str5;输入低16位被除数
         call getin;得到输入16位二进制序列
         call char2bin;字符转换
         pushf;
         cmp ck, 0 
         jne err;低16位被除数试错处理
         popf;
         mov ax, temp
         mov word ptr dividend[2],ax;保存低16位被除数
         showstr cr
         showstr str6
input3:  call getin;输入16位除数
         call char2bin2;字符转换
         mov ax, temp
         mov divider,ax; 保存除数
         showstr cr;换行回车
         pop ax
         ret
         jmp exit0
err:     showstr cr
         showstr str7;打印错误提示字符串 
         jmp recov
lop:     mov byte ptr[bx],30h;将全零移入比较
         inc bx;
         loop lop
         pop bx; 
         pop cx;
         jmp input2
exit0:   nop;空指令，保证前面的指令已完成
input    endp 
char2bin proc near;被除数字符转换
         push ax
         push bx
         push cx
         push dx
         mov cx,16;总共16比特
         lea bx, buff
loptr:   mov al,[bx+2];依次取出每个比特
         cmp al, 30h
         je is0;比特为0时，跳转
         cmp al, 31h
         je is1;比特为1时，跳转
         jmp error;非0非1，跳入错误
is0:     clc
         rcl dx,1;cf置0，循环左移，得到二进制序列
         push cx;
         mov cx, 0;
         mov ck, cx;
         pop cx;
         jmp trtr
is1:     stc
         push cx;
         mov cx, 0;
         mov ck, cx;
         pop cx;
         rcl dx,1;cf置1，循环左移，得到二进制序列
trtr:    inc bx
         loop loptr;16bit全部处理
         mov temp,dx;保存转换后的二进制数
         jmp exit2;出栈
error:   mov ck, 1
exit2:   pop dx
         pop cx
         pop bx
         pop ax 
         ret 
char2bin endp
getin    proc near
         push ax
        push dx
         push di
         mov dx, offset buff
         mov ah, 0ah;字符串输入指令
         int 21h
         pop di
         pop dx
         pop ax
         ret
getin    endp 
char2bin2 proc near;除数字符转换
         push ax
         push bx
         push cx
         push dx
         mov cx,16; 总共16bit 
         lea bx, buff
loptr2:  mov al,[bx+2];依次取出每个bit
         cmp al, 30h
         je isis0;比特为0时，跳转
         jmp isis1;比特为1时，跳转
isis0:   clc
         rcl dx,1;cf置0，循环左移，得到二进制序列
         jmp trtr2
isis1:   stc
         rcl dx,1;cf置1，循环左移，得到二进制序列
trtr2:   inc bx
         loop loptr2;16bit全部处理
         mov temp,dx ;保存转换后的二进制数
         pop dx
         pop cx
         pop bx
         pop ax 
         ret ;出栈，返回
char2bin2 endp
bin2char proc near;二进制数转换为0、1字符串输出
         push cx
         mov cx,16;总共16比特
judge:   shl bx,1;二进制数左移，分析cf
         jnc iszero;cf为0（未进位），则为0
         showstr one ;否则为1，打印字符1
         jmp final;打印结束，打印制表符
iszero:  showstr zer;为0，打印字符0
final:   loop judge;
         showstr tab;打印制表符
         pop cx
         ret
bin2char endp
code     ends
         end main