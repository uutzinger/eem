function eem_corrected=eemadd(eem,eem_add);
% eem_corrected=eemadd(eem,eem_add);
% eem      = uncorrected eem
% eem_add  = eem to add
% eem_corrected = eem of the size of eem with addition applied
%
[n,m]=size(eem);
eem_d=eem(2:n,2:m);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);

[nn,mm]=size(eem_add);
if (n-nn~=0) | (m-mm~=0)
 error('Not the same size of eems')
end
eem_add_d=eem_add(2:nn,2:mm);
t=[eem_d+eem_add_d];
eem_corrected=[[r,ex];[em,t]];

