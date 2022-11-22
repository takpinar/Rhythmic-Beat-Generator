%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
% A neuromechanistic model for rhythmic beat generation                 %
% Bose, Byrne, Rinzel (2019)                                            %
%                                                                       %
% DOI : https://doi.org/10.1371/journal.pcbi.1006450                    %
%                                                                       %
% This code simulates a single trial with a fixed simulus frequency     %
% Can be used to recreate results from Fig. 5 and 6                     %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Preamble

clear all
close all

addpath('BG-functions/')
addpath('Plotting-functions/')

% For saving data
% 1 to save, 0 otherwise
svflagICs  = 0; % Create initial data files
svflagErrs = 0; % Save error distribution

%% Parameters and numerics

freq       = 5;  % Stim Frequency
stim_dur   = 10;   % Stimuli Duration (seconds)
gcat       = 11;
gcat1      = 10;
gL         = 1.6;
gh         = 1;
gna        = 0.1;
Eca        = 50;
EL         = -70;
Eh         = -30;
ENa        = 50;
vm         = -40;
km         = 6.5;
vh         = -60;
kh         = 6;
vr         = -70;
kr         = 12;
vrT         = -75;
krT         = 8;
va         = -67;
ka         = 1;
tleft      = 30;
tright     = 5;
thmax      = 850;
phir       = 1;
phih       = 1;
iext1      = -14;
gstim      = 6;
tileft     = 20;
tiright    = 5;
taugammaBG = 40;
taugammaS  = 40;
vth        = -20; % Spike Threshold (mV)
iint       = -33;

delta1 = 0.2;
delta2 = 2.5;

% Runtime
t0   = 0;
tmax = 100000;
dt   = 0.1;
N    = tmax/dt;

t = linspace(0,tmax,N);


%% Initial Conditions
% Can load initial data from file, or set yourself
% Comment/uncomment relevant block

% Initial data from file
%init    = load(['Initial-conditions/',num2str(freq),'Hz_synced_inits_deltaT_0.2_delta_phi_2.5.mat']);
%r       = ceil(rand*length(init.U0));
%U0      = init.U0(:,r);
%iext    = init.iext0(r)*ones(1,N);
%BGcount = init.BGcount0(r)*ones(1,N);
%Scount  = init.Scount0(r)*ones(1,N);
%BG_C    = init.BG_C0(r)*ones(1,N);
%stim_C  = init.stim_C0(r)*ones(1,N);

% % Define initial yourself
U0      = [-70,0.85,0.3,-75,0.9,1.3,1.3]';
iext    = 1*ones(1,N);
BGcount = 1*ones(1,N);  % Number of gamma cycles since last spike
Scount  = 1*ones(1,N);
BG_C    = 10*ones(1,N); % BGcount at current spike
stim_C  = 10*ones(1,N);

%% Setup variables

% Empty vectors for saving spike times
BG_spike   = [];
stim_spike = [];

% Initialise variables of model
BG       = zeros(3,N);
stim_sys = zeros(2,N);
gammaBG  = zeros(1,N);
gammaS   = zeros(1,N);

% Set up with initial data
BG(:,1)       = U0(1:3,1);
stim_sys(:,1) = U0(4:5,1);
gammaBG(1)    = U0(6,1);
gammaS(1)     = U0(7,1);

% Initialise vectors to store learning rule updates
rule1 = zeros(1,N); % Period
rule2 = zeros(1,N); % Phase

% Setup stimulus as vector of ones and zeros
% 1 stimulus on, 0 stimulus off
% On every 1000/freq ms for 25 ms
S = stim(freq,t);

%% Simulate system

