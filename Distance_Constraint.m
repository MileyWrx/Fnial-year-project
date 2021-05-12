function [c,ceq] = Distance_Constraint(x,add_x,lower_bound,upper_bound)

epsilon = 0.0001*sqrt(sum((upper_bound - lower_bound).^2)); %上下界欧氏距离的0.01倍（后续可讨论常数
% 0.001 已讨论
% 0.0001
c = epsilon -  min(sqrt(sum((x - add_x).^2,2)));
ceq = [];