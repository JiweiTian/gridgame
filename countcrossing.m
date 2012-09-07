function n = countcrossing(z)

n = 0;
for i = 2:numel(z)
  if z(i-1)*z(i) < 0
    n = n + 1;
  end
end