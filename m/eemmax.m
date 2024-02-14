function eem_max=eemmax(eem);
% eem_corrected=eem(eem,lex,lem);
% scales eem at lex and lem to one

[n,m]=size(eem);
eem_d=eem(2:n,2:m);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);

eem_max=max(max(eem_d));




