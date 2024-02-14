function [str]=blankde(str)
% function [str]=blankde(str)
% removes trailing and beginning blanks from str
% str is onedimensional
%
str=deblank(str);
blnks=findstr( str, ' ');    
if ~isempty(blnks)
 i=1;
 if blnks(1)==1
  i=2;
  while (i <= length(blnks)), 
   if (blnks(i)-blnks(i-1) == 1) 
    i=i+1; 
   else 
    break; 
   end 
  end % while
 end % if blnks
else
   i=1;
end
str=str([i:length(str)]);
