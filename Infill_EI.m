function y= Infill_EI(x,dmodel,fmin)
[y,s] = predictor(x,dmodel); % u预测值，s预测值误差
EI = (fmin - y).*normpdf((fmin-y)./s) + s * normcdf((fmin-y)./s);
y  = -EI;%EI函数求最大值 遗传算法求最小值，将EI函数取负号-->求最小
 