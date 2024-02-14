function mybarfast(x,d,s,n,varargin)
%
%function mybar(meandata,stddata,numdata,signi,cstr,style,twosided)
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
 h=bar(x, d); set(h,'FaceColor',[.0 .0 .0])
 for i=1:length(d),  
   if d(i) >= 0
   		plot([x(i),x(i)],[d(i),d(i)+s(i)],'k-');  
   		plot([x(i)-.3,x(i)+.3],[d(i)+s(i),d(i)+s(i)],'k-'); 
        if n(i) > 0
            h=text(x(i)-.3, d(i)+0.02*max(d+s),num2str(n(i))); set(h,'FontSize', get(gca,'FontSize')*.75)
        end
        if signi(i)<=0.4
            h=text(x(i)+.1, d(i)+s(i)-0.02*max(d+s),num2str(signi(i),'%.2f')); set(h,'FontSize', get(gca,'FontSize')*1)
        end
    else
   		plot([x(i),x(i)],[d(i),d(i)-s(i)],'k-');  
   		plot([x(i)-.3,x(i)+.3],[d(i)-s(i),d(i)-s(i)],'k-'); 
        if n(i)>0
            h=text(x(i)-.3, d(i)-offset*max(d+s),num2str(n(i))); set(h,'FontSize', get(gca,'FontSize')*.75)
        end
        if signi(i)<=0.4
            h=text(x(i)+.1, d(i)-s(i)+offset*max(d+s),num2str(signi(i),'%.2f')); set(h,'FontSize', get(gca,'FontSize')*1)
        end
   	end
 end
 