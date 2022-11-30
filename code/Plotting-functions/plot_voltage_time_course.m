function plot_voltage_time_course(t,U,S)

% % Plot voltage trace, stimulus and iext
h = figure('Name','voltage/stim plot');
set(h,'Position',[0 1500 1400 600],'Color',[1,1,1])
clf

hold on
box on

v_icell = U(9,:);
v_icell(v_icell>-20)=NaN;

v_ecell = U(1,:);
v_ecell(v_ecell>-20)=NaN;

% plot(t,U(2,:),'Color',[0.2,0.8,0.8],'Linewidth',0.7)
icell = plot(t,v_icell,'Color',[0.5,0.5,0.5],'LineWidth',2);
ecell = plot(t,v_ecell,'Color',[1,0.3,0.3], 'LineWidth',2.2);
plot(t,5*S(1:length(t))-20,'k','LineWidth',1.8)
xlabel('Time (s)','Interpreter', 'Latex','FontSize', 20)
set(gca,'linewidth',1.5,'fontsize',22,'fontname','Times')
ylabel('(mV)','Interpreter', 'Latex','FontSize', 28);
% set(gca,'XTickLabel', {});
set(gca,'xTick',[2,4,6,8])
set(gca,'yTick',[-80 -60 -40 -20 ]);
axis([0 10 -85 0])
lgd = legend([ecell icell],{'V_{ECell}', 'V_{ICell}'},'FontSize',12);

% h = figure('Name','gating vars dynamics');
% set(h,'Position',[0 1500 1800 600],'Color',[1,1,1])
% clf
% hold on
% sie = plot(t,U