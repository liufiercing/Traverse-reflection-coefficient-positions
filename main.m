%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���Խ����� �⻬���ݲ���
% ���ñ����ķ���Ѱ�ҽ��λ�ã�������С�������Ӧλ�õ������С
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;clear;close all; 
%% ģ������
N = 100;
trace = 1;
ref=zeros(N,trace);
% ǿ��λ��
T1 = 30;
T2 = 45;
% ����λ��
rr1 = 60;
rr2 = 75;
% ��ֵ����
ref(T1,:)=0.5;
ref(T2,:)=-0.5;
ref(rr1,:)=0.2;
ref(rr2,:)=-0.2;
%%
Linewidth = 2;
figure
set (gcf,'position',[0,200,400,680] )
stem(ref,'-r','linewidth',Linewidth)
view(90,90)
%% �����Ӳ�����
dt=0.001; % 1ms
fm=30;   trun_time=0.04;  t=-trun_time:dt:trun_time;
w=(1-2*(pi*fm*t).^2).*exp(-(pi*fm*t).^2);
nWaveSampPoint=length(w);
W_temp=convmtx(w',length(ref(:,1)));  %% ʱ��
WW=W_temp(((nWaveSampPoint-1)/2)+1:end-((nWaveSampPoint-1)/2),:);     % full_freq
%% �ϳ�����
seis=WW*ref;
%%
figure;
set (gcf,'position',[400,200,400,680] )
plot(seis,1:N,  '-r', 'linewidth', Linewidth);
set(gca,'YDir','reverse'); %��x�᷽������Ϊ����(���ϵ��µ���)��
%% �������
error1 = zeros(N,N); error2 = zeros(N,N);
AA1 = zeros(N,N); AA2 = zeros(N,N);
AB1 = zeros(N,N); AB2 = zeros(N,N);
for t1 = 1 : N
    for t2 = 1 : N
        %% ��С���� ���ȸ�
        [error1(t1,t2), AA1(t1, t2), AA2(t1, t2)] = smoothness_least_squares(seis, t1, t2, WW);         %%δ֪֪ǿ��
        [error2(t1,t2), AB2(t1, t2), AB2(t1, t2)] = smoothness_least_squares(seis, t1, t2, WW, T1, T2); %%��֪ǿ��
        %% �������� ���ȵ�
        %  [error1(t1,t2), AA1(t1, t2), AA2(t1, t2)] = smoothness_error(seis, t1, t2, WW);         %%δ֪֪ǿ��
        %  [error2(t1,t2), AB1(t1, t2), AB2(t1, t2)]  = smoothness_error(seis, t1, t2, WW, T1, T2); %%��֪ǿ��
    end 
end
%% δ֪֪ǿ��
figure
% set (gcf,'position',[0 1000 560   420] )
imagesc(error1) 
colorbar
set(gca,'YDir','normal'); 
% caxis([8 24])
figure
% set (gcf,'position',[0 1400 560   420] )
surfc(error1,'FaceAlpha',0.5);
%% ��֪ǿ��
figure
% set (gcf,'position',[550 1000 560   420] )
imagesc(error2) 
colorbar
set(gca,'YDir','normal'); 
caxis([5 7])
figure
% set (gcf,'position',[550 1400 560   420] )
surfc(error2,'FaceAlpha',0.5);
% %% δ֪֪ǿ�� ���t1, t2��С
% figure
% set (gcf,'position',[0 1000 560   420] )
% imagesc(AA1)
% colorbar
% set(gca,'YDir','normal'); 
% % % �ҵ���Сֵ��λ��
% [minVal, minInd] = min(AA1(:));
% [minRow, minCol] = ind2sub(size(AA1), minInd);
% hold on;
% % ����������
% line([minCol minCol],[0 minRow],  'Color', 'red', 'LineStyle', '--');
% line([0 minCol],[minRow minRow],  'Color', 'red', 'LineStyle', '--');
% % ����Сֵλ�û�Ȧ
% plot(minCol, minRow, 'ro', 'MarkerSize', 5, 'LineWidth', 1);
% text(minCol, minRow, sprintf('(%d, %d)', minCol, minRow), 'Color', 'red', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
% %%
% %% ��֪ǿ�� ���t1, t2��С
% figure
% set (gcf,'position',[0 600 560   420] )
% imagesc(AB2)
% colorbar
% set(gca,'YDir','normal'); 
% % �ҵ���Сֵ��λ��
% [minVal, minInd] = min(AB2(:));
% [minRow, minCol] = ind2sub(size(AB2), minInd);
% hold on;
% % ����������
% line([minCol minCol],[0 minRow],  'Color', 'red', 'LineStyle', '--');
% line([0 minCol],[minRow minRow],  'Color', 'red', 'LineStyle', '--');
% % ����Сֵλ�û�Ȧ
% plot(minCol, minRow, 'ro', 'MarkerSize', 5, 'LineWidth', 1);
% text(minCol, minRow, sprintf('(%d, %d)', minCol, minRow), 'Color', 'red', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');

