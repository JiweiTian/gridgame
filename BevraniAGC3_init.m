% Values from Bevrani's "Robst Power System Frequency Control," page 24,
% Table 2.2
K1 = 0.3;       K2 = 0.2;       K3 = 0.4;
D1 = 0.015;     D2 = 0.016;     D3 = 0.015;
H1 = 0.1667/2;  H2 = 0.2017/2;  H3 = 0.1247/2;
R1 = 3.00;      R2 = 2.73;      R3 = 2.82;
Tg1 = 0.08;     Tg2 = 0.06;     Tg3 = 0.07;
Tt1 = 0.40;     Tt2 = 0.44;     Tt3 = 0.30;
B1 = 0.3483;    B2 = 0.3827;    B3 = 0.3692;

T12 = 0.20;     T21 = 0.20;     
T13 = 0.25;     T31 = 0.25;
T23 = 0.12;     T32 = 0.12;

% Demand profiles
load('demand1.mat')
load('demand2.mat')

% Underfrequency load shedding
% See P. M. Anderson et al., "An adatpive method for setting underfrequency
% load shedding relays," IEEE Transactions on Power Systems 7(2):647-655, 1992
global totalLoad2Shed firstLoad2Shed finalLoad2Shed uflsMinDeltaF 

Pstep = 1;
staticLoad2Shed = Pstep - 0.1042*H1; % Static Load Shed in p.u.
totalLoad2Shed = 1.05*staticLoad2Shed; % Dynamic Load Shed in p.u.
firstLoad2Shed = staticLoad2Shed/2;
finalLoad2Shed = mod(totalLoad2Shed-firstLoad2Shed, 0.1);
uflsMinDeltaF = -0.8-0.3*floor((totalLoad2Shed-firstLoad2Shed)/0.1);