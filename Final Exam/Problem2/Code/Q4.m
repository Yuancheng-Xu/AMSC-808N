function Q4
clear;clc;close all;
%% fix n, fraction of infecting nodes versus time 
r = 100; % run r times
n = 1e4;

% only plot the case where the starting node is in the giant component
% r_iter = 0;
% figure()
% while r_iter < r
%     [num_infect_once,t,num_infect] = SIR(n);
%     fraction = num_infect_once/n; 
%     if fraction > 0.1 % epidemic occurs, starting pt is in gaint component
%         r_iter = r_iter + 1;
%         plot(1:t, num_infect/n);
%         hold on;
%     end
% end

% plot all the cases (starting pt in or out of the giant component)
num_epid_happen = 0; % num out of r times that starting pt is in the gaint
figure();
for i = 1:r 
    [num_infect_once,t,num_infect] = SIR(n);
    fraction = num_infect_once/n; 
    if fraction > 0.1
        num_epid_happen = num_epid_happen + 1; 
    end
    plot(1:t, num_infect/n);
    hold on;
end

num_epid_happen

xlabel('t');
ylabel('fraction of infecting nodes');
title('fraction of infecting nodes versus time')
hold off;

%% vary n, how duration changes with n
clear;clc;close all;
n_list = [1e2,5e2,1e3,3e3,5e3,7e3,1e4,2e4,3e4];
n_length = length(n_list);
r = 100; % for each n, run r times
t_list = zeros(n_length,r);
for i = 1:n_length 
    n = n_list(i)
    r_iter = 0;
    % only count the case where the starting node is in the giant component
    while r_iter < r
        [num_infect_once,t,num_infect] = SIR(n);
        fraction = num_infect_once/n; 
        if fraction > 0.1 % giant component
            r_iter = r_iter + 1;
            t_list(i,r_iter) = t;
        end
    end
end
t_list_mean = mean(t_list,2);
% plot duration vs n
figure()
plot(n_list, t_list_mean);
xlabel('n');
ylabel('duration');
title('epidemic duration versus n')
% plot duration vs log(n)
figure()
plot(log(n_list), t_list_mean);
xlabel('log(n)');
ylabel('duration');
title('epidemic duration versus log(n)')
end


function [num_infect_once,t,num_infect] = SIR(n)
% return :
% num_infect_once :size of the giant or non-giant component
% t: duration; num_infect: number of infecting nodes at each time step

% the epidemic graph G_T
a = 2.2; T = 0.4; 
[G,edges,K,p] = MakePowerLawRandomGraph(n,a); % original graph
% construct G_T by keeping an edge with probability T
E = length(edges);
G_T = zeros(n);
for e = 1:E 
    if rand()<T
        G_T(edges(e,1),edges(e,2)) = 1;
        G_T(edges(e,2),edges(e,1)) = 1;
    end
end

% only for testing; a simple graph
% clear;clc;
% edges = [1,2;1,3;2,4;2,5;3,5;5,6];
% E = length(edges);
% G_T = zeros(7);
% for e = 1:E 
%     G_T(edges(e,1),edges(e,2)) = 1;
%     G_T(edges(e,2),edges(e,1)) = 1;
% end
% n =7;

% disease process
t = 1; % time
infect_duration = zeros(n,1); % the duration of infection, <=1
infect_duration(1,1) = 1; % assume the 1st node is infected at current time 1
num_infect = -ones(n,1); % number of infecting nodes versus time
num_infect(t,1) = sum(infect_duration>0);
infect_once = zeros(n,1); % if once infected, 1; otherwise, 0
infect_once(1,1) = 1;
node_ind = 1:n;

while num_infect(t,1)>0 
    
    t = t + 1;
    infect_duration(infect_duration==2) = 0; % recover (or removed)
    infect_duration(infect_duration==1) = 2; % remain infecting
    
    % for each current infected nodes, infect its neighbors that have never 
    % been infected before
    infected_node_now = node_ind(infect_duration==2);
    for node = infected_node_now 
        for j = node_ind 
            if G_T(node,j) == 1 & infect_once(j,1) ==0
                infect_duration(j,1) = 1; % infect j
                infect_once(j,1) = 1;
            end
        end
    end
    num_infect(t,1) = sum(infect_duration>0);
end

num_infect = num_infect(num_infect>=0);
% the number of nodes that have been infected once
num_infect_once = sum(infect_once>0);

end