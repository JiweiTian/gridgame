% Taking input parameters from a mask will screw up your output
function defender_statcom(t, flag, iq, iqref, loadShed)

global defenderInited attDetected currMeter
persistent action twindow timer zcThresh
% persistent fftThresh1 fftThresh2
persistent tbuf fbuf dbuf

disabled = false;

if t < 0.5 || disabled
  return
end

if ~defenderInited
  twindow = 0.50; 
  action = 1; % CHANGE ME
  switch action
    case 1
      zcThresh = 11;
      %zcThresh = 42;
    case 2
      zcThresh = 12;
      %zcThresh = 49;
  end
  % fftThresh1 = 10; fftThresh2 = 0.15;
  timer = 0.5 + twindow;
  tbuf = [];
  fbuf = [];
  dbuf = [];
  fprintf('[%.4f] %d: session begin\n', t, currMeter);
  defenderInited = true;
end

tbuf = [tbuf, t];
fbuf = [fbuf, flag];
dbuf = [dbuf, iq-iqref];

if t >= timer
  nCrossings = countcrossing(dbuf);
  % rapid oscillations indicate k->-1.2
  if nCrossings >= zcThresh
    attDetected = true;
  % % else we need to look at how sinuisoidal dbuf samples are
  % else
  %   L = numel(dbuf);
  %   %Fs = 1/mean(tbuf(2:L)-tbuf(1:(L-1)));
  %   NFFT = 2^nextpow2(L); % Next power of 2 from length of y
  %   Y = fft(dbuf,NFFT)/L;
  %   absY = 2*abs(Y(1:NFFT/2+1));
  %   f = Fs/2*linspace(0,1,NFFT/2+1);
  %   [maxY, maxI] = max(absY);
  %   powRatio = maxY/sum(absY);
  %   fprintf('freq(maxI)=%f vs %f | powRatio=%f vs %f\n', ...
  %     f(maxI), fftThresh1, powRatio, fftThresh2);
  %   if f(maxI) >= fftThresh1 || powRatio >= fftThresh2
  %     attDetected = true;
  %   end
  end
  % attDetected = (sum(fbuf)==numel(fbuf)); % ONLY FOR TESTING
  tbuf = [];
  fbuf = [];
  dbuf = [];
  timer = t + twindow;
  fprintf('[%.4f] %d: session end/begin\n', t, currMeter);
end

if attDetected
  if ~flag
    fprintf('[%.4f] %d: false positive\n', t, currMeter)
  else
    fprintf('[%.4f] %d: attack detected: nCrossings=%d >= %d\n', t, currMeter, nCrossings, zcThresh)
  end
end
