function nor_mat=normaliz(mat,varargin)
% nor_mat = normalize(mat,ex_index,em_start,em_end, individual);
% Normalization of spectral data by wavelength region:
% mat:       column oriented spectra with patient nr and site nr as first 2 rows, wavelength column in first row
% ex_index:  index number of emission sections in which to search eg. 3 excitation sections: [1,2,3]
% em_start:  emission wavelength start area
% em_end:    emission end search area
% individiaul: 1= normalize each wavelength section seperately, ex_index will include all possible ranges automatically
%              0= normalize all ranges by one higest value from all indexed ranges
%
% to normalize all ranges by first range use:
% ex_index=1
% individual=0;

[n,m]=size(mat);
nor_mat=[];
em=mat(3:n,1)';

% find wavelength bounderies
i=3; upper=[]; lower=[3];
while i<n
 if mat(i,1)>mat(i+1,1)
  upper=[upper,i];
  lower=[lower,i+1];
 end
 i=i+1;
end
upper=[upper,n];
disp(['Found ' num2str(length(upper)) ' wavelegnths.'])

qq=length(varargin);
if (qq >= 1)
   ex_index = varargin{1};
else ex_index = 1:size(upper,2); end;

if (qq >= 2)
   em_start = varargin{2};
  else em_start = 0; end;
  
if (qq >=3)
  em_end = varargin{3};
  else em_end = Inf; end;
  
if (qq >=4)
   indi = varargin{4};
  else indi = 1;  end;
  
%over rule individual for all ex wavelengths
if indi==1
   ex_index = 1:size(upper,2);
end
  
% search for maximum
mam=[];
for k=1:length(ex_index),
   i=ex_index(k);
   em_temp=em( lower(i)-2 : upper(i)-2 );
   maxi=max(find(em_temp<=em_start));
   mini=min(find(em_temp>=em_end));
   % bounderies need to be in actual wavelength ragne
   if ~isempty(mini); nupper(i)=lower(i)+mini-1; else nupper(i)=upper(i); end;
 	if ~isempty(maxi); nlower(i)=lower(i)+maxi-1; else nlower(i)=lower(i); end;
 	%em_temp=em( lower(i)-2 : upper(i)-2 );
 	ma=mat(nlower(i):nupper(i),2:m);
 	if indi==1
   	mam=max(ma,[],1); % need to state [ma;ma] it twice because if ma is nx1 only one value is returned
    	ma=mat(lower(i):upper(i),2:m);   % need to use whole range otherwise we loose data
    	ma=ma./(ones(size(ma,1),1)*mam); % devide by found maxima
    	nor_mat=[nor_mat;ma];
 	else
   	mam=[mam;max(ma,[],1)];
 	end
end % for

if indi==1
   % already normalized
   nor_mat=[mat(1:2,:); [mat(3:n,1), nor_mat]];
else
   % normalize it
   nor_mat=[mat(1:2,:); [mat(3:n,1), mat(3:n,2:m)./(ones(n-2,1)*max(mam,[],1))]];
end   


%if ex_index=-1
%   % normalize wavelength areas separately
%	for i=1:size(upper,2),
% 		ma=mat(lower(i):upper(i),2:m);
%   	mam=max(ma);
% 		if mam~=0
%   		ma=ma./(ones(size(ma,1),1)*mam);m
% 		end   
% 		nor_mat=[nor_mat;ma];
%	end
%	nor_mat=[mat(1:2,:); [mat(3:n,1), nor_mat]];
%end 

%test=[0,1,1,2; ...
% 0,1,2,1;
% 1,0,0,0;
% 2,2,2,2;
% 3,1,1,1;
% 1,0,0,0;
% 2,2,2,2;
% 3,0,0,0;
% 2,3,3,3;
% 3,3,3,3;]