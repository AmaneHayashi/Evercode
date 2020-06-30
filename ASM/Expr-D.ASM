 ;
 ;************************ 微机原理与接口技术实验四****************************
 ;   WRITTEN BY: AMANE ICE                                                  *
 ;   DATE: 11/12/2018                                                       *
 ;   REFERENCES: TEXTBOOK OF MICRO-PROCESSOR AND INTERFACE TECHNOLOGY       *
 ;   SCHOOL OF INFORMATION AND TELECOMMUNICATION ENGINNERING,               *
 ;   BEIJING UNIVERSITY OF POSTS AND TELECOMMUNICATIONS                     *                                                                                     
 ;*************************** 实验D(子程序设计) ******************************
 ; 测试参考:输入数据为15 67 89 95 07 67 97 67 59.                             *
 ; 题目要求:                                                                 *
 ; (1)从键盘上输入某班学生的某科目成绩.输入按学生的学号由小到大的顺序输入.        * 
 ; (2)统计检查每个学生的名次                                                  *    
 ; (3)将统计结果在屏幕上显示.                                                 *
 ; (4)输入学生数目不宜太多,以不超过一屏为宜.输出应便于阅读.尽可能考虑美观.        *
 ; (5)输入要有检错手段.                                                       *
 ;***************************************************************************

data     segment;数据段定义
buff     dw 100 dup (0);存储输入（学号成绩），100个全零字节
num      dw 0;存储输入总数（循环次数）
str1     db 0dh,0ah,'please input several grades of students:',0dh,0ah,'$';输入提示
str2     db 0dh,0ah,'rank',09h,'id',09h,'mark',0dh,0ah,'$';统计结果行号
str3     db 0dh,0ah,'error input! please re-input in correct form.',0dh,0ah,'$';输入错误提示
data     ends
stack    segment stack 'stack';堆栈段定义
         db 100 dup(?);定义100个字节
stack    ends
code     segment
         assume cs:code,ds:data,ss:stack;使用指定
showchar macro add8,hex;字符打印宏
         mov ah,02h
         mov dl,add8
         add dl,hex;hex=30h时，表示转换为ASCII码
         int 21h
         endm
showstr  macro str
         mov ah,09h
         mov dx,offset str;输出错误提示
         int 21h
         endm
show     proc near;打印子程序
         mov cx,num;确定循环次数
         lea si,buff
         mov bx,3031h;从0001(BCD，第1名)开始
loop1:  
         showchar bh,0;打印成绩高位
         showchar bl,0;打印成绩低位
         showchar 09h,0;打印制表符
         showchar [si],30h;打印学号高位
         inc si;当前学号低位
         showchar [si],30h;打印学号低位
         showchar 09h,0;打印制表符
         inc si;指向成绩高位
         showchar [si],30h;打印成绩高位
         inc si;指向成绩低位
         showchar [si],30h;打印成绩低位
         showchar 0dh,0
         showchar 0ah,0;换行回车
         inc bx;下一名次
         aaa;自动调整BCD
         inc si;指向下一学号高位
         loop loop1
         ret
show     endp
check    proc near;检查子程序
         mov dh,0;初始化标志
         cmp al,'0';小于0时跳转（输入异常）
         jb err
         cmp al,'9';大于9时跳转（输入异常）
         ja err
         ret
err:     showstr str3
         mov dh,01h;错误标志置位
check    endp
store    proc near;存储子程序
         push bx;入栈
         mov [di],bh;存入高位数
         inc di
         mov [di],bl;存入低位数
         inc di
         pop bx;出栈
         ret
store    endp
sort     proc near;排序子程序
         push cx
         push bx
         push num
         mov cx,num
         lea di,buff
loop2:   cmp cx,0
         jz over;检查是否还有未排序的元素
         inc di
         inc di
         cmp bh,[di];比较高位
         ja more;高位更大进入more子程序
         jb less;高位更小进入less子程序
         inc di;高位相同则继续比较
         cmp bl,[di];比较低位
         ja more2;低位更大进入more2子程序
         inc di;低位更小则跳到指向下一数高位
         dec cx;循环次数减1
         jmp loop2
less:    inc di
         inc di
         dec cx;直接跳到指向下一个数高位
         jmp loop2
more2:   dec di;减回该数高位，以该数为最大数
more:    push cx
         mov bx,num
         mov cl,02h
         shl bx,cl;bx移出高4位
         mov ax,[buff+bx-4]
         mov [buff+bx],ax;学号后移
         mov ax,[buff+bx-2]
         mov [buff+bx+2],ax;成绩后移
         pop cx
         dec num;循环次数减1
         loop more
         dec di
         dec di;以当前数为最大数
over:    pop num
         pop bx
         pop cx
         ret;出栈，结束
sort     endp
start:   mov ax,data;主程序
         mov ds,ax
         mov es,ax
         showstr str1;显示输入提示
         mov cx,0
input1:  mov ah,01h;高位输入
         int 21h;
         call check;检查输入
         test dh,01h;是否有错误标志置位
         jnz input1
         sub al,30h;ASCII码转换
         mov bh,al;移入bx高位
input2:  mov ah,01h;低位输入
         int 21h
         call check;检查输入
         test dh,01h;是否有错误标志置位
         jnz input2
         sub al,30h;ASCII码转换
         mov bl,al;移入bx低位
input3:  mov ah,01h;分隔/结束符输入
         int 21h
         cmp al,20h;若输入为空格
         jz next
         cmp al,0dh;若输入为回车
         jz exit
         showstr str3;如果都不是，显示错误提示
         jmp input1
next:    call sort;先排序
         push bx
         inc cx;调入学号
         aaa;BCD码调整
         mov bx,cx
         call store;存入对应学号
         pop bx
         call store;存入对应成绩
         inc num;还原num的值，便于确定排序次数
         jmp input1
exit:    call sort;先排序
         push bx
         inc cx;调入学号
         aaa;BCD码调整
         mov bx,cx
         call store;存入对应学号
         pop bx
         call store;存入对应成绩
         inc num;还原num的值，便于确定输出循环次数
         showstr str2;显示输出提示
         call show;输出
         mov ax,4c00h
         int 21h
code     ends
         end start