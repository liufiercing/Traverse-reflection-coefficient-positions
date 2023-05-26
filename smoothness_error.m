function [error, A1, A2] = smoothness_error(seis, t1, t2, WW, T1, T2)
    ref_err = zeros(size(seis));
    if nargin == 6  %%��֪ǿ��
        ref_err(T1) = 0.5;
        ref_err(T2) = -0.5;
    end
    error = 1000;
    %% ���ɨ��
    for a1 = -1:0.1:1
        for a2 = -1:0.1:1
            ref_err(t1) = a1;
            ref_err(t2) = a2;
            seis_err = WW*ref_err;
            err = sum(abs(seis - seis_err));
            if err < error %% �������ʱ
                error = err;
                A1 = a1;
                A2 = a2;
            end
        end
    end
    %% ��С����
    %
    
    
end