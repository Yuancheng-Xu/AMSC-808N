function [W,H,phi_history] = PGD_Lee_Seung(A,W,H,iter_PGD,iter_LS)
%% First PGD then Lee-Seung scheme for NMF
% Nonnegative factorize A = WH, A is n*d, W is n*k, H is k*d; 
% phi_history is history phi = F-norm squared of R = A - WH 
[n,d] = size(A);
k = size(W,2);
phi_history = zeros(iter_PGD+iter_LS,1); % save phi

R = A - W * H;
for iter = 1 : iter_PGD
    % obtain step size
    step_size = 1e-3 * 1000/(1000+k);
    W = subplus(W + step_size * R * H');
    H = subplus(H + step_size * W' * R);
    R = A - W * H;
    
    phi = norm(R,'fro');
    phi_history(iter) = phi;
end

for iter = 1 : iter_LS
    W = (W .* (A * H')) ./ (W * H * H');
    H = (H .* (W' * A)) ./ (W' * W * H);
    R = A - W * H;
    phi = norm(R,'fro');
    phi_history(iter+iter_PGD) = phi;
end

% compute gradient norm for W and H, even though this is not gradient 
% descent or PGD
dw_norm = norm(R*H','fro');
dH_norm = norm(W'*R,'fro');
fprintf('First PGD then Lee-Seung for NMF finished, with norm of residual = %d, grad norm for W and H = %d, %d\n',phi_history(end), dw_norm, dH_norm);



