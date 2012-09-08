figure(1)
set(gcf, 'unit', 'normalized')
set(gcf, 'position', [0, 0, 1, 0.92])
nrows = 4;
ncols = 5;
begT = 1;
endT = 1.4999;

% normal case
imin = time2Idx(Scope3_norm.time, begT);
imax = time2Idx(Scope3_norm.time, endT);

subplot(nrows,ncols,1)
v4 = Scope3_norm.signals(1,2).values(imin:imax,4);
plot(Scope3_norm.time(imin:imax), v4)
title({sprintf('$V_{B4}$ (%d)', countcrossing(v4))},'interpreter','latex')
ylabel('p.u.'); xlabel('time (s)')
grid on
axis([1 1.1 0.82 1.00])

imin = time2Idx(Scope2_norm.time, begT);
imax = time2Idx(Scope2_norm.time, endT);

subplot(nrows,ncols,2)
iq = Scope2_norm.signals(1,1).values(imin:imax,1);
iqref = Scope2_norm.signals(1,1).values(imin:imax,2);
plot(Scope2_norm.time(imin:imax), iq-iqref)
title({sprintf('$I_q-I_{qref}$ (%d)', countcrossing(iq-iqref))},'interpreter','latex')
ylabel('A'); xlabel('time (s)')
grid on

subplot(nrows,ncols,3)
q = Scope2_norm.signals(1,2).values(imin:imax,2);
plot(Scope2_norm.time(imin:imax), q)
title({sprintf('$Q$ (%d)', countcrossing(q))},'interpreter','latex')
ylabel('MVA'); xlabel('time (s)')
grid on

subplot(nrows,ncols,4)
vdc = Scope2_norm.signals(1,3).values(imin:imax);
plot(Scope2_norm.time(imin:imax), vdc)
title({sprintf('$V_{dc}$ (%d)', countcrossing(vdc))},'interpreter','latex')
ylabel('V'); xlabel('time (s)')
grid on

subplot(nrows,ncols,5)
modidx = Scope2_norm.signals(1,4).values(imin:imax);
plot(Scope2_norm.time(imin:imax), modidx)
title(sprintf('Modulation index (%d)', countcrossing(modidx)))
ylabel(''); xlabel('time (s)')
grid on

% for k=1.2
imin = time2Idx(Scope3_1_2.time, begT);
imax = time2Idx(Scope3_1_2.time, endT);

subplot(nrows,ncols,6)
v4 = Scope3_1_2.signals(1,2).values(imin:imax,4);
plot(Scope3_1_2.time(imin:imax), v4)
title({sprintf('$V_{B4}$ (%d)', countcrossing(v4))},'interpreter','latex')
ylabel('p.u.'); xlabel('time (s)')
grid on
axis([1 1.1 0.82 1.00])

imin = time2Idx(Scope2_1_2.time, begT);
imax = time2Idx(Scope2_1_2.time, endT);

subplot(nrows,ncols,7)
iq = Scope2_1_2.signals(1,1).values(imin:imax,1);
iqref = Scope2_1_2.signals(1,1).values(imin:imax,2);
plot(Scope2_1_2.time(imin:imax), iq-iqref)
title({sprintf('$I_q-I_{qref}$ (%d)', countcrossing(iq-iqref))},'interpreter','latex')
ylabel('A'); xlabel('time (s)')
grid on

subplot(nrows,ncols,8)
q = Scope2_1_2.signals(1,2).values(imin:imax,2);
plot(Scope2_1_2.time(imin:imax), q)
title({sprintf('$Q$ (%d)', countcrossing(q))},'interpreter','latex')
ylabel('MVA'); xlabel('time (s)')
grid on

subplot(nrows,ncols,9)
vdc = Scope2_1_2.signals(1,3).values(imin:imax);
plot(Scope2_1_2.time(imin:imax), vdc)
title({sprintf('$V_{dc}$ (%d)', countcrossing(vdc))},'interpreter','latex')
ylabel('V'); xlabel('time (s)')
grid on

subplot(nrows,ncols,10)
modidx = Scope2_1_2.signals(1,4).values(imin:imax);
plot(Scope2_1_2.time(imin:imax), modidx)
title(sprintf('Modulation index (%d)', countcrossing(modidx)))
ylabel(''); xlabel('time (s)')
grid on

