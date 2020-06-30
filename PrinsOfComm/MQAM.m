function [ser] = MQAM(Eb_N0dB, Nmax)
%QPSK 本函数实现16QAM调制、AWGN信道传输与解调判决，统计误符号率并输出
% 输入接口：信噪比（向量），仿真值。
% 输出接口：误符号率。
N=10000;
loop = Nmax / N;
err = zeros(1,length(Eb_N0dB));
ser = zeros(1,length(Eb_N0dB));
%数组初始化
mod1 = zeros(1,N);%调制
mod2 = zeros(1,N);
demod1 = zeros(1,N);%解调
demod2 = zeros(1,N);
demod3 = zeros(1,N);
demod4 = zeros(1,N);
Es_N0dB = 6+Eb_N0dB;%转换
n0 = 1./(10.^(Es_N0dB/10));

for k = 1 : length(n0)
    for p = 1 : loop
        data = (sign(randn(1, 4 * N)) + 1) / 2;%%产生1行，4N列均匀分布的随机数
        for q = 1:N  %%格雷码调制到星座图的映射
            if(data(4*q-3) == 0 && data(4*q-1) == 0)
                mod1(q) = -3;
            elseif(data(4*q-3) == 0 && data(4*q-1) == 1)
                mod1(q) = -1;
            elseif(data(4*q-3) == 1 && data(4*q-1) == 1)
                mod1(q) = 1;
            elseif(data(4*q-3) == 1 && data(4*q-1) == 0)
                mod1(q) = 3;
            end
            if(data(4*q-2) == 0 && data(4*q) == 0)
                mod2(q) = -3;
            elseif(data(4*q-2) == 0 && data(4*q) == 1)
                mod2(q) = -1;
            elseif(data(4*q-2) == 1 && data(4*q) == 1)
                mod2(q) = 1;
            elseif(data(4*q-2) == 1 && data(4*q) == 0)
                mod2(q) = 3;
            end            
        end
        sigma = sqrt(5) * sqrt(n0(k));%方差
        s_recv1 = mod1 + sigma * randn(1,N);%接收
        s_recv2 = mod2 + sigma * randn(1,N);
        for q = 1:N
            %同相解调
            if s_recv1(q)<-2 
                demod1(q) = 0;
                demod3(q) = 0;
            elseif s_recv1(q)<0 && s_recv1(q)>-2
                demod1(q) = 0;
                demod3(q) = 1;
            elseif s_recv1(q)<2 && s_recv1(q)>0
                demod1(q) = 1;
                demod3(q) = 1;
            elseif s_recv1(q)>2
                demod1(q) = 1;
                demod3(q) = 0;
            end
            %正交解调
            if s_recv2(q)<-2
                demod2(q) = 0;
                demod4(q) = 0;
            elseif s_recv2(q)<0 && s_recv2(q)>-2
                demod2(q) = 0;
                demod4(q) = 1;
            elseif s_recv2(q)<2 && s_recv2(q)>0
                demod2(q) = 1;
                demod4(q) = 1;
            elseif s_recv2(q)>2
                demod2(q) = 1;
                demod4(q) = 0;
            end
            %统计误符号数
            if (demod1(q) ~= data(q*4-3)) || (demod2(q) ~= data(q*4-2))||(demod3(q) ~= data(q*4-1)) || (demod4(q) ~= data(q*4))
                err(k) = err(k) + 1;
            end
        end
    end
    ser(k) = err(k) / Nmax;%统计误符号率
end

end