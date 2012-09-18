% Disinfection is performed here because attack_statcom is only invoked
% when it's connected to the switch
function out = meter_switch_ctrl(t, loadShed)

global meterSwitchInited attDetected currMeter hacked
persistent transTime transTimer howLongToDisinfect disinfectTimer

if ~meterSwitchInited
  transTime = 0.1;
  transTimer = -1;
  howLongToDisinfect = 1;
  disinfectTimer = -1;
  meterSwitchInited = true;
end

if attDetected
  transTimer = t + transTime;
  disinfectTimer = transTimer + howLongToDisinfect;
  if loadShed
    fprintf('[%.4f] start ditching and disinfecting %d, and reconnecting load\n', t, currMeter)
  else
    fprintf('[%.4f] start ditching and disinfecting %d\n', t, currMeter)
  end
  attDetected = false;
end

% finish transitioning to the other meter
if transTimer > 0 && t >= transTimer
  otherMeter = mod(currMeter,2)+1;
  if hacked(otherMeter)
    transTimer = transTimer + transTime;
    fprintf('[%.4f] %d is not ready\n', t, otherMeter)
  else
    transTimer = -1;
    if loadShed
      fprintf('[%.4f] meter %d->%d, load reconnected\n', t, currMeter, otherMeter)
    else
      fprintf('[%.4f] meter %d->%d\n', t, currMeter, otherMeter)
    end
    currMeter = otherMeter;
  end
end

% finish disinfecting
if disinfectTimer > 0 && t >= disinfectTimer  
  disinfectTimer = -1;
  disinfected = mod(currMeter,2)+1;
  hacked(disinfected) = false;
  fprintf('[%.4f] done disinfecting %d\n', t, disinfected);
end

whichPort = currMeter;
loadRecon = (transTimer > 0)*1;

out = [whichPort, loadRecon];