function toShed = UFLS(t, deltaf)
% See P. M. Anderson et al., "An adatpive method for setting underfrequency
% load shedding relays," IEEE Transactions on Power Systems 7(2):647-655, 1992

global totalLoad2Shed firstLoad2Shed
persistent stage % 0: no UFLS; 1: first; 2: intermediate; 3: final
persistent lastShed lastUnstableTime lastStableTime

if t <= 100
  stage = 0;
  toShed = 0;
  lastShed = 0;
  lastUnstableTime = 0;
  lastStableTime = 0;
  return
end

if -0.5 < deltaf
  if stage > 0 && deltaf < 0.5 && t - lastUnstableTime >= 10
    stage = 0;
    toShed = lastShed - 0.1;
    lastShed = toShed;
    fprintf('[%10.2f] Load reconnected1: %f\n', t, toShed)
    lastStableTime = t;
    return
  end
  if stage == 0
    if lastShed >= 0.1
      toShed = lastShed - 0.1;
      lastShed = toShed;
      fprintf('[%10.2f] Load reconnected2: %f\n', t, toShed)
      return
    elseif lastShed > 0
      toShed = 0;
      lastShed = 0;
      fprintf('[%10.2f] Load reconnected3: %f\n', t, toShed)
      return
    end
  end
elseif deltaf <= -0.5% && t - lastStableTime >= 1
  lastUnstableTime = t;
  if stage == 0    
    if ~(lastShed > 0)
      stage = 1;
      toShed = firstLoad2Shed;
      lastShed = toShed;
      fprintf('[%10.2f] First stage: %f\n', t, toShed)
      return
    end
  end
elseif delta <= -0.8
  if stage == 1 || stage == 2    
    if totalLoad2Shed > lastShed + 0.1
      stage = 2;
      toShed = lastShed + 0.1;
      lastShed = toShed;
      fprintf('[%10.2f] Intermediate stage: %f\n', t, toShed)
      return
    else
      stage = 3;
      toShed = totalLoad2Shed;
      lastShed = toShed;
      fprintf('[%10.2f] Final stage: %f\n', t, toShed)
      return
    end
  end
end

toShed = lastShed;
