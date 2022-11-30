function plot_voltage_time_course(t,U,S)

% % Plot voltage trace, stimulus and iext
h = figure;
set(h,'Position',[0 500 600 200],'Color',[1,1,1])
clf

hold on
box on
plot(t,U(1,:),'Color',[1,0.1,0.1], 'LineWidth',2)
% plot(t,U(2,:),'Color',[1,0.1,0.1], 'LineWidth',2)

plot(t,5*S(1:length(t))-40,'k','LineWidth',1.5)
xlabel('Time (s)','Interpreter', 'Latex','FontSize', 20)
set(gca,'linewidth',1.5,'fontsize',22,'fontname','Times')
ylabel('$V_{BG}$ (mV)','Interpreter', 'Latex','FontSize', 24);
 set(gca,'XTickLabel', {});
 set(gca,'yTick',[-80 -60 -40 -20]);
axis([0 10 -85 -30])
print
end