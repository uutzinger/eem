function eem_corrected=eemwclip(eem,clip)
% eem_corrected=eemclip(eem)
% sets negative values to zero
[n,m]=size(eem);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);
data=eem(2:n,2:m);

for i=1:m-1,
    indx1=find(clip(:,1)==ex(i));
    indx2=find(em<=clip(indx1,2)|em>=clip(indx1,3));
    data(indx2,i)=NaN;
end
eem_corrected=[[r,ex];[em,data]];
