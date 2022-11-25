function y = Iinf(v,vi,ki)
% Inactivation, for hinf and and rinf

y=1./(1+exp((v-vi)/ki));

end
