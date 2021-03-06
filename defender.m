function out = defender(t, in, attack)
% attack == 1 indicates "in" is malicious

global N currMeter nSamples flaggedMeter defenderInited aShedSoFar logFile
persistent buf      % a buffer of N samples
persistent a1 b1 a2 b2 detAlgos
persistent actionpmf

if t < 100
  out = in;
  return
end

% initialize persistent variables
if ~defenderInited
  detAlgos = {};

  % Detection Algorithm 1
  a1 = 0.2; b1 = 0.8127; detAlgos{1} = @(x) 1 - a1.^((x/N).^b1);

  % Detection Algorithm 2
  a2 = 20; b2 = 0.5203; detAlgos{2} = @(x) 1./(1+exp(-a2*(x/N-b2)));
  
  actionpmf = [1, 0];	% probability mass function of actions

  defenderInited = true;
end

% which sample am I dealing with?
if nSamples == 1
  buf = [];
  if sum(aShedSoFar) > 0
    fprintf(logFile, '[%9.2f] Session start: s1\n', t);
  else
    fprintf(logFile, '[%9.2f] Session start: s0\n', t);
  end
end

% buffer attack flag
buf = [buf, attack];

if nSamples == N
  % which Detection Algorithm should I use?
  [~, action] = histc(rand(1), [0, cumsum(actionpmf)]);
  detAlgo = detAlgos{action};
  attRate = sum(buf>0);
  detProb = detAlgo(attRate);
  flaggedMeter = currMeter * (rand(1) <= detProb);
  if flaggedMeter > 0
    fprintf(logFile, '[%9.2f] Algo %d detects meter %d attack rate %d/%d @ prob %f\n', ...
      t, action, flaggedMeter, attRate, N, detProb);
  end
  if currMeter == 1
    currMeter = 2;
    set_param('BevraniAGC2/Attacker/Meter switch', 'sw', '0');
  else
    currMeter = 1;
    set_param('BevraniAGC2/Attacker/Meter switch', 'sw', '1');
  end
  if sum(aShedSoFar) > 0
    fprintf(logFile, '[%9.2f] Session end: s1\n', t);
  else
    fprintf(logFile, '[%9.2f] Session end: s0\n', t);
  end  
end

nSamples = mod(nSamples, N)+1;

out = in;