function H = Hessianf(a,b) 
% return the Hessian matrix of f
x = (pi/10)*(0:5);
y = 1-cos(x);

H = zeros(2);
for j = 1:6 
    if a*x(j) > b
        Hj =[x(j)^2,-x(j);-x(j),1]*2;
        H = H + Hj;
    end
end

H = H/12;

end