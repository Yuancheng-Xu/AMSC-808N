function PCA_dimReduct()
%% data 
close all; clear;clc;
plotdata = true; % whether plot original data
% curve data 
% noisestd = 0.2; % noise level for the curve data
% data = MakeScurveData(noisestd);
% data = data - mean(data,1); % center the data

% Emoji data
% data = load('data/FaceData.mat').data;
% data = data(3:end,:); % remove outlier (the first two rows)
%% PCA
coeff = pca(data);
PC = data * coeff; 
PC1 = PC(:,1);
PC2 = PC(:,2);
PC3 = PC(:,3);

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
% two dim
figure;
hold on;
grid;
for i = 1:n
    color_thisrow = colors(i,:);
    plot(PC1(i),PC2(i),'.','Markersize',20,'Color',color_thisrow);
end
set(gca,'Fontsize',16);
xlabel('PC1','Fontsize',16);
ylabel('PC2','Fontsize',16);
% three dim
figure;
hold on;
grid;
for i = 1:n
    color_thisrow = colors(i,:);
    plot3(PC1(i),PC2(i),PC3(i),'.','Markersize',20,'Color',color_thisrow);
end
set(gca,'Fontsize',16);
xlabel('PC1','Fontsize',16);
ylabel('PC2','Fontsize',16);
zlabel('PC3','Fontsize',16);
view(3);
end
