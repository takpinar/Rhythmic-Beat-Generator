function plot_ibias_learning_time_course(t,iext,stim_spike,diff,rule1,rule2)

% % Plot voltage trace, stimulus and iext
h = figure('Name','I_Bias');
set(h,'Position',[0 500 800 600],'Color',[1,1,1])
clf


subplot(2,1,1)
hold on
% % Plot dashed lines and coloured box corresponding to +- gamma cycle. 
% % 1 Hz centre 3.8929, min 4.0519, max 3.7411
% % 2 Hz centre 9.0727, min 8.6217, max 9.5486
% % 3 Hz centre 12.339, min 11.699, max 12.980
% % 4 Hz centre 14.349, min 13.652, max 15.074
% % 5 Hz centre 15.677, min 14.929, max 16.460
% centre = 9.0727;
% min = 8.6217;
% max = 9.5486;
centre = mean(iext);
stdev = std(iext);
lb = min(iext);
ub = max(iext);

% fill([0 0 t(end) t(end)],[min max max min],[0.9,0.95,1])
plot(linspace(0,t(end),100),(centre+stdev)*ones(1,100),'--','Color',[0.5 0.5 0.5])
plot(linspace(0,t(end),100),(centre-stdev)*ones(1,100),'--','Color',[0.5 0.5 0.5])
plot(linspace(0,t(end),100),centre*ones(1,100),'Color',[0.7 0.7 0.7], 'LineWidth', 1)

box on
plot(t,iext,'Color',[0.1,0.5,0.9], 'LineWidth',2)
ylab = ylabel('$I_{\rm bias}$ (mA)','Interpreter', 'Latex','fontsize',18);
set(gca,'linewidth',1.5,'fontsize',18,'fontname','Times')
set(gca,'XTickLabel', {});
axis([0 10 lb-0.2 ub+1])
print
 
% subplot(3,1,2)
% hold on
% box on
% plot(linspace(0,t(end),100),40*log(2)*ones(1,100),'--','Color',[0.5 0.5 0.5])
% plot(linspace(0,t(end),100),-40*log(2)*ones(1,100),'--','Color',[0.5 0.5 0.5])
% plot(linspace(0,t(end),100),zeros(1,100),'Color',[0.7 0.7 0.7],'LineWidth', 1)
% plot(stim_spike(1+end-length(diff):end)/1000,diff,'Color',[0.4 0.4 0.4], 'LineWidth',1)
% plot(stim_spike(1+end-length(diff):end)/1000,diff,'.','Color',[1,0.4,0.2], 'MarkerSize',16)
% set(gca,'linewidth',1.5,'fontsize',18,'fontname','Times')
% ylabel('Timing Error (ms)','Interpreter', 'Latex','fontsize',16);
% % xlabel('Time (s)','Interpreter', 'Latex','FontSize', 24)
% axis([0 10 -60 45])


subplot(2,1,2)
hold on
box on
ub = max(max(rule1),max(rule2));
lb = min(min(rule1),min(rule2));
plot(t,rule1,'Color',[0.5,0,0.7], 'LineWidth',2)
plot(t,rule2,'Color',[0,0.8,0], 'LineWidth',2)
plot(t,zeros(1,length(t)),'Color',[0.7 0.7 0.7], 'LineWidth',1)
plot(t,rule1,'Color',[0.5,0,0.7], 'LineWidth',2)
plot(t,rule2,'Color',[0,0.8,0], 'LineWidth',2)
ylabel('Updates','Interpreter', 'Latex','fontsize',16);
% set(ylab,'Rotation',0,'Position',get(ylab,'Position')-[300,0.0,0.0])
set(gca,'linewidth',1.5,'fontsize',18,'fontname','Times')
xlabel('Time (s)','Interpreter', 'Latex','FontSize', 20)
axis([0 10 lb-0.2 ub+0.2])
h = legend('$LR_T$','$LR_\phi$','Location','northeast');
set(h,'Interpreter', 'Latex','fontsize',18)
print
