function eem_corrected=eems(eem,lex,lem);
% eem_corrected=eem(eem,lex,lem);
% scales eem at lex and lem to one

[n,m]=size(eem);
eem_d=eem(2:n,2:m);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);

iem=find(em==lem);
iex=find(ex==lex);

eem_d = eem_d./eem_d(iem,iex);
eem_corrected=[[r,ex];em,eem_d];



