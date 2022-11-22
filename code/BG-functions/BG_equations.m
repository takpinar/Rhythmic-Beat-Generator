function y = BG_equations(t,x,input,iext,vm,vh,vr,vrT,va,km,kh,kr,krT,ka,gcat,gL,gh,gna,Eca,EL,Eh,ENa,phir,phih,thmax,tleft,tright)
% Equations descibing the dynamics of the beat generator neuron

v = x(1);
h = x(2);
r = x(3);
s = x(4);


dvdt = iext - gcat*Ainf(v,vm,km)*h*(v-Eca) - gL*(v-EL) - gh*r*(v-Eh) - gna*Ainf(v,va,ka).*(v-ENa) - gie*s*(v-Egaba) + input;

dhdt = phir*(Iinf(v,vh,kh)-h)/tauh(v,vh,kh,tleft,tright);

drdt = phih*(Iinf(v,vr,kr)-r)/taur(v,vrT,krT,thmax);

dsdt = 0;


y = [dvdt;dhdt;drdt;dsdt];

end