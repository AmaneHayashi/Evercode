clc
clear
tic
%仿真参数设定
Eb_N0dB_min = 0;
Eb_N0dB_max = 15;
Eb_N0dB = Eb_N0dB_min : 1 : Eb_N0dB_max;
Eb_N0 = 10.^(Eb_N0dB/10);
SIMU_TIMES = 10^6;
%仿真
QPSK_SER = QPSK(Eb_N0dB, SIMU_TIMES);
MQAM_SER = MQAM(Eb_N0dB, SIMU_TIMES);
%作图参数设定
fig_name = "实验一";
plot_x = Eb_N0dB;
plot_y = [QPSK_SER; erfc(sqrt(Eb_N0)); MQAM_SER; 1.5*erfc(sqrt(0.4*Eb_N0))];
plot_name = ["QPSK仿真","QPSK理想", "16QAM仿真", "16QAM理想"];
plot_type = ["o", "^", "square", "+"];
xlab_name = "Eb/N0(dB)";
ylab_name = "SER";
%作图
GRAPH(fig_name, plot_x, plot_y, plot_name, plot_type, plot_x, xlab_name, ylab_name);
toc