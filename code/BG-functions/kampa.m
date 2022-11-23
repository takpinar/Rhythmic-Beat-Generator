function y = kampa(v)
% Opening Rate of AMPA synapse
y = 5*(1+tanh(v/4));
end