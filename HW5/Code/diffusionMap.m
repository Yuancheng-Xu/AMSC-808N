function diffusionMap()
%% data 
close all; clear;clc;
plotdata = true; % whether plot original data
% curve data 
noisestd = 0.5; % noise level for the curve data
data = MakeScurveData(noisestd);
data = data - mean(data,1); % center the data

% Emoji data
% data = load('data/FaceData.mat').data;
% data = data(3:end,:); % remove outlier (the first two rows)

% parameters for diffusion map
eps_factor = 30; % local scale param factor; eps = eps_factor * something eps = 1000 for face data
alpha = 1; % the "alpha", renormalization param
%% kernel
X = data;
n = size(X,1);
% compute pairwise squared distances ||x_i - x_j||^2
d = zeros(n);
e = ones(n,1);
for i = 1 : n
    d(i,:) = sum((X - e*X(i,:)).^2,2); 
end
% find a good epsilon
d_row_min = zeros(n,1);
for i = 1:n 
    d_row_min(i) = min(d(i,setdiff(1:n,i)));
end
eps = eps_factor * mean(d_row_min);
% compute kernel 
K = exp(-d/eps);
%% compute rwo sum and form the new nomalized kernel
q = sum(K,2); % row sum of K 
K = (diag(q.^(-alpha))) * K * (diag(q.^(-alpha))); % new normalized kernel
q = sum(K,2); % new row sum of K 

P  = (diag(q.^(-1))) * K; % stochastic matrix 

%% compute eigendecomposition
pi = q/sum(q); % invariant measure of P
Pi = diag(pi);
A = (diag(pi.^(0.5))) * P * (diag(pi.^(-0.5))); % a symmetric matrix 
% even though A is already symmetric, it may not due to round off error, 
% so symmetrize it again!
A = 0.5*(A+A'); % now symmetric within machine error; real eigenvalue
[A_V,A_D] = eig(A); 
[lambda_abs,ind] = sort(diag(abs(A_D)),'descend');
A_V = A_V(:,ind); % corresponds to lambda, descending eigenvalues 
A_D = A_D(ind,ind); 
lambda = diag(A_D);
R = (diag(pi.^(-0.5))) * A_V;% right eigenvalues of P 

%% compute diffision map embeddings
% decide t for 2,3 dimensional embedding
delta = 0.2; % acc parameter 
t_2 = ceil(log(delta)/(log(lambda_abs(3))-log(lambda_abs(2))));
t_3 = ceil(log(delta)/(log(lambda_abs(4))-log(lambda_abs(2))));

% compute the complete embedding (but later truncate to 2,3 dimensiona)
R = R(:,2:end);
% the ith row is embedding of ith point;
lambda = lambda(2:end);
embedding_2 = (diag(lambda.^((1-alpha) * t_2)) * R')'; 
embedding_3 = (diag(lambda.^((1-alpha) * t_3)) * R')'; 
embedding_dim2 = embedding_2(:,1:2); % 2-dim embedding 
embedding_dim3 = embedding_3(:,1:3); % 3-dim embedding 

%% plot
% each point has a unique color 
n = size(data,1);
colors = parula(n); % many colors (n * 3, 3 is RGB)
if plotdata == true
    % original data
    figure;
    hold on;
    for i = 1:n
        color_thisrow = colors(i,:);
        plot3(data(i,1),data(i,2),data(i,3),'.','Markersize',20,'Color',color_thisrow);
    end
    daspect([1,2,2]); % axis scale ratio
    set(gca,'fontsize',16);
    view(3);
    grid;
end
% two dim
figure;
hold on;
grid;
for i = 1:n
    color_thisrow = colors(i,:);
    plot(embedding_dim2(i,1),embedding_dim2(i,2),'.','Markersize',20,'Color',color_thisrow);
end
set(gca,'Fontsize',16);
% three dim
figure;
hold on;
grid;
for i = 1:n
    color_thisrow = colors(i,:);
    plot3(embedding_dim3(i,1),embedding_dim3(i,2),embedding_dim3(i,3),'.','Markersize',20,'Color',color_thisrow);
end
set(gca,'Fontsize',16);
view(3);
end