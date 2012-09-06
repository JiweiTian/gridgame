for i=1:numel(deltaf1.time)
  if deltaf1.time(i) > 100
    break
  end
end

imin = i;
imax = numel(deltaf1.signals.values);
fprintf('mindeltaf1=%f, maxdeltaf1=%f\n', ...
  min(deltaf1.signals.values(imin:imax)), max(deltaf1.signals.values(imin:imax)))

figure(1)
set(gcf, 'unit', 'normalized')
set(gcf, 'position', [0.5, 0.5, 0.35, 0.4])
begT = 100;
endT = 599.99;

subplot(2,2,1)
imin = time2Idx(corruptedFreq.time, begT);
imax = time2Idx(corruptedFreq.time, endT);
plot(corruptedFreq.time(imin:imax), corruptedFreq.signals.values(imin:imax))
title({'Corrupted $\Delta f_1$'},'interpreter','latex')
ylabel('Hz'); xlabel('time (s)')
grid on

subplot(2,2,3)
imin = time2Idx(deltaf1.time, begT);
imax = time2Idx(deltaf1.time, endT);
plot(deltaf1.time(imin:imax), deltaf1.signals.values(imin:imax))
title({'$\Delta f_1$'},'interpreter','latex')
ylabel('Hz'); xlabel('time (s)')
grid on

subplot(2,2,2)
imin = time2Idx(Pshed1.time, begT);
imax = time2Idx(Pshed1.time, endT);
plot(Pshed1.time(imin:imax), Pshed1.signals.values(imin:imax), 'r', 'linewidth', 1.5)
hold on
plot(Pshed1.time(imin:imax), deltaPe1.signals.values(imin:imax), 'b')
hold off
title('Area 1'); ylabel('p.u.'); xlabel('time (s)')
legend({'Shed load', 'Demand'},'location','best')
grid on

subplot(2,2,4)
%imin = time2Idx(Pshed2.time, begT);
%imax = time2Idx(Pshed2.time, endT);
plot(Pshed2.time(imin:imax), Pshed2.signals.values(imin:imax), 'r', 'linewidth', 1.5)
hold on
plot(Pshed2.time(imin:imax), deltaPe2.signals.values(imin:imax), 'b')
hold off
title('Area 2'); ylabel('p.u.'); xlabel('time (s)')
legend({'Shed load', 'Demand'},'location','best')
grid on

time = Pshed1.time(imin:imax);
shedSum = Pshed1.signals.values(imin:imax) + Pshed2.signals.values(imin:imax);
[s1len,s1area] = recta(time, shedSum);
if s1len > 0; res = s1area/s1len; else res = 0; end
fprintf(1, 'G_{a,d}(s_1)=%.4f\n', res);
%[s1len1,s1area1] = recta(Pshed1.time(imin:imax), Pshed1.signals.values(imin:imax));
%[s1len2,s1area2] = recta(Pshed2.time(imin:imax), Pshed2.signals.values(imin:imax));
%if s1len1 > 0; forarea1 = s1area1/s1len1; else forarea1 = 0; end
%if s1len2 > 0; forarea2 = s1area2/s1len2; else forarea2 = 0; end
%fprintf(1, 'G_{a,d}(s_1)=%f\n', forarea1+forarea2);

demandSum = deltaPe1.signals.values(imin:imax) + deltaPe2.signals.values(imin:imax);
[s0len,s0area] = rectb(time, demandSum, shedSum);
if s0len > 0; res = -s0area/s0len; else res = 0; end
fprintf(1, 'G_{a,d}(s_0)=%.4f\n', res);
%[s0len1,s0area1] = rectb(Pshed1.time(imin:imax), deltaPe1.signals.values(imin:imax), shedSum);
%[s0len2,s0area2] = rectb(Pshed2.time(imin:imax), deltaPe2.signals.values(imin:imax), shedSum);
%if s0len1 > 0; forarea1 = s0area1/s0len1; else forarea1 = 0; end
%if s0len2 > 0; forarea2 = s0area2/s0len2; else forarea2 = 0; end
%fprintf(1, 'G_{a,d}(s_0)=-%f\n', forarea1+forarea2);

% sanity check
fprintf(1, 'expected=%f, s1len+s0len=%f\n', ...
  time(numel(time))-time(1), s1len+s0len);