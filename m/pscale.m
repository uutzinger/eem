function nor_mat=pscale(mat,varargin)
% nor_mat = pscale(mat,ex_index,em_start,em_end, individual, globalmax);
% Normalization (devision) of spectral data by maximal measurement in each patient:
%
% mat:       column oriented spectra with patient nr and site nr as first 2 rows, wavelength column in first row
% ex_index:  index number of emission sections in which to search
% em_start:  emission wavelength start area (for all ex_index)
% em_end:    emission end search area
% individiaul: 1= normalize each wavelength section seperately (ex_index will include all possible ranges automatically)
%              0= normalize each emission vector by one higest value from the correspondend indexed ranges
% globalmax:   1= scale by maximal intensity even they are in different sites from the same patient.
%              0= search for site with maximal intensities
% Default:
% ex_inded   = [all possible]
% em_start   = 0;
% em_end     = Inf;
% individual = 1;
% globalmax  = 0;
%
% Example:to normalize the concatenated emission vector by the maximum of all ranges use:
% ex_index   =[1,2,3]
% individual =0;
% em_start   =0;
% em_end     =Inf;
% globalmax  =0;

[n,m]=size(mat);
nor_mat=[];
em=mat(3:n,1)';

% find wavelength bounderies
i=3; l_upper=[]; l_lower=[3];
while i<n
 if mat(i,1)>mat(i+1,1)
  l_upper=[l_upper,i];
  l_lower=[l_lower,i+1];
 end
 i=i+1;
end
l_upper=[l_upper,n];
disp(['Found ' num2str(length(l_upper)) ' wavelegnths.'])

% find patients indeces
i=2; p_upper=[]; p_lower=[2];
while i<m
 if ~(mat(1,i)==mat(1,i+1))
  p_upper=[p_upper,i];
  p_lower=[p_lower,i+1];
 end
 i=i+1;
end
p_upper=[p_upper,m];
disp(['Found ' num2str(length(p_upper)) ' patients.'])


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
  
if (qq >=5)
   globalmax = varargin{5};
  else globalmax = 0;  end;

%over rule individual for all ex wavelengths
if indi==1
   ex_index = 1:size(l_upper,2);
end

mam=[];
for k=1:length(ex_index),
    i=ex_index(k);
    % check inside wavelength boundaries for selected wavelength boundary
    em_temp=em( l_lower(i)-2 : l_upper(i)-2 );
    maxi=max(find(em_temp<=em_start));
    mini=min(find(em_temp>=em_end));
    % bounderies need to be in actual wavelength ragne
    if ~isempty(mini); nupper(i)=l_lower(i)+mini-1; else nupper(i)=l_upper(i); end;
 	 if ~isempty(maxi); nlower(i)=l_lower(i)+maxi-1; else nlower(i)=l_lower(i); end;
    % 
    ma=mat(nlower(i):nupper(i),2:m);
    mam=[mam;max(ma,[],1)];
end % for k

nor_mat=[];
for j=1:size(p_upper,2),
   % for one patient
   [mm,ii]=max(mam(:,p_lower(j)-1:p_upper(j)-1),[],2);
   if globalmax==0
	   iii=round(median(ii,1));
      mm=mam(:,p_lower(j)-2+iii);
   end
   if indi==1 % normalize each ex section individually
      sma=[];
      for jj=1:size(l_upper,2),
         ma=mat(l_lower(jj):l_upper(jj),p_lower(j):p_upper(j))./mm(jj); % devide by found maxima
        	sma=[sma;ma];
      end
      nor_mat=[nor_mat, sma];
   else %normalize by maximum of all maxima found in wavelength selection
      sma=mat(l_lower(1):l_upper(length(l_upper)),p_lower(j):p_upper(j))./max(mm); % devide by found maxima
      nor_mat=[nor_mat, sma];
   end
end
   
nor_mat=[mat(1:2,:); [mat(3:n,1),nor_mat]];

% test=...
%[0,1,1,2; 
% 0,1,2,1;
% 1,0,0,0;
% 2,2,2,2;
% 3,1,1,1;
% 1,0,0,0;
% 2,2,2,2;
% 3,0,0,0;
% 2,3,3,3;
% 3,3,3,3;]
