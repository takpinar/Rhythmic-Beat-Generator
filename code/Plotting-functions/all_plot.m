function all_plot(t,U,S,S_full,iext,rule1,rule2)
% plots voltage, ibias and rules updates

% % Plot voltage trace, stimulus and iext
h=figure();
set(h,'Position',[100, 100, 10240, 12000])
clf

subplot(5,1,1:2)

hold on
box on
v_icell = U(9,:);
v_icell(v_icell>-20)=NaN;

v_ecell = U(1,:);
v_ecell(v_ecell>-20)=NaN;

% plot(t,U(2,:),'Color',[0.2,0.8,0.8],'Linewidth',0.7)
icell = plot(t,v_icell,'Color',[0.5,0.5,0.5],'LineWidth',2);
set(gca,'linewidth',1,'fontsize',10)
ecell = plot(t,v_ecell,'Color',[0.8,0.2,0.2], 'LineWidth',1.8);
 plot(t,5*S_full(1:length(t))-20,'Color',[0.9 0.9 0.9],'LineWidth',2.1);
stim = plot(t,5*S(1:length(t))-20,'k','LineWidth',2);
% xlabel('Time (s)','FontSize', 12)

ylabel('(mV)','FontSize', 12);
% set(gca,'XTickLabel', {});
set(gca,'xTick',[])
set(gca,'yTick',[-80 -60 -40 -20 ]);
axis([0 10 -85 0])
lgd = legend([ecell icell],{'V_{BG}', 'V_{Inhib}'},'FontSize',10,'Orientation','horizontal');
print

subplot(4,1,3)
hold on
box on
set(gca,'linewidth',1,'fontsize',10)
centre = mean(iext);
stdev = std(iext);
lb = min(iext);
ub = max(iext);

% fill([0 0 t(end) t(end)],[min max max min],[0.9,0.95,1])
plot(linspace(0,t(end),100),(centre+stdev)*ones(1,100),'--','Color',[0.5 0.5 0.5])
plot(linspace(0,t(end),100),(centre-stdev)*ones(1,100),'--','Color',[0.5 0.5 0.5])
plot(linspace(0,t(end),100),centre*ones(1,100),'Color',[0.6 0.6 0.6], 'LineWidth', 1)


plot(t,iext,'Color',[0.1,0.5,0.9], 'LineWidth',1.8)
ylab = ylabel('I_{\rm bias} (mA)','fontsize',12);
% set(gca,'XTickLabel', {});
axis([0 10 lb-0.2 ub+1])
set(gca,'xTick',[])
print

subplot(4,1,4)
hold on 
box on
set(gca,'linewidth',1,'fontsize',10)
ub = max(max(rule1),max(rule2));
lb = min(min(rule1),min(rule2));
% plot(t,rule1,'Color',[0.5,0,0.7], 'LineWidth',2)
% plot(t,rule2,'Color',[0,0.8,0], 'LineWidth',2)
plot(t,zeros(1,length(t)),'Color',[0.6 0.6 0.6], 'LineWidth',1.2)
per = plot(t,rule1,'Color',[0.5,0,0.7], 'LineWidth',1.8);
pha = plot(t,rule2,'Color',[0,0.8,0], 'LineWidth',1.8);
ylabel('LR Updates','fontsize',12);
% set(ylab,'Rotation',0,'Position',get(ylab,'Position')-[300,0.0,0.0])

xlabel('Time (s)','FontSize', 14)
axis([0 10 lb-0.2 ub+0.2])
% set(gca,'xTick',[0,1,2,3,4,5,6,7,8,9,10])
legend([per pha],{'LR_{T}', 'LR_{\phi}'},'linewidth',0.8,'FontSize',11,'Orientation','horizontal','Location','southeast');
print





end