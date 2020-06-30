function [ber] = OFDM(NFrame, N_ofdm, N_cp, h, Eb_N0dB)
%OFDM ������ʵ��QPSK���ơ�OFDM�ŵ����������о���ͳ��������ʲ����
% ����ӿڣ�����ȣ�������������ֵ��
% ����ӿڣ�������ʡ�
Es_N0dB = 3+Eb_N0dB;
n0 = 1./(10.^(Es_N0dB/10));

N = N_ofdm + N_cp;
%����H����
H = zeros(N);
h_r = [h zeros(1, N-3)];
%��ת
h_all = fliplr(h_r);
%ѭ����λ
for k = 1 : N
    H(k,:) = circshift(h_all, (k));
end
g = zeros(1, N);%��ʼ��
sr = zeros(1, N_ofdm);
err = zeros(1, length(n0));
ber = zeros(1, length(n0));
%����g����
for k = 1 : N_ofdm
    g(k) = h(1) + h(2) * exp(-1j * 2 * pi * k / N_ofdm) + h(3) * exp(-1j * 4 * pi * k / N_ofdm);
end 

for k = 1 : length(n0)
    for p = 1 : NFrame
        %Ƶ�򣨳�ʼ�ź�2048�㣬����2064�㣩
        s_r = sqrt(0.5) * sign(randn(1, N_ofdm));
        s_i = sqrt(0.5) * sign(randn(1, N_ofdm));
        s_send  = s_r + 1j * s_i;
        v = sqrt(0.5) * sqrt(n0(k)) * randn(1,N) + 1j * sqrt(0.5) * sqrt(n0(k)) * randn(1,N);
        %ʱ��IFFT�󱣻�16�㣬����ֱ��IFFT��
        is = ifft(s_send);
        x = [is(1, N_ofdm - N_cp + 1 : 1 : N_ofdm), is];
        n = ifft(v);
        y = (H * (x).' + (n).').';
        yy = y(N_cp + 1 : end);
        r = fft(yy, 2048);
        %����
        for q = 1 : N_ofdm
            sr(q) = conj(g(q)) / (abs(g(q)^2 + n0(k))) * r(q);
        end
        %��һ��
        s_recv = sqrt(0.5) * sign(real(sr)) + sqrt(0.5) * 1j * sign(imag(sr));
        %�����������
        err(k) = err(k) + sum(real(s_recv) ~= real(s_send)) + sum(imag(s_recv) ~= imag(s_send));
    end
    ber(k) = err(k) / (NFrame * N_ofdm * 2);%�����������
end

end

