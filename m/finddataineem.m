function r=finddataineem(eem)
% r=finddataineem(eem)
% r contain start on first row and end on second row
% searches for non zero values and returns vector with start and end for
% each excitation wavelength the index is for data part of eem and does not
% include emission and excitation header
[m,n]=size(eem); 
for i=2:n; t=find(eem(2:end,i)~=0); r(1:2,i-1)=[min(t); max(t)]; end;
