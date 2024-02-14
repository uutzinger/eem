function outspct = sgfilt(inspct, winhw, porder, dorder);
%
%   BRIEF:
%       perform savitsky-golay smoothing/differentiation
%   PURPOSE:
%
%   SYNTAX:
%   outspct = sgfilt2(inspct, winhw, porder, dorder);
%
%   OUTPUT VARIABLES:
%   -(1) outspct-->output spectra
%
%   INPUT VARIABLES:
%   -(1) inspct-->input spectra in rows!
%   -(2) winhw-->smoothing window half-width
%   -(3) porder-->polynomial order to fit within window
%   -(4) dorder-->derivative order ("0" for simple smooth)
%************************************************************************
% Authors: Various
% Speed optimization: Urs Utzinger, Spectroscopy Laboratory UT Austin 1999

% General Fit
% g = fit, f = spectrum
% g(i)= sum(n=-nL:nR) ( c(n) f(i+n) )
% mov average c(n) =  1/(nL + nR + 1)
%
% local polynomial fit:
% a0 + a1*i + ... + aM*i^M
% A(i,j)= i^j, i=-nL:nR, j=0:M
% 
%      A'*A*a = A'*f
%           a = inv(A'*A) * A'*f
% {A'*A}(i,j) = sum(k=-nL:nR) A(k,i)*A(k,j) = sum(k=-nL:nR) k^(i+j)
%    {A'f}(j) = sum(k=-nL:nR) A(k,i)*f(k)   = sum(k=-nL:nR) k^j * f(k)
% unit vector = e_n
%        c(n) ={ inv(A'*A) * (A'*e_n) }_0   = sum(m=0:M) {inv(A'*A)}_0m * n^m
% c(n) is a0 if f(n) is replaced e_n because we are only interested at location i=0 to 
% compute the new filtered value.
%
% Suggested changes 
% local polynomia = A * a = A * {inv(A'*A) * A'*f}
%
if winhw <1
    outspct=inspct;
    return;
end;

if nargin ~= 4
    disp('ERROR: number of arguments incorrect');
    return;
end;

if porder > (2 * winhw + 1)
    disp('ERROR: maximum polynomial order = %d', (2*winhw +1));
    return;
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
    
    % regenerate coefficients if these window boundaries different from previous

    if (nl~=prevnl) | (nr~=prevnr);
        clear A;
        clear c;
        n = -nl:nr;
        m = 0:porder;

        %for i = 1:length(n);
        %    for j = 1: length(m);
        %        A(i,j) = n(i)^m(j);
        %    end;
        %end;

        Nn=n(ones(size(m)),:)';
        Mm=m(ones(size(n)),:);
        A=Nn.^Mm;

        % [Q,R]=qr(A'*A);
        % T = R\Q';

        arg1 = inv(A'*A);
        vec1 = arg1(dorder+1,:);

        %for i = 1:length(n)
        %    c(i) = sum(vec1.*A(i,:));
        %end;
        
        c=vec1*A';
        
        cmat = ones(nspct,1) * c;

        prevnl = nl;
        prevnr = nr;
    end;

    outspct(:,ipix) = sum( (cmat.*inspct(:,lpix:rpix))' )';

end;
