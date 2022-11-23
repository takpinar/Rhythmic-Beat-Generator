function y = BG_equations(t,x,input,iext,vm,vh,vr,vrT,va,km,kh,kr,krT,ka,gcat,gL,gh,gna,Eca,EL,Eh,ENa,phir,phih,thmax,tleft,tright)
% Equations descibing the dynamics of the beat generator netowork

% MAIN BG VARS (excitatory cell)
Ve  = x(1);
he  = x(2);
re  = x(3);
sie = x(4);

% INHIBITORY VARS
Vi  = NaN;
hi  = Nan;
ri  = Nan;
sei = NaN;

% synaptic time constants
tau_ampa = 2;
tau_gaba = 10;


dvdt   = iext - gcat*Ainf(Ve,vm,km)*he*(Ve-Eca) - gL*(Ve-EL) - gh*re*(Ve-Eh) - gna*Ainf(Ve,va,ka).*(Ve-ENa) - gie*sie*(Ve-Egaba) + input;
dhdt   = phir*(Iinf(Ve,vh,kh)-he)/tauh(Ve,vh,kh,tleft,tright);
drdt   = phih*(Iinf(Ve,vr,kr)-re)/taur(Ve,vrT,krT,thmax);
dsiedt = kgaba(vi)*(1-sie)-sie/tau_gaba;





y = [dvdt;dhdt;drdt;dsiedt];

end