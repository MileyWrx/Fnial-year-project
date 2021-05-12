clearvars;clc;close all;
format shortG;% 更改输出格式
addpath('dace');
time = zeros([1,10]);
RMSE = zeros([1,10]);
% % % MODIFY % % %
fun_name = 'Ackley';
dimension = 50;%Sixhump 2,Sasena 2,Ellipsoid 10,Rosenbrock 20,Ackley 50
lower_bound = -32.768 * ones(1,50);
upper_bound = 32.768 * ones(1,50);
% % % % % % % % % %
num_test = 1000;
num_initial = 10 * dimension;

for i = 1:10
sample_x = lhsdesign(num_initial,dimension).*(upper_bound-lower_bound) + lower_bound;
% X=lhsdesign(N,P) generates a latin hypercube sample X containing N values on each of P variables.  
% For each column, the N values are randomly distributed with one from each interval (0,1/N), (1/N,2/N),
%  ..., (1-1/N,1), and they are randomly permuted.
% 调用拉丁超立方抽样函数，在每个维度生成num_initial个随机数
sample_y = feval(fun_name,sample_x);% FEVAL is usually used inside functions which take function handles or function strings as arguments.
% train the model
tic
GP_model = dacefit(sample_x,sample_y, 'regpoly0', 'corrgauss', 1 * ones(1,dimension), 0.001 * ones(1,dimension), 1000*ones(1,dimension));
% sample_x，sample_y，趋势函数，相关度，猜想theta = 1,上界，下界
time(i) =toc;
% test samples
test_x = lhsdesign(num_test,dimension).*(upper_bound-lower_bound) + lower_bound;%生成随机数
test_y =  feval(fun_name,test_x);% 实际值
test_prediction = predictor(test_x,GP_model);% 预测值
% RMSE
RMSE(i) = sqrt(sum((test_prediction - test_y).^2)/num_test);% 加.表示点乘，对矩阵中的每个元素进行运算
disp([i,time(i),RMSE(i)])
end
% Calculating avg
avg_time = mean(time(:));
avg_RMSE = mean(RMSE(:));

disp(fun_name)
disp(time);
disp(RMSE);
disp([avg_time, avg_RMSE]);



% 生成第101个点 最大化期望提高函数（看文献
% 用6个函数分别计算第101个点的真实值