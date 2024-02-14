function [wavelength,transmission]=loadhita(fname)
%
% [wavelength,transmission]=loadhitachi(fname)
%
hit=loadeem(fname);
[n,m]=size(hit);

transmission=hit(7:n,1);
wavelength =[hit(2):-hit(6):hit(3)]';
