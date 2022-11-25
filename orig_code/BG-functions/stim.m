function s = stim(freq,t)
% Function for setting up stimulus
% 1 stimulus on, 0 stimulus off
% On every 1000/freq ms for 25 ms

tm = 25 - mod(t,1000/freq);

s = heaviside(tm);

end