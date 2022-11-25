function [iext,delT,r] = individual_sims(S,t,freq1,freq2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                       %
% A neuromechanistic model for rhythmic beat generation                 %
% Bose, Byrne, Rinzel (2019)                                            %
%                                                                       %
% DOI : https://doi.org/10.1371/journal.pcbi.1006450                    %
%                                                                       %
% This code simulates a single trial for a given stimulus S             %
% Used by looped_freq_change and looped_phase_shift                     %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('BG-functions/')

%% Parameters an numerics

gcat=11;
gcat1=10;
gL=1.6;
gh=1;
gna=0.1;
Eca=50;
EL=-70;
Eh=-30;
ENa=50;
v1=-40;
k1=6.5;
v2=-60;
k2=6;
v3=-70;
k3=12;
v4=-75;
k4=8;
v5=-67;
k5=1;
tleft=30;
tright=5;
thmax=850;
phir=1;
phih=1;
iext1=-14;
gstim=6;
tileft=20;
tiright=5;
taugamma=40;
vth=-20;
iint=-33;
 
delta1 = 0.2;
delta2 = 2.5;

N = length(t);
dt = max(t)/N;


%% Initial Conditions
% Load initial data from file
init = load(['Initial-conditions/',num2str(freq1),'Hz_synced_inits_deltaT_0.2_delta_phi_2.5.mat']);
r = ceil(rand*length(init.U0));
U0 = init.U0(:,r);
iext = init.iext0(r)*ones(1,N);
BGcount = init.BGcount0(r)*ones(1,N);
Scount = init.Scount0(r)*ones(1,N);
BG_C = init.BG_C0(r)*ones(1,N);
stim_C = init.stim_C0(r)*ones(1,N);

%% Setup variables

% Empty vectors for saving spike times
BG_spike = [];
stim_spike = [];

% Initialise variables of model
BG = zeros(3,N);
stim_sys = zeros(2,N);
gamma = zeros(1,N);

% Set up with initial data
BG(:,1) = U0(1:3,1);
stim_sys(:,1) = U0(4:5,1);
gamma(1) = U0(end,1);


%% Simulate system
for i = 2:N

    % Evolve equations for BG neuron
    BG(:,i) = BG(:,i-1) + dt*BG_equations(t(i-1),BG(:,i-1),0,iext(i-1)+iint,v1,v2,v3,v4,v5,k1,k2,k3,k4,k5,gcat,gL,gh,gna,Eca,EL,Eh,ENa,phir,phih,thmax,tleft,tright);

    % Evolve equations for stimulus neuron
    stim_sys(:,i) = stim_sys(:,i-1) + dt*stim_equations(t(i-1),stim_sys(:,i-1),S(i-1),iext1,gcat1,gL,gstim,Eca,EL,phih,v1,k1,v2,k2,tileft,tiright)';

    % Evolve gamma integrator
    gamma(i) = gamma(i-1)+dt*(-gamma(i-1)/taugamma);

    % Reset gamma integrator when value reaches threshold
    % Add 1 to gamma counters
    if gamma(i)<1
        BGcount(i:end) = BGcount(i-1) + 1;
        Scount(i:end) = Scount(i-1) + 1;
        gamma(i)=2;
    end
    
    % Recognise when BG neuron spikes
    if BG(1,i)>vth && BG(1,i-1)<vth
        
        % Update BG_C with current BG gamma counter value - number of gamma
        % cycles between this spike and the previous spike
        BG_C(i:end) = BGcount(i);
        
        % Reset BG gamma counter to zero
        BGcount(i:end)=0;
        
        % Ignore first spike if occurs at very beginning
        if t(i)>0.1*1000/freq1
            % Apply period rule 
            iext(i:end)=iext(i-1)+delta1*(BG_C(i)-stim_C(i));
            % Save spike time
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
        
        % Ignore first spike if occurs at very beginning
        if t(i)>0.1*1000/freq1
            % Apply phase rule 
            iext(i:end) = iext(i-1) + delta2*(sign(BGcount(i)-stim_C(i)/2-0.001)*(BGcount(i)*abs(stim_C(i)-BGcount(i))))/stim_C(i)^2;
            % Save spike time
            stim_spike = [stim_spike,t(i)];
        end
    end

end

% Compute difference between BG spike time and stimulus spike time at each
% stimuls spike
if length(BG_spike) == length(stim_spike)
    delT = BG_spike - stim_spike;
else
    b = min([length(BG_spike),length(stim_spike)]);
    delT = BG_spike(1+end-b:end) - stim_spike(1+end-b:end);
end


%% Plot voltage timecourse for individual trial
% % Useful for debugging code
% U = [BG;stim_sys;gamma];
% 
% figure
% hold on
% box on
% plot(t,U(1,:),'Color',[1,0.1,0.1], 'LineWidth',2)
% plot(t,5*S(1:length(t))+20,'k','LineWidth',1.5)
    
end





