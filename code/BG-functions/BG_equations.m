function [y,z] = BG_equations(~,bg,icell,inpute,inputi,iBias,vm,vh,vr,vrT,va,km,kh,kr,krT,ka,gcat,gL,gh,gna,Eca,EL,Eh,ENa,phir,phih,thmax,tleft,tright,Egaba,Eampa,gei,gie)
% Equations descibing the dynamics of the beat generator network

% BG VARS (e cell)
Ve  = bg(1);
he  = bg(2);
re  = bg(3);
sie = bg(4);

% INHIBITORY VARS (i cell)
Vi  = icell(1);
hi  = icell(2);
ri  = icell(3);
sei = icell(4);

% synaptic time constants
tau_ampa = 20;
tau_gaba = 300;

% Evolve E cell vars
dvedt  = iBias - gcat*Ainf(Ve,vm,km)*he*(Ve-Eca) - gL*(Ve-EL) - gh*re*(Ve-Eh) - gna*Ainf(Ve,va,ka).*(Ve-ENa) - gie*sie*(Ve-Egaba) + inpute;
dhedt  = phir*(Iinf(Ve,vh,kh)-he)/tauh(Ve,vh,kh,tleft,tright);
dredt  = phih*(Iinf(Ve,vr,kr)-re)/taur(Ve,vrT,krT,thmax);
dsiedt = kgaba(Vi)*(1-sie)-sie/tau_gaba;

% Evolve I cell vars
dvidt  = inputi - gcat*Ainf(Vi,vm,km)*hi*(Vi-Eca) - gL*(Vi-EL) - gh*ri*(Vi-Eh) - gna*Ainf(Vi,va,ka).*(Vi-ENa) - gei*sei*(Vi-Eampa);
dhidt  = (Iinf(Vi,vh,kh)-hi)/tauh(Vi,vh,kh,tleft,tright);
dridt  = (Iinf(Vi,vr,kr)-ri)/taur(Vi,vrT,krT,thmax);
dseidt = kampa(Ve)*(1-sei)-sei/tau_ampa;


y = [dvedt;dhedt;dredt;dsiedt]; z = [dvidt;dhidt;dridt;dseidt];
end