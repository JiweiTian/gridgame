% Interpreted MATLAB function block for Simulink.
% Sampling time of this Simulink block should be set to 0.05s.
function toShed = UFLS(t, deltaf, deltaPest)

global deltaPsafe
persistent timer shedSoFar scheduledShed lastUnstableTime

if t <= 100
  timer = 0;
  shedSoFar = 0;
  scheduledShed = 0;
  lastUnstableTime = 0;
  toShed = 0;
  return
end

if timer > 0
  timer = timer - 1;
  if timer == 0
    shedSoFar = shedSoFar + scheduledShed;
    toShed = shedSoFar;
    fprintf('[%8.2f] Shed %f\n', t, toShed)
  else
    toShed = shedSoFar;
  end
  return
end

% The following will only be executed if timer == 0
if deltaf <= -0.4
  lastUnstableTime = t;
  if deltaPest + deltaPsafe > 0 % deltaPest > 0 implies delta f < 0
    timer = 1;
    scheduledShed = deltaPest + deltaPsafe;
    toShed = shedSoFar;
    fprintf('[%8.2f] Scheduled level 1 %f + %f\n', t, shedSoFar, scheduledShed)
    return
  end
elseif -0.4 < deltaf && deltaf <= -0.35
  lastUnstableTime = t;
  if deltaPest + deltaPsafe > 0 % deltaPest > 0 implies delta f < 0
    timer = 2;
    scheduledShed = deltaPest + deltaPsafe;
    toShed = shedSoFar;
    fprintf('[%8.2f] Scheduled level 2 %f + %f\n', t, shedSoFar, scheduledShed)
    return
  end
elseif shedSoFar > 0 && t - lastUnstableTime >= 30
  shedSoFar = 0;
  toShed = 0;
  fprintf('[%8.2f] Load reconnected\n', t)
  return
end

toShed = shedSoFar;
