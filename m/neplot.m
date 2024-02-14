function [h,lgd]=neplot(eem,l,c)
% [h,lgd]=ebgplot(bg,l,[c])
% plots eem unscaled 2D at wavelengths l
% linetype c
% Usage and changes of this software is restricted, contact:
% Urs Utzinger, Spectroscopy Laboratory UT Austin 1999

 if nargin == 2
 c= [  ' -c'; ' -r'; ' -g'; ' -b'; ' -k'; ' -y'; ' -m'; ...
       '--c'; '--r'; '--g'; '--b'; '--k'; '--y'; '--m'; ...
       '-.c'; '-.r'; '-.g'; '-.b'; '-.k'; '-.y'; '-.m'; ...
       ' :c'; ' :r'; ' :g'; ' :b'; ' :k'; ' :y'; ' :m';];
 end;
 index=[];
 r=eem(1,1); eem(1,1)=0;
 for i = 1:length(l),
  index=[index; min(find(eem(1,:)>=l(i)))];
 end
 temp=eem(2:size(eem,1),index);
 hold on; ii=1; h=[];lgd=[];
 for i = 1:length(l),
  ht=plot(eem(2:size(eem,1),1),temp(:,i),c(ii,:));
  h=[h;ht]; ii=ii+1; lgd = [lgd; num2str(eem(1,index(i)))];
 end

