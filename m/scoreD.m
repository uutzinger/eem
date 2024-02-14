function pcs = scoreD(D,eigvec,A,B,varargin);
% Usage:
% function pcs = scoreD(D,eigvec,A,B,q,typ);
% Produces the principal component scores
% Needs the Data, the eigenvectors and the A,B scaling and offset values
% q=1 then quiet mode
% typ: force type of calculation, is recommended:
% 1 covariance about origin:                 D'D
% 2 covariance about mean:                   [D-mean(D)]' (D-mean(D))
% 3 correlation about origin (unit length):  [D/sqrt(sum(D^2))]'[D/sqrt(sum(D^2))]
% 4 correlation about mean (unit variance):  [D-mean(D)/std(D)]'[D-mean(D)/std(D)]
% UU updated 2012
%
qq=length(varargin);
if qq>=2
   dsp=varargin{1};
   typ=varargin{2};
elseif qq>=1
   dsp=varargin{1};
   typ=[];
else
   dsp=1;
   typ=[];
end

[m,n] = size(D);
[A_m,A_n] = size(A);
[B_m,B_n] = size(B);

if isempty(typ)
    if A_n > 1 
        if B_n > 1 
          if dsp disp('Using method: correlation about mean for PC score calculation'); end;
          typ=4;
        else
          if dsp disp('Using method: correlation about origin for PC score calculation'); end;
          typ=3;
        end
    elseif B_n > 1
         if dsp disp('Using method: covariance about mean for PC score calculation'); end;
         typ=2;
    else
         if dsp disp('Using method: covariance about origin for PC score calculation'); end
         typ=1;
    end
end

switch typ
    case 1
      if dsp disp('Using method: covariance about origin'); end
      pcs = D*eigvec;
    case 2
      if dsp disp('Using method: covariance about mean'); end;
      pcs = (D - ones(m,1)*B)./A*eigvec;
    case 3
      if dsp disp('Using method: correlation about origin'); end;
      pcs = (D*diag(1./A,0)*eigvec);
    case 4
      if dsp disp('Using method: correlation about mean'); end;
      pcs = (D - (ones(m,1)*B))*diag(1./A,0)*eigvec;
    otherwise
      if dsp disp('Unknown Method'); end;
      pcs=[];
end
end

