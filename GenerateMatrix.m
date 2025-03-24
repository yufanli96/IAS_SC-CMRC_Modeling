function [ADN,BDN,CDN,DDN,EDN,O41] = GenerateMatrix(m,alpha1,alpha2,alpha3,beta)
%GENERATEMATRIX 

k=2*m-1;%Contains only odd harmonics
%电路参数
fs=2e3;
Ts=1/fs;
ws=2*pi/Ts;
Nt=1.8;
Lreq=556.56e-6;
Creq=16.32e-6;
Co=2.52e-3;
RL=4;


% sk1R=0;
sk1I=-2*cos(k*alpha1/2)*cos(k*alpha2/2)/(k*pi);
sk2R=-2*cos(k*alpha3/2)*sin(k*beta)/(k*pi);
sk2I=-2*cos(k*alpha3/2)*cos(k*beta)/(k*pi);

ADN=[0 ,            k*ws,   -1/Lreq,        0      
   - k*ws ,           0,       0,        -1/Lreq   
   1/Creq ,             0,       0,         k* ws   
    0 ,            1/Creq,     - k*ws,      0,       ];
BDN=[-Nt*sk2R/Lreq;
    -Nt*sk2I/Lreq;
    0;
    0];
CDN=[2*Nt*sk2R/Co;
    2*Nt*sk2I/Co;
    0;
    0]';%转置
DDN=-1/(Co*RL);

EDN=[0,         ;
    sk1I/Lreq,   ;
    0,         ;
    0,     ;];
O41=[0;0;0;0];

end

%no more