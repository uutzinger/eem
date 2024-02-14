function [h,lgd,ma]=raweplot(raweem,l)
% function [h,lgd,ma]=raweplot(raweem,l)
% plots eem at colums l without scaling and in pixel
% returns plot handles h and scaling values ma
% so that the plots fit into 0-1 scale
c= [ ' -c'; ' -r'; ' -g'; ' -b'; ' -w'; ' -y'; ' -m'; ...
       '--c'; '--r'; '--g'; '--b'; '--w'; '--y'; '--m'; ...
       '-.c'; '-.r'; '-.g'; '-.b'; '-.w'; '-.y'; '-.m'; ...
       ' :c'; ' :r'; ' :g'; ' :b'; ' :w'; ' :y'; ' :m';];

r=raweem(1,1); raweem(1,1)=0;
index=[]; temp=[];
for i = 1:length(l),
 temp=[temp, raweem(2:size(raweem,1),l(i))];
end

ma=max(max(temp)); % temp=temp./ma;

hold on; ii=1; h=[];lgd=[];
for i = 1:length(l),
 ht=plot(temp(:,i),c(ii,:));
 h=[h;ht]; ii=ii+1; lgd = [lgd; sprintf('%3i', i)];
end

