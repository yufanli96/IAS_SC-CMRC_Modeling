%TIA——dcMMC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
USM1=1000;
USM2=1000;
    DM=0.83;
    totalMatrixA = [];
    totalMatrixB = [];
    totalMatrixC = [];
    totalMatrixD = [];
    totalMatrixE = [];
    totalMatrixF = [];
   [A,B,C,D,E,F]=GenerateMatrixDCMMC(1,DM);%矩阵生成函数

    totalMatrixA = blkdiag(totalMatrixA, A);%对角线
    totalMatrixC = horzcat(totalMatrixC, C); %水平相接
    totalMatrixB = vertcat(totalMatrixB, B); %垂直相接
    totalMatrixD = D; 
    totalMatrixE = vertcat(totalMatrixE, E);
    totalMatrixF= vertcat(totalMatrixF, F);

AAA=[[totalMatrixA,totalMatrixB];[totalMatrixC,totalMatrixD]];
BBB=[totalMatrixE;totalMatrixF;];
U=[USM1;USM2];
X2=inv(AAA)*(-BBB*U);
 theta=0:0.01*pi:2*pi*100;


IMV2 =X2(5)+2*X2(1)*cos(theta)-2*X2(2)*sin(theta);
UMV2 =X2(6)+2*X2(3)*cos(theta)-2*X2(4)*sin(theta);



figure(1)




m=2;n=1;
linewidth_line = 1.5;      
markersize = 2.5;         
x1min=340;x1max=400;     
x2min=340;x2max=400;     
y1min=200;y1max=400;
y2min=1600;y2max=1700;

subplot(m, n, 1); 
plot (theta,IMV2);hold on
xlim([x1min x1max])           

set(gca,'XLim',[x1min x1max]);
set(gca,'XTick',x1min:(x1max-x1min)/4: x1max);
ylim([y1min y1max])      

subplot(m, n, 2); 
plot (theta,UMV2);hold on
xlim([x1min x1max])           
set(gca,'XLim',[x1min x1max]);
set(gca,'XTick',x1min:(x1max-x1min)/4: x1max);
ylim([y2min y2max])

Width=6;Height=6;
ScreenSize=13.3;
ScreenSizeInCM=ScreenSize*2.45; 
scrsz = get(0,'ScreenSize'); 
ScreenWidth=ScreenSizeInCM/sqrt(1+(scrsz(4)/scrsz(3))^2);
ScreenHeight=ScreenWidth*scrsz(4)/scrsz(3);
WidthRatio=Width/ScreenWidth;
HeightRatio=Height/ScreenHeight;
set(gcf,'Unit','Normalized','Position',[0.4 0.4 WidthRatio HeightRatio]);
