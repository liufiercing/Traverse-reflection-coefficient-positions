function [error, A1, A2] = smoothness_least_squares(seis, t1, t2, WW, T1, T2)
%%%%%%%%%%%%%%%  输入说明  %%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   seis：  一维光滑地震合成数据
%   t1,t2： 猜测解出现的位置
%   WW：    子波矩阵
%   T1,T2： 已知强轴位置 可以不输入
%%%%%%%%%%%%%%%  输出说明  %%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   error：最佳振幅对应的误差
%   A1,A2: 为t1,t2位置对应的振幅
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % 构建参考误差矩阵
    ref_err = zeros(size(seis));
    ref_err(t1) = 1;
    ref_err(t2) = 1;
    if nargin == 6  %%已知强轴
        ref_err(T1) = 0.5;
        ref_err(T2) = -0.5;
    end
    % 构建系数矩阵
    A = WW(:, [t1, t2]);
    % 执行最小二乘法求解
    sol = lsqnonneg(A, abs(seis));
    
    % 获取最优解的振幅值
    A1 = sol(1) * sign(seis(t1));
    A2 = sol(2) * sign(seis(t2));
    
    % 更新ref_err的值
    ref_err(t1) = A1;
    ref_err(t2) = A2;
    
    % 计算最优解对应的误差
    seis_err = WW * ref_err;
    error = sum(abs(seis - seis_err));
end
