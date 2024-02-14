function [xav, mav] = eemcorr(eem);
% [xav, mav]= eemcorr(eem)
% m-file to generate excitation and emission autocorrelation vectors given a data eem 
% in standard format 
%
% mav's are defined to be diag(eem*eem')/rms(diag())
% xav's are defined to be diag(eem'*eem)/rms(diag())


[r c] = size(eem);

% do the calculations
% **MAY WANT TO CONSIDER FURTHER NORMALIZATION IN ORDER TO TAKE CARE OF INTER-DATASET COMPATIBILITY
mavd=diag(eem(2:r,2:c)*eem(2:r,2:c)');
mav=mavd/ ( norm(mavd)/sqrt(size(mavd,1)) );

xavd=diag(eem(2:r,2:c)'*eem(2:r,2:c));
xav=xavd/ ( norm(xavd)/sqrt(size(xavd,1)) );

% add wavelength information to the output arrays
mav = [eem(2:r,1) mav];
xav = [eem(1,2:c)' xav];

