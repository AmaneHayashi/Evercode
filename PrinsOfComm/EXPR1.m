clc
clear
tic
%��������趨
Eb_N0dB_min = 0;
Eb_N0dB_max = 15;
Eb_N0dB = Eb_N0dB_min : 1 : Eb_N0dB_max;
Eb_N0 = 10.^(Eb_N0dB/10);
SIMU_TIMES = 10^6;
%����
QPSK_SER = QPSK(Eb_N0dB, SIMU_TIMES);
MQAM_SER = MQAM(Eb_N0dB, SIMU_TIMES);
%��ͼ�����趨
fig_name = "ʵ��һ";
plot_x = Eb_N0dB;
plot_y = [QPSK_SER; erfc(sqrt(Eb_N0)); MQAM_SER; 1.5*erfc(sqrt(0.4*Eb_N0))];
plot_name = ["QPSK����","QPSK����", "16QAM����", "16QAM����"];
plot_type = ["o", "^", "square", "+"];
xlab_name = "Eb/N0(dB)";
ylab_name = "SER";
%��ͼ
GRAPH(fig_name, plot_x, plot_y, plot_name, plot_type, plot_x, xlab_name, ylab_name);
toc