function y = meter(id, t, deltaf)
% y = [out, attack]
% out = output deltaf
% attack = 1 indicates "out" is malicious
% This script is run for both meters, so be careful!

global N currMeter nSamples flaggedMeter attackerInited logFile
persistent states buffers attRates timers
persistent actionpmf
maxTicks = 10*N;	% number of ticks required to compromise meter

if t < 100
  y = [deltaf, 0];
  return
end

% initialize persistent variables
if ~attackerInited
  states = [1; 0];  % 1 = compromised
  buffers = {[], []};
  attRates = [0; 0];
  timers = [0; 0];
  %actionpmf = 1/N * ones(N,1); % uniform distribution, change if necessary
  actionpmf = zeros(N,1); actionpmf(N) = 1;
  attackerInited = true;
end

if currMeter == id
	%- - - - it's my report session - - - -
	% which sample am I dealing with?
	if nSamples == 1
		if states(id) == 1
			% choose pollution rate
			[~, action] = histc(rand(1), [0;cumsum(actionpmf)]);
			attRates(id) = 1/N * action;
			%attRates(id) = 0;  % test
		else
			attRates(id) = 0;
		end
		% clear history
		buffers{id} = [];
	end

	if attRates(id) == 0
    %- - - - no attack - - - -
		y = [deltaf, 0];
		buffers{id} = [buffers{id}; 0];
  else
    %- - - - attack - - - -
		if rand(1) <= attRates(id)
			y = [-4.5*(deltaf < 0) + 3.5*(deltaf >= 0), 1];
			buffers{id} = [buffers{id}; 1];
		else
			y = [deltaf, 0];
			buffers{id} = [buffers{id}; 0];
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
		timers(id) = maxTicks;
    fprintf(logFile, '[%9.2f] Meter %d compromise starts\n', t, id);
  end  
  % not compromising -- start timer
  if timers(id) == 0 && states(id) == 0
    timers(id) = maxTicks;
    fprintf(logFile, '[%9.2f] Meter %d compromise starts\n', t, id);
  end
  y = [deltaf, 0];
end