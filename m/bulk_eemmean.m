function [eem_mean,eem_std]=bulk_eemmean(eem,ex_length);
% [eem_mean,eem_std] = eemmean(eem1,eem2,..);
% calucaltes mean and std of all combined matrix passed as argument 
% Need to know length of excitation vector(row length for single EEM)

a = length(eem(1,:))/ex_length;  %Split EEM into individual EEM's
[n,m]=size(eem(:,1:ex_length));

em=eem(2:n,1);
ex=eem(1,2:m);

meem = [];
seem = [];
r = eem(1,1);

for i = 2:m,  %scan over excitation wavelengths
    tmp = [eem(2:n,i)];
    for k = 1:(a-1),
        tmp2=[eem(2:n,k*ex_length+i)];
        tmp=[tmp,tmp2];
    end
    
    meem=[meem,mean(tmp')'];
   seem=[seem, std(tmp')'];
end

eem_mean=[[r,ex];em,meem];
eem_std =[[r,ex];em,seem];


