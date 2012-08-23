% Prequisite: dbuf loaded

N = 20;
nChunks = floor(numel(dbuf.data)/N);
arr_sumdiff = zeros(1, nChunks-1);
arr_flag = zeros(1, nChunks-1);
z = zeros(1, N);
for i=1:(nChunks-1) % ignore the first N
  z = dbuf.data((i*N+1):(i*N+N));
  sumdiff = abs(z(1)-dbuf.data(i*N));
  for j=2:N
    sumdiff = sumdiff + abs(z(j)-z(j-1));
  end
  arr_sumdiff(i) = sumdiff;
  arr_flag(i) = sum(dbuf.flag((i*N+1):(i*N+N)));
end

%plot(1:(nChunks-1), arr_sumdiff)