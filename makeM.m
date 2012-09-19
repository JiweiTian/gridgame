% This is for voltage control (STATCOM) games
time = Scope3.time;
loadShed = Scope3.signals(1,3).values;

M = zeros(2,2);
prevState = -1;
currState = -1;

begT = 0.5;
twindow = 0.5;
endT = begT + twindow;
i = 0;

while endT <= time(length(time))
  while true
    i = i + 1;
    if time(i) >= begT
      begI = i; break
    end
  end
  while true
    i = i + 1;
    if time(i) >= endT
      endI = i; break
    end
  end
  [tlen, energy] = recta(time(begI:endI), loadShed(begI:endI));
  if tlen > 0
    power = energy/tlen;
    currState = 2;
  else
    power = 0;
    currState = 1;
  end  
  fprintf('[%.1f:%.1f] %.4f | %.4f\n' , begT, endT, energy, power)
  if prevState > 0
    M(prevState,currState) = M(prevState,currState) + 1;
  end
  prevState = currState;
  
  begT = endT;
  endT = begT + twindow;
end