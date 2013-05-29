function idx = time2Idx(times, t)
  idx = 0;
  for i=1:numel(times)
    if times(i) > t
      idx = i-1;
      return
    end
  end
end