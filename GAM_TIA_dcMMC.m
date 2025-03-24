%TIA——dcMMC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
%Circuit parameters of DC-MMC
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



AM1=[0 ws -1/L 0;
    -ws 0 0 -1/L;
    1/C 0 -1/(C*RL) ws
    0 1/C -ws -1/(C*RL)];
BM1=[0 0;
    0 0;
    0 0;
    0 0];
CM1=[0 0;
    0 0;
    0 0;
    0 0]';
DM1=[0 -1/L;
    1/C -1/(C*RL)];
AAA=[AM1,BM1;
    CM1,DM1];
EM1=[ fR2/L,fR2/L;
    fI2/L,fI2/L;
    0,0;
   0,0;
   D/L,D/L;
   0,0];


U=[USM1;USM2];




X2=inv(AAA)*(-EM1*U)%求静态工作点
 theta=0:0.01*pi:2*pi*100;


IMV2 =X2(5)+2*X2(1)*cos(theta)-2*X2(2)*sin(theta);
UMV2 =X2(6)+2*X2(3)*cos(theta)-2*X2(4)*sin(theta);



figure(1)

plot (theta,IMV2,'Color','k');hold on
plot (theta,UMV2,'Color','k');hold on


