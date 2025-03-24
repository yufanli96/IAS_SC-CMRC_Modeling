%TIA——NPC-DBSRC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
%Circuit parameters of NPC-DBSRC
fs=2e3;
Ts=1/fs;
ws=2*pi/Ts;
Nt=1.8;
Lreq=556.56e-6;
Creq=16.32e-6;
Co=2.52e-3;
RL=4;
%Input of NPC-DBSRC
Udc1=1800;
Io=0;
U=[Udc1;Io];
x = zeros(19,1);
alpha1=0.1*pi;
alpha2=0.2*pi;
alpha3=0.05*pi;
beta=0.068*pi;


totalMatrixA = [];
totalMatrixB = [];
totalMatrixC = [];
totalMatrixD = [];
totalMatrixE = [];
totalMatrixO = [];
for m = 1:5
   [A,B,C,D,E,O41]=GenerateMatrix(m,alpha1,alpha2,alpha3,beta);%矩阵生成函数

    totalMatrixA = blkdiag(totalMatrixA, A);%对角线
    totalMatrixC = horzcat(totalMatrixC, C); %水平相接
    totalMatrixB = vertcat(totalMatrixB, B); %垂直相接
    totalMatrixD = D; 
    totalMatrixE = vertcat(totalMatrixE, E);
    totalMatrixO= vertcat(totalMatrixO, O41);

end

A=[[totalMatrixA,totalMatrixB];[totalMatrixC,totalMatrixD]];
B=[totalMatrixE,totalMatrixO;0,-1/Co;];

X=inv(A)*(-B*U)%求静态工作点


theta=0:0.01*pi:2*pi*200;



 
ir1 =2*X(1)*cos(theta)-2*X(2)*sin(theta);
vr1 =2*X(3)*cos(theta)-2*X(4)*sin(theta); 

ir3 =2*X(1)*cos(theta)-2*X(2)*sin(theta)+2*X(5)*cos(3*theta)-2*X(6)*sin(3*theta);
vr3 =2*X(3)*cos(theta)-2*X(4)*sin(theta)+2*X(7)*cos(3*theta)-2*X(8)*sin(3*theta); 

ir9 =2*X(1)*cos(theta)-2*X(2)*sin(theta)+2*X(5)*cos(3*theta)-2*X(6)*sin(3*theta)...
    +2*X(9)*cos(5*theta)-2*X(10)*sin(5*theta)+2*X(13)*cos(7*theta)-2*X(14)*sin(7*theta)...
    +2*X(17)*cos(9*theta)-2*X(18)*sin(9*theta);
vr9 =2*X(3)*cos(theta)-2*X(4)*sin(theta)+2*X(7)*cos(3*theta)-2*X(8)*sin(3*theta)...
    +2*X(11)*cos(5*theta)-2*X(12)*sin(5*theta)+2*X(15)*cos(7*theta)-2*X(16)*sin(7*theta)...
    +2*X(19)*cos(9*theta)-2*X(20)*sin(9*theta); 
vr91m=vr9/(1+Nt*Nt);
vr11m=vr1/(1+Nt*Nt);
vr31m=vr3/(1+Nt*Nt);
vo=X(21)*cos(0*theta);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=3;n=1;
linewidth_line = 1.5;      
markersize = 2.5;         
x1min=1050;x1max=1062;     
x2min=1050;x2max=1062;     
y1min=-400;y1max=400;
y2min=900;y2max=1100;

subplot(m, n, 1); % RESONANT CURRENT
plot (theta,ir9,'Color','g');hold on
plot (theta,ir1,'Color','b');hold on
plot (theta,ir3,'Color','m');hold on
xlim([x1min x1max])           

set(gca,'XLim',[x1min x1max]);
set(gca,'XTick',x1min:(x1max-x1min)/4: x1max);
ylim([y1min y1max])       
subplot(m, n, 2); % RESONANT Voltage
plot (theta,vr91m,'Color','g');hold on
plot (theta,vr11m,'Color','b');hold on
plot (theta,vr31m,'Color','m');hold on
xlim([x1min x1max])           
set(gca,'XLim',[x1min x1max]);
set(gca,'XTick',x1min:(x1max-x1min)/4: x1max);
ylim([y1min y1max])
subplot(m, n, 3); % SubModule voltage
plot (theta,vo,'Color','g');hold on
xlim([x2min x2max])          
set(gca,'XLim',[x2min x2max]);
set(gca,'XTick',x2min:(x2max-x2min)/4: x2max);
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

