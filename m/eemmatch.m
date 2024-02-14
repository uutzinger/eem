function eem2_match=eemmatch(eem1,eem2)
% eemmatch(eem1,eem2)
% match eem2 to fit range of eem1
% uu

[n,m]=size(eem1);
em=eem1(2:n,1);
ex=eem1(1,2:m);
r=eem1(1,1);
eem_d=eem1(2:n,2:m);
mi=min(min(eem_d));

if mi <0
 disp('Warning EEM has negative values !')
 % eem_d(eem_d<0) = 0.0*eem_d(eem_d<0);
end

[n,m]=size(eem2);
em_2=eem2(2:n,1);
ex_2=eem2(1,2:m);
eem_2_d=eem2(2:n,2:m);
r_2=eem2(1,1);
cfac = INTERP2(ex_2,em_2,eem_2_d,ex,em);
eem2_match=[[r_2,ex];em,cfac];

ind=isnan(eem2_match);
eem2_match(ind)=zeros(size(eem2_match(ind)));