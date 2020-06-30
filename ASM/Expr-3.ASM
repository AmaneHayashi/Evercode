data      segment;数据段定义
nums      dw 0fffh;八分音符
num       dw 01fffh;四分音符
data      ends
stack     segment stack'stack';堆栈段定义
          db 100h dup(?);定义100个字节
stack     ends 
code      segment 
          assume cs:code, ds:data, ss:stack

delay     proc far ;四分音符延迟
          pushf
          push cx
          mov cx,num;设置外循环
loop1:    push cx
          mov cx,num;设置内循环
loop2:    loop loop2
          pop cx
          loop loop1
          pop cx
          popf
          retf
delay     endp

delays    proc far ;八分音符延迟
          pushf
          push cx
          mov cx,num;设置外循环
loops1:   push cx
          mov cx,nums;设置内循环
loops2:   loop loops2
          pop cx
          loop loops1
          popf
          retf
delays    endp

stop      proc far ;终止退出
          mov dx,0e8e0h
          in al,dx
          mov dx,0e820h
          mov al,00h;停止蜂鸣器播放
          out dx,al
          mov dx,0e800h
          mov al,00h;停止数码管显示
          out dx,al
          mov ax,4c00h
          int 21h
          ret
stop      endp
;-----------------------音符代码，基频32000Hz-------------------------
notedo    proc far ;四分音符do
do:       mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停
          jz dodelay
          test al,02h;第0位为0时，停止
          jz stopdo
          mov dx,0e820h 
          mov al,7dh;频率256Hz，32000/256=125d=7dh
          out dx,al
          mov dx,0e800h 
          mov al,21h;数码管显示1 
          out dx,al
          call delay  
stopdo:   call stop
          retf
dodelay:  mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h
          mov al,21h;数码管显示1
          out dx,al
          jmp do
notedo    endp

notere    proc far ;四分音符re
re:       mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz redelay 
          test al,02h;第0位为0时，停止
          jz stopre  
          mov dx,0e820h 
          mov al,6fh;频率288Hz，32000/288=111d=6fh 
          out dx,al
          mov dx,0e800h 
          mov al,0f4h;数码管显示2 
          out dx,al
          call delay  
stopre:   call stop
          retf
redelay:  mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,0f4h;数码管显示2 
          out dx,al
          jmp re
notere    endp

notemi    proc far ;四分音符mi
mi:       mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz midelay 
          test al,02h;第0位为0时，停止
          jz stopmi
          mov dx,0e820h 
          mov al,64h;频率320Hz，32000/320=100d=64h 
          out dx,al
          mov dx,0e800h 
          mov al,0f1h;数码管显示3 
          out dx,al
          call delay  
stopmi:   call stop
          retf
midelay:  mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,0f1h;数码管显示3 
          out dx,al
          jmp mi
notemi    endp

notefa    proc far ;四分音符fa
fa:
          mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz fadelay 
          test al,02h;第0位为0时，停止
          jz stopfa
          mov dx,0e820h 
          mov al,5eh;频率341Hz，32000/341=94d=5eh 
          out dx,al
          mov dx,0e800h 
          mov al,39h;数码管显示4 
          out dx,al
          call delay  
stopfa:   call stop
          retf
fadelay:  mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,39h;数码管显示4 
          out dx,al
          jmp fa
notefa    endp

noteso    proc far ;四分音符so
so:       mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz sodelay 
          test al,02h;第0位为0时，停止
          jz stopso
          mov dx,0e820h 
          mov al,53h;频率384Hz，32000/384=83d=53h 
          out dx,al
          mov dx,0e800h 
          mov al,0d9h;数码管显示5 
          out dx,al
          call delay  
stopso:   call stop
          retf
sodelay:
          mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,0d9h;数码管显示5 
          out dx,al
          jmp so
noteso    endp

notela    proc far ;四分音符la
la:       mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz radelay 
          test al,02h;第0位为0时，停止
          jz stopla
          mov dx,0e820h 
          mov al,4bh;频率426.6Hz，32000/426.6=75d=4bh 
          out dx,al
          mov dx,0e800h 
          mov al,0ddh;数码管显示6 
          out dx,al 
          call delay  
stopla:   call stop
          retf
radelay:  mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,0ddh;数码管显示6 
          out dx,al 
          jmp la
notela    endp

notexi    proc far ;四分音符xi
xi:
          mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz xidelay 
          test al,02h;第0位为0时，停止
          jz stopxi    
          mov dx,0e820h 
          mov al,3fh;频率512Hz，32000/512=63=3fh 
          out dx,al
          mov dx,0e800h 
          mov al,61h;数码管显示7 
          out dx,al
          call delay  
stopxi:   call stop 
          retf
xidelay:  mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,61h;数码管显示7 
          out dx,al
          jmp xi
notexi    endp

notedos   proc far  ;八分音符do
dos:      mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停
          jz dosdelay
          test al,02h;第0位为0时，停止
          jz stopdos       
          mov dx,0e820h 
          mov al,7dh 
          out dx,al
          mov dx,0e800h 
          mov al,21h;数码管显示1 
          out dx,al
          call delays 
stopdos:  call stop
          retf
dosdelay:
          mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h
          mov al,21h;数码管显示1
          out dx,al
          jmp do
notedos   endp

