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

% Dataset 1 is for AGC sampling rate of 1s
% Dataset 2 is for AGC sampling rate of 2s
dataset = 1;

if dataset == 1
  % M(a10,d1)
  M(:,:,1,1)=[3/8,   5/8;  4/77, 73/77];
  % M(a10,d2)
  M(:,:,1,2)=[13/21, 8/21; 7/64, 57/64];
  % M(a20,d1)
  M(:,:,2,1)=[5/11,  6/11; 8/74, 66/74];
  % M(a20,d2)
  M(:,:,2,2)=[3/9,   6/9;  6/76, 70/76];
  
  % state s0: G(s0) = [a10,d1 a20,d1; a10,d2 a20,d2]
  G(:,:,1)=[-8.7984, -8.7652; -8.7975, -8.7787];
  %G(:,:,1)=[0, 0; 0, 0];
  % state s1: G(s1) = [a10,d1 a20,d1; a10,d2 a20,d2]
  G(:,:,2)=[ 0.3473,  0.3505;  0.3046,  0.3719];
elseif dataset == 2
  % M(a10,d1)
  M(:,:,1,1)=[9/14, 5/14; 4/28, 24/28];
  % M(a10,d2)
  M(:,:,1,2)=[7/11, 4/11; 4/31, 27/31];
  % M(a20,d1)
  M(:,:,2,1)=[7/10, 3/10; 3/32, 29/32];
  % M(a20,d2)
  M(:,:,2,2)=[8/12, 4/12; 3/30, 27/30];
  
  % state s0: G(s0) = [a10,d1 a20,d1; a10,d2 a20,d2]
  G(:,:,1)=[-8.7672, -8.7602; -8.7894, -8.7606];
  %G(:,:,1)=[0, 0; 0, 0];
  % state s1: G(s1) = [a10,d1 a20,d1; a10,d2 a20,d2]
  G(:,:,2)=[ 0.5884,  0.6450;  0.5038,  0.6643];
else
  % M(a10,d1)
  M(:,:,1,1)=[0.200000 0.800000; 0.136364 0.863636];
  % M(a10,d2)
  M(:,:,1,2)=[0.333333 0.666667; 0.142857 0.857143];
  % M(a20,d1)
  M(:,:,2,1)=[0.500000 0.500000; 0.043478 0.956522];
  % M(a20,d2)
  M(:,:,2,2)=[0.571429 0.428571; 0.100000 0.900000];

  % state s0: G(s0) = [a10,d1 a20,d1; a10,d2 a20,d2]
  G(:,:,1)=[0 0; 0 0];
  % state s1: G(s1) = [a10,d1 a20,d1; a10,d2 a20,d2]
  G(:,:,2)=[0.668604 0.773476; 0.605829 0.823540];
end


[sim,cpu_time] = newsecgamesolve2(M,G,0.9);
%[dummy,x,y]=zerosumgamesolver1(G(:,:,1)); %no vuln
%[dummy,xv,yv]=zerosumgamesolver1(G(:,:,2)); %vuln
sim
sim.policy1'
sim.policy2'

% % Display results

figure(199)
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
title('Attack and Defense Strategies for Markov Game')
xlabel('Actions')
set(gca,'XTickLabel',{'a10,d1','a20,d2'})
ylabel('Probability')
legend('Attacker','Defender')

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
