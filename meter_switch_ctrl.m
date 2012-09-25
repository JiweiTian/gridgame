% Disinfection is performed here because attack_statcom is only invoked
% when it's connected to the switch
function out = meter_switch_ctrl(t, loadShed)

global meterSwitchInited attDetected currMeter hacked
persistent howLongToTrans transTimer
persistent howLongToDisinfect disinfectTimer
persistent howLongToReconn reconnTimer

if ~meterSwitchInited
  howLongToTrans = 0.1;
  transTimer = -1;
  howLongToDisinfect = 0.5;
  % howLongToDisinfect = 1;
  disinfectTimer = -1;
  howLongToReconn = 0.1;
  reconnTimer = -1;
  meterSwitchInited = true;
end

if attDetected
  transTimer = t + howLongToTrans;
  fprintf('[%.4f] %d: begin ->%d\n', t, currMeter, mod(currMeter,2)+1)
  attDetected = false;
end

% done reconnecting load
if reconnTimer > 0 && t >= reconnTimer
  reconnTimer = -1;
end

% done disinfecting
if disinfectTimer > 0 && t >= disinfectTimer  
  disinfectTimer = -1;
  disinfected = mod(currMeter,2)+1;
  hacked(disinfected) = false;
  fprintf('[%.4f] %d: done disinfecting %d, begin reconn load\n', t, currMeter, disinfected);
  reconnTimer = t + howLongToReconn; % it's only meaningful by now
end

% done transitioning to the other meter
if transTimer > 0 && t >= transTimer
  otherMeter = mod(currMeter,2)+1;
  if hacked(otherMeter)
    transTimer = transTimer + howLongToTrans;
    fprintf('[%.4f] %d: %d is not ready\n', t, currMeter, otherMeter)
  else
    transTimer = -1;
    disinfectTimer = t + howLongToDisinfect;  
    fprintf('[%.4f] %d: done ->%d, begin disinfecting %d\n', t, otherMeter, otherMeter, currMeter)
    currMeter = otherMeter;
  end
end

out = [currMeter, (loadShed && reconnTimer > 0), (~hacked(mod(currMeter,2)+1) && disinfectTimer > 0)];