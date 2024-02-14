function [a]=areaundereem(eem,r)
% a=areaundereem(eem,r)
% eem standard eem
% r vector with index where data is to be found within emission spectrum
% r(1,ex_index): start of emission at ex_index
% r(2,ex_index): end of emission at ex_index
[n,m]=size(eem);
a=0;
for ex=1:m-1, % excitation range
     a=a+sum(eem([r(1,ex):r(2,ex)]+1,ex+1));
end
