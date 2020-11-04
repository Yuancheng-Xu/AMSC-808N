function w = LAD(M,y)
%% Linear Discriminant Analysis (two classes)
% M is the input features n*d; y is -1 or 1 class
n = size(M,1);
d = size(M,2); % # of words
index_1 = (y==1); % index of class 1
index_2 = (y==-1); % another class -1
M_1 = M(index_1,:);
M_2 = M(index_2,:);
n_1 = size(M_1,1);
n_2 = size(M_2,1);

% class mean
Mu_1 = mean(M_1)';
Mu_2 = mean(M_2)';

% overal mean
Mu = (Mu_1 + Mu_2)/2; 

% class covariance 
S_1 = cov(M_1);
S_2 = cov(M_2);

% within-class scatter matrix
S_w = S_1 + S_2;

% between class scatter matrix
SB_1 = n_1 * (Mu_1 - Mu) * (Mu_1 - Mu)';
SB_2 = n_2 * (Mu_2 - Mu) * (Mu_2 - Mu)';
SB = SB_1 + SB_2;

%% compute LDA projection!
invSw_by_SB = S_w\SB;
[V,D] = eigs(invSw_by_SB,1); 
w = V; % because only one class
%% visualization
close all
M_new_1 = M_1 * w;
M_new_2 = M_2 * w;
histogram(M_new_1,10,'DisplayName',"Indiana");
hold on;
histogram(M_new_2,10,'DisplayName',"Florida");
legend('show');
xlabel('LDA component');
ylabel('Number of docs');

end