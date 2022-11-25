function plot_voltage_ibias_learning_time_course(t,U,S,iext,rule1,rule2)

% % Plot voltage trace, stimulus and iext
h = figure;
set(h,'Position',[0 500 600 750],'Color',[1,1,1])
clf

set(subplot(4,1,1), 'Position', [0.12, 0.58, 0.85, 0.35])
hold on
% % Colours learning, synchronised aand continuation. Change numbers to
% % correspond to given simulation
% fill([0 0 1.4 1.4],[-85 -25 -25 -85],[0.9 1 0.9],'EdgeColor','none')
% fill([1.4 1.4 3.052 3.052],[-85 -25 -25 -85],[1 1 0.95],'EdgeColor','none')
% fill([3.052 3.052 10 10],[-85 -25 -25 -85],[1 0.9 0.9],'EdgeColor','none')
box on
plot(t,U(1,:),'Color',[1,0.1,0.1], 'LineWidth',2)
plot(t,5*S(1:length(t))-40,'k','LineWidth',1.5)
% xlabel('Time (s)','Interpreter', 'Latex','FontSize', 20)
set(gca,'linewidth',1.5,'fontsize',22,'fontname','Times')
ylabel('$V_{BG}$ (mV)','Interpreter', 'Latex','FontSize', 24);
 set(gca,'XTickLabel', {});
 set(gca,'yTick',[-80 -60 -40 -20]);
axis([0 10 -85 -30])
print
set(subplot(4,1,3), 'Position', [0.12, 0.37, 0.85, 0.18])
hold on
% % Plot dashed lines and coloured box corresponding to +- gamma cycle. 
% % 1 Hz centre 3.8929, min 4.0519, max 3.7411
% % 2 Hz centre 9.0727, min 8.6217, max 9.5486
% % 3 Hz centre 12.339, min 11.699, max 12.980
% % 4 Hz centre 14.349, min 13.652, max 15.074
% % 5 Hz centre 15.677, min 14.929, max 16.460
centre = 9.0727;
min = 8.6217;
max = 9.5486;
fill([-2 -2 10 10],[min max max min],[0.9,0.95,1])
plot(linspace(0,10,100),max*ones(1,100),'Color',[0.5 0.5 0.5])
plot(linspace(0,10,100),min*ones(1,100),'Color',[0.5 0.5 0.5])
plot(linspace(0,10,100),centre*ones(1,100),'k--', 'LineWidth', 1.5)

box on
plot(t,iext,'Color',[0.1,0.5,0.9], 'LineWidth',2)
ylab = ylabel('$I_{\rm bias}$ (mA)','Interpreter', 'Latex','fontsize',24);
set(gca,'linewidth',1.5,'fontsize',22,'fontname','Times')
set(gca,'XTickLabel', {});
axis([0 10 min-0.5 max+0.5])
 
set(subplot(4,1,4), 'Position', [0.12, 0.16, 0.85, 0.18])
hold on
box on
plot(t,rule1,'Color',[0.5,0,0.7], 'LineWidth',2)
plot(t,rule2,'Color',[0,0.8,0], 'LineWidth',2)
plot(t,zeros(1,length(t)),'k--', 'LineWidth',1)
plot(t,rule1,'Color',[0.5,0,0.7], 'LineWidth',2)
plot(t,rule2,'Color',[0,0.8,0], 'LineWidth',2)
ylabel('Updates','Interpreter', 'Latex','fontsize',24);
% set(ylab,'Rotation',0,'Position',get(ylab,'Position')-[300,0.0,0.0])
set(gca,'linewidth',1.5,'fontsize',22,'fontname','Times')
xlabel('Time (s)','Interpreter', 'Latex','FontSize', 24)
axis([0 10 -1 1])
h = legend('$LR_T$','$LR_\phi$','Location','northeast');
set(h,'Interpreter', 'Latex','fontsize',18,'fontname','Helvetica')
print
