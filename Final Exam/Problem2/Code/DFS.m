function size_components = DFS(A)
%% depth first search, input is an adjacency matrix A
% return the sizes of all components
%%% only for testing
% clear;clc
% A = randomGraphGenerator(10,0.2);
%%% end testing

% 0 = white, 1 = Gray, 2 = black
% index of vertex: 1,2,3,...,n
n = size(A,1);
colors = zeros(n,1);
parents = zeros(n,1); % initial parents = 0 (corresponds to nothing)
% time stamp u.d and u.f
d_list = zeros(n,1);
f_list = zeros(n,1);

time = 0;

num_components = 0; %including the giant one
size_components = zeros(n,1); % at most n components

for u = 1:n
    if colors(u) == 0
        [time,colors,parents,d_list,f_list] =  DFS_Visit(A,u,time,colors,parents,d_list,f_list);
        num_components = num_components + 1;
        if num_components > 1   % colors should be 0 or 2
            size_components(num_components) = sum(colors)/2 - sum(size_components(1:num_components-1));
        else
            size_components(num_components) = sum(colors)/2;
        end
    end
end
size_components = size_components(1:num_components);
end

function [time,colors,parents,d_list,f_list] =  DFS_Visit(A,u,time,colors,parents,d_list,f_list)
n = size(A,1);
time = time + 1;
d_list(u) = time;
colors(u) = 1;

for v = 1:n 
    if A(v,u) == 1 % w is adjacent to u
        if colors(v) == 0 
            parents(v) = u;
            [time,colors,parents,d_list,f_list] =  DFS_Visit(A,v,time,colors,parents,d_list,f_list); 
        end
    end
end
colors(u) = 2;
time = time + 1;
f_list(u) = time;
end