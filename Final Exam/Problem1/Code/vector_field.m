function vector_field()
%%
clear;clc;close all;
a_num = 10;
b_num = 10;
[A,B] = meshgrid(linspace(0,1.2,a_num),linspace(-0.3,1,b_num));
U = zeros(a_num,b_num);
V = zeros(a_num,b_num);
for i = 1:a_num
    for j = 1:b_num
        grad = gradf(A(i,j),B(i,j));
        U(i,j) = grad(1);
        V(i,j) = grad(2); 
    end
end

quiver(A,B,-U,-V,'r')
hold on;

[a_star, b_star] = star();
plot(a_star, b_star, 'gs', 'LineWidth', 2, 'MarkerSize', 10); % minimizer
plot(1, 0, 'bs', 'LineWidth', 2, 'MarkerSize', 10);
% plot(3.18, 4, 'ks', 'LineWidth', 2, 'MarkerSize', 10); % starting pt of the grad=0 line
legend('GD','Minimizer','Initial Point')
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