function y = kgaba(v)
% Opening Rate of GABA synapse
y = 2*(1+tanh(v/4));
end