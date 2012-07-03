function [xlen, area] = rectb(x,y1,y2)
% xlen = total length of x for which y2 == 0
% area = area under curve y1 for which y2 == 0

if numel(x)==0 || numel(y1)==0 || numel(y2)==0 || numel(x)>numel(y1)+1 || numel(x)>numel(y2)+1
  throw(MException('Invalid arguments'))
end

xlen = 0;
area = 0;
lastx = x(1);
for i=2:numel(x)
  if y2(i-1) < 0
    throw(MException('y2 must be nonnegative'))
  end
  if y2(i-1) > 0
    lastx = x(i);
  end
  if y2(i-1) == 0
    deltax = x(i)-lastx;
    lastx = x(i);
    if deltax < 0
      throw(MException('x is not in increasing order'))
    end
    if y1(i-1) < 0
      throw(MException('y must be nonnegative'))
    end
    if y1(i-1) > 0
      xlen = xlen + deltax;
    end
    area = area + deltax*y1(i-1);
    %fprintf(1, 'deltax=%f,deltaare=%f\n', deltax, deltax*y1(i-1));
  end
end
