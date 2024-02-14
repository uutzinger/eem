function [h,lgd,ma]=compseem(eem1,eem2,l,varargin)
% function [h,lgd,ma]=compseem(eem1,eem2,l,all,sep)
% plots eem's at excitation wavelengt l
% all : 1 normalizes all spectra
% sep plot in subplots
% returns plot handles h and actually used wavelengths lg and scaling values ma
% so that the plots fit into 0-1 scale


qq=length(varargin);

% Assign defaults if not all arguments were specified
if (qq >= 1)
   all = varargin{1};
else all = 0; end;

if (qq >= 2)
   sep = varargin{2};
  else sep = 0; end;
  
c = [' -k';'--k'; ' -b';'--b'; ' -r';'--r'; ' -g';'--g'; ' -c'; '--c'; ' -w';'--w'; ' -y'; '--y'; ' -m'; '--m'; ...
     '-.c';' :c'; '-.r';' :r'; '-.g';' :g'; '-.b'; ' :b'; '-.w';' :w'; '-.y'; ' :y'; '-.m'; ' :m'];

r1=eem1(1,1); eem1(1,1)=0;
r2=eem2(1,1); eem2(1,1)=0;

el=length(l);

index1=[];
for i = 1:length(l),
 index1=[index1; min(find(eem1(1,:)>=l(i)))];
end
if all
   temp=eem1(2:size(eem1,1),index1); ma1=(max(temp)); temp1=temp./(ones(size(temp,1),1)*ma1);
else
   temp=eem1(2:size(eem1,1),index1); ma1=max(max(temp)); temp1=temp./ma1;
end
index2=[];
for i = 1:length(l),
 index2=[index2; min(find(eem2(1,:)>=l(i)))];
end
if all
   temp=eem2(2:size(eem2,1),index2); ma2=(max(temp)); temp2=temp./(ones(size(temp,1),1)*ma2);
else
   temp=eem2(2:size(eem2,1),index2); ma2=max(max(temp)); temp2=temp./ma2;
end   
ma = [ma1;ma2];

ii=1; h=[];lgd=[];
if sep==0
hold on; 
for i = 1:length(l),
 ht=plot(eem1(2:size(eem1,1),1),temp1(:,i),c(ii,:));
 h=[h,ht]; ii=ii+1; lgd = [lgd; eem1(1,index1(i))];
 ht=plot(eem2(2:size(eem2,1),1),temp2(:,i),c(ii,:));
 h=[h,ht]; ii=ii+1; lgd = [lgd; eem2(1,index2(i))];
end
else
for i = 1:el,
 subplot(round(sqrt(el)), ceil(el/round(sqrt(el))), i)
 hold on; 
 ht=plot(eem1(2:size(eem1,1),1),temp1(:,i),c(1,:));
 h=[h,ht]; ii=ii+1; lgd = [lgd; eem1(1,index1(i))];
 ht=plot(eem2(2:size(eem2,1),1),temp2(:,i),c(2,:));
 h=[h,ht]; ii=ii+1; lgd = [lgd; eem2(1,index2(i))];
 title(['Ex: ', num2str(l(i))])
end
end