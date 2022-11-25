clear all
close all

ifsave = 1;                             % saves plots if equal to 1

savedir = '/Users/ainebyrne/Documents/MATLAB/INaP-model/BG_code/Test/';

TapTimes1 = [];
TapTimes2 = [];
TapTimes3 = [];
reps2 = 0;
ExtraTaps = 0;
num1trials = 0;
num2trials = 0;
num3trials = 0;

freq1 = 2;
freq2 = [1.5 2 2.5];
T1 = 1000./freq1;
T2 = 1000./freq2;

load('Not-normalized-rule-data/Frequency-changes/freq_change_from_2Hz_periods.mat');

for j = 2:4
    x = data(j);
for i=1:length(x.spike_times)
    reps2 = max(reps2,length(x.spike_times{i}));
    if x.freq2 == freq2(1)
        TapTimes1 = [TapTimes1; x.spike_times{i}-5000];
        num1trials = num1trials + 1;
    elseif x.freq2 == freq2(2)
        TapTimes2 = [TapTimes2; x.spike_times{i}-5000];
        num2trials = num2trials + 1;
    elseif x.freq2 == freq2(3)
        TapTimes3 = [TapTimes3; x.spike_times{i}-5000];
        num3trials = num3trials + 1;
    else
        disp(['File with freq ',num2str(data.rate),' not included'])
    end
end
end



f1 = figure;
edges = -10*T1:T1/10:10*T1+(reps2+ExtraTaps+2)*T2(1);
set(gcf, 'Position', [0 500 1400 650],'PaperPositionMode','auto')
subplot(3,1,1)
histogram(TapTimes1,edges,'FaceColor','b')
hold on
for j = -10*T1:T1:0
    plot([j,j],[0,num1trials],'r')
end
plot([0,0],[0,num1trials],'k--')
for j = T2(1):T2(1):10*T1+reps2*T2(1)
    plot([j,j],[0,num1trials],'k')
end
axis([-4000 20*T2(1) 0 num1trials])
title(['Timecourse of tap times for frequency decrease (',num2str(freq1),' Hz to ',num2str(freq2(1)),' Hz)'],'Fontsize',14)
set(gca,'linewidth',1,'fontsize',15,'fontname','Times')
subplot(3,1,2)
histogram(TapTimes2,edges,'FaceColor','b')
hold on
for j = -10*T1:T1:0
    plot([j,j],[0,num2trials],'r')
end
plot([0,0],[0,num2trials],'k--')
for j = T2(2):T2(2):10*T1+reps2*T2(2)
    plot([j,j],[0,num2trials],'k')
end
axis([-1000 20*T2(2) 0 num2trials])
title(['Timecourse of tap times for no frequency change (',num2str(freq1),' Hz)'],'Fontsize',14)
set(gca,'linewidth',1,'fontsize',15,'fontname','Times')
subplot(3,1,3)
histogram(TapTimes3,edges,'FaceColor','b')
hold on
for j = -10*T1:T1:0
    plot([j,j],[0,num3trials],'r')
end
plot([0 0],[0,15],'k--')
for j = T2(3):T2(3):10*T1+reps2*T2(3)
    plot([j,j],[0,num3trials],'k')
end
axis([-1000 20*T2(3) 0 num3trials])
title(['Timecourse of tap times for frequency increase (',num2str(freq1),' Hz to ',num2str(freq2(3)),' Hz)'],'Fontsize',14)
set(gca,'linewidth',1,'fontsize',15,'fontname','Times')




f2 = figure;
set(f2, 'Position', [0 500 1400 650],'PaperPositionMode','auto')
subplot(3,1,1)
hold on
plot(linspace(-5*T1,0,100),T1*ones(1,100),'k--')
plot(linspace(0,22*T2(1),100),T2(1)*ones(1,100),'k--')
for j = -10*T1:T1:0
    plot([j,j],[0,2000],'r')
end
plot([0,0],[0,num1trials],'k--')
for j = T2(1):T2(1):10*T1+reps2*T2(1)
    plot([j,j],[0,2000],'k')
end
for j=1:size(TapTimes1,1)
    plot(TapTimes1(j,2:end),TapTimes1(j,2:end)-TapTimes1(j,1:end-1),'.','Color',[0,1-(j)/(size(TapTimes1,1)),(j-1)/(size(TapTimes1,1)-1)],'MarkerSize',20)
