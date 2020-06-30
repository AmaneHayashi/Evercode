clc
clear
tic
%��������趨
ha = [0.612, 0.500, 0.612];
hb = [0.100, 0.500, 0.860];
hc = [0.000, 0.500, 0.866];
Eb_N0dB_min = 0;
Eb_N0dB_max = 30;
Eb_N0dB = Eb_N0dB_min : 1 : Eb_N0dB_max;
SIMU_FRAMES = 50;
%����
BERa = OFDM(SIMU_FRAMES, 2048, 16, ha, Eb_N0dB);
BERb = OFDM(SIMU_FRAMES, 2048, 16, hb, Eb_N0dB);
BERc = OFDM(SIMU_FRAMES, 2048, 16, hc, Eb_N0dB);
%��ͼ�����趨
fig_name = "ʵ���";
plot_x = Eb_N0dB;
graf_x = Eb_N0dB_min : 10 : Eb_N0dB_max;
plot_y = [BERa; BERb; BERc];
plot_name = ["OFDM����-A", "OFDM����-B", "OFDM����-C"];
plot_type = ["+", "^", "."];
xlab_name = "Eb/N0(dB)";
ylab_name = "BER";
%��ͼ
GRAPH(fig_name, plot_x, plot_y, plot_name, plot_type, graf_x, xlab_name, ylab_name);
toc