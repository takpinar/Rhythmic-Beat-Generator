function plot_voltage_time_course(t,U,S)

% % Plot voltage trace, stimulus and iext
h = figure('Name','voltage/stim plot');
set(h,'Position',[0 500 600 200],'Color',[1,1,1])
clf

hold on
box on
plot(t,U(4,:),'Color',[0.2,0.8,0.8],'Linewidth',0.7)
plot(t,U(1,:),'Color',[1,0.1,0.1], 'LineWidth',1.5)
plot(t,5*S(1:length(t))-40,'k','LineWidth',1.5)
xlabel('Time (s)','Interpreter', 'Latex','FontSize', 20)
set(gca,'linewidth',1.5,'fontsize',22,'fontname','Times')
ylabel('$V_{BG}$ (mV)','Interpreter', 'Latex','FontSize', 28);
% set(gca,'XTickLabel', {});
set(gca,'xTick',[2,4,6,8])
set(gca,'yTick',[-80 -60 -40 -20]);
axis([0 10 -85 -30])

end