function outspct = med_filt(inspct, winhw);
%
% outspct = med_filt(inspct, winhw);
% median filter
% for raman spectra use winhw = 1 or 2
%
% Usage and changes of this software is restricted, contact:
% Urs Utzinger, Spectroscopy Laboratory UT Austin 1999

if winhw <1
    outspct=inspct;
    break;
end;

if nargin ~= 2
    disp('ERROR: number of arguments incorrect');
    break;
end;

[nspct,lgth] = size(inspct);
if lgth == 1
    inspct=inspct';
    [nspct,lgth]=size(inspct);
end;

% loop through the spectral elements. Do all spectra at one time.

prevnl = -1;
prevnr = -1;
for ipix = 1:lgth
    % determine the window boundaries for this pixel
    lpix = ipix-winhw;
    nl = winhw;
    if lpix < 1;
        lpix = 1;
        nl = ipix - 1;
    end;
    rpix = ipix+winhw;
    nr = winhw;
    if rpix > lgth;
        rpix = lgth;
        nr = lgth - ipix;
    end;
    outspct(:,ipix) = median(inspct(:,lpix:rpix)')';
end;

