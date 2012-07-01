N = 20;

x = 1:N;
figure(200)

a1 = 20; b1 = 0.5203; p1 = 1./(1+exp(-a1*(x/N-b1)));
%a1 = 1.2; b1 = 20; c1 = 0.75; p1 = 1./(a1+exp(-b1*(x/N-c1)));
plot(x, p1, 'b.', 'linewidth', 2);
hold on

%p2 = 1-exp(-a2.*(x/N).^b2);
%p2 = 2./(3+exp(-a2*(x/N-b2)));
a2 = 0.2; b2 = 0.8127; p2 = 1 - a2.^((x/N).^b2);
%a2 = 0.4; b2 = 1; p2 = 1 - a2.^((x/N).^b2);
plot(x, p2, 'r+', 'linewidth', 2);
hold off
legend({'Algo 1', 'Algo 2'}, 'location', 'northwest')

%p3 = exp(-10000*exp(-20*(x/N)));
%plot(x, p3, 'g*')
%legend({'Algo 1', 'Algo 2', 'test'}, 'location', 'northwest')
%hold off

ylabel('Attack detection probability')
xlabel({'\# malicious samples in $N$ latest samples'}, 'interpreter', 'latex')
grid on