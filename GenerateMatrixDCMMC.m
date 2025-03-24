function [AMN,BMN,CMN,DMN,EMN,FMN] = GenerateMatrixDCMMC(n,D)

%GENERATEMATRIX 
fs=1e3;
Ts=1/fs;
ws=2*pi/Ts;
USM1=1000;
USM2=1000;
L=3e-3;
C=200e-6;
RL=5.51;
% D=0.83;

f0=D;
fR2=sin(2*n*pi*D)*cos(2*n*pi*D)/(2*n*pi);
fI2=-sin(2*n*pi*D)*sin(2*n*pi*D)/(2*n*pi);
AMN=[0 ws -1/L 0;
    -ws 0 0 -1/L;
    1/C 0 -1/(C*RL) ws
    0 1/C -ws -1/(C*RL)];
BMN=[0 0;
    0 0;
    0 0;
    0 0];
CMN=[0 0;
    0 0;
    0 0;
    0 0]';
DMN=[0 -1/L;
    1/C -1/(C*RL)];

EMN=[ fR2/L,fR2/L;
    fI2/L,fI2/L;
    0,0;
   0,0;];
FMN= [D/L,D/L;
      0,0];
  

U=[USM1;USM2];

end

%no more
