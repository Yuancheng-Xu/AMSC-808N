function [M,approx_error_history] = NuclearNormCompletion(A,M,iter_max,lam)
%% Nuclear norm trick for Matrix Factorization 
% complete A = M with small nuclear norm; A is observed partially
% Details are in Matrix Completion Bindel's Notes
% approx_error_history is history of F-norm squared of A - M on known
% entries
empty_entries = isnan(A);
nonempty_entries = ~isnan(A);
[n,d] = size(A);
approx_error_history = zeros(iter_max,1); 

A_complete_now = zeros(n,d);
for iter = 1 : iter_max
    % first we complete matrix A with current information M
    A_complete_now(nonempty_entries) = A(nonempty_entries);
    A_complete_now(empty_entries) = M(empty_entries);
    
    % then we do thresholding SVD and obtain the next approxiamted M
    [U,S,V] = svd(A_complete_now);
    S_threshold = subplus(S - lam * eye(n,d));
    M = U * S_threshold * V';
    
    res = A - M; % this inlcude NAN
    approx_error_history(iter) = norm(res(nonempty_entries),'fro');
end
fprintf('Nuclear Norm completion finished, with norm of residual = %d\n', approx_error_history(iter_max));