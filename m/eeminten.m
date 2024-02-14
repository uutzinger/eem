function inten = eeminten(eem,ex,em,hw);
% inten = eeminten(eem,ex,em,hw);
% eem
% ex = excitation
% em = emition
% hw = half width in nm, same for emission and excitation.
%
% UU UofA 2003
% based on AZ Oct 23, 1997

% Read excitation and emission, data ranges
[r c] = size(eem);
x = eem(1,2:c);
m = eem(2:r,1);
rho = eem(1,1);
eemdata = eem(2:r,2:c);

neweemdata = eemdata(find(m>=em-hw & m<=em+hw),find(x>=ex-hw & x<=ex+hw));
[r c]=size(neweemdata);
neweemdata=reshape(neweemdata,1,r*c);
% s=std(neweemdata);
% m=mean(neweemdata);
% i=find((neweemdata <= m+2*s | neweemdata >= m-2*s));
% inten=mean(neweemdata(i));
inten=mean(neweemdata);



