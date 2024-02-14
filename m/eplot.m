function [h,lgd,ma]=eplot(eem,l,c)
% function [h,lgd,ma]=eplot(eem,l,c)
% plots eem at excitation wavelength l
% returns plot handles h and actually used wavelengths lg and scaling values ma
% so that the plots fit into 0-1 scale
if nargin == 2
c= [  ' -c'; ' -r'; ' -g'; ' -b'; ' -w'; ' -y'; ' -m'; ...
       '--c'; '--r'; '--g'; '--b'; '--w'; '--y'; '--m'; ...
       '-.c'; '-.r'; '-.g'; '-.b'; '-.w'; '-.y'; '-.m'; ...
       ' :c'; ' :r'; ' :g'; ' :b'; ' :w'; ' :y'; ' :m';];
end;
r=eem(1,1); eem(1,1)=0;
index=[];
for i = 1:length(l),
 index=[index; min(find(eem(1,:)>=l(i)))];
end
temp=eem(2:size(eem,1),index); ma=max(max(temp)); temp=temp./ma;

hold on; ii=1; h=[];lgd=[];
for i = 1:length(l),
 ht=plot(eem(2:size(eem,1),1),temp(:,i),c(ii,:));
 h=[h;ht]; ii=ii+1; lgd = [lgd; num2str(eem(1,index(i)))];
end

