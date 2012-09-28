% secgame1  
%   Initial script for security markovgame
%   This is the markov version of the cdc04 game            
%
%   S={s=sense, ns=not sensed by sensor}
%   A={a=attack,  na=not attack}
%   D={d=response,nd=no response}
%-------------------------------------------------------------------------
% By Tansu Alpcan
% Modified by Yee Wei Law 
%-------------------------------------------------------------------------

%clear;
% Define the transition probabilities
% If there is a vulnerability (1) or not (2)
% M(A), left stochastic matrix, M*x
% columns add up to one!
% alternative is right s.m, x*M
%

scenario = 3;
gammas = [0.1 0.9];
fpCost = 0.01; % cost of false positives

switch scenario
  case 1
    % M(a1,d1)
    M(:,:,1,1)=[6/14, 8/14; 7/35, 28/35];
    % M(a1,d2)
    M(:,:,1,2)=[4/9,  5/9;  4/40, 36/40];
    % M(a2,d1)
    M(:,:,2,1)=[6/14, 8/14; 7/35, 28/35];
    % M(a2,d2)
    M(:,:,2,2)=[6/14, 8/14; 7/35, 28/35];

    % state s0: G(s0) = [a1,d1 a1,d2; a2,d1 a2,d2]
    G(:,:,1)=[0, 0; 0, 0];	
    G(:,:,2)=[2, 2; 2, 2];
  case 2
    % M(a1,d1)
    M(:,:,1,1)=[43/45, 2/45; 2/4, 2/4];
    % M(a1,d2)
    M(:,:,1,2)=[34/39, 5/39; 5/10, 5/10];
    % M(a2,d1)
    M(:,:,2,1)=[43/45, 2/45; 2/4, 2/4];
    % M(a2,d2)
    M(:,:,2,2)=[34/39, 5/39; 5/10, 5/10];

    % state s0: G(s0) = [a1,d1 a1,d2; a2,d1 a2,d2]
    G(:,:,1)=fpCost*[44/46, 32/40; 44/46, 32/40];	
    G(:,:,2)=[2, 2; 2, 2];
  case 3
    % M(a1,d1)
    M(:,:,1,1)=[43/45, 2/45; 2/4, 2/4];
    % M(a1,d2)
    M(:,:,1,2)=[0/2, 2/2; 1/47, 46/47];
    % M(a2,d1)
    M(:,:,2,1)=[48/49, 1/49; 0, 0];
    % M(a2,d2)
    M(:,:,2,2)=[25/32, 7/32; 7/17, 10/17];

    % state s0: G(s0) = [a1,d1 a1,d2; a2,d1 a2,d2]
    G(:,:,1)=fpCost*[44/46, 0; 42/49, 24/33];	
    G(:,:,2)=[2, 2.5; 2, 2.15];
end

% display results

figure(299)
set(gcf, 'units', 'normalized')
set(gcf, 'position', [0.2, 0.2, 0.4, 0.2])
colormap(copper)

% [dummy,x,y]=zerosumgamesolver1(G(:,:,1));
% [dummy,xv,yv]=zerosumgamesolver1(G(:,:,2));
% subplot(2,2,1)
% bar([xv x])
% title('Attack Strategies for Static Game')
% xlabel('Actions')
% ylabel('Probability')
% set(gca,'XTickLabel',{'a1','a2'})
% legend('s0','s1')
% 
% subplot(2,2,2)
% bar([yv y])
% title('Defense Strategies for Static Game')
% xlabel('Actions')
% ylabel('Probability')
% set(gca,'XTickLabel',{'d1','d2'})
% legend('s0','s1')

subplot(1,2,1)
[sim,cpu_time] = newsecgamesolve2(M,G,gammas(1));
bar([sim.policy1 sim.policy2])
xlabel('Actions')
set(gca,'XTickLabel',{'a1, d1','a2, d2'})
ylabel('Probability')
legend({'Attacker','Defender'},'location','best')
set(gca, 'YGrid', 'on')

subplot(1,2,2)
[sim,cpu_time] = newsecgamesolve2(M,G,gammas(2));
bar([sim.policy1 sim.policy2])
xlabel('Actions')
set(gca,'XTickLabel',{'a1, d1','a2, d2'})
ylabel('Probability')
legend({'Attacker','Defender'},'location','best')
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

savefig(sprintf('allerton12-res%d.pdf', scenario), gcf, 'pdf')
