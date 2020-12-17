function grad = gradf(a,b) 
% return the gradient of f
x = (pi/10)*(0:5);
y = 1-cos(x);

grad_a = 0;
grad_b = 0;
for j = 1:6 
    if a*x(j) > b
        grad_a = grad_a + 2*(a*x(j)-b-y(j))*x(j);
        grad_b = grad_b - 2*(a*x(j)-b-y(j));
    end
end

grad = [grad_a;grad_b]/12;

end