function iteration_vs_alpha
%% gradient decent with constant stepsize; iteration vs alpha
clear;clc;close all;

l = 100;
alpha_list = linspace(0.2,1.31,l);
num_iter_list = zeros(l,1);
tol = 1e-6;
num_iter_max = 1e5;


for i = 1:l 
    a = 1; b = 0; 
    alpha = alpha_list(i);
    grad = gradf(a,b);
    num_iter = 0;
    while norm(grad)>tol 
    if num_iter > num_iter_max
        fprintf('Too many iterations')
        break; 
    end
    a = a - grad(1)*alpha;
    b = b - grad(2)*alpha;
    grad = gradf(a,b);
    num_iter = num_iter + 1;    
    end
    num_iter_list(i,1) = num_iter;
end
 
% plot
plot(alpha_list, num_iter_list);
xlabel('alpha');
ylabel('number of iterations');

alpha_list(num_iter_list == min(num_iter_list))
end