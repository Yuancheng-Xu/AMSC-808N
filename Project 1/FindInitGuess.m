%% find a feasible point for Aw >= b 
% if output l > 0, fail to find a feasible point
function [w,l,lcomp] = FindInitGuess(w,A,b)
relu = @(x)max(x,0); 
drelu = @(x)ones(size(x)).*sign(relu(x));
l = sum(relu(b - A*w));
iter = 0;
itermax = 10000;
step = 0.1;
while l > 0 && iter < itermax
df = sum(-drelu(b - A*w)'*A,1)';
if norm(df) > 1 
    df = df/norm(df); 
end
w = w - step*df;
l = sum(relu(b - A*w));
iter = iter + 1;
end
if l == 0
    fprintf('succeed to find a feasible point, %d iterations: l = %d\n',iter,l);
else
    fprintf('fail to find a feasible point, %d iterations: l = %d\n',iter,l)
end
lcomp = relu(b - A*w); 
end