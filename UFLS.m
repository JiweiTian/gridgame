function toShed = UFLS(t, deltaf)
% See P. M. Anderson et al., "An adatpive method for setting underfrequency
% load shedding relays," IEEE Transactions on Power Systems 7(2):647-655, 1992

global totalLoad2Shed firstLoad2Shed lastLoad2Shed uflsMinDeltaF 
persistent uflsOn lastShed startTime

toShed = 0;

if t <= 100
  uflsOn = false;
  lastShed = 0;
  startTime = 0;
  return
end

if -0.5 < deltaf
  if uflsOn == true && t - startTime >= 10
    uflsOn = false;
    toShed = 0;
    fprintf('[%10.2f] Load reconnected\n', t)
  end
elseif -0.8 < deltaf && deltaf <= -0.5
  if uflsOn == false
    uflsOn = true;
    toShed = firstLoad2Shed;
    lastShed = toShed;
    startTime = t;
    fprintf('[%10.2f] First stage: %f\n', t, toShed)
  end
elseif deltaf <= uflsMinDeltaF
  if uflsOn == true
    if totalLoad2Shed > lastShed + lastLoad2Shed
      toShed = lastShed + lastLoad2Shed;
      lastShed = toShed;
      fprintf('[%10.2f] Final stage: %f\n', t, toShed)
    end
  end
else
  if uflsOn == true
    if totalLoad2Shed > lastShed + 0.1
      toShed = lastShed + 0.1;
      lastShed = toShed;
      fprintf('[%10.2f] Intermediate stage: %f\n', t, toShed)
    end
  end
end
