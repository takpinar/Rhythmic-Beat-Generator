function [y,z] = BG_equations(t,x,inpute,iBias,vm,vh,vr,vrT,va,km,kh,kr,krT,ka,gcat,gL,gh,gna,Eca,EL,Eh,ENa,phir,phih,thmax,tleft,tright)
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

% Evolve E cell vars
dvedt  = iBias - gcat*Ainf(Ve,vm,km)*he*(Ve-Eca) - gL*(Ve-EL) - gh*re*(Ve-Eh) - gna*Ainf(Ve,va,ka).*(Ve-ENa) - gie*sie*(Ve-Egaba) + inpute;
dhedt  = phir*(Iinf(Ve,vh,kh)-he)/tauh(Ve,vh,kh,tleft,tright);
dredt  = phih*(Iinf(Ve,vr,kr)-re)/taur(Ve,vrT,krT,thmax);
dsiedt = kgaba(vi)*(1-sie)-sie/tau_gaba;

% Evolve I cell vars
dvidt  = inputi - gcat*Ainf(Vi,vm,km)*hi*(Vi-Eca) - gL*(Vi-EL) - gh*ri*(Vi-Eh) - gna*Ainf(Vi,va,ka).*(Vi-Ena) - gei*sei*(Vi-Eampa);
dhidt  = (Iinf(Vi,vh,kh)-hi)/tauh(Vivh,kh,tleft,tright);
dridt  = (Iinf(Vi,vr,kr)-ri)/taur(Vi,vrT,krT,thmax);
dseidt = kampa(ve)*(1-sei)-sei/tau_ampa;


y = [dvedt;dhedt;dredt;dsiedt]; z = [dvidt;dhidt;dridt;dseidt];

end