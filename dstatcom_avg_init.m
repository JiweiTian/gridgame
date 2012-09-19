Ts=40e-6;
rng(1234);

global defenderInited attackerInited attDetected
defenderInited = false;
attackerInited = false;
attDetected = false;

global meterSwitchInited currMeter hacked
meterSwitchInited = false;
currMeter = 1;
hacked = [true, false];

% disturbances
n = 20;
x = ones(1,3*n);
for i=0:(n-1)
  x(i*3+1) = 0.9 + (0.2)*rand(1);
  x(i*3+2) = 1 + (-1)^(x(i*3+1) > 1)*(0.1)*rand(1);
  x(i*3+3) = 1;
end
amplitudes = sprintf('[%s]', num2str([1 x]));
fprintf('Amplitudes (%d): %s\n', length(x), amplitudes)
set_param('dstatcom_avg/Generator', 'Amplitudes', amplitudes)
t = zeros(1,3*n);
for i=0:(n-1)
  t(i*3+1) = 0.5 + (i)*0.5;
  t(i*3+2) = 0.5 + (i)*0.5 + (0.1)*rand(1);
  t(i*3+3) = 0.5 + (i)*0.5 + 0.1;
end
times = sprintf('[%s]', num2str([0 t]));
fprintf('Times (%d): %s\n', length(t), times)
set_param('dstatcom_avg/Generator', 'TimeValues', times)

tic;