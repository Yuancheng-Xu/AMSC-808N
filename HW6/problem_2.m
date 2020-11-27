function problem_2()
%%
clear;clc;close all;

k_list = [10,11,12,13]; % use for different n
l_list = zeros(4,1);

for ind = 1:4
    k = k_list(ind);
    n = 2^k;
    z = 8; % approxiamely every point is in the gian component so they are all reachable
    p = z/(n-1);
    A = randomGraphGenerator(n,p);

    r = 100; % randomly choose r points as source and compute shortest length
%     source_list = 1:r; % just use 1,2,...,r
    % or choose random vertices, the results are the same though.
    source_list = 1:n;
    source_list = source_list(randperm(n));
    source_list = source_list(1:r);

    average_distance = zeros(r,1); % save avg distance for each vertex

    for i = 1:r 
        s = source_list(i);
        d_list = BFS(A,s); % -1: not reachable; 0: itself; positive if reachable
        d_list_reachable = d_list(d_list > 0); 
    %     length(d_list_reachable) - n + 1; % should be n-1 if whole graph is connected
        average_distance(i) = mean(d_list_reachable);
    end
    
    l_list(ind) = mean(average_distance);
end
%% theorectical values
l_theory_list = zeros(4,1);
n_list = zeros(4,1);
for ind = 1:4 
    k = k_list(ind);
    n = 2^k;
    l_theory_list(ind) = log(n) / log(z); 
    
    n_list(ind) = n;
end
%% plot
figure;
hold on;
grid;
plot(n_list,l_list,'-o');
plot(n_list,l_theory_list,'-o');
set(gca,'Fontsize',16);
xlabel('n','Fontsize',16);
ylabel('Shortest path length','Fontsize',16);
legend('Simulation','Theory')
end