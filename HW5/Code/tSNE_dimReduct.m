function tSNE_dimReduct()
%% data 
close all; clear;clc;
plotdata = false; % whether plot original data
% curve data 
% noisestd = 0.2; % noise level for the curve data
% data = MakeScurveData(noisestd);
% data = data - mean(data,1); % center the data

% Emoji data
data = load('data/FaceData.mat').data;
data = data(3:end,:); % remove outlier (the first two rows)

%% t_SNE
Y = tsne(data);

%% plot
% each point has a unique color 
n = size(data,1);
colors = parula(n); % many colors (n * 3, 3 is RGB)
if plotdata == true
    % original data
    figure;
    hold on;
    for i = 1:n
        color_thisrow = colors(i,:);
        plot3(data(i,1),data(i,2),data(i,3),'.','Markersize',20,'Color',color_thisrow);
    end
    daspect([1,2,2]); % axis scale ratio
    set(gca,'fontsize',16);
    view(3);
    grid;
end
% embedding
figure;
hold on;
grid;
for i = 1:n
    color_thisrow = colors(i,:);
    plot(Y(i,1),Y(i,2),'.','Markersize',20,'Color',color_thisrow);
end
set(gca,'Fontsize',16);
end
