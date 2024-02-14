function [h,lgd,ma]=compeem(eem1,eem2,l)
% function [h,lgd,ma]=compeem(eem1,eem2,l)
% plots eem's at excitation wavelengt l
% returns plot handles h and actually used wavelengths lg and maxima
%
c = [' -k';'--k';' -c';'--c'; ' -r';'--r'; ' -g';'--g'; ' -b'; '--b'; ' -w';'--w'; ' -y'; '--y'; ' -m'; '--m'; ...
     '-.c';' :c'; '-.r';' :r'; '-.g';' :g'; '-.b'; ' :b'; '-.w';' :w'; '-.y'; ' :y'; '-.m'; ' :m'];

r1=eem1(1,1); eem1(1,1)=0;
r2=eem2(1,1); eem2(1,1)=0;

index1=[];
for i = 1:length(l),
 index1=[index1; min(find(eem1(1,:)>=l(i)))];
end
temp1=eem1(2:size(eem1,1),index1); ma1=max(max(temp1));

index2=[];
for i = 1:length(l),
 index2=[index2; min(find(eem2(1,:)>=l(i)))];
end
temp2=eem2(2:size(eem2,1),index2); ma2=max(max(temp2));
ma = [ma1;ma2];

hold on; ii=1; h=[];lgd=[];
for i = 1:length(l),
 ht=plot(eem1(2:size(eem1,1),1),temp1(:,i),c(ii,:));
 h=[h,ht]; ii=ii+1; lgd = [lgd; eem1(1,index1(i))];
 ht=plot(eem2(2:size(eem2,1),1),temp2(:,i),c(ii,:));
 h=[h,ht]; ii=ii+1; lgd = [lgd; eem2(1,index2(i))];
end

