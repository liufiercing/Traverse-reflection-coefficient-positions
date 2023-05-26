%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 测试解问题 光滑数据测试
% 采用遍历的方法寻找解的位置，利用最小二乘求对应位置的振幅大小
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clc;clear;close all; 
%% 模型设置
N = 100;
trace = 1;
ref=zeros(N,trace);
% 强轴位置
T1 = 30;
T2 = 45;
% 弱轴位置
rr1 = 60;
rr2 = 75;
% 幅值设置
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
%% 构建子波矩阵
dt=0.001; % 1ms
fm=30;   trun_time=0.04;  t=-trun_time:dt:trun_time;
w=(1-2*(pi*fm*t).^2).*exp(-(pi*fm*t).^2);
nWaveSampPoint=length(w);
W_temp=convmtx(w',length(ref(:,1)));  %% 时移
WW=W_temp(((nWaveSampPoint-1)/2)+1:end-((nWaveSampPoint-1)/2),:);     % full_freq
%% 合成数据
seis=WW*ref;
%%
figure;
set (gcf,'position',[400,200,400,680] )
plot(seis,1:N,  '-r', 'linewidth', Linewidth);
set(gca,'YDir','reverse'); %将x轴方向设置为反向(从上到下递增)。
%% 遍历求解
error1 = zeros(N,N); error2 = zeros(N,N);
AA1 = zeros(N,N); AA2 = zeros(N,N);
AB1 = zeros(N,N); AB2 = zeros(N,N);
for t1 = 1 : N
    for t2 = 1 : N
        %% 最小二乘 精度高
        [error1(t1,t2), AA1(t1, t2), AA2(t1, t2)] = smoothness_least_squares(seis, t1, t2, WW);         %%未知知强轴
        [error2(t1,t2), AB2(t1, t2), AB2(t1, t2)] = smoothness_least_squares(seis, t1, t2, WW, T1, T2); %%已知强轴
        %% 遍历方法 精度低
        %  [error1(t1,t2), AA1(t1, t2), AA2(t1, t2)] = smoothness_error(seis, t1, t2, WW);         %%未知知强轴
        %  [error2(t1,t2), AB1(t1, t2), AB2(t1, t2)]  = smoothness_error(seis, t1, t2, WW, T1, T2); %%已知强轴
    end 
end
%% 未知知强轴
figure
% set (gcf,'position',[0 1000 560   420] )
imagesc(error1) 
colorbar
set(gca,'YDir','normal'); 
% caxis([8 24])
figure
% set (gcf,'position',[0 1400 560   420] )
surfc(error1,'FaceAlpha',0.5);
%% 已知强轴
figure
% set (gcf,'position',[550 1000 560   420] )
imagesc(error2) 
colorbar
set(gca,'YDir','normal'); 
caxis([5 7])
figure
% set (gcf,'position',[550 1400 560   420] )
surfc(error2,'FaceAlpha',0.5);
% %% 未知知强轴 振幅t1, t2大小
% figure
% set (gcf,'position',[0 1000 560   420] )
% imagesc(AA1)
% colorbar
% set(gca,'YDir','normal'); 
% % % 找到最小值的位置
% [minVal, minInd] = min(AA1(:));
% [minRow, minCol] = ind2sub(size(AA1), minInd);
% hold on;
% % 绘制坐标线
% line([minCol minCol],[0 minRow],  'Color', 'red', 'LineStyle', '--');
% line([0 minCol],[minRow minRow],  'Color', 'red', 'LineStyle', '--');
% % 在最小值位置画圈
% plot(minCol, minRow, 'ro', 'MarkerSize', 5, 'LineWidth', 1);
% text(minCol, minRow, sprintf('(%d, %d)', minCol, minRow), 'Color', 'red', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
% %%
% %% 已知强轴 振幅t1, t2大小
% figure
% set (gcf,'position',[0 600 560   420] )
% imagesc(AB2)
% colorbar
% set(gca,'YDir','normal'); 
% % 找到最小值的位置
% [minVal, minInd] = min(AB2(:));
% [minRow, minCol] = ind2sub(size(AB2), minInd);
% hold on;
% % 绘制坐标线
% line([minCol minCol],[0 minRow],  'Color', 'red', 'LineStyle', '--');
% line([0 minCol],[minRow minRow],  'Color', 'red', 'LineStyle', '--');
% % 在最小值位置画圈
% plot(minCol, minRow, 'ro', 'MarkerSize', 5, 'LineWidth', 1);
% text(minCol, minRow, sprintf('(%d, %d)', minCol, minRow), 'Color', 'red', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');