end
axis([-4*T1 20*T2(1) 300 1000])
title(['Timecourse of period for frequency decrease (',num2str(freq1),' Hz to ',num2str(freq2(1)),' Hz)'],'Fontsize',14)
set(gca,'linewidth',1,'fontsize',15,'fontname','Times')
subplot(3,1,2)
hold on
plot(linspace(-5*T1,0,100),T1*ones(1,100),'k--')
plot(linspace(0,22*T2(2),100),T2(2)*ones(1,100),'k--')
for j = -10*T1:T1:0
    plot([j,j],[0,2000],'r')
end
plot([0,0],[0,num1trials],'k--')
for j = T2(2):T2(2):10*T1+reps2*T2(2)
    plot([j,j],[0,2000],'k')
end
for j=1:size(TapTimes2,1)
    plot(TapTimes2(j,2:end),TapTimes2(j,2:end)-TapTimes2(j,1:end-1),'.','Color',[0,1-(j)/(size(TapTimes2,1)),(j-1)/(size(TapTimes2,1)-1)],'MarkerSize',20)
end
axis([-4*T1 20*T2(2) 200 900])
title(['Timecourse of period for no change in frequency (',num2str(freq1),' Hz)'],'Fontsize',14)
set(gca,'linewidth',1,'fontsize',15,'fontname','Times')
subplot(3,1,3)
hold on
plot(linspace(-5*T1,0,100),T1*ones(1,100),'k--')
plot(linspace(0,22*T2(2),100),T2(2)*ones(1,100),'k--')
for j = -10*T1:T1:0
    plot([j,j],[0,2000],'r')
end
plot([0,0],[0,num1trials],'k--')
for j = T2(3):T2(3):10*T1+reps2*T2(3)
    plot([j,j],[0,2000],'k')
end
for j=1:size(TapTimes3,1)
    plot(TapTimes3(j,2:end),TapTimes3(j,2:end)-TapTimes3(j,1:end-1),'.','Color',[0,1-(j)/(size(TapTimes3,1)),(j-1)/(size(TapTimes3,1)-1)],'MarkerSize',20)
end
axis([-4*T1 20*T2(1) 100 800])
title(['Timecourse of period for frequency increase (',num2str(freq1),' Hz to ',num2str(freq2(3)),' Hz)'],'Fontsize',14)
set(gca,'linewidth',1,'fontsize',15,'fontname','Times')



C = cell(30,3);
for i = 1:size(TapTimes1,1)
    for j = 2:size(TapTimes1,2)
    if TapTimes1(i,j)<0
        event = round((TapTimes1(i,j))/T1);
    else
        event = round((TapTimes1(i,j))/T2(1));
    end
    if event <=20 && TapTimes1(i,j)-TapTimes1(i,j-1)>0
        C(event+9,1) = {[C{event+9,1},TapTimes1(i,j)-TapTimes1(i,j-1)]};
    end
    end
end
for i = 1:size(TapTimes2,1)
    for j = 2:size(TapTimes2,2)
    if TapTimes2(i,j)<0
        event = round((TapTimes2(i,j))/T1);
    else
        event = round((TapTimes2(i,j))/T2(2));
    end
    if event<=20 && TapTimes2(i,j)-TapTimes2(i,j-1)>0 
        C(event+9,2) = {[C{event+9,2},TapTimes2(i,j)-TapTimes2(i,j-1)]};
    end
    end
end
for i = 1:size(TapTimes3,1)
    for j = 2:size(TapTimes3,2)
    if TapTimes3(i,j)<0
        event = round((TapTimes3(i,j))/T1);
    else
        event = round((TapTimes3(i,j))/T2(3));
    end
    if event<=20 && TapTimes3(i,j)-TapTimes3(i,j-1)>0
        C(event+9,3) = {[C{event+9,3},TapTimes3(i,j)-TapTimes3(i,j-1)]};
    end
    end
end
    


