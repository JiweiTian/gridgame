function [xlen, area] = rectz(x,y)
% xlen = total length of x for which y is positive
% area = area under curve -- mimicks trapz, except we use rectangles instead of trapezoidals

if numel(x)==0 || numel(y)==0 || numel(x)>numel(y)+1
  throw(MException('Invalid arguments'))
end

xlen = 0;
area = 0;
for i=2:numel(x)
  deltax = x(i)-x(i-1);
  if deltax < 0
    throw(MException('x is not in increasing order'))
  end
  if y(i-1) < 0
    throw(MException('y must be nonnegative'))
  end
  if y(i-1) > 0
    xlen = xlen + deltax;
  end
  area = area + deltax*y(i-1);  
end
  
  
