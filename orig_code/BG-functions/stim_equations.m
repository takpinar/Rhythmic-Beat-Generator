function y = stim_equations(t,x,S,iext,gcat,gL,gstim,Eca,EL,phih,v1,k1,v2,k2,tleft,tright)
% Equations descibing the dynamics of the stimulus generator neuron

v = x(1);
h = x(2);

y(1) = iext-gcat*Ainf(v,v1,k1)*h*(v-Eca)-gL*(v-EL) + gstim*S; 
y(2) = phih*(Iinf(v,v2,k2)-h)/tauh(v,v2,k2,tleft,tright);

end