function A = randomGraphGenerator(n,p)
% return adjacency matrix A (diag = 0, symmetric, unweigted)
A = (rand(n)<p);
lower_tri_A = triu(A',1)';
A = lower_tri_A + lower_tri_A';
end