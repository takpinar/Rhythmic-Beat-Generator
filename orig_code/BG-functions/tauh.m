function y = tauh(v,vi,ki,tleft,tright)
% r time constant 

y=tleft*1./(1+exp((v-vi)./ki))+tright*1./(1+exp(-(v-vi)./ki));

end
