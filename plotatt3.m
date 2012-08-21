% Attack 3 - negative compensation: injects -1*deltaf and -1.2*deltaf

load('att3_n1');
load('att3_n1_2');
set(gcf, 'unit', 'normalized')
set(gcf, 'position', [0.5, 0.5, 0.2, 0.21])
begT = 250;
endT = 450;

imin = time2Idx(att3_n1_deltaf1.time, begT);
imax = time2Idx(att3_n1_deltaf1.time, endT);
plot(att3_n1_deltaf1.time(imin:imax), att3_n1_deltaf1.signals.values(imin:imax), 'linewidth', 1)
hold on

imin = time2Idx(att3_n1_2_deltaf1.time, begT);
imax = time2Idx(att3_n1_2_deltaf1.time, endT);
plot(att3_n1_2_deltaf1.time(imin:imax), att3_n1_2_deltaf1.signals.values(imin:imax), 'r--', 'linewidth', 1)
hold off

ylabel({'$\Delta f_1$ (Hz)'}, 'interpreter', 'latex')
xlabel('Time (s)')
legend({'$\Delta f_1$ for $k=1$', '$\Delta f_1$ for $k=1.2$'}, 'location', 'northwest', 'interpreter', 'latex')
grid on

savefig('agc-game-att3.pdf', gcf, 'pdf');