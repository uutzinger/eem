function [EEMN] = wraman_remove(EEM,pfit);

%Simple routine for removing water raman peaks from fluorescence spectra
%based on water raman peak calculation and subsequent polynomial fit of
%data excluding water raman peak
%Optimized for removal from entire EEM

%%Author: NK 2005

%only work with non-zero spectra

EEMN = [];
for i = 2:1:size(EEM,2)
    w = EEM(2:end,1);
    fl_em = EEM(2:end,i);
    inz = find(fl_em~=0);
    wnz = w(inz);
    flnz = fl_em(inz);

%find raman wavelength
w_wl=1e7/(1e7/EEM(1,i)-3360);

%remove segment where raman peak is
%only remove water raman if peak is located at least 5 nm above lowest
%emission wavelengh
if (w_wl-7.5 > wnz(1)+5 & w_wl+7.5 < wnz(end)-5)

idx=find(wnz<=w_wl-7.5 | wnz>=w_wl+7.5);

%define new wavelengths
nw = wnz(idx);
nfl = flnz(idx);

%figure(1);clf; plot(nw,nfl)

[P,S] = polyfit(nw,nfl,pfit);

fl_p = polyval(P,wnz);

%hold on;
%plot(wnz,fl_p,'r')

%%%add zeros back to spectra

zs = inz(1) - 1;
zf = length(fl_em)-inz(end);

fl_pz = fl_p;
if zs > 0
    for j = 1:1:zs
        fl_pz = [0;fl_pz];
    end
else
    fl_pz = fl_pz;
end

if zf > 0
    for j = 1:1:zf
        fl_pz = [fl_pz;0];
    end
else
    fl_pz = fl_pz;
end


else      %%%raman peak was not shifted enough from emission start or is too far out

fl_pz = EEM(2:end,i);   

end

EEMN = [EEMN,fl_pz];

end

%%%add back exciation and emission wavelengths

EEMN = [EEM(2:end,1),EEMN];
EEMN = [EEM(1,:);EEMN];
