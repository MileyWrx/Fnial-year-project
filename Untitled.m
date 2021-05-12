clearvars;clc;close all;
format shortG;% 更改输出格式
addpath('dace');
time = zeros([1,10]);
final_min = zeros([1,10]);
% % % MODIFY % % %
fun_name = 'Ackley';
dimension = 50;%Sixhump 2,Sasena 2,Ellipsoid 10,Rosenbrock 20,Ackley 50
lower_bound = -32.768 * ones(1,50);
upper_bound = 32.7688 * ones(1,50);
% % % % % % % % % %
% num_test = 1000;
iterations = 5 * dimension; % 迭代次数
num_initial = 10 * dimension; % 取样数量

for i = 1: 10
    sample_x = lhsdesign(num_initial,dimension).*(upper_bound-lower_bound) + lower_bound; % sample values随机取点
    sample_y = feval(fun_name,sample_x);% real values 算出真实值
    fmin = min(sample_y);%算出真实值的最小值
    % train the model 建立高斯过程模型
    GP_model = dacefit(sample_x,sample_y, 'regpoly0', 'corrgauss', 1 * ones(1,dimension), 0.001 * ones(1,dimension), 1000 * ones(1,dimension));
    tic;
    % Add a new point at each loop and evaluate
    for j = 1:iterations
        new_x = lhsdesign(1,dimension).*(upper_bound - lower_bound);
        % 调用拉丁超立方抽样函数，在每个维度生成1个随机数
        % X=lhsdesign(N,P) generates a latin hypercube sample X containing N values on each of P variables.  
        % For each column, the N values are randomly distributed with one from each interval (0,1/N), (1/N,2/N),
        %  ..., (1-1/N,1), and they are randomly permuted.
        options = optimoptions('ga','Display','off','PopulationSize',50,'MaxGenerations',200);
        % 创建优化选项
        [new_x,max_EI] = ga(@(x)Infill_EI(x,GP_model,fmin),dimension,[],[],[],[],lower_bound,upper_bound,[],[],options);
        % 利用遗传算法求最小值 -> 此时（EI函数的负值最小），EI函数取值为最大值
        % -> EI函数最大值的点是原函数真实值最小的点
        new_y = feval(fun_name,new_x);
        sample_x = [sample_x;new_x];
        sample_y = [sample_y;new_y];
        fmin = min(sample_y); %(calcluate once again) corner case: in case the newly calcluate value is the minimum one
        GP_model = dacefit(sample_x,sample_y, 'regpoly0', 'corrgauss', 1 * ones(1,dimension),0.001 * ones(1,dimension), 1000*ones(1,dimension));
        disp([i,j,fmin])
    end
    time(i) = toc;
    final_min(i) = fmin;
    % disp(time(i)) 
end

avg_time = mean(time(:));
avg_final_min = mean(final_min(:));

disp(fun_name)
disp(final_min);
disp([avg_time, avg_final_min]);

% 生成第101个点 最大化期望提高函数（看文献 参考表达式 参考Matlab帮助文档->遗传算法
% 用6个函数分别计算第101个点的真实值