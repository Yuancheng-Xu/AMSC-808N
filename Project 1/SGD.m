function [w,f,normgrad,toctime] = SGD(fun,gfun,Y,w,batchsize,step_strategy,kmax)
%% Stochastic Gradient Descent 
% step_strategy is "fixed" or "decreasing" (1/k)
% w variable, initial guess; Y is parameter specific to exercise 2
% f, normgrad is history of f value and grad f
TOL = 1e-5; % stop criterion for norm of grad
% TOL = -1; % this is only for tracking run time; always run kmax iterations
n = size(Y,1); % data size
bsz = min(n,batchsize); % batch size
% kmax = 1e5; % number of iterations
I = 1:n;
f = zeros(kmax,1); % save f values
normgrad = zeros(kmax,1); % save norm of grad f
toctime = zeros(kmax,1); % save run time 

tic;
for k = 1 : kmax
    Ig = randperm(n,bsz); % batch index 
    % obtain direction
    p = - gfun(Ig,Y,w);
    p_tmp = gfun(I,Y,w);
    normgrad(k) = norm(p_tmp);
    
    % obtain step size
    if strcmp(step_strategy,'fixed')
        step_size = 0.1;
    elseif strcmp(step_strategy,'decreasing')
        step_size = 0.1 * 1000/(1000+k);
    else 
        error('SGD step strategy not available\n')
    end
    
    w = w + step_size * p;
    f(k) = fun(I,Y,w); % save f
    
    if normgrad(k) < TOL
        f(k+1:end) = [];
        normgrad(k+1:end) = [];
        fprintf('SGD: A local solution is found, iter = %d, with grad norm = %d\n',k, norm(p));
        return;
    end
    toctime(k) = toc;
end
fprintf('SGD: failed to find a local solution, with grad norm = %d\n', norm(p));
end
