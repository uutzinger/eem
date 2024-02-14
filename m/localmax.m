function keep_max=localmax(inspct,winhw);
% localmaxima=localmaxima(inspct,winhw);
% inspct : 1 dim spectra
% winhw  : window half width to search in
%
keep_max=[];
lgth=length(inspct);
pi_max=1;
for ipix = 1:lgth-1
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

    [l_max, li_max]=max(inspct(lpix:rpix));
    li_max=li_max+lpix-1;
    % pi_max1=pi_max+1;
    %if pi_max1>rpix; pi_max1=rpix; end;

    if (li_max~=rpix) & (li_max~=lpix)
      if (pi_max~=li_max)
       % if li_max==121; break; end;
       keep_max=[keep_max,li_max];
       pi_max=li_max;
      end
    end
end;

