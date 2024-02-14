function [eem_mask]=generate_eemmask(StartDir,FilePattern, em_start, em_end, em_step, gpix)
%
% function [eem_mask]=generate_eemmask(StartDir,FilePattern, em_start, em_end, eem_step, gradsearch)
%
% StartDir ='.'
% FilePattern='*.out'
% em_start = start emission wavelength
% em_end = end emission wavelength
% em_step = wavelgnth spacing: 4|2
% gradsearch = amount of pixels at start and end emission to search for large gradients to be cut off (4)

eval(['cd ' StartDir ]);

% generate a file list, open it
dos(['dir ' StartDir '\' FilePattern ' /O:N /B /S   > ' StartDir '\efile.lst']);
pause(5)

fidlst = fopen('efile.lst');

if fidlst==-1
  error('File not found or permission denied');
end

s=[]; e=[];
  
while 1
  fline = fgetl(fidlst);
  if ~isstr(fline), break, end
  % tic
  dum=max(findstr(fline,'\'));
  dum2=max(findstr(fline,'.'));
  if isempty(dum)
   fpath='.';
   dum=0;
  else
   fpath=fline(1,1:dum-1);
  end;
  file=fline(1,dum+1:dum2-1);
  suf=fline(1,dum2+1:length(fline));
  sf=max(size(file));
  ptnr=str2num(file(2:4));
  sitenr=str2num(file(sf-1));
  rnr=str2num(file(sf));
  
  eem=loadeem(fline);
  [n,m]=size(eem); raw=eem(2:n,2:m); [n,m]=size(raw);
  em=eem(2:n+1,1);
  ex=eem(1,2:m+1);
  
  % search for large gradients in eem in emission direction only at the beginning and end of spectrum
  
  [Fx,Fy]=gradient(raw); % x = column in emission direction
  sl=[];  el=[];
  % loop through all excitation wavelengths
  for i=1:m
     % calculte average changes of d(I)/d(lambda_emission) 
     F=Fy(:,i);
     sF=std(F);
     % find locations where |dI/dl| is larger than std
     index1=find(abs(F)>sF);
     % search start and end of data in spectrum
     id=find(raw(:,i)~=0); si=min(id); ei=max(id);
     % only first 5 and last 5 points of spectrum are allowd to be cut off based on gradient
     s1=max(index1(find(index1<si+gpix)));
     e1=min(index1(find(index1>ei-gpix)));
     % or if none found take values larger than zero
     id=find(raw(:,i)>0); 
     s2=min(id);         e2=max(id);
     % take the appropriate ones
     si=max([s1,s2]);    ei=min([e1,e2]);
     % make a list of start and end wavelengths
     sl=[sl,em(si)];     el=[el,em(ei)];
     %figure(1); clf; hold on; plot(F); plot(index1,F(index1),'o'); plot([si,ei],F([si,ei]),'ro')
     %figure(2); clf; hold on; plot(raw(:,i)); pause;
  end
  s=[s;sl];  e=[e;el];
  % eem=[eem(1,:);[eem(2:n+1,1), raw]]
end % while
fclose(fidlst);

s=ceil(max(s,[],1)); % maximal start wavelength
e=floor(min(e,[],1)); % minimal end wavelength

mis=min(s); % lowest  measured wavelength
mae=max(e); % highest measured wavelength

if mis<em_start; mis=em_start; end;
if mae>em_end;   mae=em_end; end;

ex=ex;
em=(mis:em_step:mae)';
mask=[];
for i=1:length(s)
   t=ones(size(em));
   j=find(em<s(i) | em>e(i));
   t(j)=t(j)*.0;
   mask=[mask,t];
end

eem_mask=[[0;em],[ex; mask]];
