function [w,f,normgrad,toctime] = SINewton(fun,gfun,Hvec,Y,w,batchsize,kmax)
%% subsampled Inexact Newton
% Hvec(x) is Hx; w is initial guess; Y is argument of fun0 in main.m
rho = 0.1; % tolerence of relative error for CG
gam = 0.9; % used for backtracking line search
jmax = ceil(log(1e-14)/log(gam)); % max # of iterations in line search
eta = 0.5; % used for backtracking line search
CGimax = 20; % max number of CG iterations
n = size(Y,1);
bsz = min(n,batchsize); % batch size
% kmax = 1e3;
[n,~] = size(Y);
I = 1:n;
f = zeros(kmax,1); % save f values
normgrad = zeros(kmax,1); % save norm of grad f
toctime = zeros(kmax,1); % save run time 
nfail = 0;
nfailmax = 5*ceil(n/bsz);

tic;
for k = 1 : kmax
    Ig = randperm(n,bsz); % batch index for grad
    IH = randperm(n,bsz); % batch index for Hessian
    Mvec = @(v)Hvec(IH,Y,w,v);
    b = gfun(Ig,Y,w);
    p_tmp = gfun(I,Y,w);
    normgrad(k) = norm(p_tmp);
    s = CG(Mvec,-b,-b,CGimax,rho); % solve Hs = -grad

    % backtracking line search to find step length
    a = 1;
    f0 = fun(Ig,Y,w);
    aux = eta*b'*s;
    for j = 0 : jmax
        wtry = w + a*s;
        f1 = fun(Ig,Y,wtry);
        if f1 < f0 + a*aux
%             fprintf('Linesearch: j = %d, f1 = %d, f0 = %d\n',j,f1,f0);
            break;
        else
            a = a*gam;
        end
    end


    if j < jmax
        w = wtry; % Linesearch succeeds, update w
    else
        nfail = nfail + 1; % Linesearch fails (step length too small), don't update
    end
    f(k) = fun(I,Y,w); % save f
%     fprintf('k = %d, a = %d, f = %d\n',k,a,f(k+1)); % k iteration, a is step length
    if nfail > nfailmax % means linesearch fails, maybe reach optimal point, exit
        f(k+1:end) = [];
        normgrad(k+1:end) = [];
        fprintf('SINewton: A local solution is found, iter = %d, with grad norm = %d\n',k, normgrad(k));
        return;
    end
    toctime(k) = toc;
end
fprintf('SINewton: failed to find a local solution, with grad norm = %d\n', normgrad(length(normgrad)));
end
        
        
    
    
