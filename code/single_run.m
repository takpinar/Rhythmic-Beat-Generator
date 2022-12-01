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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%sdfsdfsdfsd


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

freq     = 2;  % Stim Frequency
freq1    = 2;
freq2    = 3;
stim_dur = 10; % Stimuli Duration (seconds)

% Conductance Params
gcat  = 11;
gcat1 = 10;
gL    = 1.6;
gh    = 1;
gna   = 0.1;
gei   = 0.5;
gie   = 0.9;

% Reversal Potentials
Eca   = 50;
EL    = -70;
Eh    = -30;
ENa   = 50;
Egaba = -80;
Eampa = 0;

% Gating Dynamics Params
vm     = -40;
km     = 6.5;
vh     = -60;
kh     = 6;
vr     = -70;
kr     = 12;
vrT    = -75;
krT    = 8;
va     = -67;
ka     = 1;
tleft  = 30;
tright = 5;
thmax  = 850;

inpute     = 0;
inputi     = -30;
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

delta1_E = 0.2; % E Cell Period Learning Rate
delta2_E = 2.5; % E Cell Phase Learning Rate

delta1_I = -0.2; % I Cell Period Learning Rate
delta2_I = -2.5; % I Cell Phase Learning Rate

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
% [Ve, he, re, sie,   Vi, hi, ri, sei,   StimV, Stimh, gammaBGinit, gammaSinit]
U0      = [-70,0.85,0.3,0,... % Ve, he, re, sie,
           -66.6,0.85,0.3,0,... % Vi, hi, ri, sei,
           -75,0.9,1.3,1.3]';
iBias_ecell   = 9*ones(1,N);
iBias_icell   = 5*ones(1,N);
BGcount = 1*ones(1,N);  % Number of gamma cycles since last spike
Scount  = 1*ones(1,N);
BG_C    = 10*ones(1,N); % BGcount at current spike
stim_C  = 10*ones(1,N);

%% Setup variables

% Empty vectors for saving spike times
BG_spike   = [];
stim_spike = [];

% Initialise variables of model
BG       = zeros(4,N);
ICell    = zeros(4,N);
stim_sys = zeros(2,N);
gammaBG  = zeros(1,N);
gammaS   = zeros(1,N);

% Set up with initial data
BG(:,1)       = U0(1:4,1);
ICell         = U0(5:8,1);
stim_sys(:,1) = U0(9:10,1);
gammaBG(1)    = U0(11,1);
gammaS(1)     = U0(12,1);

% Initialise vectors to store learning rule updates
rule1_E = zeros(1,N); % E Cell Period Updates
rule2_E = zeros(1,N); % E Cell Phase Updates
rule1_I = zeros(1,N); % I Cell Period Updates
rule2_I = zeros(1,N); % I Cell Phase Updates


% Setup stimulus as vector of ones and zeros
% 1 stimulus on, 0 stimulus off
% On every 1000/freq ms for 3 ms
% S = stim(freq,t);
s1 = stim(freq1,t);
s2 = stim(freq2,t);
S = or(s1,s2);
S(1,stim_dur*10000) = 0;

%% Simulate system

for i = 2:N

    % Display time (see progress)
    if mod(i,100000)==0
        t(i)
    end

    % Evolve equations for BG neuron
    [bgdiffs,icelldiffs] = BG_equations(t(i-1),BG(:,i-1),ICell(:,i-1),inpute,iBias_icell(i-1)+inputi,iBias_ecell(i-1)+iint,...
        vm,vh,vr,vrT,va,km,kh,kr,krT,ka,gcat,...
        gL,gh,gna,Eca,EL,Eh,ENa,phir,phih,...
        thmax,tleft,tright,Egaba,Eampa,gei,gie);


    BG(:,i)    = BG(:,i-1) + dt*bgdiffs;
    ICell(:,i) = ICell(:,i-1) + dt*icelldiffs;

    % Evolve equations for stimulus neuron
%     if i < stim_dur*10000 % duration of stimulus
%         stim_sys(:,i) = stim_sys(:,i-1) + dt*stim_equations(t(i-1),stim_sys(:,i-1),S(i-1),iext1,gcat1,gL,gstim,Eca,EL,phih,vm,km,vh,kh,tileft,tiright)';
%     else
%         stim_sys(:,i) = stim_sys(:,i-1);
%     end

    % Evolve gamma integrators
    gammaBG(i) = gammaBG(i-1)+dt*(-gammaBG(i-1)/taugammaBG);
    gammaS(i)  = gammaS(i-1)+dt*(-gammaS(i-1)/taugammaS);

    % Reset BG gamma integrator when value reaches threshold
    % Add 1 to BG gamma counter
    if gammaBG(i)<1
        BGcount(i:end) = BGcount(i-1) + 1;
        gammaBG(i)     = 2;
    end

    % Reset stimulus gamma integrator when value reaches threshold
    % Add 1 to stimulus gamma counter
    if gammaS(i)<1
        Scount(i:end) = Scount(i-1) + 1;
        gammaS(i)     = 2;
    end

%     % Recognise when BG neuron spikes
    if BG(1,i)>vth && BG(1,i-1)<vth

        % Update BG_C with current BG gamma counter value - number of gamma
        % cycles between this spike and the previous spike
        BG_C(i:end) = BGcount(i);

        % Reset BG gamma counter to zero
        BGcount(i:end) = 0;

        % Apply period rules
        rule1_E(i:end) = delta1_E*(BG_C(i)-stim_C(i));
        iBias_ecell(i:end) = iBias_ecell(i-1)+rule1_E(i);

        rule1_I(i:end) = delta1_I*(BG_C(i)-stim_C(i));
        iBias_icell(i:end) = iBias_icell(i-1)+rule1_I(i);

        % Save spike time
        if t(i)>20
            BG_spike = [BG_spike,t(i)];
        end

    end
