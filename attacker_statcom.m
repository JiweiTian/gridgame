function out = attacker_statcom(id, t, vina, vinb, vinc)

global attackerInited hacked currMeter
persistent kvec b howLongToHack timer

if ~attackerInited
  kvec = [1.1];
  b = 0;
  howLongToHack = 0.2;
  timer = -1;
  attackerInited = true;
end

if currMeter == id && ~hacked(id)
  if timer < 0
    % start hacking
    timer = t + howLongToHack;
    fprintf('[%.4f] start hacking %d\n', t, id);
  elseif timer > 0 && t >= timer
    % finish hacking
    timer = -1;
    hacked(id) = true;
    fprintf('[%.4f] finish hacking %d\n', t, id);
  end
end

if hacked(id)
  vout = kvec(randi(numel(kvec),1))*[vina, vinb, vinc] + b*ones(1,3);
  out = [vout, 1];
else
  out = [vina, vinb, vinc, 0];
end