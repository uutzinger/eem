function [eem]=vector2eem(v,r,z,em,ex)
% [eem]=vector2eem(v,r,z,em,ex)
% returns the eem from a vector
% r represents the indices where data was taken
% z is eem(1,1,) element
% em,ex are the emission and excitation vectors

n=length(em)+1;
m=length(ex)+1;
% initialize EEM
eem=zeros(n,m);
eem(1,1)=z;
eem(2:end,1)=em;
eem(1,2:end)=ex;

l=(r(2,:)-r(1,:))+1;
p=1; % need index in vector
for i=1:m-1,
    eem(r(1,i)+1:r(2,i)+1,i+1)=v(p:p+l(i)-1)'; % paste data
    p=p+l(i); % update index
end
