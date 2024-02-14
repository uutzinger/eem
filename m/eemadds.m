function eem_corrected=eemadds(eem,s);
% eem_corrected=eemadds(eem,s);
% add scalar s to eem

[n,m]=size(eem);
eem_d=eem(2:n,2:m);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);

eem_d = eem_d+s;
eem_corrected=[[r,ex];em,eem_d];



