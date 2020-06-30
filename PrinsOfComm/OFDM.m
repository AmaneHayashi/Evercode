function [ber] = OFDM(NFrame, N_ofdm, N_cp, h, Eb_N0dB)
%OFDM 本函数实现QPSK调制、OFDM信道传输与解调判决，统计误比特率并输出
% 输入接口：信噪比（向量），仿真值。
% 输出接口：误比特率。
Es_N0dB = 3+Eb_N0dB;
n0 = 1./(10.^(Es_N0dB/10));

N = N_ofdm + N_cp;
%生成H矩阵
H = zeros(N);
h_r = [h zeros(1, N-3)];
%反转
h_all = fliplr(h_r);
%循环移位
for k = 1 : N
    H(k,:) = circshift(h_all, (k));
end
g = zeros(1, N);%初始化
sr = zeros(1, N_ofdm);
err = zeros(1, length(n0));
ber = zeros(1, length(n0));
%生成g向量
for k = 1 : N_ofdm
    g(k) = h(1) + h(2) * exp(-1j * 2 * pi * k / N_ofdm) + h(3) * exp(-1j * 4 * pi * k / N_ofdm);
end 

for k = 1 : length(n0)
    for p = 1 : NFrame
        %频域（初始信号2048点，噪声2064点）
        s_r = sqrt(0.5) * sign(randn(1, N_ofdm));
        s_i = sqrt(0.5) * sign(randn(1, N_ofdm));
        s_send  = s_r + 1j * s_i;
        v = sqrt(0.5) * sqrt(n0(k)) * randn(1,N) + 1j * sqrt(0.5) * sqrt(n0(k)) * randn(1,N);
        %时域（IFFT后保护16点，噪声直接IFFT）
        is = ifft(s_send);
        x = [is(1, N_ofdm - N_cp + 1 : 1 : N_ofdm), is];
        n = ifft(v);
        y = (H * (x).' + (n).').';
        yy = y(N_cp + 1 : end);
        r = fft(yy, 2048);
        %均衡
        for q = 1 : N_ofdm
            sr(q) = conj(g(q)) / (abs(g(q)^2 + n0(k))) * r(q);
        end
        %归一化
        s_recv = sqrt(0.5) * sign(real(sr)) + sqrt(0.5) * 1j * sign(imag(sr));
        %计算误比特数
        err(k) = err(k) + sum(real(s_recv) ~= real(s_send)) + sum(imag(s_recv) ~= imag(s_send));
    end
    ber(k) = err(k) / (NFrame * N_ofdm * 2);%计算误比特率
end

end