% for k=-1.2
imin = time2Idx(Scope3_n1_2.time, begT);
imax = time2Idx(Scope3_n1_2.time, endT);

subplot(nrows,ncols,11)
v4 = Scope3_n1_2.signals(1,2).values(imin:imax,4);
plot(Scope3_n1_2.time(imin:imax), v4)
title({sprintf('$V_{B4}$ (%d)', countcrossing(v4))},'interpreter','latex')
ylabel('p.u.'); xlabel('time (s)')
grid on
axis([1 1.1 0.82 1.00])

imin = time2Idx(Scope2_n1_2.time, begT);
imax = time2Idx(Scope2_n1_2.time, endT);

subplot(nrows,ncols,12)
iq = Scope2_n1_2.signals(1,1).values(imin:imax,1);
iqref = Scope2_n1_2.signals(1,1).values(imin:imax,2);
plot(Scope2_n1_2.time(imin:imax), iq-iqref)
title({sprintf('$I_q-I_{qref}$ (%d)', countcrossing(iq-iqref))},'interpreter','latex')
ylabel('A'); xlabel('time (s)')
grid on

subplot(nrows,ncols,13)
q = Scope2_n1_2.signals(1,2).values(imin:imax,2);
plot(Scope2_n1_2.time(imin:imax), q)
title({sprintf('$Q$ (%d)', countcrossing(q))},'interpreter','latex')
ylabel('MVA'); xlabel('time (s)')
grid on

subplot(nrows,ncols,14)
vdc = Scope2_n1_2.signals(1,3).values(imin:imax);
plot(Scope2_n1_2.time(imin:imax), vdc)
title({sprintf('$V_{dc}$ (%d)', countcrossing(vdc))},'interpreter','latex')
ylabel('V'); xlabel('time (s)')
grid on

subplot(nrows,ncols,15)
modidx = Scope2_n1_2.signals(1,4).values(imin:imax);
plot(Scope2_n1_2.time(imin:imax), modidx)
title(sprintf('Modulation index (%d)', countcrossing(modidx)))
ylabel(''); xlabel('time (s)')
grid on

% for k=-0.8
imin = time2Idx(Scope3_n0_8.time, begT);
imax = time2Idx(Scope3_n0_8.time, endT);

subplot(nrows,ncols,16)
v4 = Scope3_n0_8.signals(1,2).values(imin:imax,4);
plot(Scope3_n0_8.time(imin:imax), v4)
title({sprintf('$V_{B4}$ (%d)', countcrossing(v4))},'interpreter','latex')
ylabel('p.u.'); xlabel('time (s)')
grid on
axis([1 1.1 0.82 1.00])

imin = time2Idx(Scope2_n0_8.time, begT);
imax = time2Idx(Scope2_n0_8.time, endT);

subplot(nrows,ncols,17)
iq = Scope2_n0_8.signals(1,1).values(imin:imax,1);
iqref = Scope2_n0_8.signals(1,1).values(imin:imax,2);
plot(Scope2_n0_8.time(imin:imax), iq-iqref)
title({sprintf('$I_q-I_{qref}$ (%d)', countcrossing(iq-iqref))},'interpreter','latex')
ylabel('A'); xlabel('time (s)')
grid on

subplot(nrows,ncols,18)
q = Scope2_n0_8.signals(1,2).values(imin:imax,2);
plot(Scope2_n0_8.time(imin:imax), q)
title({sprintf('$Q$ (%d)', countcrossing(q))},'interpreter','latex')
ylabel('MVA'); xlabel('time (s)')
grid on

subplot(nrows,ncols,19)
vdc = Scope2_n0_8.signals(1,3).values(imin:imax);
plot(Scope2_n0_8.time(imin:imax), vdc)
title({sprintf('$V_{dc}$ (%d)', countcrossing(vdc))},'interpreter','latex')
ylabel('V'); xlabel('time (s)')
grid on

subplot(nrows,ncols,20)
modidx = Scope2_n0_8.signals(1,4).values(imin:imax);
plot(Scope2_n0_8.time(imin:imax), modidx)
title(sprintf('Modulation index (%d)', countcrossing(modidx)))
ylabel(''); xlabel('time (s)')
grid on
