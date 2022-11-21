function y = Ainf(v,vi,ki)
% Activation, for minf

y=1./(1+exp(-(v-vi)/ki));

end
