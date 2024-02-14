function eem_corrected=eemclip(eem)
% eem_corrected=eemclip(eem)
% sets negative values to zero
[n,m]=size(eem);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);
data=eem(2:n,2:m);
data(data<0)=data(data<0)*0;
eem_corrected=[[r,ex];[em,data]];
