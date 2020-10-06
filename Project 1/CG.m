function x = CG(Mvec,x,b,kmax,rho)
% Congugate gradient for solving Ax = b; Mvec(x) = Ax
r = Mvec(x) - b;
p = -r;k = 0;
rerr = 1; % relative error; rho is the tolerance
normb = norm(b);
while k < kmax &&  rerr > rho
    Ap = Mvec(p);
    a = r'*r/(Ap'*p);
    x = x + a*p;
    rr = r'*r;
    r = r + a*Ap;
    bet = r'*r/rr;
    p = -r + bet*p;
    k = k + 1;
    rerr = norm(r)/normb;
end
end
    