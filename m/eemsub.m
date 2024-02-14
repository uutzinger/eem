function eem_corrected=eemsub(eem,eem_sub);
% eem_corrected=eemadd(eem,eem_sub);
% eem      = uncorrected eem
% eem_sub  = eem to subtract
% eem_corrected = eem of the size of eem with addition applied
%
[n,m]=size(eem);
eem_d=eem(2:n,2:m);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);

[nn,mm]=size(eem_sub);
eem_sub_d=eem_sub(2:nn,2:mm);

if (n-nn~=0) | (m-mm~=0)
 warning('Not the same size of eems')
 em_sub=eem_sub(2:nn,1);
 ex_sub=eem_sub(1,2:mm);
 eem_sub_d = INTERP2(ex_sub,em_sub,eem_sub_d,ex,em);
end
eem_corrected=[[r,ex];em,eem_d-eem_sub_d];

