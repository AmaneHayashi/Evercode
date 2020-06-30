function [] = GRAPH(fig_name, plot_x, plot_y, plot_name, plot_type, graf_x, xlab_name, ylab_name)
%GRAPH 本函数实现多曲线同坐标轴的作图功能
%   输入接口：图标名，自变量，因变量，曲线名，曲线标记，横轴名，纵轴名。

fig = figure('name', fig_name);%定义图
axe = axes('Parent', fig, 'YScale', 'log', 'YMinorTick', 'on', 'YMinorGrid', 'on', 'FontSize', 14);%定义轴
%作图
for i = 1 : length(plot_name)
    box('on');%边框
    grid('on');%网格
    hold('all');%坐标轴重用
    set(semilogy(plot_x, plot_y(i,:), 'Parent', axe, 'LineWidth', 2), 'Marker', plot_type(i),'DisplayName', plot_name(i));%对数坐标系
end
%横纵坐标与图例设置
set(gca,'xtick',graf_x);%横坐标步长
xlabel({xlab_name}, 'FontSize', 14);%横坐标名
ylabel({ylab_name}, 'FontSize', 14);%纵坐标名
legend(plot_name,'Location', 'Best');%图例位置

end

