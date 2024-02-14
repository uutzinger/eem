function eem_corrected=eemmult(eem,eem_cfac);
% eem_corrected=feemmult(eem,eem_cfac);
% multiply correction factors or multiply two eems
% eem      = uncorrected eem
% eem_cfac = correction factors eem or scalar
% eem_corrected = eem of the size of eem with cfac applied
% if no cfac's availble -> Zeros
%
[n,m]=size(eem);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);
eem_d=eem(2:n,2:m);
mi=min(min(eem_d));

if mi <0
 disp('Warning EEM has negative values !')
 % eem_d(eem_d<0) = 0.0*eem_d(eem_d<0);
end

if length(eem_cfac)~=1
   
[n,m]=size(eem_cfac);
em_cfac=eem_cfac(2:n,1);
ex_cfac=eem_cfac(1,2:m);
eem_cfac_d=eem_cfac(2:n,2:m);
cfac = interp2(ex_cfac,em_cfac,eem_cfac_d,ex,em);
% contour(cfac)

eem_corrected=[[r,ex];em,eem_d.*cfac];
else
 eem_corrected=[[r,ex];em,eem_d.*eem_cfac];
end

ind=isnan(eem_corrected);
eem_corrected(ind)=zeros(size(eem_corrected(ind)));

