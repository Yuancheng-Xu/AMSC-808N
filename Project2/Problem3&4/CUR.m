function [C,U,R,res_CUR,res_SVD] = CUR(M,k,c)
%% CUR decomposition: M = CUR 
% C and R are from the actual rows and columns of M

% run ColumnSelect to choose columns and rows of M 
C = ColumnSelect(M,k,c);
R = ColumnSelect(M',k,c);
R = R'; % Now M = CUR

% compute U such that M = CUR 
% UR = C\M;
% U = (R'\UR')';

UR = pinv(C)*M;
U = (pinv(R')*UR')';

% CUR error
res = M - C*U*R;
res_CUR = norm(res,'fro'); 
svd_M = svd(M);
res_SVD = norm(svd_M(k+1:end),'fro');
fprintf('CUR composition: approximation error in F-norm is %d, and approximation error for k-SVD is %d\n\n',res_CUR,res_SVD);
end

 
function C = ColumnSelect(A,k,c)
%% return C consisting of some columns of A
[U,S,V] = svd(A,'econ');
V_k = V(:,1:k); % trucated V vector
% probability vector ratio (d dimensional, column vector)
p = 1 / k * sum(V_k .^2,2); 
% we want to choose (slightly smaller than) c columns in expecation
% p_tmp is the probabilty vector (possibly have entries >1)
p_tmp = c * p; 
% choose column or not
eta = rand(size(p_tmp)); % uniform (0,1)
C = A(:,(eta<p_tmp));
end