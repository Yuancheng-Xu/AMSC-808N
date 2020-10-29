function P3P4_main()
%% data preparation
clear; clc; close all
M = readdata();

%% M = CUR (problem 3)
k = 4; % we want CUR have fitting power approximately equal to k rank SVD
a = 5; 
c = a*k; % we select number of col slightly smaller than c in expectation
[C,U,R] = CUR(M,k,c);

%% text categorization (problem 4)
end

%% utils
function M = readdata()
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
    M(j,A(i+2:2:iend-1)) = 1; A(i+3:2:iend);
end
i1 = find(y==-1);
i2 = find(y==1);
ii = find(M>0);
n1 = length(i1);
n2 = length(i2);

fprintf('Class 1: %d items\nClass 2: %d items\n',n1,n2);
fprintf('M is %d-by-%d, fraction of nonzero entries: %d\n\n',n,d,length(ii)/(n*d));
end
