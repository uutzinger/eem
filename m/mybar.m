function mybar(d,s,n,varargin)
%
%function mybar(meandata,stddata,numdata,signi,cstr,style,twosided)
%
%
qq=length(varargin);

% Assign defaults if not all arguments were specified
if (qq >= 1)
   signi = varargin{1};
else signi = []; end;

if (qq >= 2)
   cstr= varargin{2};
else cstr = num2str(1:size(d,2)); end;

if (qq >= 3)
   style= varargin{3};
else style = 0; end;

if (qq >= 4)
   twosided= varargin{4};
else twosided = 0; end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% 
% Simple patho plot
%

 si=round(signi*100)/100;
 % plot bar chart and std
 hold on; box on
 % bar(d,'k');
 if (style ~= 0) & (length(style) > 1)
 	hold on; si=1;
   for i=1:length(style)
   	% si:(si+style(i)-1)
      h=bar(si:(si+style(i)-1), d(si:(si+style(i)-1)), 'grouped');
      set(h,'FaceColor',([1 1 1] - [1 1 1].*((i)/length(style))))
      % (i-1)/length(style)
      si=si+style(i);
  	end
 else
    h=bar(d','grouped'); set(h,'FaceColor',[.0 .0 .0])
 end
 for i=1:length(d),  
   if twosided
   		plot([i,i],[d(i),d(i)+s(i)],'k-');  
   		plot([i-.3,i+.3],[d(i)+s(i),d(i)+s(i)],'k-'); 
   		plot([i,i],[d(i),d(i)-s(i)],'k-');  
   		plot([i-.3,i+.3],[d(i)-s(i),d(i)-s(i)],'k-'); 
    else
      if d(i) >= 0
   		plot([i,i],[d(i),d(i)+s(i)],'k-');  
   		plot([i-.3,i+.3],[d(i)+s(i),d(i)+s(i)],'k-'); 
   	else
   		plot([i,i],[d(i),d(i)-s(i)],'k-');  
   		plot([i-.3,i+.3],[d(i)-s(i),d(i)-s(i)],'k-'); 
   	end
	end   
 end
 ao=axis; 

 if (style~=0) & (~isempty(signi))
  	a=[ao(1),ao(2)+(ao(2)-ao(1))/2.8,ao(3),ao(4)]; 
   axis(a);
 else
  a=ao;
 end;

 set(gca,'XTick',[1:length(d)]);
 set(gca,'XTicklabel',cstr);
 
 for j=1:length(meandata),
  h=text(j,a(3)-(a(4)-a(3))/15,num2str(n(j))); set(h,'FontSize', get(gca,'FontSize')*.9)
 end

if style~=0
   if ~isempty(signi)
  		textpos=[ao(2),ao(4)-(ao(4)-ao(3))/20];
  		h=text(textpos(1),textpos(2),'T-test:'); set(h,'FontName','Courier'); ex=get(h,'Extent'); textpos=[textpos(1),ex(2)-ex(4)/3];
  		for j=1:length(meandata),
    		for i=j-1:-1:1
       		if signi(j,i) < 0.2
   	     		h=text(textpos(1), textpos(2), [cstr(i,:) '-' cstr(j,:) ': ' sprintf('%4.2f',si(j,i))]);
   	     		set(h,'FontName','Courier'); ex=get(h,'Extent'); textpos=[textpos(1),ex(2)-ex(4)/3];
   	    	end
    		end
       end
    end
end;
%
