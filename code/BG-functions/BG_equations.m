function y = BG_equations(t,x,input,iext,v1,v2,v3,v4,v5,k1,k2,k3,k4,k5,gcat,gL,gh,gna,Eca,EL,Eh,ENa,phir,phih,thmax,tleft,tright)
% Equations descibing the dynamics of the beat generator neuron

v = x(1);
h = x(2);
r = x(3);


dvdt=iext-gcat*Ainf(v,v1,k1)*h*(v-Eca)-gL*(v-EL)-gh*r*(v-Eh)-gna*Ainf(v,v5,k5).*(v-ENa)+input;
dhdt=phir*(Iinf(v,v2,k2)-h)/tauh(v,v2,k2,tleft,tright);
drdt=phih*(Iinf(v,v3,k3)-r)/taur(v,v4,k4,thmax);


y = [dvdt;dhdt;drdt];

end
