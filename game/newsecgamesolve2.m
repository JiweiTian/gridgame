% secgamesolve1  
%           Solving a zero-sum Markov game where environment
%           depends on actions of first player (maximizer,row) only.
% 
% Arguments --------------------------------------------------------------
% Let S = number of states, A = number of actions
%   M(SxSxA1) = transition matrix depends only on action of one player
%   G(SxA1xA2) = cost matrix
%   alpha = discount rate, in ]0; 1[
% Evaluation -------------------------------------------------------------
%   J(S)       = vector of optimal values for each state
%   policy1(S) = optimal policy (stochastic)
%   policy2(S) = optimal policy (stochastic)
%   cpu_time   = used CPU time
%-------------------------------------------------------------------------
% By Tansu Alpcan 
%-------------------------------------------------------------------------

function [sim,cpu_time] = newsecgamesolve2(M,G,alpha)

cpu_time = cputime;     % to assess algorithm duration

%% Define sim data structure
sim.M=M;    
sim.G=G;            
sim.alpha=alpha;
sim.S=size(G,1); %nbr of states (rows=columns=size(G,2))
sim.A=[size(G,1), size(G,2)] ; %nbr of actions of players

% init lookup table for Q-factor
%Q=zeros(sim.A(1),sim.A(2),sim.S);
Q=G;    %meaningful init!

% init
% policies column per state
policy1=(1/sim.A(1))*ones(sim.A(1),sim.S);      % stochastic version  
policy2=(1/sim.A(2))*ones(sim.A(2),sim.S);      % stochastic version
max_iter=100;     % maximum number of iterations allowed.
done = 0;          % flag
i=0;               % iteration number

% This is the decaying rate for DP iteration
sim.alpha=alpha;           


% Main iteration loop
while ~done
    
    i=i+1; %nbr of iterations updated
    % maybe one can add another stopping criterion
    % therefore not a simple for loop!
    
    % solve zeros sum game for each state to find V(s)!
    V=zeros(sim.S,1);          
    for state=1:sim.S %iterate over states
        [V(state),x,y]=zerosumgamesolver1(Q(:,:,state));
        policy1(:,state)=x;
        policy2(:,state)=y;
    end
    
    % now iterate Q
    % This is where one determines 
    % how M depends on player actions!
    temp=zeros(sim.A(1),sim.A(2),sim.S);
    for k=1:sim.A(1)        %P1
        for m=1:sim.A(2)    %P2
            temp(k,m,:)=M(:,:,k,m)*V;
            %disp(temp)
        end
    end
    Qold=Q;
    Q=G+sim.alpha*temp;
    if max(max(abs(Q-Qold)))<0.05
        done=1;
    end
    
    
    % stopping criterion
    if i>max_iter
        disp('maximum iteration')
        done=1;
    end
end

cpu_time = cputime - cpu_time; % display time of algorithm


%% store time series in sim structure

sim.policy1=policy1;
sim.policy2=policy2;
sim.Q=Q;
sim.Qold=Qold;
sim.V=V;
sim.iter=i;

% display
%plot([Jstore1 Jstore2]);


