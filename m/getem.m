function [em,data]=getem(eem,l)
% function [em,data]=getem(eem,l)
% linear interpolates eem at excitation wavelength[s] l
% returns em wavelengths and data at excitation l
%
[n,m]=size(eem);
em=eem(2:n,1);
ex=eem(1,2:m);
eem_d=eem(2:n,2:m);
mi=min(min(eem_d));
data = interp2(ex,em,eem_d,l,em);
