function data = MakeScurveData(noisestd)
% close all; clear; clc; 
tt = [-1:0.1:0.5]*pi; uu = tt(end:-1:1); hh = [0:0.1:1]*5;
xx = [cos(tt) -cos(uu)]'*ones(size(hh));
yy = ones(size([tt uu]))'*hh;
zz = [sin(tt) 2-sin(uu)]'*ones(size(hh));
cc = [tt uu]' * ones(size(hh));
data = [xx(:),yy(:),zz(:)];
data = data + noisestd * randn(size(data)); % add noise
% figure;
% hold on;
% plot3(xx(:),yy(:),zz(:),'.','Markersize',20);
% daspect([1,1,1]);
% set(gca,'fontsize',16);
% view(3);
% grid
% save('data/ScurveData.mat','data');
end
 
  
