function r=bg_fit(factor,bg_em,bg,sp_em,sp,l_ex)
% bg fit based on water Raman;
global debug
% Water Raman Wavelength
w_wl=1e7/(1e7/l_ex-3360);

idx=find(sp_em<=w_wl+30 & sp_em>=w_wl-30);

sp_r=sp(idx);
bg_r=bg(idx);

sp_c=sp_r-factor*bg_r;
sp_cf=sp - factor*bg;
[P,S] = polyfit(sp_em(idx),sp_c,3);
sp_fit = polyval(P,sp_em(idx));

r=sum((sp_fit-sp_c).^2);

if debug
    figure(9999); hold on;
    plot(bg_em,bg,'k')
    plot(sp_em,sp,'b')
    plot(sp_em(idx),sp_fit,'r')
    plot(sp_em,sp_cf,'g')
end

