function eem_cut=cutray(eem)
% eem_cut=cutray(eem)
% CUTRAY removes the Rayleigh scattering line, both first and second 
%	order, from the EEM, i.e. the first and last 25 nm in each spec

[n,m]=size(eem);
z=eem(2:n,2:m);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);

for i=1:m-1
   lex=ex(i);
   jstart=max(find(em<=lex+25));
   jstop =max(find(em<=2*lex-30));
   z(1:jstart,i)=zeros(size(z(1:jstart,i)));
   z(jstop:n-1,i)=zeros(size(z(jstop:n-1,i)));
end 

eem_cut=[[r,ex];em,z];
