clearvars;clc;close all;
format shortG;% 更改输出格式
addpath('dace');
time = zeros([1,10]);
final_min = zeros([1,10]);
% % % % MODIFY % % %
fun_name = 'Sixhump';
dimension = 2;% Sixhump 2,Sasena 2,Ellipsoid 5,Rosenbrock 20,Ackley 20
lower_bound = -2 * ones(1,dimension);
upper_bound = 2 * ones(1,dimension);
% % % % % % % % % % %
% num_initial = 10 * dimension; % 取样数量
iterations = 20; % 迭代次数
fmin_record = zeros(iterations+1,10);

for q = [1,2,4,8] % Experiments: setting number of points in one batch 1 2 4 8
% q = 8;
load(strcat(fun_name,'_initial.mat'));% Reading generated file
for i = 1: 10
    sample_x = initial_x(:,:,i); % sample values随机取点
    sample_y = feval(fun_name,sample_x);% real values 算出真实值
    fmin = min(sample_y);%算出真实值的最小值
    fmin_record(1,i) = fmin;
    % train the model 建立高斯过程模型
    GP_model = dacefit(sample_x,sample_y, 'regpoly0', 'corrgauss', 1 * ones(1,dimension), 0.001 * ones(1,dimension), 1000 * ones(1,dimension));
    
    tic;
    for j = 1:iterations
        predict_y = zeros(q,1);% 用于存储每次迭代的几个预测值
        new_x = zeros(q,dimension);
        
        for k = 1:q
            options = optimoptions('ga','Display','off','PopulationSize',50,'MaxGenerations',200);
            [new_x(k,:),max_EI] = ga(@(x)Infill_EI(x,GP_model,fmin),dimension,[],[],[],[],lower_bound,upper_bound,[],[],options);
            % 将预测值加入矩阵 用预测值更新高斯过程模型 fmin fmax fmean
            % predict_y(k) = predictor(new_x(k,:), GP_model);
            % 用样本点的均值更新高斯过程
            % predict_y(k) = mean(sample_y);
            % 用样本点的最小值更新高斯过程
            predict_y(k) = min(sample_y);
             % 用样本点的最大值更新高斯过程
            predict_y(k) = max(sample_y);
            temp_x = [sample_x;new_x(1:k,:)];
            temp_y = [sample_y;predict_y(1:k)];
            % 避免重复取点
            [unique_temp_x,index] = unique(temp_x,'rows');
            unique_temp_y = temp_y(index);
            GP_model = dacefit(unique_temp_x,unique_temp_y, 'regpoly0', 'corrgauss', GP_model.theta);
            % 保留原有高斯过程模型的超参数 因为新加入的点不是真实值 而是高斯过程模型的预测值
        end
        %disp(predict_y)
        new_y = feval(fun_name,new_x); % 并行计算q个x的真实值
        sample_x = [sample_x;new_x];
        sample_y = [sample_y;new_y]; % 加入sample_y
        fmin = min(sample_y);
        fmin_record(j+1,i) = fmin;
        [unique_sample_x,index] = unique(sample_x,'rows');
        unique_sample_y = sample_y(index);
        GP_model = dacefit(unique_sample_x,unique_sample_y, 'regpoly0', 'corrgauss', 1 * ones(1,dimension),0.001 * ones(1,dimension), 1000*ones(1,dimension));
        fprintf('q:%d, run:%d, iteration:%d, fmin: %0.4f\n',q,i,j,fmin);
    end
    time(i) = toc;
    final_min(i) = fmin;
    % disp(time(i))
end

save(strcat(fun_name,'_max_q',num2str(q),'.mat'),'fmin_record')

end
%
avg_time = mean(time(:));
avg_final_min = mean(final_min(:));
%
% disp(fun_name)
% disp(final_min);
disp([avg_final_min,avg_time]);

