function Q3 
%% Stochastic Gradient Descent with batchsize = 1
clear;clc;close all;

kmax = 1e3; 
alpha_0 = 2; 
M = 1000; % parameter for decreasing stepsize

% run SGD (single run, see tranjectories)
% plot the vector field
% vector_field();
% plt = 1;
% [a,b,normgrad,error] = SGD('decreasing',kmax,alpha_0,M,plt);
% hold off; 
%%
% see average error 
r = 1e3;
plt = 0;
final_error_list = -ones(r,1); % save the final error of all runs
running_error = zeros(kmax,1); % save the average error across iterations

for i = 1:r 
    [a,b,normgrad,error] = SGD('decreasing',kmax,alpha_0,M,plt);
    final_error_list(i) = error(end);
    running_error = running_error + error; 
end

figure()
plot(1:kmax, running_error/r);
xlabel('iteration');
ylabel('absolute error');
title('Absolute Error Versus Iteration')

figure()
h = histogram(final_error_list,100)
xlabel('Absolute Error');
title('Histogram of Final Absolute Error')
% p = histcounts(final_error_list,100,'Normalization','pdf');
% figure()
% binCenters = h.BinEdges + (h.BinWidth/2);
% plot(binCenters(1:end-1), p, 'r-')
end

function [a,b,normgrad,error] = SGD(step_strategy,kmax,alpha_0,M,plt)
%% Stochastic Gradient Descent 
% step_strategy is "fixed" or "decreasing" (1/k)
% normgrad is history of true grad f

% Decreasing : alpha_0 * M / (M+k)
% M = 10;

x = (pi/10)*(0:5);
y = 1-cos(x);
a = 1; b = 0; 
n = 6; % data size
I = 1:n;
[a_star, b_star] = star();
normgrad = zeros(kmax,1); % save norm of grad f
error = zeros(kmax,1); % distance between the true global minimizer 

for k = 1 : kmax
    Ig = randi(n);
%     Ig = I; % GD
    % obtain direction
    p = - gradf_stochastic(a,b,Ig);
    p_tmp = gradf(a,b);
    normgrad(k) = norm(p_tmp);
    error(k) = norm(a-a_star,b-b_star);
    
    % obtain step size
    if strcmp(step_strategy,'fixed')
        step_size = alpha_0;
    elseif strcmp(step_strategy,'decreasing')
        step_size = alpha_0 * M/(M+k);
    else 
        error('SGD step strategy not available\n')
    end
    
    a = a + step_size * p(1);
    b = b + step_size * p(2);
    
    if plt == 1
        % use Breakpoint to see the dynamic of the point!
        plot(a,b,'ko','HandleVisibility','off');
    end
end
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