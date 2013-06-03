% Solving a zero-sum game with linear programming 
%          
% Arguments --------------------------------------------------------------
%   B(Nx,Ny)=cost matrix (of P1)
%   Nx: nbr of actions of P1 (maximizer, row chooser)
%   Ny: nbr of actions of P2 (minimizer, column chooser)
% Evaluation -------------------------------------------------------------
%   J=x^T A y = saddle point value of the game
%   x         = optimal policy vector of P1
%   y         = optimal policy vector of P2
%-------------------------------------------------------------------------
% By Tansu Alpcan based on M J Chlond's script
%-------------------------------------------------------------------------

function [J,x,y]=tzsgsolver2(B);

% find vector sizes
[rownbr, colnbr]=size(B);


% Solve ZS game

%maximizer, attacker, row

f=[-1 zeros(1,rownbr)];
b=zeros(rownbr,1);
A=[ones(rownbr,1) -B'];
Aeq=[0 ones(1,rownbr)];
beq=1;
lb=[-10^12; zeros(rownbr,1)];
ub=[10^12; ones(rownbr,1)];
x0=[0 ; (1/rownbr)*ones(rownbr,1)];
options = optimset('LargeScale','off','Display','off'); % run medium-scale algorithm
res1 = linprog(f,A,b,Aeq,beq,lb,ub,x0,options);
v=res1(1);
x=res1(2:rownbr+1);


%minimizer, defender, column
f=[1 zeros(1,rownbr)];
b=zeros(rownbr,1);
A=[-ones(rownbr,1) B];
Aeq=[0 ones(1,rownbr)];
beq=1;
lb=[-10^9; zeros(rownbr,1)];
ub=[10^9; ones(rownbr,1)];
x0=[0 ; (1/rownbr)*ones(rownbr,1)];
options = optimset('LargeScale','off','Display','off'); % run medium-scale algorithm
res2 = linprog(f,A,b,Aeq,beq,lb,ub,x0,options);
w=res2(1);
y=res2(2:rownbr+1);

if abs(v-w)>0.01
    display('Problem with solution!')
end
J=x'*B*y;

