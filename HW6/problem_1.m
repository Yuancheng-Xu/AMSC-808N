function problem_1()
%%
clear;clc;close all;

n = 1000;
z_list = [0.2,0.5,0.9,1.05,1.1,1.2,1.3,1.4,1.5,1.6,2,2.5,3,4];
z_list_len = length(z_list);
% by experiments
S_list = zeros(z_list_len,1); % fraction of giant components for each z, if exists
s_list = zeros(z_list_len,1); % avg size of non-giant
% by theory
S_theory_list = zeros(z_list_len,1); % fraction of giant components for each z, if exists
s_theory_list = zeros(z_list_len,1); % avg size of non-giant

r = 100; % for each z, run r random graph

for i = 1:z_list_len
    z = z_list(i)
    p = z/(n-1);
    
    for round = 1:r
        A = randomGraphGenerator(n,p);
        size_components = DFS(A);
        largest_size = max(size_components); % size of giant component if exists
        S = largest_size/n; % giant component fraction
        if z>1
            s = (sum(size_components) - largest_size)/(length(size_components)-1); % avg size of non-giant
        else
            s = mean(size_components);
        end
        
        S_list(i) = S_list(i) + S; 
        s_list(i) = s_list(i) + s;
    end
    S_list(i) = S_list(i)/r;
    s_list(i) = s_list(i)/r;
end
%% theorectical values
for i = 1:z_list_len 
    z = z_list(i);
    S_equation = @(S)1 - exp(-z*S)-S;
    % choose different intialization "init" for different z
    % this is by hand tune; if z<=1.1, init = 0.1 works; if z>=1.11, init = 1
    if z <= 1.1
        init = 0.1;
    else
        % if z>1.11; here I don't use 1.1<z<1.11 
        init = 1;
    end
    S_theory_list(i) = fzero(S_equation,init);
    s_theory_list(i) = 1 / (1-z+z*S_theory_list(i));
end

%% plot
figure;
hold on;
grid;
plot(z_list,S_list,'-o');
plot(z_list,S_theory_list,'-o');
set(gca,'Fontsize',16);
xlabel('Z','Fontsize',16);
ylabel('Giant Component fraction','Fontsize',16);
legend('Simulation','theory')

%%
figure;
hold on;
grid;
plot(z_list,s_list,'-o');
plot(z_list,s_theory_list,'-o');
set(gca,'Fontsize',16);
xlabel('Z','Fontsize',16);
ylabel('Non-gaint component size','Fontsize',16);
legend('Simulation','theory')
end