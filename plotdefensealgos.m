N_D = 20;
a_D = 20;
b_D = 0.5;
b_P = log(log(0.1)/log(0.5))/log(5)
a_P = -log(0.5)/10^b_P

subplot(1,2,1)
x = 0:1:N_D;
P_D = 1./(1+exp(-a_D*(x/N_D-b_D)));
plot(x, P_D, '.');
ylabel('Attack detection probability')
xlabel({'\# malicious samples in $N_D$ latest samples'}, 'interpreter', 'latex')
grid on

subplot(1,2,2)
N_P = 0:1:50;
P_P = 1-exp(-a_P.*N_P.^b_P);
plot(N_P, P_P, '.');
ylabel({'$\Pr[|\Delta\hat{f}-\Delta f|<0.1|N_P]$'}, 'interpreter', 'latex')
xlabel({'$N_P$'}, 'interpreter', 'latex')
grid on