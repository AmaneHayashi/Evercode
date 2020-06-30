function [] = GRAPH(fig_name, plot_x, plot_y, plot_name, plot_type, graf_x, xlab_name, ylab_name)
%GRAPH ������ʵ�ֶ�����ͬ���������ͼ����
%   ����ӿڣ�ͼ�������Ա�����������������������߱�ǣ�����������������

fig = figure('name', fig_name);%����ͼ
axe = axes('Parent', fig, 'YScale', 'log', 'YMinorTick', 'on', 'YMinorGrid', 'on', 'FontSize', 14);%������
%��ͼ
for i = 1 : length(plot_name)
    box('on');%�߿�
    grid('on');%����
    hold('all');%����������
    set(semilogy(plot_x, plot_y(i,:), 'Parent', axe, 'LineWidth', 2), 'Marker', plot_type(i),'DisplayName', plot_name(i));%��������ϵ
end
%����������ͼ������
set(gca,'xtick',graf_x);%�����경��
xlabel({xlab_name}, 'FontSize', 14);%��������
ylabel({ylab_name}, 'FontSize', 14);%��������
legend(plot_name,'Location', 'Best');%ͼ��λ��

end

