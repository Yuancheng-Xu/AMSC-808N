function P4_LDA_chi2()
%% Text categorization by feature selection + LDA
% first use Univariate feature ranking for classification using 
% chi-square tests to select features (words)
% Then apply linear discriminant analsis to find projection with maximal
% seperability; here the projection is one-dimensional since only 2 classes
%% read dara
clear; clc; close all;
[M,y] = readdata();
% this is the dictionary of all words
dictionary = load('dictionary.mat').dictionary;
%% Feature selection
idx = fscchi2(M,y); % rank feature importance
k = 10; % select k most important words
dictionary(idx(1:k),:) % print these words
M_sub = M(:,idx(1:k));

%% Linear Discriminant Analysis (LDA)
w = LDA(M_sub,y);
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
