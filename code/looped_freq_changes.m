%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
% A neuromechanistic model for rhythmic beat generation                 %
% Bose, Byrne, Rinzel (2019)                                            %
%                                                                       %
% DOI : https://doi.org/10.1371/journal.pcbi.1006450                    %
%                                                                       %
% This code simulates many realisations of a change in stimulus         %
% frequency, for changes of different magnitude and direction (Fig. 7)  %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Preamble

clear all
close all

addpath('BG-functions/')

% For saving data
% 1 to save, 0 otherwise
svflag = 0;         % Set to 1 to save data

%% Setup

% Set initial frequency (fixed)
T1 = 500;
freq1 = 1000./T1;

% Determine time of frequency switch
t0 = 0;
NumTonesInitialFreq = 4;
t1 = (1000/freq1)*NumTonesInitialFreq;
dt = 0.05;
buffer = 100;       % time at end to ensure both neurons have spiked before terminating

% Set frequencies to switch to
T = 150:50:1000;
Freqs = 1000./T;
data = struct;
    
% Number of times to repeat each frequency switch
M = 100;


%% Simulate each frequency switch M times

% Loop over different frequencies
for j = 1:length(Freqs)
    
    freq2 = Freqs(j);
    
    % Set simulation length
    % Low frequencies need more time to resynchronise
    if freq2<1.2
        tmax = t1 + 40./freq2*1000;
    elseif freq2<1.6
        tmax = t1 + 30./freq2*1000;
    else
        tmax = t1 + 20./freq2*1000;
    end
    
    % Initialise time vector
    t = 0:dt:tmax+buffer;
    N = length(t);
        
    % Stimulus parameters
    % On for 25ms, 25/dt time points
    % Off for (1000/freq - 25)ms, (1000/freq - 25)/dt time points
    S1 = stim(freq1,t(1:round(t1/dt)));
    S2 = stim(freq2,t(1:end-round(t1/dt)));
    S = [S1,S2];

    
    % Initalise vectors to keep track of Iext, spike time differences,
    % which initial condition was used and resync times
    iext = zeros(N,M);
    delT = zeros(ceil((tmax-t1)/1000*freq2),M);
    r = zeros(1,M);
    tsync = zeros(1,M);
    
    % Repeat each frequency change M times
    for i = 1:M
        
        % Marker for where we are in simulation    
        disp([Freqs(j),i])
        
        % Call function to run 'single trial'
        [iext(:,i),x,r(i)] = individual_sims(S,t,freq1,freq2);
        
        % Store spike time differences from first stimulus tone after the
        % frequency change
        delT(:,i) = x(1+end-size(delT,1):end);
        
        % Determine on which tone the BG resynchronises
        % First BG spike that is within a gamma cycle of the stimulus,
        % spike, and is followed by at least two more BG spikes within a 
        % gamma cycle of subsequent stimulus spikes
        temp = (NumTonesInitialFreq-1) + find(abs(x(NumTonesInitialFreq:end-2))<log(2)*40,1,'first');
        while ~isempty(temp) && ((abs(x(temp+1))>log(2)*40 || abs(x(temp+2))>log(2)*40))
            temp = temp+find(abs(x(temp+1:end))<log(2)*40,1,'first');
        end
        
        % Compute the resynchronisation time
        if temp<=NumTonesInitialFreq
            tsync(i) = 0;
        else
            tsync(i) = ((tmax-t1)/1000)-(1/freq2)*(length(x)-temp);
        end
        
    end
    
    % Save results to a structured array
    data(j).freq2 = freq2;
    data(j).delT = delT;
    data(j).iext = iext;
    data(j).tsync = tsync;
    data(j).r = r;
    
    
    %% Plot results
    % Data points get added to these plots on each iteration of the loop
    % over frequency switches
    
    % Plot average synchronisation time 
    figure(3)
    hold on
    %     plot(ones(1,length(tsync))*freq2,tsync,'k.','MarkerSize',5)
    errorbar(1000./freq2,mean(tsync),std(tsync),'r.','LineWidth',2,'MarkerSize',24)
    
    % Plot average number of cycles before resynchroniation 
    figure(4)
    hold on
    %     plot(ones(1,length(tsync))*freq2,tsync,'k.','MarkerSize',5)
    errorbar(1000./freq2,mean(tsync*freq2),std(tsync*freq2),'r.','LineWidth',2,'MarkerSize',24)
    
end

figure(3)
set(gca,'linewidth',1.5,'fontsize',18,'fontname','Times')
xlabel('Target frequency (Hz)', 'FontSize',22)
ylabel('Resync time (s)', 'FontSize',22)

figure(4)
set(gca,'linewidth',1.5,'fontsize',18,'fontname','Times')
xlabel('Target frequency (Hz)', 'FontSize',22)
ylabel('Cycles before resync', 'FontSize',22)

%% Save data
% Saves data structure with resync times etc. if save flag is equal to 1
if svflag == 1
    save(['Frequency-changes/frequency_change_from_',num2str(freq1),'Hz_equal_period_jumps.mat'],'data','-v7.3');
end
