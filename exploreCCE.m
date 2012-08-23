% Prequisite: vector z
% Code adapted from Slege's "(Automatic) Cluster Count Extraction from
% Unlabeled Data Sets"

% Dissimilarity matrix
n = numel(z);
R = zeros(n,n);
for i=1:n
  for j=1:n
    R(i,j)=(z(i)-z(j))^2;
  end
end

[vatImage,C,I,RI] = VAT(R);
figure(400);
image(vatImage);
% reso = 256;
% greycm = zeros(reso, 3);
% for i=1:reso
%   greycm(i,:) = [(i-1)/reso, (i-1)/reso, (i-1)/reso];
% end
% colormap(greycm);
grid minor;

% Step 1: Threshold VAT image
binVAT = im2bw(vatImage, graythresh(vatImage));
 
% Step 2: Threshold VAT image
filter=zeros(n,n);
s = n/2; % filter size ratio
if((size(vatImage,1) < s))
	filter(1,1) = 1;
else
	for x=1:round(size(vatImage,1)/s)
		for y=1:round(size(vatImage,2)/s)
			filter(x,y) = 1;
		end
	end
end

% Step 3: Convert binary VAT image and correlation filter to frequency domain.
FreqVAT=fft2(binVAT);
FreqFilter=fft2(filter,n,n);
 
% Step 4: Perform correlation
FreqFilter=conj(FreqFilter);
FreqResult=FreqFilter.*FreqVAT;
 
% Step 5: Back-transform the frequency-domain filtered image
result=real(ifft2(FreqResult));
%Result=gscale(result); % gscale?
Result=result;
 
% Step 6: Compute CCE histogram
numElements = 1:size(Result,1)-1;
offDiag = diag(Result, 1);
figure(401)
bar(numElements, offDiag)

% Step 7: Extraction of c, the number of dark blocks in the VAT image.
num_cluster = 0;
previous_value = 0;
b = 1e-6;
for i=1:(size(result,1)-1)
	if i==1
		previous_value = 0; %offDiag(i);
  else
		previous_value = offDiag(i-1);
  end
  if offDiag(i)>b && previous_value<1e-6
    num_cluster = num_cluster + 1;
  end
  fprintf('offDiag(i)=%f, previous_value=%f\n', offDiag(i), previous_value); 
end

fprintf('Number of clusters=%d\n', num_cluster);

