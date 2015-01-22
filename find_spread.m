function[change_p] = find_spread(p)

q = 1-p;
s = p^2;
t = q^2;

num = s - (s+t)*p;
denom = 1 -2*t*s;

change_p = (p*num*q)/denom;