function [Z,A,B]=prepZ(D,typ)
%
% function [Z,A,B]=prepZ(D,typ)
%
% D contains spectra horizontally concatenated: each measurement one row
%
% typ:
% 1 covariance about origin:                 D'D
% 2 covariance about mean:                   [D-mean(D)]' (D-mean(D))
% 3 correlation about origin (unit length):  [D/sqrt(sum(D^2))]'[D/sqrt(sum(D^2))]
% 4 correlation about mean (unit variance):  [D-mean(D)/std(D)]'[D-mean(D)/std(D)]
%
% A,B for reconstruction, contain mean or std

% check number and type of arguments
if nargin < 1
  error('Function requires one input argument');
elseif nargin == 1
  disp('Used default covariance about mean');
  typ=2
end

[r,c]=size(D);

if typ == 1
 A = 1;
 B = 0; 
 Z = D'*D;

elseif typ == 2
  A = sqrt(r-1);
  B = mean(D);
  Z = cov(D);
 %
 % AA = diag((ones(c,1)./A),0);
 % BB = ((-1.)*ones(r,1)*B) * AA;
 % TT = D*AA+BB;
 % ZZ = TT'*TT;
 % 1.0e-18 error
 %
 % DD = D - ones(r,1)*mean(D)
 % ZZZ=(DD'*DD)/(r-1);
 % OK!

elseif typ == 3
 A = sqrt(sum(D.^2));
 B = 0;
 Z = (D'*D)./(A'*A);
 %
 % AA  = diag(A.^(-1),0);
 % TT = D*AA;
 % ZZ = TT'*TT;
 % sqrt(sum(TT.^2)) != 1
 % OK
 
elseif typ == 4
 B = mean(D);
 A = std(D)*sqrt(r-1);
 D = (D - ones(r,1)*B);
 Z = (D'*D)./(A'*A);
 %
 % AA = diag(A.^(-1),0);
 % BB = ((-1.)*ones(r,1)*B) * AA;
 % TT = D*AA+BB;
 % ZZ = TT'*TT;
 % sqrt(sum((TT - ones(r,1)*mean(TT)).^2)) != 1!

else
 error('Type not available use value 1-4')

end
