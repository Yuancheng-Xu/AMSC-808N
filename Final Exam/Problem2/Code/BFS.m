function d_list = BFS(A,s)
%% Breadth first search, input is an adjacency matrix A, s is the source vertice
% output: d_list: shortest path to s (-1 if not reachable, 0 with itself)
% index of vertex: 1,2,3,...,n

%%% only for testing
% clear;clc
% A = randomGraphGenerator(4,0.6)
% s = 2;
%%% end testing

n = size(A,1);
colors = zeros(n,1); % 0 = white, 1 = Gray, 2 = black
parents = zeros(n,1); % initial parents = 0 (corresponds to nothing)
d_list = zeros(n,1); % distance; 0 means infinity
Q = zeros(n,1); % queue, first in first out; at most n entries
Q_size = 0; % size of Q; the queque is in fact Q(1:Q_ind); empty at first. 

colors(s) = 1;
[Q,Q_size] = add_queue(Q,s,Q_size);

while Q_size > 0 
    u = Q(Q_size); % will explore the neighbors of u
    [Q,Q_size] = inject_queue(Q,Q_size); % inject u
    for v  = 1:n  
        if A(v,u) == 1 
            % v is a neigbor of u
            if colors(v) == 0 
                colors(v) = 1;
                d_list(v) = d_list(u) + 1;
                parents(v) = u;
                [Q,Q_size] = add_queue(Q,v,Q_size); % add v to Q
            end
        end
    end 
    colors(u) = 2;  
end
d_list(d_list == 0) = -1;
d_list(s) = 0;
end

function [Q,Q_size] = add_queue(Q,k,Q_size)
% add k to queue; queue(1) = k and shift others one index rightwards
Q = circshift(Q,1);
Q(1) = k;
Q_size = Q_size + 1;
end

function [Q,Q_size] = inject_queue(Q,Q_size)
Q(Q_size) = 0;
Q_size = Q_size - 1;
end