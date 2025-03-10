%TIA——dcMMC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 大信号求解
% clc;
% clear;
fs=1e3;
Ts=1/fs;
ws=2*pi/Ts;
USM1=1000;
USM2=1000;
L=3e-3;
C=200e-6;
RL=5.51;
D=0.83;

f0=D;
fR2=sin(2*pi*D)*cos(2*pi*D)/(2*pi);
fI2=-sin(2*pi*D)*sin(2*pi*D)/(2*pi);

PfR2=2*pi*cos(4*pi*D)/(2*pi);
PfI2=2*pi*sin(4*pi*D)/(2*pi);

AM=[0,     0,     0,   -1/L,         0,          0;
    0,     0,     ws,   0,          -1/L,          0;
    0,     -ws,   0,    0,           0,          -1/L;
    1/C,   0,     0,   -1/(C*RL),    0,          0;
    0,     1/C,   0,    0,           -1/(C*RL),  ws;
    0,     0,     1/C,  0,           -ws,        -1/(C*RL) ];
BM=[D/L,D/L;
    fR2/L,fI2/L;
    fI2/L,fI2/L;
    0,     0;
    0,     0;
    0,     0];
U=[USM1;USM2];
X1=inv(AM)*(-BM*U)%求静态工作点
 theta=0:0.01*pi:2*pi*100;
IMV1 =X1(1)+2*X1(2)*cos(theta)-2*X1(3)*sin(theta);
UMV1 =X1(4)+2*X1(5)*cos(theta)-2*X1(6)*sin(theta);
figure(1)
plot (theta,IMV1,'Color','g');hold on
plot (theta,UMV1,'Color','R');hold on

%% 小信号求解
BMS=[D/L,D/L,2/L*(USM1),2/L*(USM2)
    fR2/L,fI2/L,1/L*(fR2)*(USM1),1/L*(fR2)*(USM2)
    fI2/L,fI2/L,1/L*(fI2)*(USM1),1/L*(fI2)*(USM2)
    0,     0,0,0;
    0,     0,0,0;
    0,     0,0,0        ];
CMS=[1,0,0,0,0,0;
   0,1,0,0,0,0;
   0,0,1,0,0,0;
   0,0,0,1,0,0;
   0,0,0,0,1,0;
   0,0,0,0,0,1];
G=ss(AM,BMS,CMS,0)  %创建系统模型

G1=tf(G)       %直接获取传递函数矩阵
w=[0,logspace(2,4,200)];
opt = bodeoptions; % 生成bode函数的属性设置默认结构体
opt.FreqUnits = 'Hz'; % 将频率单位设置成 Hz （默认是 rad/s）
% opt.PhaseWrapping = 'on'; % 关键设置：打开自动换算相位开关
% opt.PhaseWrappingBranch =-180; %这是默认值，此行代码可以省略，大意是小于-180的相位进行换算
figure(2)





bode(G1(4,3),w,opt);hold on

xlim([10 1000]) ;


wout=unnamed(:,1).*(2*pi); %化成弧度秒
magg=10.^(unnamed(:,2)./20);%由分贝转化为放大倍数  20*log(a)=MAG
phasee=unnamed(:,3);

data = frd(magg.*exp(1j*phasee*pi/180),wout);

np=2;
nz=0;

bode(data,'*')
Width=6;Height=6;%单位为厘米！！！这里根据需求更改。。。
ScreenSize=13.3; % 屏幕大小，单位为英寸，且应该注意该值通常指对角线的长度，需根据勾股定理计算宽高
ScreenSizeInCM=ScreenSize*2.45; %1英寸等于2.45厘米，长度换算
scrsz = get(0,'ScreenSize');  %得到屏幕分辨率
ScreenWidth=ScreenSizeInCM/sqrt(1+(scrsz(4)/scrsz(3))^2);%屏幕宽，单位为厘米
ScreenHeight=ScreenWidth*scrsz(4)/scrsz(3);%屏幕高，单位厘米
WidthRatio=Width/ScreenWidth;%图形的期望宽度与屏幕宽度的比值
HeightRatio=Height/ScreenHeight;%图形的期望高度与屏幕高度的比值
set(gcf,'Unit','Normalized','Position',[0.4 0.4 WidthRatio HeightRatio]);%设置绘图的大小，无需再到word里再调整大小

