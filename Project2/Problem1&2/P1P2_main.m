function P1P2_main()
%% first do matrix completion; then NMF on completed matrix
% the completed matrix entries should be in [0,5]
clear; clc; close all
%% read data
A = readmatrix('MovieRankings36.csv');
[n,d] = size(A);
%% Matrix Completion (problem 2)

% method 1
% alternating iteration for low rank factorization A = XY'
low_rank = 5; % rank-k approximation
lambda = 4.9;
% initialization; rating is in [0,5] and A is the sum of low_rank rank-1 matrices
X = rand(n,low_rank) * 5 / low_rank; 
Y = rand(d,low_rank) * 5 / low_rank;
[X,Y,approx_error_history] = LowRankFac_Alter(A,X,Y,500,lambda);
A_completed = X * Y';
fprintf('Low rank factorization A = XY'': The completed matrix have %d entries smaller than 0 and %d entries larger than 5\n\n',sum(A_completed < 0,"all"),sum(A_completed > 5,"all") );
% remark: if lam is small, fitting is good, but A_completed may be out of
% [0,5]; if lam is reasonable large, fitting is still good but now
% A_completed is within the range [0,5], which is the most reasonable

% method 2
% Nuclear norm trick: find low-rank M directly by penalizing nuclear norm
M = rand(n,d) * 5;
[M,approx_error_history] = NuclearNormCompletion(A,M,500,lambda);
fprintf('Nuclear Norm completion: The completed matrix have %d entries smaller than 0 and %d entries larger than 5\n\n',sum(M < 0,"all"),sum(M > 5,"all") );
% A_completed = M;

% do the method 1 and 2 give the same result? yes if lambda is big!
% if lambda is larger than 4.9, the low_rank=5 will be larger than the rank
% of M (because higher lambda suppress the rank of M), so same result!
fprintf('norm of M - X * Y'' = %d\n\n', norm(M-X*Y','fro'))
%% Nonnegative Matrix Factorization (problem 1): A = WH
% factorize A_completed in problem2
low_rank = 5; % rank-k approximation
W = rand(n,low_rank) * 5 / low_rank; % initialization
H = rand(low_rank,d) * 5 / low_rank;

% method 1 
% Projected Gradient Descent
[W,H,phi_history] = PGD(A_completed,W,H,'decreasing',10000);

% remark: grad of H and W need not be zero to be optimal since some entries
% are 0 so they cannot decrease (constrained optimization);
% also it will not recover XY' which can benegative; if set lambda very
% large in problem 1, it will recover the XY'!

% if lambda is big, see if we can recover X and Y' respectively
fprintf('PGD: norm of W-X = %d, norm of H-Y = %d\n\n',norm(W-X,'fro'),norm(H-Y','fro'));
% remark: we find that if lamda is big(100), we can recover WH = XY', H = Y but
% interestly, not W = X 

low_rank = 5; % rank-k approximation
W = rand(n,low_rank) * 5 / low_rank; % initialization
H = rand(low_rank,d) * 5 / low_rank;

% method 2
% Lee_Seung scheme
[W,H,phi_history] = Lee_Seung(A_completed,W,H,1000);

% remark: perform much better than PGD! smaller residual norm and grad norm
% even when lambda in problem is small, residual is small (fit better than
% PGD); of course, when lambda is big, fit error is of machine epsilon.

% if lambda is big, see if we can recover X and Y' respectively
fprintf('Lee-Seung: norm of W-X = %d, norm of H-Y = %d\n\n',norm(W-X,'fro'),norm(H-Y','fro'));

% remark: we find that if lamda is big, we can recover WH = XY', W = X but
% interestly, not H = Y' ,contrary to PGD!
