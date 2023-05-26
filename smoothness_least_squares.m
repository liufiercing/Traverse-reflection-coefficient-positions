function [error, A1, A2] = smoothness_least_squares(seis, t1, t2, WW, T1, T2)
%%%%%%%%%%%%%%%  ����˵��  %%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   seis��  һά�⻬����ϳ�����
%   t1,t2�� �²����ֵ�λ��
%   WW��    �Ӳ�����
%   T1,T2�� ��֪ǿ��λ�� ���Բ�����
%%%%%%%%%%%%%%%  ���˵��  %%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   error����������Ӧ�����
%   A1,A2: Ϊt1,t2λ�ö�Ӧ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % �����ο�������
    ref_err = zeros(size(seis));
    ref_err(t1) = 1;
    ref_err(t2) = 1;
    if nargin == 6  %%��֪ǿ��
        ref_err(T1) = 0.5;
        ref_err(T2) = -0.5;
    end
    % ����ϵ������
    A = WW(:, [t1, t2]);
    % ִ����С���˷����
    sol = lsqnonneg(A, abs(seis));
    
    % ��ȡ���Ž�����ֵ
    A1 = sol(1) * sign(seis(t1));
    A2 = sol(2) * sign(seis(t2));
    
    % ����ref_err��ֵ
    ref_err(t1) = A1;
    ref_err(t2) = A2;
    
    % �������Ž��Ӧ�����
    seis_err = WW * ref_err;
    error = sum(abs(seis - seis_err));
end
