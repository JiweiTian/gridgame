function out = attacker_statcom(id, t, vina, vinb, vinc)

global attackerInited hacked currMeter
persistent action kvec b howLongToHack timer

if ~attackerInited
  action = 1; % CHANGE ME
  switch action
    case 1
      kvec = [1.1];
    case 2
      kvec = [1.2];
    otherwise
      kvec = [-0.8];
  end
  b = 0;
  howLongToHack = 0.5;
  % howLongToHack = 0.01;
  timer = -1;
  attackerInited = true;
end

if currMeter == id && ~hacked(id)
  if timer < 0
    % start hacking
    timer = t + howLongToHack;
    fprintf('[%.4f] %d: begin hacking\n', t, id);
  elseif timer > 0 && t >= timer
    % finish hacking
    timer = -1;
    hacked(id) = true;
    fprintf('[%.4f] %d: done hacking\n', t, id);
  end
end

if hacked(id)
  vout = kvec(randi(numel(kvec),1))*[vina, vinb, vinc] + b*ones(1,3);
  out = [vout, 1];
else
  out = [vina, vinb, vinc, 0];
end