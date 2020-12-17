function Q2 
clear;clc;close all;
a = 2.2 ; % alpha
G0 = @(x)polylog(a,x)/polylog(a,1);
G1 = @(x)polylog(a-1,x)./(x*polylog(a-1,1));
%% a 
u = fzero(@(x)G1(x)-x,0.3)
S = 1 - G0(u)

%% b
T = 0.4;
u = fzero(@(x)G1(1-T+T*x)-x,0.3)
S = 1 - G0(1-T+T*u)

%% c
% kappa = polylog(a-2,1)/polylog(a-1,1) % this will be infinity
% T_c = 1/(kappa - 1)
% v_c = 1 - T_c/T


end