period_mean = zeros(length(C),3);
    period_sd = zeros(length(C),3);
    period_CV = zeros(length(C),3);
    event_no = zeros(length(C),3);
    for j = 1:3
    for i = 1:length(C)
       period_mean(i,j) = mean(C{i,j});
       period_CV(i,j) = std(C{i,j})/mean(C{i,j});    
       period_sd(i,j) = std(C{i,j}); 
      
       event_no(i,j) = i-9;
    end
    end
    
    
    stat_sd1 = 64.3304;
    stat_sd2 = 38.2187;
    stat_sd3 = 53.5905;
    
    f3 = figure;
    set(f3, 'Position', [0 500 1400 650],'PaperPositionMode','auto')
    subplot(3,1,1)
    hold on
    box on
    fill([-10 -10 0 0],[T1-40*log(2) T1+40*log(2) T1+40*log(2) T1-40*log(2)],[1,0.8,0.8])
    fill([0 0 25 25],[T2(1)-40*log(2) T2(1)+40*log(2) T2(1)+40*log(2) T2(1)-40*log(2)],[0.9,0.9,0.9])
    plot(linspace(-10,0,100),T1*ones(1,100),'k--')
    plot(linspace(0,25,100),T2(1)*ones(1,100),'k--')
    for j = -20:1:0
    plot([j,j],[0,2500],'r')
    end
    plot([0 0],[0,2500],'k--')
    for j = 1:1:10
    plot([j,j],[0,2500],'k')
    end
    for j = 10:1:30
    plot([j,j],[0,2500],'k--')
    end
    errorbar(event_no(:,1),period_mean(:,1),period_sd(:,1),'b.','LineWidth',2,'MarkerSize',24,'CapSize', 20)
    axis([-5 15 400 800])   
    set(gca,'linewidth',1,'fontsize',20,'fontname','Times')
    title(['Frequency decrease (',num2str(freq1),' Hz to ',num2str(freq2(1)),' Hz)'],'Fontsize',18)
    subplot(3,1,2)
    hold on
    box on
    fill([-10 -10 0 05],[T1-40*log(2) T1+40*log(2) T1+40*log(2) T1-40*log(2)],[1,0.8,0.8])
    fill([0 0 25 25],[T2(2)-40*log(2) T2(2)+40*log(2) T2(2)+40*log(2) T2(2)-40*log(2)],[0.9,0.9,0.9])
    plot(linspace(-10,0,100),T1*ones(1,100),'k--')
    plot(linspace(0,25,100),T2(2)*ones(1,100),'k--')
    for j = -20:1:0
    plot([j,j],[0,2500],'r')
    end
    plot([0 0],[0,2500],'k--')
    for j = 1:1:10
    plot([j,j],[0,2500],'k')
    end
    for j = 10:1:30
    plot([j,j],[0,2500],'k--')
    end
    errorbar(event_no(:,2),period_mean(:,2),period_sd(:,2),'b.','LineWidth',2,'MarkerSize',24,'CapSize', 20)
    axis([-5 15 300 700])   
    set(gca,'linewidth',1,'fontsize',20,'fontname','Times')
    set(gca,'YTick',[400 600])
    title(['No frequency change (',num2str(freq1),' Hz)'],'Fontsize',18)
    subplot(3,1,3)
    hold on
    box on
    fill([-10 -10 0 0],[T1-40*log(2) T1+40*log(2) T1+40*log(2) T1-40*log(2)],[1,0.8,0.8])
    fill([0 0 25 25],[T2(3)-40*log(2) T2(3)+40*log(2) T2(3)+40*log(2) T2(3)-40*log(2)],[0.9,0.9,0.9])
    plot(linspace(-10,0,100),T1*ones(1,100),'k--')
    plot(linspace(0,25,100),T2(3)*ones(1,100),'k--')
    for j = -20:1:0
    plot([j,j],[0,2500],'r')
    end
    plot([0 0],[0,2500],'k--')
    for j = 1:1:10
    plot([j,j],[0,2500],'k')
    end
    for j = 10:1:30
    plot([j,j],[0,2500],'k--')
    end
    errorbar(event_no(:,3),period_mean(:,3),period_sd(:,3),'b.','LineWidth',2,'MarkerSize',24,'CapSize', 20)
    axis([-5 15 200 600])    
    set(gca,'linewidth',1,'fontsize',20,'fontname','Times')
    title(['Frequency increase (',num2str(freq1),' Hz to ',num2str(freq2(3)),' Hz)'],'Fontsize',18)
    

