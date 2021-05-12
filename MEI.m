clearvars;clc;close all;
format shortG;% 更改输出格式
addpath('dace');
time = zeros([1,10]);
final_min = zeros([1,10]);
% % % % MODIFY % % %
fun_name = 'Ackley';
dimension = 20;% Sixhump 2,Sasena 2,c 5,Rosenbrock 20,Ackley 20
lower_bound = -32.768 * ones(1,dimension);
upper_bound = 32.768 * ones(1,dimension);
% % % % % % % % % % %

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
            options = optimoptions('ga','Display','off','PopulationSize',50,'MaxGenerations',200);
            [new_x(1,:),max_EI] = ga(@(x)Infill_EI(x,GP_model,fmin),dimension,[],[],[],[],lower_bound,upper_bound,[],[],options);
            add_x = new_x(1,:);
            if q>1
                for k = 2:q
                    [new_x(k,:),max_EI] = ga(@(x)Infill_EI(x,GP_model,fmin),dimension,[],[],[],[],lower_bound,upper_bound,@(x)Distance_Constraint(x,add_x,lower_bound,upper_bound),[],options);
                    add_x = new_x(1:k,:);
                    % 再次调用遗传算法
                    % 检查优化
                    % 所以慢
                end
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
    
    save(strcat(fun_name,'_MEI_0000_q',num2str(q),'.mat'),'fmin_record')
    
end
%
avg_time = mean(time(:));
avg_final_min = mean(final_min(:));
%
% disp(fun_name)
% disp(final_min);
disp([avg_final_min,avg_time]);

