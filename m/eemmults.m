function eem_corrected=eemmults(eem,s);
% eem_corrected=eemmults(eem,s);
% multiply eem data by scalar s

[n,m]=size(eem);
eem_d=eem(2:n,2:m);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);

eem_d = eem_d.*s;
eem_corrected=[[r,ex];em,eem_d];



