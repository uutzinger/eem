function [v,z,em,ex]=eem2vector(eem,r)
% [v,r,z,em,ex]=eem2vector(eem,r)
% returns a concatenated vector of EEM
% r represents the indices where data was taken
% z is eem(1,1,) element
% em,ex are the emission and excitation vectors

[n,m]=size(eem);
eem_d=eem(2:n,2:m);
em=eem(2:n,1);
ex=eem(1,2:m);
z=eem(1,1);
v=[];
for i=1:m-1,
    v=[v,eem_d(r(1,i):r(2,i),i)'];
end
