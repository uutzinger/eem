function mybarfast(x,d,s,n,w,varargin)
%
%function mybar(xvalues,meandata,stddata,numdata,signi,cstr,style,twosided)
%
%

qq=length(varargin);

if qq>=1
    signi=varargin{1};
    if qq>=2
        offset=varargin{2};
    end
else
    signi=ones(1,length(d));
    offset=0.02;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% 
% Simple patho plot
%

 % plot bar chart and std
 hold on; box on
 % bar(d,'k');
 h=bar(x, d, w); set(h,'FaceColor',[.1 .1 .1]); 
 for i=1:length(d),  
   if d(i) >= 0
   		h = plot([x(i),x(i)],[d(i),d(i)+s(i)],'k-'); set(h,'LineWidth',2.5);  
   		h = plot([x(i)-.4,x(i)+.4],[d(i)+s(i),d(i)+s(i)],'k-'); set(h,'LineWidth',2.5);
        if n(i) > 0
            h=text(x(i)-.38, d(i)+0.03*max(d+s),num2str(n(i))); set(h,'FontSize', get(gca,'FontSize'),'FontWeight','bold')
        end
        if signi(i)<=0.4
            h=text(x(i)+.1, d(i)+s(i)-0.02*max(d+s),num2str(signi(i),'%.2f')); set(h,'FontSize', get(gca,'FontSize')*1)
        end
    else
   		%h = plot([x(i),x(i)],[d(i),d(i)-s(i)],'k-');  set(h,'LineWidth',1); 
   		%h = plot([x(i)-.1,x(i)+.1],[d(i)-s(i),d(i)-s(i)],'k-'); set(h,'LineWidth',1); 
        if n(i)>0
            h=text(x(i)-.17, d(i)-offset*max(d+s),num2str(n(i))); set(h,'FontSize', get(gca,'FontSize')*.9)
        end
        if signi(i)<=0.4
            h=text(x(i)+.1, d(i)-s(i)+offset*max(d+s),num2str(signi(i),'%.2f')); set(h,'FontSize', get(gca,'FontSize')*1)
        end
   	end
 end