for i = 2:N

    % Display time (see progress)
    if mod(i,5000)==0
        t(i)
    end
    
    % Evolve equations for BG neuron
    BG(:,i) = BG(:,i-1) + dt*BG_equations(t(i-1),BG(:,i-1),0,iext(i-1)+iint,vm,vh,vr,vrT,va,km,kh,kr,krT,ka,gcat,gL,gh,gna,Eca,EL,Eh,ENa,phir,phih,thmax,tleft,tright);

    % Evolve equations for stimulus neuron
    if i < stim_dur*10000 % duration of stimulus
        stim_sys(:,i) = stim_sys(:,i-1) + dt*stim_equations(t(i-1),stim_sys(:,i-1),S(i-1),iext1,gcat1,gL,gstim,Eca,EL,phih,vm,km,vh,kh,tileft,tiright)';
    else
        stim_sys(:,i) = stim_sys(:,i-1);
    end

    % Evolve gamma integrators
    gammaBG(i) = gammaBG(i-1)+dt*(-gammaBG(i-1)/taugammaBG);
    gammaS(i) = gammaS(i-1)+dt*(-gammaS(i-1)/taugammaS);

    % Reset BG gamma integrator when value reaches threshold
    % Add 1 to BG gamma counter
    if gammaBG(i)<1
        BGcount(i:end) = BGcount(i-1) + 1;
        gammaBG(i)=2;
    end

    % Reset stimulus gamma integrator when value reaches threshold
    % Add 1 to stimulus gamma counter
    if gammaS(i)<1
        Scount(i:end) = Scount(i-1) + 1;
        gammaS(i)=2;
    end

    % Recognise when BG neuron spikes
    if BG(1,i)>vth && BG(1,i-1)<vth

        % Update BG_C with current BG gamma counter value - number of gamma
        % cycles between this spike and the previous spike
        BG_C(i:end) = BGcount(i);

        % Reset BG gamma counter to zero
        BGcount(i:end)=0;

        % Apply period rule
        rule1(i:end)=delta1*(BG_C(i)-stim_C(i));
        iext(i:end)=iext(i-1)+rule1(i);

        % Save spike time
        if t(i)>20
            BG_spike = [BG_spike,t(i)];
        end

    end

    % Recognise when stimulus neuron spikes
    if stim_sys(1,i)>vth && stim_sys(1,i-1)<vth

        % Update stim_C with current stimulus gamma counter value - number
        % of gamma cycles between this spike and the previous spike
        stim_C(i:end) = Scount(i);

        % Reset stimulus gamma counter to zero
        Scount(i:end)=0;

        % Apply phase rule
        rule2(i:end) = delta2*(sign(BGcount(i)-stim_C(i)/2-0.001)*(BGcount(i)*abs(stim_C(i)-BGcount(i)))/stim_C(i)^2);
        iext(i:end) = iext(i-1) + rule2(i);

        % Save spike time
        if t(i)>20
            stim_spike = [stim_spike,t(i)];
        end

    end

end


% Combine variables into single vector
U = [BG;stim_sys;gammaBG;gammaS];

% Convert to seconds
t = t/1000;

% Compute difference between BG spike time and stimulus spike time at each
% stimuls spike
if length(BG_spike) == length(stim_spike)
    diff = BG_spike - stim_spike;
else
    b = min(length(BG_spike),length(stim_spike));
    diff = BG_spike(1+length(BG_spike)-b:end) - stim_spike(1+length(stim_spike)-b:end);
end

%% Plotting

% Timecourse with subplots for VBG, Ibias and rules
% Need change axis limits and values for gamma accuracy box on Ibias plot
% inside function, if looking at different frequencies.
% plot_voltage_ibias_learning_time_course(t,U,S,iext,rule1,rule2)

% Function plots voltage trace
plot_voltage_time_course(t,U,S)

% Function plots bias current, timing error and learning rule updates
% Current settings: displays first 10 seconds of data, ibias y-axis limits
% set for 2 Hz
plot_ibias_learning_time_course(t,iext,stim_spike-1000,diff,rule1,rule2)

% Histogram of spike timing differences
figure('Name','Spike Timing Diffs')
clf
hold on
a = diff>500/freq;
diff(a) = diff(a)-1000/freq;
histogram(diff,35,'Normalization','probability','FaceColor','r')
% x = [-200:.2:200];
% plot(x,normpdf(x,mean(diff),std(diff)))
title('Spike Timing Difference Distribution')
print



% Histogram of BG periods
figure('Name','BG spike periods')
hold on
histogram(BG_spike(2:end)-BG_spike(1:end-1),30,'Normalization','probability','FaceColor','r')
print
mean(BG_spike(2:end)-BG_spike(1:end-1))
std(BG_spike(2:end)-BG_spike(1:end-1))

%% Save data

% Saves variables at every stimulus onset if IC save flag equal to 1
if svflagICs ==1
    x = linspace(1000/(freq*dt), length(t),length(t)/1000*dt*(freq));
    U0 = U(:,ceil(x));
    iext0 = iext(:,ceil(x));
    BGcount0 = BGcount(:,ceil(x));
    Scount0 = Scount(:,ceil(x));
    BG_C0 = BG_C(:,ceil(x));
    stim_C0 = stim_C(:,ceil(x));
    save(['Initial-conditions/',num2str(freq),'Hz_synced_inits_deltaT_',num2str(delta1),'_delta_phi_',num2str(delta2),'.mat'],'U0','iext0','BGcount0','Scount0','BG_C0','stim_C0');
end

% Saves spike time differences (BG vs stim) if Err save flag equal to 1
if svflagErrs == 1
    save(['Error-distributions/',num2str(freq),'Hz_error_dist_deltaT_',num2str(delta1),'_delta_phi_',num2str(delta2),'.mat'],'BG_spike','stim_spike','diff')
end