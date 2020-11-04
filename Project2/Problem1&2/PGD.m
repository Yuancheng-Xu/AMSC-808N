function [W,H,phi_history] = PGD(A,W,H,step_strategy,iter_max)
%% (non-stochastic) Projected Gradient Descent for NMF
% Nonnegative factorize A = WH, A is n*d, W is n*k, H is k*d; 
% phi_history is history phi = F-norm squared of R = A - WH
[n,d] = size(A);
k = size(W,2); 
phi_history = zeros(iter_max,1); % save phi

R = A - W * H;
for iter = 1 : iter_max
    % obtain step size
    if strcmp(step_strategy,'fixed')
        step_size = 1e-3;
    elseif strcmp(step_strategy,'decreasing')
        step_size = 1e-3 * 1000/(1000+k);
    else 
        error('PGD step strategy not available\n')
    end
    
    W = subplus(W + step_size * R * H');
    H = subplus(H + step_size * W' * R);
    R = A - W * H;
    
    phi = norm(R,'fro');
    phi_history(iter) = phi;
end

% compute gradient norm for W and H
dw_norm = norm(R*H','fro');
dH_norm = norm(W'*R,'fro');
fprintf('PGD for NMF finished, with norm of residual = %d, grad norm for W and H = %d, %d\n',phi_history(iter_max), dw_norm, dH_norm);


