function [ser] = QPSK(Eb_N0dB, Nmax)
%QPSK ������ʵ��QPSK���ơ�AWGN�ŵ����������о���ͳ��������ʲ����
% ����ӿڣ�����ȣ�������������ֵ��
% ����ӿڣ�������ʡ�

N=10000;%����ÿ�ζ�10000�����Ų���
loop = Nmax / N;%֡��
Es_N0dB = 3+Eb_N0dB;%������������������ȵ�ת��
n0 = 1./(10.^(Es_N0dB/10));
err = zeros(1, length(n0));%��ʼ��
ser = zeros(1, length(n0));

for k = 1 : length(n0)
    for p = 1 : loop
        Q_r  = sqrt(0.5) * sign(randn(1,N));%����ʵ���ź�
        Q_i = sqrt(0.5) * sign(randn(1,N));%�����鲿�ź�
        Q_s  = Q_r + 1j* Q_i;
        white_n = sqrt(0.5) * sqrt(n0(k)) * randn(1,N) + 1j*sqrt(0.5) * sqrt(n0(k)) * randn(1,N);  %����AWGN
        Y_r = Q_s + white_n;  %AWGN�ŵ��Ľ����ź�
        Y_d = sqrt(0.5) * sign(real(Y_r)) + sqrt(0.5) * 1j* sign(imag(Y_r));   %�����źŵ��о�
        err(k) = err(k) + sum(Y_d ~= Q_s);%ͳ������Ÿ���
    end
    ser(k) = err(k) / Nmax;%�����������
end

end
