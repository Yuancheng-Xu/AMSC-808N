function [X,Y,approx_error_history] = LowRankFac_Alter(A,X,Y,iter_max,lam)
%% Alternating Iteration for Matrix Factorization based on Low Rank factorization
% complete A = XY'; A is observed partially
% update X and Y aternatively; when X (Y), update each row by ridghe
% regression; details are in Matrix Completion Bindel's Notes
% approx_error_history is history of F-norm squared of A - XY'
empty_entries = isnan(A);
nonempty_entries = ~isnan(A);
[n,d] = size(A);
k = size(X,2); % rank k approximation; X is n * k; Y is d * k
approx_error_history = zeros(iter_max,1); 

for iter = 1 : iter_max
    % update each row of X, using Ridge Regression
    for row = 1 : n
        % ridge regression with Y_omega and a_omega
        Y_omega = Y(nonempty_entries(row,:),:);
        a_omega = A(row,nonempty_entries(row,:))';
        X_row = (Y_omega' * Y_omega + lam * eye(k,k)) \ (Y_omega' * a_omega);
        X(row,:) = X_row';
    end
    % update each row of Y 
    for row = 1 : d
        X_omega = X(nonempty_entries(:,row),:);
        a_omega = A(nonempty_entries(:,row),row);
        Y_row = (X_omega' * X_omega + lam * eye(k,k)) \ (X_omega' * a_omega);
        Y(row,:) = Y_row';
    end
    % compute residual (of observed part of A)
    res = A - (X * Y'); % this inlcude NAN
    approx_error_history(iter) = norm(res(nonempty_entries),'fro');
end
fprintf('Alternating iteration for low rank factorization finished, with norm of residual = %d\n', approx_error_history(iter_max));