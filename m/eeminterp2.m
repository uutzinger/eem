function eem_s=eeminterp2(eem,em_n,ex_n)
% eem_s=eeminterp2(eem,em,ex)
%
[n,m]=size(eem);
em=eem(2:n,1);
ex=eem(1,2:m);
rho_max=eem(1,1);
data=eem(2:n,2:m);

I = interp2(ex,em,data,ex_n',em_n','linear');
eem_s=[[rho_max,ex_n];[em_n,I]];
