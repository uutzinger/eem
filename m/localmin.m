function keep_min=localmin(inspct,winhw);
% localminima=localminima(inspct,winhw);
% inspct : 1 dim spectra
% winhw  : window half width to seach in
%
keep_min=[];
lgth=length(inspct);
pi_min=1;
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

    [l_min, li_min]=min(inspct(lpix:rpix));
    li_min=li_min+lpix-1;
    % pi_min1=pi_min+1;
    %if pi_min1>rpix; pi_min1=rpix; end;

    if (li_min~=rpix) & (li_min~=lpix)
      if (pi_min~=li_min)
       % if li_min==121; break; end;
       keep_min=[keep_min,li_min];
       pi_min=li_min;
      end
    end
end;

