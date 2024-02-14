function [h,lgd]=seplot(eem,l,c)
% [h,lgd]=seplot(bg,l,c)]
% plots eem unscaled 2D at wavelength l with linestyle c
%
 index=[];
 r=eem(1,1); eem(1,1)=0;
 index= min(find(eem(1,:)>=l));
 h=plot(eem(2:size(eem,1),1),eem(2:size(eem,1),index),c);
 lgd = num2str(eem(1,index));

