% Interpreted MATLAB function block for Simulink.
% Sampling time of this Simulink block should be set to 0.05s.
function deltaPl = ufls(area, t, deltaf, deltaPe, deltaPm)
% area = 1 or 2

global deltaPsafe aMaxShed aShedSoFar uflsInited logFile
persistent aTimer aScheduledShed aShedStack aLastUnstableTime

if t < 100
  deltaPl = deltaPe;
  return
end

if ~uflsInited
  aTimer = [0, 0];
  aScheduledShed = [0, 0];
  aShedStack = {[]; []};
  aLastUnstableTime = [0, 0];
  uflsInited = true;
end

if aTimer(area) > 0
  aTimer(area) = aTimer(area) - 1;
  if aTimer(area) == 0
    aShedSoFar(area) = aShedSoFar(area) + aScheduledShed(area);
    deltaPl = deltaPe - aShedSoFar(area);
    fprintf(logFile, '[%9.2f] UFLS %d sheds %f\n', t, area, aShedSoFar(area));
    aShedStack{area} = [aScheduledShed(area), aShedStack{area}];
  else
    deltaPl = deltaPe - aShedSoFar(area);
  end
  return
end

% The following will only be executed when timer == 0
deltaPest = deltaPm - deltaPe;
if deltaf <= -0.4
  aLastUnstableTime(area) = t;
  % deltaPest > 0 implies delta f < 0
  if 0 < deltaPest + deltaPsafe && aShedSoFar(area) < aMaxShed(area)
    aTimer(area) = 1;
    aScheduledShed(area) = min(deltaPest + deltaPsafe, aMaxShed(area) - aShedSoFar(area));
    deltaPl = deltaPe - aShedSoFar(area);
    fprintf(logFile, '[%9.2f] UFLS %d schedules level 1 %f + %f\n', ...
      t, area, aShedSoFar(area), aScheduledShed(area));
    return
  end
elseif -0.4 < deltaf && deltaf <= -0.35
  aLastUnstableTime(area) = t;
  % deltaPest > 0 implies delta f < 0
  if 0 < deltaPest + deltaPsafe && aShedSoFar(area) < aMaxShed(area)
    aTimer(area) = 2;
    aScheduledShed(area) = min(deltaPest + deltaPsafe, aMaxShed(area) - aShedSoFar(area));
    deltaPl = deltaPe - aShedSoFar(area);
    fprintf(logFile, '[%9.2f] UFLS %d schedules level 2 %f + %f\n', ...
      t, area, aShedSoFar(area), aScheduledShed(area));
    return
  end
elseif aShedSoFar(area) > 0 && t - aLastUnstableTime(area) >= 30
  fprintf(logFile, '[%9.2f] UFLS %d reconnects %f - %f\n', ...
    t, area, aShedSoFar(area), aShedStack{area}(1));
  if numel(aShedStack{area}) == 1
    aShedSoFar(area) = 0;
    aShedStack{area} = [];
  else
    aShedSoFar(area) = aShedSoFar(area) - aShedStack{area}(1);
    aShedStack{area} = aShedStack{area}(2:numel(aShedStack{area}));
  end
  deltaPl = deltaPe - aShedSoFar(area);
  return
end

deltaPl = deltaPe - aShedSoFar(area);
