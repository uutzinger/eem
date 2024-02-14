function subeem = eemsubst(eem,xmin,xmax,mmin,mmax);
% subeem = eemsubst(eem,xmin,xmax,mmin,mmax)
% eemsubst returns the subset of eem defined in excitation by xmin and xmax
% and in emission by mmin, mmax.

% AZ Oct 23, 1997

% Read excitation and emission, data ranges
[r c] = size(eem);
x = eem(1,2:c);
m = eem(2:r,1);
rho = eem(1,1);
eemdata = eem(2:r,2:c);

% Check if desired range is whitin data range
xm = min(x);
xx = max(x);
if(xmin<xm) 
   disp('Desired excitation out of range!'); 
   xmin=xm;
elseif(xmax>xx)
   disp('Desired excitation out of range!'); 
   xmax=xx;
end

mm = min(m);
mx = max(m);
if(mmin<mm | mmax>mx) 
   disp('Desired emission out of range!'); 
   mmin=mm;    
elseif(mmax>mx)
   disp('Desired emission out of range!'); 
   mmax=mx;   
end

% Define new excitation and emission, new data set
newx=x(x>=xmin & x<=xmax);
newm=m(m>=mmin & m<=mmax);
neweemdata = eemdata(find(m>=mmin & m<=mmax),find(x>=xmin & x<=xmax));

subeem = [rho newx; newm neweemdata];
