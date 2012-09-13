% Taking input parameters from a mask will screw up your output
function attDetected = defender_statcom(t, flag, iq, iqref)

global defenderInited
persistent twindow timeout zcThresh fftThresh
persistent tbuf fbuf dbuf

disabled = true;
attDetected = 0;

if t < 0.2 || disabled
  return
end

if ~defenderInited
  twindow = 0.5;
  timeout = 0.2 + twindow;
  zcThresh = 10;
  fftThresh = 0.2;
  defenderInited = true;
end

tbuf = [tbuf, t];
fbuf = [fbuf, flag];
dbuf = [dbuf, iq-iqref];

if t >= timeout
  nCrossings = countcrossing(dbuf);
  fprintf('nCrossings=%d vs %d\n', nCrossings, zcThresh)
  % rapid oscillations indicate k->-1.2
  if nCrossings > zcThresh
    attDetected = 1;
  % else we need to look at how sinuisoidal dbuf samples are
  else
    L = numel(dbuf);
    %Fs = 1/mean(tbuf(2:L)-tbuf(1:(L-1)));
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(dbuf,NFFT)/L;
    absY = 2*abs(Y(1:NFFT/2+1));
    %f = Fs/2*linspace(0,1,NFFT/2+1);
    [maxY, ~] = max(absY);
    howSinusoidal = maxY/sum(absY);
    fprintf('howSinusoidal=%f vs %f\n', howSinusoidal, fftThresh);
    if howSinusoidal > fftThresh
      % very sinusoidal
      attDetected = 1;
    else
      % not very sinusoidal
      attDetected = 0;
    end
  end
  % attDetected = (sum(fbuf) == numel(fbuf)); % only for testing
  tbuf = [];
  fbuf = [];
  dbuf = [];
  timeout = t + twindow;
end

if attDetected
  set_param('dstatcom_avg/game/meter_switch', 'sw', '1');
  if ~flag
    fprintf('t=%f: false positive\n', t)
  else
    fprintf('t=%f: attack detected\n', t)
  end
end