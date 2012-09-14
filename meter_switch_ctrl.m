% Disinfection is performed here because attack_statcom is only invoked
% when it's connected to the switch
function whichPort = meter_switch_ctrl(t)

global meterSwitchInited attDetected currMeter hacked
persistent transTime transTimer howLongToDisinfect disinfectTimer

if ~meterSwitchInited
  transTime = 0.1;
  transTimer = -1;
  howLongToDisinfect = 0.1;
  disinfectTimer = -1;
  meterSwitchInited = true;
end

if attDetected
  transTimer = t + transTime;
  disinfectTimer = transTimer + howLongToDisinfect;
  fprintf('[%.4f] start ditching and disinfecting %d\n', t, currMeter)
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
    fprintf('[%.4f] meter %d->%d\n', t, currMeter, otherMeter)
    currMeter = otherMeter;
  end
end

% finish disinfecting
if disinfectTimer > 0 && t >= disinfectTimer  
  disinfectTimer = -1;
  disinfected = mod(currMeter,2)+1;
  hacked(disinfected) = false;
  fprintf('[%.4f] finish disinfecting %d\n', t, disinfected);
end

whichPort = currMeter;