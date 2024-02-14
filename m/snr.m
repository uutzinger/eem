function snr=snr(spc_filt,spectrum,winhw)
% snr=snr(spc_filt,spectrum,winhw)
% caclulates snr
% data in rows!
% Usage and changes of this software is restricted, contact:
% Urs Utzinger, Spectroscopy Laboratory UT Austin 1999

[nspct,lgth] = size(spectrum);
noise=(spectrum-spc_filt);

noise_std=[];
for ipix=1:lgth,
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
   noise_std(:,ipix) = (std(noise(:,lpix:rpix)'))';
end
snr=spc_filt./noise_std;
snr(find(snr<0))=0;
