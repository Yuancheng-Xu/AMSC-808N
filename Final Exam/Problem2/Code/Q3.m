function Q3 
clc;clear;close all;
%% a
a = 2.2; n = 1e4;
r = 100; 
S_list = zeros(r,1);
for i = 1:r
    [G,edges,K,p] = MakePowerLawRandomGraph(n,a); % original graph
    G = full(G); % this will make my DFS much faster! sparse matrix is slow
    size_components = DFS(G);
    largest_size = max(size_components); % size of giant component if exists
    S_list(i,1) = largest_size/n; % giant component fraction
end
S = mean(S_list)

%% b 
a = 2.2; T = 0.4; n = 1e4;
r = 100; 
S_T_list = zeros(r,1);
for i = 1:r
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
    
    size_components = DFS(G_T);
    largest_size = max(size_components); % size of giant component if exists
    S_T_list(i,1) = largest_size/n; % giant component fraction
end
S_T = mean(S_T_list)

%% c
T_list = [(1:14)/100,(15:3:100)/100];
T_list_len = length(T_list);
r = 20; % run each T for r times
S_T_list = zeros(T_list_len,r);
for i = 1:T_list_len
    T = T_list(i);
    for j = 1:r
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

        size_components = DFS(G_T);
        largest_size = max(size_components); % size of giant component if exists
        S_T_list(i,j) = largest_size/n; % giant component fraction
    end
end
S_T_list_mean = mean(S_T_list,2);
% plot
plot(T_list, S_T_list_mean);
xlabel('T');
ylabel('S');
title('fraction S of giant component versus T')

%% d
v_list = [(1:8:90)/100,(91:100)/100];
v_list_len = length(v_list);
r = 20; % run each T for r times
S_v_list = zeros(v_list_len,r);
T = 0.4;
for i = 1:v_list_len
    v = v_list(i);
    for j = 1:r
        [G,edges,K,p] = MakePowerLawRandomGraph(n,a); % original graph
        vaccine = rand(n,1)<v; % 1 if vaccinated; 0 if not. 

        % construct G_T by keeping an edge with probability T
        E = length(edges);
        G_T = zeros(n);
        for e = 1:E 
            % if both of them are not vaccinated
            if vaccine(edges(e,1),1) == 0 & vaccine(edges(e,2),1) == 0
                if rand()<T
                    G_T(edges(e,1),edges(e,2)) = 1;
                    G_T(edges(e,2),edges(e,1)) = 1;
                end
            end
        end

        size_components = DFS(G_T);
        largest_size = max(size_components); % size of giant component if exists
        S_v_list(i,j) = largest_size/n; % giant component fraction
    end
end
S_v_list_mean = mean(S_v_list,2);
% plot
plot(v_list, S_v_list_mean);
xlabel('v');
ylabel('S');
title('fraction S of giant component versus v')
end