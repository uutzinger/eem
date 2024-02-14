function eem_s=eeminterp(eem,em_s,ex_s)
% eem_s=eeminterp(eem,em_s,ex_s)
% does resample eem at sample intervals em_s and ex_s, leaves size as is
% designed for reducing emission points and increasing excitation wavelengths
%
[n,m]=size(eem);
em=eem(2:n,1)';
ex=eem(1,2:m);
rho_max=eem(1,1);
%min_em=10*ceil( min(em)/10.);
%max_em=10*floor(max(em)/10.);
%min_ex=10*ceil( min(ex)/10.);
%max_ex=10*floor(max(ex)/10.);

min_em=min(em);
max_em=max(em);
min_ex=min(ex);
max_ex=max(ex);

l=min_ex:ex_s:max_ex;
[em,data]=getem(eem,l);
n=length(em);

em_so=em(2)-em(1);
f=ceil(em_s/em_so);
em_n=min_em:em_s:max_em;

%remove all possible NaN;
NaNloc=isnan(data);
data(NaNloc)=0;

i=(data~=0);

%
% need to cut out zeros
% unfortunately spectra do not have the same length all the time
%

data_f=zeros(size(data));
for k=1:size(data,2)
 t=find(i(:,k)==1);
 imax=max(t);
 imin=min(t);
 d=data(imin:imax,k);
 d_f = sgfilt(d', f, 1,0)';
 data_f(imin:imax,k)=d_f;
end 
data_n = interp1(em',data_f,em_n,'linear');
eem_s=[[rho_max,l];[em_n',data_n]];

% remove data where no data can be
[n,m]=size(eem_s);
em=eem_s(2:n,1)';
ex=eem_s(1,2:m);
data=eem_s(2:n,2:m)';
for i=1:length(ex),
    indx=(em<=(ex(i)-5) | em>2*(ex(i)+5));
    if any(indx); data(i,indx)=NaN; end;
end
eem_s=[[eem_s(1,1), ex]; [em', data']];
