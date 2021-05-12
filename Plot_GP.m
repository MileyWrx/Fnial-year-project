% plot GP model on one-dimensional function
addpath('dace')
clearvars;clc;close all;
% plot real function
plot_x = linspace(0,1,1001)';
plot_y = feval('Forrester',plot_x);
% training points
sample_x = linspace(0,1,4)';
sample_y = feval('Forrester',sample_x);
% train GP model
GP_model = dacefit(sample_x,sample_y,'regpoly0','corrgauss',1,0.01,10);
% Kriging prediction and error
[predict_u,predict_s] = predictor(plot_x, GP_model);
% plot
figure;
plot(plot_x,plot_y,'LineWidth',1);
xlabel('x');ylabel('y');
hold on;
plot(plot_x,predict_u,'--','LineWidth',1);
scatter(sample_x,sample_y,'ko','filled');
lower_bound = predict_u - predict_s;
upper_bound = predict_u + predict_s;
h=fill([plot_x',fliplr(plot_x')],[lower_bound',fliplr(upper_bound')],'b');
set(h,'edgealpha',0,'facealpha',0.2); 