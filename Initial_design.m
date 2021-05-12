clearvars;clc;close all;
format shortG;% 更改输出格式
addpath('dace');
% % % MODIFY % % %
fun_name = 'Sixhump';
dimension = 2;% Sixhump 2,Sasena 2,Ellipsoid 5,Rosenbrock 20,Ackley 20
lower_bound = -2 * ones(1,dimension);
upper_bound = 2 * ones(1,dimension);
num_initial = 10 * dimension;
initial_x = zeros(num_initial,dimension,10);
for i = 1: 10
    initial_x(:,:,i) = lhsdesign(num_initial,dimension).*(upper_bound-lower_bound) + lower_bound; % sample values随机取点
end
save(strcat(fun_name,'_initial.mat'),'initial_x')