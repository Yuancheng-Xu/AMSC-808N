function grad = gradf_stochastic(a,b,I) 
% return the gradient of f, only using index I of the data point
x = (pi/10)*(0:5);
y = 1-cos(x);

n = length(I);
x = x(I); y = y(I);

grad_a = 0;
grad_b = 0;
for j = 1:n
    if a*x(j) > b
        grad_a = grad_a + 2*(a*x(j)-b-y(j))*x(j);
        grad_b = grad_b - 2*(a*x(j)-b-y(j));
    end
end

grad = [grad_a;grad_b]/12;

end