%  f4 = figure;
%     set(f4, 'Position', [0 500 1400 650],'PaperPositionMode','auto')
%     subplot(3,1,1)
%     hold on
%     for j = -20:1:0
%     plot([j,j],[0,2500],'r')
%     end
%     plot([0 0],[0,2500],'k--')
%     for j = 1:1:(reps2)
%     plot([j,j],[0,2500],'k')
%     end
%     for j = reps2:1:(reps2+12)
%     plot([j,j],[0,2500],'k--')
%     end
%     plot(linspace(-10,30,100),ones(1,100),'k--')
%     a = find(event_no(:,1)>0,1);
%     errorbar(event_no(1:a-1,1),period_mean(1:a-1,1)/T1,period_CV(1:a-1,1),'b.','MarkerSize',24)
%     errorbar(event_no(a,1),period_mean(a,1)/T1,period_CV(a,1),'r.','MarkerSize',24)
%     errorbar(event_no(a:end,1),period_mean(a:end,1)/T2(1),period_CV(a:end,1),'b.','MarkerSize',24)
%     axis([-5 21 0.4 1.6])
%     title(['CV of period for frequency decrease (',num2str(freq1),' Hz to ',num2str(freq2(1)),' Hz)'],'Fontsize',14)
%     set(gca,'linewidth',1,'fontsize',15,'fontname','Times')
%     subplot(3,1,2)
%     hold on
%     for j = -20:1:0
%     plot([j,j],[0,2500],'r')
%     end
%     plot([0 0],[0,2500],'k--')
%     for j = 1:1:(reps2)
%     plot([j,j],[0,2500],'k')
%     end
%     for j = reps2:1:(reps2+12)
%     plot([j,j],[0,2500],'k--')
%     end
%     plot(linspace(-10,30,100),ones(1,100),'k--')
%     a = find(event_no(:,2)>0,1);
%     errorbar(event_no(1:a-1,2),period_mean(1:a-1,2)/T1,period_CV(1:a-1,2),'b.','MarkerSize',24)
%     errorbar(event_no(a,2),period_mean(a,2)/T1,period_CV(a,2),'r.','MarkerSize',24)
%     errorbar(event_no(a:end,2),period_mean(a:end,2)/T2(2),period_CV(a:end,2),'b.','MarkerSize',24)
%     axis([-5 21 0.4 1.6])
%     title(['CV of period for no change in frequency (',num2str(freq2(3)),' Hz)'],'Fontsize',14)
%     set(gca,'linewidth',1,'fontsize',15,'fontname','Times')
%     subplot(3,1,3)
%     hold on
%     for j = -20:1:0
%     plot([j,j],[0,2500],'r')
%     end
%     plot([0 0],[0,2500],'k--')
%     for j = 1:1:(reps2)
%     plot([j,j],[0,2500],'k')
%     end
%     for j = reps2:1:(reps2+12)
%     plot([j,j],[0,2500],'k--')
%     end
%     plot(linspace(-10,30,100),ones(1,100),'k--')
%     a = find(event_no(:,3)>0,1);
%     errorbar(event_no(1:a-1,3),period_mean(1:a-1,3)/T1,period_CV(1:a-1,3),'b.','MarkerSize',24)
%     errorbar(event_no(a,3),period_mean(a,3)/T1,period_CV(a,3),'r.','MarkerSize',24)
%     errorbar(event_no(a:end,3),period_mean(a:end,3)/T2(3),period_CV(a:end,3),'b.','MarkerSize',24)
%     axis([-5 21 0.4 1.6])
%     title(['CV of period for frequency increase (',num2str(freq1),' Hz to ',num2str(freq2(3)),' Hz)'],'Fontsize',14)
%     set(gca,'linewidth',1,'fontsize',15,'fontname','Times')

    
    
%     if ifsave 
%         print(f1,[savedir,'Sub',num2str(Subject),'_FreqSwitch_timecourses'],'-dpng','-r0');
%         print(f2,[savedir,'Sub',num2str(Subject),'_FreqSwitch_periods_nolines'],'-dpng','-r0');
%         print(f3,[savedir,'Sub',num2str(Subject),'_FreqSwitch_period_mean_std'],'-dpng','-r0');
%         print(f4,[savedir,'Sub',num2str(Subject),'_FreqSwitch_period_CV'],'-dpng','-r0');
%     end

    