% 
%     % Recognise when stimulus neuron spikes
    if S(1,i)~=0 && S(1,i-1)==0

        % Update stim_C with current stimulus gamma counter value - number
        % of gamma cycles between this spike and the previous spike
        stim_C(i:end) = Scount(i);

        % Reset stimulus gamma counter to zero
        Scount(i:end) = 0;

        % Apply phase rule
        rule2_E(i:end) = delta2_E*(sign(BGcount(i)-stim_C(i)/2-0.001)*(BGcount(i)*abs(stim_C(i)-BGcount(i)))/stim_C(i)^2);
        iBias_ecell(i:end) = iBias_ecell(i-1) + rule2_E(i);

        % Save spike time
        if t(i)>20
            stim_spike = [stim_spike,t(i)];
        end
% 
    end

end


% Combine variables into single vector
U = [BG;stim_sys;gammaBG;gammaS;ICell];

% Convert to seconds
t = t/1000;

% Compute difference between BG spike time and stimulus spike time at each
% stimuls spike
if length(BG_spike) == length(stim_spike)
    diff = BG_spike - stim_spike;
else
    b    = min(length(BG_spike),length(stim_spike));
    diff = BG_spike(1+length(BG_spike)-b:end) - stim_spike(1+length(stim_spike)-b:end);
end

%% Plotting

% Timecourse with subplots for VBG, Ibias and rules
% Need change axis limits and values for gamma accuracy box on Ibias plot
% inside function, if looking at different frequencies.
% plot_voltage_ibias_learning_time_course(t,U,S,iext,rule1,rule2)

% Function plots voltage trace
% plot_voltage_time_course(t,U,S)

% Function plots bias current, timing error and learning rule updates
% Current settings: displays first 10 seconds of data, ibias y-axis limits
% set for 2 Hz
plot_excitatory_ibias_learning_time_course(t,iBias_ecell,stim_spike-1000,diff,rule1_E,rule2_E)
% plot_inhibitory_ibias_learning_time_course(t,iBias_icell,stim_spike-1000,diff,rule1_I,rule2_I)

% Histogram of spike timing differences
% figure('Name','Spike Timing Diffs')
% clf
% 
% hold on
% a       = diff>500/freq;
% diff(a) = diff(a)-1000/freq;
% mn = mean(diff);
% stdev = std(diff);
% H=histogram(diff,50,'Normalization','probability','FaceColor','r');
% mxy = max(H.Values) + 0.01;
% fill([mn-stdev mn+stdev mn+stdev mn-stdev],[0 0 mxy mxy],'red','LineStyle','none','FaceAlpha',0.2);
% plot([mn mn],[0 mxy],'Color',[0.5 0.5 0.5])
% axis([mn-4*stdev mn+4*stdev 0 mxy])
% title('Spike Timing Difference Distribution')
% mnstr = sprintf('Mean = %.1f',mn);
% stdstr = sprintf('STD = %.1f',stdev);
% annotation('textbox',[.77 .8 .21 .1], 'String',append(mnstr,newline,stdstr))
% 
% 
% 
% Histogram of BG periods
% figure('Name','BG spike periods')
% hold on
% prds = BG_spike(2:end)-BG_spike(1:end-1);
% mn = mean(prds);
% stdev = std(prds);
% H=histogram(prds,50,'Normalization','probability','FaceColor','r');
% mxy = max(H.Values) + 0.01;
% f=fill([mn-stdev mn+stdev mn+stdev mn-stdev],[0 0 mxy mxy],'red','LineStyle','none','FaceAlpha',0.2);
% axis([mn-4*stdev mn+4*stdev 0 mxy])
% plot([mn mn],[0 mxy],'Color',[0.5 0.5 0.5])
% title('Excitatory Cell Period Distribution')
% mnstr = sprintf('Mean = %.1f',mn);
% stdstr = sprintf('STD = %.1f',stdev);
% annotation('textbox',[.78 .8 .2 .1], 'String',append(mnstr,newline,stdstr))


print


%% Save data

% Saves variables at every stimulus onset if IC save flag equal to 1
if svflagICs ==1
    x        = linspace(1000/(freq*dt), length(t),length(t)/1000*dt*(freq));
    U0       = U(:,ceil(x));
    iext0    = iBias_ecell(:,ceil(x));
    BGcount0 = BGcount(:,ceil(x));
    Scount0  = Scount(:,ceil(x));
    BG_C0    = BG_C(:,ceil(x));
    stim_C0  = stim_C(:,ceil(x));
    save(['Initial-conditions/',num2str(freq),'Hz_synced_inits_deltaT_',num2str(delta1_E),'_delta_phi_',num2str(delta2_E),'.mat'],'U0','iext0','BGcount0','Scount0','BG_C0','stim_C0');
end

% Saves spike time differences (BG vs stim) if Err save flag equal to 1
if svflagErrs == 1
    save(['Error-distributions/',num2str(freq),'Hz_error_dist_deltaT_',num2str(delta1_E),'_delta_phi_',num2str(delta2_E),'.mat'],'BG_spike','stim_spike','diff')
end