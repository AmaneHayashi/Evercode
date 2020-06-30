function [ser] = QPSK(Eb_N0dB, Nmax)
%QPSK 本函数实现QPSK调制、AWGN信道传输与解调判决，统计误符号率并输出
% 输入接口：信噪比（向量），仿真值。
% 输出接口：误符号率。

N=10000;%设置每次对10000个符号操作
loop = Nmax / N;%帧数
Es_N0dB = 3+Eb_N0dB;%符号信噪比与比特信噪比的转换
n0 = 1./(10.^(Es_N0dB/10));
err = zeros(1, length(n0));%初始化
ser = zeros(1, length(n0));

for k = 1 : length(n0)
    for p = 1 : loop
        Q_r  = sqrt(0.5) * sign(randn(1,N));%生成实部信号
        Q_i = sqrt(0.5) * sign(randn(1,N));%生成虚部信号
        Q_s  = Q_r + 1j* Q_i;
        white_n = sqrt(0.5) * sqrt(n0(k)) * randn(1,N) + 1j*sqrt(0.5) * sqrt(n0(k)) * randn(1,N);  %生成AWGN
        Y_r = Q_s + white_n;  %AWGN信道的接受信号
        Y_d = sqrt(0.5) * sign(real(Y_r)) + sqrt(0.5) * 1j* sign(imag(Y_r));   %接收信号的判决
        err(k) = err(k) + sum(Y_d ~= Q_s);%统计误符号个数
    end
    ser(k) = err(k) / Nmax;%计算误符号率
end

end
