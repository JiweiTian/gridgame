% Values from Bevrani's "Robst Power System Frequency Control," page 24,
% Table 2.2
K_AGC1 = 0.3;   K_AGC2 = 0.2;   K_AGC3 = 0.4;
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
global deltaPsafe aMaxShed aShedSoFar uflsInited
deltaPsafe = -0.3/R1;
aMaxShed = [4, 1];
aShedSoFar = [0, 0];
uflsInited = false;

% Attack and defense
global N currMeter nSamples flaggedMeter attackerInited defenderInited 
N = 20; % a meter supplies N samples in a session
currMeter = 1; set_param('BevraniAGC2/Attacker/Meter switch', 'sw', '1');
nSamples = 1;
flaggedMeter = 0;
attackerInited = false;
defenderInited = false;

% Log file
global logFile
logFile = fopen('log.txt', 'w+');

% Misc
rng(1234);
tic;