noteres   proc far ;八分音符re
res:      mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz resdelay 
          test al,02h;第0位为0时，停止
          jz stopres           
          mov dx,0e820h 
          mov al,6fh 
          out dx,al
          mov dx,0e800h 
          mov al,0f4h;数码管显示2 
          out dx,al
          call delays  
stopres:  call stop
          retf
resdelay: mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,0f4h;数码管显示2 
          out dx,al
          jmp res
noteres   endp

notemis   proc far ;八分音符mi 
mis:      mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz misdelay 
          test al,02h;第0位为0时，停止
          jz stopmis 
          mov dx,0e820h 
          mov al,64h 
          out dx,al
          mov dx,0e800h 
          mov al,0f1h;数码管显示3 
          out dx,al
          call delays  
stopmis:  call stop
          retf
misdelay: mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,0f1h;数码管显示3 
          out dx,al
          jmp mis
notemis   endp

notefas   proc far ;八分音符fa 
fas:      mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz fasdelay 
          test al,02h;第0位为0时，停止
          jz stopfas 
          mov dx,0e820h 
          mov al,5eh 
          out dx,al
          mov dx,0e800h 
          mov al,39h;数码管显示4 
          out dx,al
          call delays  
stopfas:  call stop
          retf
fasdelay: mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,39h;数码管显示4 
          out dx,al
          jmp fas
notefas   endp

notesos   proc far ;八分音符so 
sos:      mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz sosdelay 
          test al,02h;第0位为0时，停止
          jz stopsos 
          mov dx,0e820h 
          mov al,53h 
          out dx,al
          mov dx,0e800h 
          mov al,0d9h;数码管显示5 
          out dx,al
          call delays  
stopsos:  call stop
          retf
sosdelay: mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,0d9h;数码管显示5 
          out dx,al
          jmp sos
notesos   endp

notelas   proc far ;八分音符la 
las:      mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz rasdelay 
          test al,02h;第0位为0时，停止
          jz stoplas 
          mov dx,0e820h 
          mov al,4bh 
          out dx,al
          mov dx,0e800h 
          mov al,0ddh;数码管显示6 
          out dx,al 
          call delays  
stoplas:  call stop
          retf
rasdelay: mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,0ddh;数码管显示6 
          out dx,al 
          jmp las
notelas   endp

notexis   proc far ;八分音符xi 
xis:      mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz xisdelay 
          test al,02h;第0位为0时，停止
          jz stopxis   
          mov dx,0e820h 
          mov al,3fh 
          out dx,al
          mov dx,0e800h 
          mov al,61h;数码管显示7 
          out dx,al
          call delays  
stopxis:  call stop 
          retf
xisdelay: mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,61h;数码管显示7 
          out dx,al
          jmp xis
notexis   endp

notesod   proc far ;四分音符so（低八度）
sod:      mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz soddelay 
          test al,02h;第0位为0时，停止
          jz stopsod 
          mov dx,0e820h 
          mov al,0a7h;频率192Hz，32000/192=166d=a7h 
          out dx,al
          mov dx,0e800h 
          mov al,0dbh ;数码管显示5.
          out dx,al
          call delay  
stopsod:  call stop
          retf
soddelay: mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,0dbh 
          out dx,al
          jmp sod
notesod   endp

notexid   proc far ;四分音符xi（低八度）
xid:
          mov dx,0e8e0h
          in al,dx
          test al,04h;第1位为0时，暂停 
          jz xiddelay 
          test al,02h;第0位为0时，停止
          jz stopxid   
          mov dx,0e820h 
          mov al,85h;频率240Hz，32000/140=133d=85h  
          out dx,al
          mov dx,0e800h 
          mov al,63h ;数码管显示7.
          out dx,al
          call delay  
stopxid:  call stop 
          retf
xiddelay:
          mov dx,0e820h 
          mov al,00h;停止播放 
          out dx,al
          mov dx,0e800h 
          mov al,63h 
          out dx,al
          jmp xid
notexid   endp
;--------------------------主程序------------------------------
start     proc far 
          mov ax,data
          mov ds,ax 
ini:      mov dx,0e823h 
          mov al,00010110b ;0号计数器，只读写低8位，方式3，计数初值为二进制
          out dx,al
    
          mov dx,0e803h 
          mov al,80h ;数码管初始状态，亮上方一行
          out dx,al
                            
          mov dx,0e801h ;设置数码管选通信号
          mov al,01h
          out dx,al
          mov dx,0e800h ;显示清零 
          mov al,00h
          out dx,al

          call notedo 
          call notedo
          call notedo

          call notere
          call noteres
          call notemis
          call notere 

          call notemi
          call notemi
          call notefa

          call noteso
          call delay 

          call notefa
          call noteso
          call notela

          call notemi
          call notemis
          call notefas
          call notemi

          call notere
          call notere
          call notexid

          call notedo
          call delay

          call noteres
          call notedos
          call notere
          call notesod

          call notedos
          call noteres
          call notemi
          call notemi

          call notefas
          call notemis
          call notefa
          call notefas
          call notelas

          call notesos
          call notefas
          call notemi
          call delay 

          call noteso
          call noteso
          call noteso

          call notedo 
          call notedos
          call noteres
          call notemi

          call notefa
          call notefa
          call notere

          call notedo
          call delay  
          jmp ini
start     endp
code ends
          end start

