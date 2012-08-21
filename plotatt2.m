% Attack 2 - overcompensation: injects 8*deltaf

load('att2_8');

set(gcf, 'unit', 'normalized')
set(gcf, 'position', [0.5, 0.5, 0.4, 0.2])
begT = 250;
endT = 450;

subplot(1,2,1)
imin = time2Idx(att2_8_deltaf1.time, begT);
imax = time2Idx(att2_8_deltaf1.time, endT);
plot(att2_8_deltaf1.time(imin:imax), att2_8_deltaf1.signals.values(imin:imax))
%ylabel({'$\Delta f_1$, frequency deviation of area 1 (Hz)'}, 'interpreter', 'latex')
ylabel({'$\Delta f_1$ (Hz)'}, 'interpreter', 'latex')
xlabel('Time (s)')
grid on
%set(gca, 'outerposition', [0 0 0.5 1])

subplot(1,2,2)
imin = time2Idx(att2_8_Pshed1.time, begT);
imax = time2Idx(att2_8_Pshed1.time, endT);
plot(att2_8_Pshed1.time(imin:imax), att2_8_Pshed1.signals.values(imin:imax), 'linewidth', 2)
hold on
plot(att2_8_Pshed2.time(imin:imax), att2_8_Pshed2.signals.values(imin:imax), 'r--', 'linewidth', 2)
hold off
ylabel('Load shed (p.u.)')
xlabel('Time (s)')
legend({'Load shed in area 1', 'Load shed in area 2'}, 'location', 'northwest')
grid on
%set(gca, 'outerposition', [0.5 0 0.5 1])

savefig('agc-game-att2.pdf', gcf, 'pdf');