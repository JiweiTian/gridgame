function injectedFreq = injectfreq(t, deltaf)

global logFile

if t < 100
  injectedFreq = deltaf;
else
  injectedFreq = 16*deltaf;
  fprintf(logFile, '[%8.2f] Injecting %f\n', t, injectedFreq);
end
