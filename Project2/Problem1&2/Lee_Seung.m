function [W,H,phi_history] = Lee_Seung(A,W,H,iter_max)
%% (non-stochastic) Lee-Seung scheme for NMF
% Nonnegative factorize A = WH, A is n*d, W is n*k, H is k*d; 
% phi_history is history phi = F-norm squared of R = A - WH 
[n,d] = size(A);
k = size(W,2);
phi_history = zeros(iter_max,1); % save phi

for iter = 1 : iter_max
    W = (W .* (A * H')) ./ (W * H * H');
    H = (H .* (W' * A)) ./ (W' * W * H);

    % the following updates (using both old ones) will diverge! 
%     W_ = (W .* (A * H')) ./ (W * H * H');
%     H_ = (H .* (W' * A)) ./ (W' * W * H);
%     W = W_;
%     H = H_;
    
    R = A - W * H;
    phi = norm(R,'fro');
    phi_history(iter) = phi;
    
end

% compute gradient norm for W and H, even though this is not gradient 
% descent or PGD
dw_norm = norm(R*H','fro');
dH_norm = norm(W'*R,'fro');
fprintf('Lee-Seung for NMF finished, with norm of residual = %d, grad norm for W and H = %d, %d\n',phi_history(iter_max), dw_norm, dH_norm);



