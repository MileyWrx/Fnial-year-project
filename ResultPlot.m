clearvars;
fun_name = 'Sixhump'; % Sixhump Sasena Ellipsoid Rosenbrock Ackley
% load(strcat(fun_name,'_max_q1.mat'));
% record1 = fmin_record;
% load(strcat(fun_name,'_MEI_q2.mat'));
% record2 = fmin_record;
load(strcat(fun_name,'_MEI_q8.mat'));
record2 = fmin_record;
load(strcat(fun_name,'_MEI_000_q8.mat'));
record3 = fmin_record;
load(strcat(fun_name,'_MEI_0000_q8.mat'));
record4 = fmin_record;

figure;
% plot(0:20,mean(record1,2));hold on;
plot(0:20,mean(record2,2));hold on;
plot(0:20,mean(record3,2));hold on;
plot(0:20,mean(record4,2));
xlabel('iterations')
ylabel('minimum value')
% legend('q=1','q=2','q=4','q=8')
legend('theta=0.001','theta=0.0001','theta=0.00001')
