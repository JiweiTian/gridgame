function vout = attacker_statcom(t, vina, vinb, vinc)

global attackerInited
persistent k b howLongToHack timeout

if ~attackerInited
  k = 1.2;
  b = 0;
  howLongToHack = 0.1;
  timeout = -1;
  attackerInited = true;
end

vout = k*[vina, vinb, vinc] + b*ones(1,3);

if get_param('dstatcom_avg/game/meter_switch', 'sw') == '0' 
  if timeout < 0
    fprintf('t=%f: start hacking\n', t);
    timeout = t + howLongToHack;
  elseif t >= timeout
    fprintf('t=%f: Hacked!\n', t);
    set_param('dstatcom_avg/game/meter_switch', 'sw', '1');
    timeout = -1;
  end
end