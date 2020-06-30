 ;
 ;************************ 微机原理与接口技术实验三****************************
 ;   WRITTEN BY: AMANE ICE                                                  *
 ;   DATE: 10/12/2018                                                       *
 ;   REFERENCES: TEXTBOOK OF MICRO-PROCESSOR AND INTERFACE TECHNOLOGY       *
 ;   SCHOOL OF INFORMATION AND TELECOMMUNICATION ENGINNERING,               *
 ;   BEIJING UNIVERSITY OF POSTS AND TELECOMMUNICATIONS                     *                                                                                     
 ;************************** 实验C(代码转换程序设计)*************************** 
 ; 测试参考:输入数据为67 93 45 89.                                            *
 ; 题目要求:                                                                 *
 ; (1)从键盘上输入若干两位十进制数,寻找其中的最小值,然后在屏幕上显示出来.         * 
 ; (2)两个十进制数之间的分隔符,输入结束标志自定,但要在报告中说明.                *    
 ; (3)对输入要有检错措施,以防止非法字符输入,并有适当的提示.                      *
 ; (4)将整个程序分解为若干模块,分别用子程序实现.在报告中要给出模块层次图.         *
 ;***************************************************************************

data     segment;数据段定义
str1     db 0dh,0ah,'pLEASE INPUT SEVERAL DOUBLE DECIMAL DIGIT. tHE NUMBERS SHOULD BE SEPERATED WITH blank AND END WITH full-stop.',0dh,0ah,'$';输入提示
str2     db 0dh,0ah,'error input! pLEASE RE-INPUT IN CORRECT FORM.',0dh,0ah,'$';输入错误提示
str3     db 0dh,0ah,'tHE minimum number IS:',0dh,0ah,'$';输出提示
min      db'9','9';初始化最小值为99
data     ends
stack    segment stack 'stack';堆栈段定义
         db 100 dup(?);定义100个字节
stack    ends
code     segment
         assume cs:code,ds:data,ss:stack;使用指定
print    macro str;字符串打印宏
         mov ah,09h
         mov dx,offset str
         int 21h
         endm        
input    proc near;输入子程序
         mov ah,01h;中断调用输入字符
         int 21h
         cmp al,'0';小于0时跳转（输入异常）
         jb flag
         cmp al,'9';大于9时跳转（输入异常）
         ja flag
         ret
flag:    mov al,0;格式化
         ret
input    endp
start:   mov ax,data;主程序
         mov ds,ax;初始化数据段
loop1:   print str1
loop2:   call input;调用输入子程序
         cmp al,0;若被flag处理过
         jz err;则报错
         mov dh,al
         call input;调用输入子程序
         cmp al,0;若被flag处理过
         jz err;则报错
         mov dl,al;将得到的数保存在dx的高低位
         mov ah,1;读取键盘
         int 21h
         cmp al,'.';数字结束符
         jz over;输入'.'时跳转结束子程序
         cmp al,' ';数字分隔符
         jnz err;没用' '分割时输入错误
         cmp dx,word ptr min;将得到的数与先前的min相减
         jb swap;比99小则跳入交换子程序
         jmp loop2
over:    cmp dx,word ptr min;最后一次比较
         jb swap2;小于min则跳转
         jmp output
err:     print str2
         jmp loop1;重新输入
swap:    mov word ptr min,dx;交换最小值
         jmp loop2
swap2:   mov word ptr min,dx;最后一次交换最小值
output:  print str3
         mov ah,02h
         mov dl,[min+1];先输出高位
         int 21h
         mov ah,02h
         mov dl,min;再输出低位
         int 21h
         mov ax,4c00h
         int 21h
code     ends
         end start