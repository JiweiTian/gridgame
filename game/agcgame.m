% secgame1  
%   Initial script for security markovgame
%   This is the markov version of the cdc04 game            
%
%   S={s=sense, ns=not sensed by sensor}
%   A={a=attack,  na=not attack}
%   D={d=response,nd=no response}
%-------------------------------------------------------------------------
% By Tansu Alpcan 
%-------------------------------------------------------------------------

%clear;
% Define the transition probabilities
% If there is a vulnerability (1) or not (2)
% M(A), left stochastic matrix, M*x
% columns add up to one!
% alternative is right s.m, x*M
%

stabletime = 30; % number of seconds during which frequency is stable after load shedding
samplingrate = 0.5; % AGC sampling rate
alpha = 0.1; % discount factor
zerogs0 = false; % zero game matrix for state s0

if stabletime == 30 && samplingrate == 0.5
  % M(a10,d1)
  M(:,:,1,1)=[7/11, 4/11; 4/31, 27/31];
  % M(a10,d2)
  M(:,:,1,2)=[9/14, 5/14; 4/28, 24/28];
  % M(a20,d1)
  M(:,:,2,1)=[8/12, 4/12; 3/30, 27/30];
  % M(a20,d2)
  M(:,:,2,2)=[7/10, 3/10; 3/32, 29/32];
  
  % state s0: G(s0) = [a10,d1 a10,d2; a20,d1 a20,d2]
  G(:,:,1)=[-8.7894, -8.7672; -8.7606, -8.7602];
  % state s1: G(s1) = [a10,d1 a10,d2; a20,d1 a20,d2]
  G(:,:,2)=[ 0.5038,  0.5884;  0.6643,  0.6450];
elseif stabletime == 30 && samplingrate == 1
  % M(a10,d1)
  M(:,:,1,1)=[13/21, 8/21; 7/64, 57/64];
  % M(a10,d2)
  M(:,:,1,2)=[3/8,   5/8;  4/77, 73/77];
  % M(a20,d1)
  M(:,:,2,1)=[3/9,   6/9;  6/76, 70/76];
  % M(a20,d2)
  M(:,:,2,2)=[5/11,  6/11; 8/74, 66/74];
  
  % state s0: G(s0) = [a10,d1 a10,d2; a20,d1 a20,d2]
  G(:,:,1)=[-8.7975, -8.7984; -8.7787, -8.7652];
  % state s1: G(s1) = [a10,d1 a10,d2; a20,d1 a20,d2]
  G(:,:,2)=[ 0.3046,  0.3473;  0.3719,  0.3505];
elseif stabletime == 60 && samplingrate == 0.5
  % M(a10,d1)
  M(:,:,1,1)=[2/4  2/4; 0/38  38/38];
  % M(a10,d2)
  M(:,:,1,2)=[0/1  1/1; 0/41  41/41];
  % M(a20,d1)
  M(:,:,2,1)=[0/2  2/2; 1/40  39/40];
  % M(a20,d2)
  M(:,:,2,2)=[2/4  2/4; 2/38  36/38];
  
  % state s0: G(s0) = [a10,d1 a10,d2; a20,d1 a20,d2]
  G(:,:,1)=[-8.7547 -8.8519; -8.7587 -8.7484];
  % state s1: G(s1) = [a10,d1 a10,d2; a20,d1 a20,d2]
  G(:,:,2)=[0.6778 0.7133; 0.6234 0.6132];
elseif stabletime == 60 && samplingrate == 1
  % M(a10,d1)
  M(:,:,1,1)=[3/7  4/7; 2/78  76/78];
  % M(a10,d2)
  M(:,:,1,2)=[0/1  1/1; 0/84  84/84];
  % M(a20,d1)
  M(:,:,2,1)=[0/1  1/1; 0/84  84/84];
  % M(a20,d2)
  M(:,:,2,2)=[1/3  2/3; 1/82  81/82];
  
  % state s0: G(s0) = [a10,d1 a10,d2; a20,d1 a20,d2]
  G(:,:,1)=[-8.8054 -8.8063; -8.8157 -8.7233];
  % state s1: G(s1) = [a10,d1 a10,d2; a20,d1 a20,d2]
  G(:,:,2)=[0.2722 0.3529; 0.4037 0.4081];
end

if zerogs0
  G(:,:,1)=[0, 0; 0, 0];
end

[sim,cpu_time] = newsecgamesolve2(M,G,alpha);
%[dummy,x,y]=zerosumgamesolver1(G(:,:,1)); %no vuln
%[dummy,xv,yv]=zerosumgamesolver1(G(:,:,2)); %vuln
sim
sim.policy1'
sim.policy2'

% % Display results

figure(299)
% colormap(copper)
% subplot(2,2,1)
% bar([xv x])
% title('Attack Strategies for Static Game')
% %xlabel('Action Space')
% set(gca,'XTickLabel',{'a10','a20'})
% ylabel('Probability')
% legend('s0','s1')
% 
% subplot(2,2,2)
% bar([yv y])
% title('Defense Strategies for Static Game')
% xlabel('Actions')
% ylabel('Probability')
% set(gca,'XTickLabel',{'d1','d2'})
% legend('s0','s1')
% 
% subplot(2,2,3)
colormap(copper)
bar([sim.policy1 sim.policy2])
%title('Attack and Defense Strategies for Markov Game')
xlabel('Actions')
set(gca,'XTickLabel',{'a10,d1','a20,d2'})
ylabel('Probability')
legend({'Attacker','Defender'},'location','best')
set(gcf, 'units', 'normalized')
set(gcf, 'position', [0.8, 0.7, 0.15, 0.2])
set(gca, 'YGrid', 'on')

% figure(1)
% plot([sim.Jstore{1} sim.Jstore{2}]);
% title('Evolution of Cost Values')
% xlabel('Number of Iterations');
% ylabel('Value');
% figure(2)
% subplot(2,1,1)
% bar(sim.policy{1}');
% ylabel('Probability');
% title('Optimal Attacker and IDS Strategies');
% subplot(2,1,2)
% bar(sim.policy{2}');
% legend('Detection','No Detection');
% xlabel('Action');
