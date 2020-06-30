function [ser] = MQAM(Eb_N0dB, Nmax)
%QPSK ������ʵ��16QAM���ơ�AWGN�ŵ����������о���ͳ��������ʲ����
% ����ӿڣ�����ȣ�������������ֵ��
% ����ӿڣ�������ʡ�
N=10000;
loop = Nmax / N;
err = zeros(1,length(Eb_N0dB));
ser = zeros(1,length(Eb_N0dB));
%�����ʼ��
mod1 = zeros(1,N);%����
mod2 = zeros(1,N);
demod1 = zeros(1,N);%���
demod2 = zeros(1,N);
demod3 = zeros(1,N);
demod4 = zeros(1,N);
Es_N0dB = 6+Eb_N0dB;%ת��
n0 = 1./(10.^(Es_N0dB/10));

for k = 1 : length(n0)
    for p = 1 : loop
        data = (sign(randn(1, 4 * N)) + 1) / 2;%%����1�У�4N�о��ȷֲ��������
        for q = 1:N  %%��������Ƶ�����ͼ��ӳ��
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
        sigma = sqrt(5) * sqrt(n0(k));%����
        s_recv1 = mod1 + sigma * randn(1,N);%����
        s_recv2 = mod2 + sigma * randn(1,N);
        for q = 1:N
            %ͬ����
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
            %�������
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
            %ͳ���������
            if (demod1(q) ~= data(q*4-3)) || (demod2(q) ~= data(q*4-2))||(demod3(q) ~= data(q*4-1)) || (demod4(q) ~= data(q*4))
                err(k) = err(k) + 1;
            end
        end
    end
    ser(k) = err(k) / Nmax;%ͳ���������
end

end