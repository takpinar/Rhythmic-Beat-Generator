function y = taur(v,vi,ki,thmax)
% r time constant

y=thmax./cosh( (v - vi) ./ (2 * ki) );

end
