function Q1 
%% find the isolated stationary point
clear;clc;close all;
x = (pi/10)*(0:5);
y = 1-cos(x);
x_flip = flip(x);
y_flip = flip(y);

% row n (6>n>=2): when n pts are activated 
% n=0,1 don't care; n=6: take care of seperately
% for example, when n = 3, use x3,x4,x5 to find the trial point 
% and check if a>0 and ax2<b<ax3, if yes, is_stationary = 1
stationary_try_positive_a = zeros(5,2);
is_stationary_postive_a = zeros(5,1);

stationary_try_negative_a = zeros(5,2); 
is_stationary_negative_a = zeros(5,1);
% when n = 3, use x0,x1,x2 to find the trial point
% and check if a<0 and ax3<b<ax2

for n = 2:5
    % positive a, use last n elements of x
    x1 = x_flip(1:n);
    y1 = y_flip(1:n);
    A = [sum(x1.^2),-sum(x1);-sum(x1),n];
    b = [sum(x1.*y1);-sum(y1)];
    tmp = A\b; a=tmp(1);b=tmp(2);
    stationary_try_positive_a(n,:) = [a,b];
    if a>0 & b>x_flip(n+1)*a & b<x_flip(n)*a 
        is_stationary_postive_a(n,1) = 1;
        a_star = a;
        b_star = b;
    end
    
    % negative a, use first n elements of x
    x1 = x(1:n); 
    y1 = y(1:n);
    A = [sum(x1.^2),-sum(x1);-sum(x1),n];
    b = [sum(x1.*y1);-sum(y1)];
    tmp = A\b; a=tmp(1);b=tmp(2);
    stationary_try_negative_a(n,:) = [a,b];
    if a<0 & b>x(n+1)*a & b<x(n)*a 
        is_stationary_negative_a(n,1) = 1;
    end
end
is_stationary_postive_a 
is_stationary_negative_a

% n=6, the case where all pts are activated
% we need b<0 and b<a*x5
A = [sum(x.^2),-sum(x);-sum(x),6];
b = [sum(x.*y);-sum(y)];
tmp = A\b; a=tmp(1); b=tmp(2); % b is positive, not valid!
fprintf('when n=6, the trial solution is [%.3f, %.3f], not valid!\n\n',a,b);
fprintf('The only isolated stationary point is [%.3f, %.3f], with x2345 activated. \n\n',a_star,b_star);
fprintf('The global min is %f\n\n', f(a_star,b_star));

end