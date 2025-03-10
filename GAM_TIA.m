% clc;
% clear;
%电路参数
fs=2e3;
Ts=1/fs;
ws=2*pi/Ts;
Nt=1.8;


Lr=556.56e-6;
Cr=16.32e-6;
Co=2.52e-3;

RL=4;

%输入参数
Udc1=1800;

U=Udc1;

% x = zeros(19,1);


alpha1=0.1*pi;
alpha2=0.2*pi;
alpha3=0.05*pi;
beta=0.068*pi;


%大信号状态矩阵
k=1;
A1=[0 ,            k*ws,   -1/Lr,        0      
   - k*ws ,           0,       0,        -1/Lr   
   1/Cr ,             0,       0,         k* ws   
    0 ,            1/Cr,     - k*ws,      0,       ];
B1=[(2*Nt*cos(k*alpha3/2)*sin(k*beta))/(k*pi*Lr);
    (2*Nt*cos(k*alpha3/2)*cos(k*beta))/(k*pi*Lr);
    0;
    0];

C1=[-(4*Nt*cos(k*alpha3/2)*sin(k*beta))/(k*pi*Co);
    -(4*Nt*cos(k*alpha3/2)*cos(k*beta))/(k*pi*Co);
    0;
    0]';
D=-1/(Co*RL);
E1=[0;
    (-2*cos(k*alpha1/2)*cos(k*alpha2/2))/(k*pi*Lr);
    0;
    0];





A_sym=[[A1,B1];[C1,D]];

B_sym=[E1;0];
X=inv(A_sym)*(-B_sym*U)%求静态工作点

k=1;
a13=-(Nt*sin(k*alpha3/2)*sin(k*beta))/(pi*Lr)*X(1);
a14=2*X(1)*(Nt*cos(k*alpha3/2)*cos(k*beta))/(pi*Lr);

a21=Udc1*(sin(k*alpha1/2)*cos(k*alpha2/2))/(pi*Lr);
a22=Udc1*(cos(k*alpha1/2)*sin(k*alpha2/2))/(pi*Lr);
a23=-(Nt*sin(k*alpha3/2)*cos(k*beta))/(pi*Lr)*X(2);
a24=2*(Nt*cos(k*alpha3/2)*sin(k*beta))/(pi*Lr)*X(2);
a25=-2*(cos(k*alpha1/2)*cos(k*alpha2/2))/(k*pi*Lr);

a53=2*(Nt*sin(k*alpha3/2)*sin(k*beta))/(pi*Co)*X(1)...
    +2*(Nt*sin(k*alpha3/2)*cos(k*beta))/(pi*Co)*X(2);
a54=-4*(Nt*cos(k*alpha3/2)*cos(k*beta))/(pi*Co)*X(1)...
    -4*(Nt*cos(k*alpha3/2)*sin(k*beta))/(pi*Co)*X(2);

F1=[0 0 a13 a14 0;
    a21 a22 a23 a24 a25;
    0 0 0 0 0 ;
    0 0 0 0 0;
    0 0 a53 a54 0];
% K1=[0 0 0 0 1];
K=[1,0,0,0,0;
   0,1,0,0,0;
   0,0,1,0,0;
   0,0,0,1,0;
   0,0,0,0,1];


G=ss(A_sym,F1,K,0)  %创建系统模型
G1=tf(G)       %直接获取传递函数矩阵


numerator1 = [0.02,0.1];
denominator1 = [1 0];
Gpi_outloop = tf(numerator1,denominator1);
%%%%%%%陷波器的传递函数%%%%%%%
wo= 358*2*pi;%SRDAB中的拍振频率

numerator2 = [1 0.01*wo wo^2];
denominator2 = [1 2*wo wo^2];
% numerator2 = [1 wo^2];
% denominator2 = [1 8*wo wo^2];
% G_xianbo = tf(numerator2,denominator2);
G_xianbo = 1;

s=tf('s');
Gd=exp(-Ts*s);
GdPade=pade(Gd,1);
% GdPade=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gopenloop=Gpi_outloop*G1(5,4)*G_xianbo*GdPade;%开环传递函数
Gcloseloop=Gopenloop/(1+Gopenloop);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure 1 稳态输出波形
% figure(1)
% theta=0:0.01*pi:2*pi*20;
% ir =2*X(1)*cos(theta)-2*X(2)*sin(theta);
% 
% 
% vr =2*X(3)*cos(theta)-2*X(4)*sin(theta);
% 
% vr1=vr/3.25;
% vo=X(5)*cos(0*theta);
% 
% 
% plot (theta,ir);hold on
% plot (theta,vr1);hold on
% plot (theta,vo);hold on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)

w=[0,logspace(1,4,200)];
opt = bodeoptions; % 生成bode函数的属性设置默认结构体
opt.FreqUnits = 'Hz'; % 将频率单位设置成 Hz （默认是 rad/s）
opt.PhaseWrapping = 'on'; % 关键设置：打开自动换算相位开关
opt.PhaseWrappingBranch =-360; %这是默认值，此行代码可以省略，大意是小于-180的相位进行换算

bode(G1(5,4),w,opt);hold on 
bode(Gopenloop,w,opt);hold on 
% bode(Gcloseloop,w,opt);hold on 
Width=6;Height=4;%单位为厘米！！！这里根据需求更改。。。
ScreenSize=13.3; % 屏幕大小，单位为英寸，且应该注意该值通常指对角线的长度，需根据勾股定理计算宽高
ScreenSizeInCM=ScreenSize*2.45; %1英寸等于2.45厘米，长度换算
scrsz = get(0,'ScreenSize');  %得到屏幕分辨率
ScreenWidth=ScreenSizeInCM/sqrt(1+(scrsz(4)/scrsz(3))^2);%屏幕宽，单位为厘米
ScreenHeight=ScreenWidth*scrsz(4)/scrsz(3);%屏幕高，单位厘米
WidthRatio=Width/ScreenWidth;%图形的期望宽度与屏幕宽度的比值
HeightRatio=Height/ScreenHeight;%图形的期望高度与屏幕高度的比值
set(gcf,'Unit','Normalized','Position',[0.4 0.4 WidthRatio HeightRatio]);%设置绘图的大小，无需再到word里再调整大小
