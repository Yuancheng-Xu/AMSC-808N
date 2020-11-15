function LLE_dimReduct()
%% data 
close all; clear;clc;
plotdata = true; % whether plot original data
% curve data 
noisestd = 0.2; % noise level for the curve data
data = MakeScurveData(noisestd);
data = data - mean(data,1); % center the data

% Emoji data
% data = load('data/FaceData.mat').data;
% data = data(3:end,:); % remove outlier (the first two rows)

%% Locally Linear Embedding
X = data';
K = 30; % number of neighbors (face data k=100)
d_embed = 2; % embedding dimensionality: 2 or 3
[Y] = lle(X,K,d_embed);
embedding = Y'; % n*d_embed

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
% embedding 2dim
figure;
hold on;
grid;
for i = 1:n
    color_thisrow = colors(i,:);
    plot(embedding(i,1),embedding(i,2),'.','Markersize',20,'Color',color_thisrow);
end
set(gca,'Fontsize',16);
% embedding three dim
% figure;
% hold on;
% grid;
% for i = 1:n
%     color_thisrow = colors(i,:);
%     plot3(embedding(i,1),embedding(i,2),embedding(i,3),'.','Markersize',20,'Color',color_thisrow);
% end
% set(gca,'Fontsize',16);
% view(3);
end
