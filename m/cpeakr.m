function eem=cpeakr(eem)
% function eem=cpeakr(eem)
% remove one data peak if derivative is to big
%
[m,n]=size(eem);
for i=2:n
 for k=3:m-2
  d0=eem(k-1,i)-eem(k-2,i);
  d1=eem(k,i)-eem(k-1,i);
  d2=eem(k,i)-eem(k+1,i);
  d3=eem(k+1,i)-eem(k+2,i);
  if abs(d1) > 5.* abs(d0) & abs(d2) > 5.* abs(d3)
   if d1/d2 > 0.5
     eem(k,i)=(eem(k+1,i)+eem(k-1,i))./2;
   end
  end 
 end
end
