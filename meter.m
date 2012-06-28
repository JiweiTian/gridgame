function y = meter(id, t, deltaf)
% y = [out, attack]
% out = output deltaf
% attack = 1 indicates "out" is malicious
% This script is run for both meters, so be careful!

global N currMeter nSamples flaggedMeter attackerInited logFile
persistent states buffers targetSamples timers
%persistent actionpmf
persistent randStream
maxTicks = [2*N, 10*N];  % number of ticks required to compromise meter

if t < 100
  y = [deltaf, 0];
  return
end

% initialize persistent variables
if ~attackerInited
  states = [1, 0];  % 1 = compromised
  buffers = {[]; []};
  targetSamples = {[]; []};
  timers = [0, 0];
  %actionpmf = 1/N * ones(1,N); % uniform distribution, change if necessary
  randStream = RandStream('mt19937ar','seed',0);
  attackerInited = true;
end

if currMeter == id
  %- - - - it's my report session - - - -
  % which sample am I dealing with?
  if nSamples == 1
    if states(id) == 1
      % choose pollution rate
      %[~, action] = histc(rand(1), [0, cumsum(actionpmf)]);
      action = 20; % test
      targetSamples{id} = sort(randperm(randStream, N, action));
    end
    % clear history
    buffers{id} = [];
  end

  if isempty(targetSamples{id})
    %- - - - no attack - - - -
    y = [deltaf, 0];
    buffers{id} = [buffers{id}, 0];
  else
    %- - - - attack - - - -
    if nSamples == targetSamples{id}(1)
      targetSamples{id} = targetSamples{id}(2:numel(targetSamples{id}));
      y = [-4.5*(deltaf < 0) + 3.5*(deltaf >= 0), 1];
      %y = [8*deltaf, 1]; % test
      buffers{id} = [buffers{id}, 1];
    else
      y = [deltaf, 0];
      buffers{id} = [buffers{id}, 0];
    end
  end

  if nSamples == N
    attCnt = sum(buffers{id}>0);
    if attCnt > 0
      fprintf(logFile, '[%9.2f] Meter %d corrupts %d/%d\n', t, id, attCnt, N);
    end
  end
else
  %- - - - not my report session - - - -
  % compromising -- decrement timer
  if timers(id) > 0
    timers(id) = timers(id) - 1;
    if timers(id) == 0
      states(id) = 1;
      fprintf(logFile, '[%9.2f] Meter %d compromise completes\n', t, id);
    end
  end
  % has attack been detected?
  if flaggedMeter == id
    flaggedMeter = 0; % reset
    states(id) = 0;
    % start compromising me again
    timers(id) = maxTicks(id);
    fprintf(logFile, '[%9.2f] Meter %d compromise starts\n', t, id);
  end  
  % not compromising -- start timer
  if timers(id) == 0 && states(id) == 0
    timers(id) = maxTicks(id);
    fprintf(logFile, '[%9.2f] Meter %d compromise starts\n', t, id);
  end
  y = [deltaf, 0];
end
