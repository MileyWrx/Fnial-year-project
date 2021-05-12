clearvars;clc;close all;
addpath('dace');
fun_name = 'Sasena';
lower_bound = [0,0];
upper_bound = [5,5];

% plot the real function
x1 = linspace(lower_bound(1),upper_bound(1),51);
x2 = linspace(lower_bound(2),upper_bound(2),101);
[x1_mesh,x2_mesh] = meshgrid(x1,x2);

for ii = 1:length(x2)
    for jj = 1:length(x1)
        f_mesh(ii,jj) = feval(fun_name,[x1_mesh(ii,jj),x2_mesh(ii,jj)]);
    end
end

% sampling
 num_sample = 100;
    sample_x = lower_bound + lhsdesign(num_sample,2).*(upper_bound - lower_bound);
    sample_y = feval(fun_name,sample_x);
    % train the GP model
    tic
    GP_model = dacefit(sample_x,sample_y, 'regpoly0', 'corrgauss', [1,1], [0.001,0.001], [1000,1000]);
    toc



% predict
for ii = 1:length(x2)
    for jj = 1:length(x1)
        GP_mesh(ii,jj) = predictor([x1_mesh(ii,jj),x2_mesh(ii,jj)],GP_model);
    end
end




figure;
mesh(x1_mesh,x2_mesh,f_mesh);
hold on;
scatter3(sample_x(:,1),sample_x(:,2),sample_y,'ro','filled')
title('real function')
figure;
mesh(x1_mesh,x2_mesh,GP_mesh);
hold on;
scatter3(sample_x(:,1),sample_x(:,2),sample_y,'ro','filled')
title('GP model')



