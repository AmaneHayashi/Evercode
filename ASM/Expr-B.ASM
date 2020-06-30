 ;
 ;************************ 微机原理与接口技术实验二****************************
 ;   WRITTEN BY: AMANE ICE                                                  *
 ;   DATE: 09/12/2018                                                       *
 ;   REFERENCES: TEXTBOOK OF MICRO-PROCESSOR AND INTERFACE TECHNOLOGY       *
 ;   SCHOOL OF INFORMATION AND TELECOMMUNICATION ENGINNERING,               *
 ;   BEIJING UNIVERSITY OF posiTS AND TELECOMMUNICATIONS                    *                                                                                     
 ;************************** 实验B(分支循环程序设计)*************************** 
 ; 测试参考:存储数据为-5,10,9,0,-7,2,0,41,-42,18,0,34,-86,3,0,21,-63.         *
 ; 题目要求:                                                                 *
 ; (1)安排一个数据区(数据段),内存有若干个正数,负数和零.每类数的个数都不超过9.     * 
 ; (2)编写一个程序统计数据区中正数,负数和零的个数.                              *    
 ; (3)将统计结果在屏幕上显示.                                                 *
 ; (4)统计出正奇数,正偶数,负奇数,负偶数以及零的个数.                            *
 ;***************************************************************************

data    segment;数据段定义
buff    dw -24,0,56,6,26,-17,-5,9,32,0,-13,-28,0,9,57,86,-59,99;存储3个0，2个负偶数，4个负奇数，5个正偶数，4个正奇数
count   equ $-buff;统计数据段buff所占字节数
posi    db ?;正数个数
evenp   db 0;正偶数个数
oddp    db 0;正奇数个数
zero    db ?;零个数
nega    db ?;负数个数
evenn   db 0;负偶数个数
oddn    db 0;负奇数个数
str1    db 0dh,0ah,'the amount of posiitive number is:',20h,'$';正数提示
str2    db 0dh,0ah,'the amount of negative number is:',20h,'$';负数提示
str3    db 0dh,0ah,'the amount of zero is:',20h,'$';零提示
str4    db 0dh,0ah,'among them, the amount of even is:',20h,'$';偶数提示
str5    db 0dh,0ah,'among them, the amount of odd is:',20h,'$';奇数提示
cr      db 0dh,0ah,'$';换行
data    ends
stack   segment stack 'stack';堆栈段定义
        db 100 dup(?);定义100个字节
stack   ends
code    segment
        assume cs:code,ds:data,ss:stack,es:data;使用指定
print   macro str,x;字符串变量输出宏，str为字符串，x为对应的变量
        mov ah,09h
        mov dx,offset str
        int 21h
        mov ah,02h
        mov dl,x
        add dl,30h
        int 21h
        endm
newline macro;换行宏
        mov ah,09h
        mov dx,offset cr
        int 21h
        endm
start:  mov ax,data
        mov ds,ax
        mov cx,count
        shr cx,1;确定buff中的数据个数循环
        mov ah,0;存储负数
        mov dx,0;dl存储正数，dh存储零
        lea bx,buff
cmpr:   cmp word ptr[bx],0;逐个与0比较
        jg more;大于0跳转
        jz equa;等于0跳转
        jl less;小于0跳转
more:   inc dl;正数个数加1
        test word ptr[bx],01h;与01H与运算
        jne moreo;不为0则为奇数，跳转
        inc evenp;为0则为偶数，偶数个数加1
        jmp next;跳转到下一次操作
moreo:  inc oddp;奇数个数加1
        jmp next;跳转到下一次操作
equa:   inc dh;零个数加1
less:   inc ah;负数个数加1
        test word ptr[bx],01h;;与01H与运算
        jne lesso;不为0则为奇数，跳转
        inc evenn;为0则为偶数，偶数个数加1
        jmp next;跳转到下一次操作
lesso:  inc oddn;奇数个数加1
        jmp next;跳转到下一次操作
next:   inc bx
        inc bx;一个word有2个byte
        loop cmpr
        mov posi,dl;将正数个数赋值
        mov zero,dh;将零个数赋值
        mov nega,ah;将负数个数赋值
show:   print str1,posi;打印正数
        print str4,evenp;打印正偶数
        print str5,oddp;打印正奇数
        newline;换行
        print str2,nega;打印负数
        print str4,evenn;打印负偶数
        print str5,oddn;打印负奇数
        newline;换行
        print str3,zero;打印零个数
        mov ax,4c00h
        int 21h
code    ends
        end start