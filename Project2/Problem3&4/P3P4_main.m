function P3P4_main()
%% data preparation
clear; clc; close all
[M,y] = readdata();
% this is the dictionary of all words
dictionary = load('dictionary.mat').dictionary;
%% M = CUR (problem 3)
%% make plot for different (k,a)
relative_res = zeros(8,9); % res_CUR / res_SVD
absolute_res= zeros(8,9); % res_CUR
iter_num = 20;
for iter = 1 : iter_num % run multiple times since CUR is random algorithm
    for a = 1:8
        for k = 1:9 % in fact k is from 2:10, here is only index 
            c = a*(k+1);
            [C,U,R,res_CUR,res_SVD] = CUR(M,k+1,c);
            relative_res(a,k) = relative_res(a,k) + res_CUR / res_SVD;
            absolute_res(a,k) = absolute_res(a,k) + res_CUR;
        end
    end
end
relative_res = relative_res / iter_num; 
absolute_res= absolute_res / iter_num;

fsz = 16;clf;
figure(1);
hold on;
grid;
for k = 1 : 9
    plot((1:8)',relative_res(:,k),'Linewidth',2,'DisplayName',['k = ',num2str(k+1)]);
end
set(gca,'Fontsize',fsz);
legend('show');
xlabel('a','Fontsize',fsz);
ylabel('resCUR / resSVD','Fontsize',fsz);
title('resCUR / resSVD')
filename = 'figs/res_CUR_ratio_res_SVD.png';
saveas(gcf,filename)

figure(2);
hold on;
grid;
for k = 1 : 9
    plot((1:8)',absolute_res(:,k),'Linewidth',2,'DisplayName',['k = ',num2str(k+1)]);
end
set(gca,'Fontsize',fsz);
legend('show');
xlabel('a','Fontsize',fsz);
ylabel('resCUR','Fontsize',fsz);
title('resCUR')
filename = 'figs/res_CUR.png';
saveas(gcf,filename)
%% choose reasonable (k,a) and do CUR
k = 10; % we want CUR have fitting power approximately equal to k rank SVD
a = 8; 
c = a*k; % we select number of col slightly smaller than c in expectation
[C,U,R] = CUR(M,k,c);

%% text categorization (problem 4)
k = 100;
% compute leverage scroes for all columns (words)
[U,S,V] = svd(M,'econ');
V_k = V(:,1:k); % trucated V vector
% probability vector ratio (d dimensional, column vector)
p = 1 / k * sum(V_k .^2,2); 
[p_sort, p_index] = sort(p,'ascend');
words_k = p_index(1:k); %index of words
dictionary(words_k,:) % and they are these words
end

%% utils
function [M,y] = readdata()
%% read data
fid=fopen('vectors.txt','r');
A = fscanf(fid,'%i\n');
% A is a vector. If an entry>100000, that is a document ID while smaller 
% numbers are the actual words (one-hot coding) in that document
ind = find(A>100000); % find entries of A with document IDs
n = length(ind); % the number of documents
la = length(A);
I = 1:la;
II = setdiff(I,ind); % index of words
d = max(A(II)); % the number of words in the dictionary

% construct M: each row is a docoment; each col is a word count
M = zeros(n,d);
y = zeros(n,1); % y = -1 => category 1; y = 1 => category 2 
% define M and y
for j = 1 : n
    i = ind(j); 
    y(j) = A(i+1); 
    if j<n 
        iend = ind(j+1)-1; % end of j-th document
    else
        iend = length(A);
    end
    M(j,A(i+2:2:iend-1)) = A(i+3:2:iend);1;
end
i1 = find(y==-1);
i2 = find(y==1);
ii = find(M>0);
n1 = length(i1);
n2 = length(i2);

fprintf('Class 1: %d items\nClass 2: %d items\n',n1,n2);
fprintf('M is %d-by-%d, fraction of nonzero entries: %d\n\n',n,d,length(ii)/(n*d));
end
