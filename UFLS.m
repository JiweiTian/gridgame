% Interpreted MATLAB function block for Simulink.
% Sampling time of this Simulink block should be set to 0.05s.
function deltaPl = UFLS(t, deltaf, deltaPe, deltaPm)

global deltaPsafe maxShed1 logFile
persistent timer shedSoFar scheduledShed shedStack lastUnstableTime

if t <= 100
  timer = 0;
  shedSoFar = 0;
  scheduledShed = 0;
  shedStack = [];
  lastUnstableTime = 0;
  deltaPl = deltaPe;
  return
end

if timer > 0
  timer = timer - 1;
  if timer == 0
    shedSoFar = shedSoFar + scheduledShed;
    deltaPl = deltaPe - shedSoFar;
    fprintf(logFile, '[%9.2f] Shed %f\n', t, shedSoFar);
    shedStack = [scheduledShed; shedStack];
  else
    deltaPl = deltaPe - shedSoFar;
  end
  return
end

% The following will only be executed if timer == 0
deltaPest = deltaPm - deltaPe;
if deltaf <= -0.4
  lastUnstableTime = t;
  % deltaPest > 0 implies delta f < 0
  if 0 < deltaPest + deltaPsafe && shedSoFar < maxShed1
    timer = 1;
    scheduledShed = min(deltaPest + deltaPsafe, maxShed1 - shedSoFar);
    deltaPl = deltaPe - shedSoFar;
    fprintf(logFile, '[%9.2f] Scheduled level 1 %f + %f\n', t, shedSoFar, scheduledShed);
    return
  end
elseif -0.4 < deltaf && deltaf <= -0.35
  lastUnstableTime = t;
  % deltaPest > 0 implies delta f < 0
  if 0 < deltaPest + deltaPsafe && shedSoFar < maxShed1
    timer = 2;
    scheduledShed = min(deltaPest + deltaPsafe, maxShed1 - shedSoFar);
    deltaPl = deltaPe - shedSoFar;
    fprintf(logFile, '[%9.2f] Scheduled level 2 %f + %f\n', t, shedSoFar, scheduledShed);
    return
  end
elseif shedSoFar > 0 && t - lastUnstableTime >= 10
  fprintf(logFile, '[%9.2f] Load reconnected: %f - %f\n', t, shedSoFar, shedStack(1));
  if numel(shedStack) == 1
    shedSoFar = 0;
    shedStack = [];
  else
    shedSoFar = shedSoFar - shedStack(1);
    shedStack = shedStack(2:numel(shedStack));
  end
  deltaPl = deltaPe - shedSoFar;  
  return
end

deltaPl = deltaPe - shedSoFar;
