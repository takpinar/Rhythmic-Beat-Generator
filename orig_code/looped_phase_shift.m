%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
% A neuromechanistic model for rhythmic beat generation                 %
% Bose, Byrne, Rinzel (2019)                                            %
%                                                                       %
% DOI : https://doi.org/10.1371/journal.pcbi.1006450                    %
%                                                                       %
% This code simulates many realisations of a phase shift for phase      %
% shifts of different magnitude and direction (Fig. 8)                  %
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

% Set initial frequency
freq=2;

% Determine time of phase shift
t0 = 0;
NumTonesInitialFreq = 4;
t1 = (1000/freq)*NumTonesInitialFreq;
t2 = 15000;
dt = 0.05;
buffer = 100;       % time at end to ensure both neurons have spiked before terminating

% Set phase shift amounts
Phases = -0.5:0.1:0.5;
data = struct;

% Number of times to repeat each frequency switch
M = 50;

%% Simulate each phase shift M times

% Loop over different phase shifts
for j = 1:length(Phases)
    
    phase = Phases(j);
    
    % Set simulation length
    % All trials end 100ms after last tone
    tmax = t1+t2+phase*(1000/freq);
    
    % Initialise time vector
    t = 0:dt:tmax+buffer;
    N = length(t);
    
    % Stimulus parameters
    % On for 25ms, 25/dt time points
    % Off for (1000/freq - 25)ms, (1000/freq - 25)/dt time points
    S1 = stim(freq,t(1:t1/dt-0.5*(1000/freq)/dt));
    Shift = zeros(1,round((0.5+phase)*(1000/freq)/dt));
    S2 = stim(freq,t(1:t2/dt+buffer/dt+1));
    S = [S1,Shift,S2];

    % Initalise vectors to keep track of Iext, spike time differences,
    % which initial condition was used and resync times    
    iext = zeros(N,M);
    delT = zeros(t2/1000*freq+1,M);
    r = zeros(1,M);
    tsync = zeros(1,M);
    
    % Repeat each frequency change M times
    for i = 1:M
        
        % Marker for where we are in simulation 
        disp([Phases(j),i])
        
        % Call function to run 'single trial'
        [iext(:,i),x,r(i)] = individual_sims(S,t,freq,freq);
        
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
            tsync(i) = ((t2)/1000)-(1/freq)*(length(x)-temp);
        end
        
    end
    
    % Save results to a structured array
    data(j).phase = phase;
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
    errorbar(phase,mean(tsync),std(tsync),'r.','LineWidth',2,'MarkerSize',24)
    
    
end

figure(3)
set(gca,'linewidth',1.5,'fontsize',18,'fontname','Times')
xlabel('Target frequency (Hz)', 'FontSize',22)
ylabel('Resync time (s)', 'FontSize',22)


%% Save data
% Saves data structure with resync times etc. if save flag is equal to 1
if svflag == 1
    save(['Phase-shifts/phase_shift_data_freq_',num2str(freq),'Hz.mat'],'data','-v7.3');
end
    
