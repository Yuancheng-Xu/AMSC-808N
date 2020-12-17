function Q2 
%% gradient decent with constant stepsize
clear;clc;close all;
% find alpha_star
tmp = gradf(1,0); a=tmp(1); b=tmp(2);
alpha_star = (pi/2)/(pi*a/2-b)

% plot the vector field
vector_field();

% % then plot the trajector on it
tol = 1e-3;
a = 1; b = 0;

% choose alpha
% alpha = alpha_star*0.99; % slightly smaller than alpha_star
alpha = 1.2988;

% plot(a,b,'ko','HandleVisibility','off');
grad = gradf(a,b);
num_iter = 0;
num_iter_max = 1e3;
while norm(grad)>tol 
    if num_iter > num_iter_max
        fprintf('Too many iterations')
        break; 
    end
    a = a - grad(1)*alpha;
    b = b - grad(2)*alpha;
    grad = gradf(a,b);
    % use Breakpoint to see the dynamic of the point!
    plot(a,b,'ko','HandleVisibility','off');
    num_iter = num_iter + 1;
end
num_iter
[a,b];
[a_star, b_star] = star();
end

function [a_star, b_star] = star()
% return the isolated minimizer 
x = (pi/10)*(0:5);
y = 1-cos(x);
x = x(3:6); y = y(3:6);
A = [sum(x.^2),-sum(x);-sum(x),4];
b = [sum(x.*y);-sum(y)];
tmp = A\b;
a_star=tmp(1);b_star=tmp(2);
end