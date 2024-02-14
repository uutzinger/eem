function eem_corrected=eemshft(eem,ex_shift,em_shift);
% eem_corrected=eemshft(eem,ex_shift,em_shift);
%
[n,m]=size(eem);
em=eem(2:n,1);
em=em+em_shift;
ex=eem(1,2:m);
ex=ex+ex_shift;
eem_d=eem(2:n,2:m);
r=eem(1,1);

eem_corrected=[[r,ex];em,eem_d];

