function f = f(a,b) 
% return the value of f
x = (pi/10)*(0:5);
y = 1-cos(x);

f = 0;
for j = 1:6 
    if a*x(j) > b
        f = f + (a*x(j)-b-y(j))^2;
    else
        f = f + (y(j))^2;
    end
end

f = f/12;

end