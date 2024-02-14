function clegend=imgeem(eem,em_s,ex_s,mapstr,brightness,linear,varargin);
% clegend=imgeem(eem,em_s,ex_s,mapstring,brightness,linear);
% produces an eem image, data is interpolated in uniform grid according to 
% em_s, ex_s usually 5nm
% map could be pink or jet
% c is colormap brightness factor 
% data is scaled inside fluorescence data (80% inside scattering lines)
% UU 4/98
% Usage and changes of this software is restricted, contact:
% Urs Utzinger, Spectroscopy Laboratory UT Austin 1999

qq=length(varargin);

% Assign defaults if not all arguments were specified
if (qq >= 1)
   pltmode = varargin{1};
else pltmode = 4; end;

eem_s=eeminterp(eem,em_s,ex_s);
[n,m]=size(eem_s);
em=eem_s(2:n,1)';
ex=eem_s(1,2:m);
data=eem_s(2:n,2:m)';
data(data==0)=data(data==0)*NaN;

% total minima
mi2=min(min(data));

% search maximum inside fluroescence data outside scattering lines
%
ma=[];mi=[];locma=[];locmi=[];
ll=0.8;
for i = 1:m-1,
 index=find(isnan(data(i,:))==0);
 mai=max(index); mii=min(index);
 if isempty(mai) ;   mai=size(data,2); end
 if isempty(mii) ;   mii=1; end
 l = ll*(mai-mii);
 [mm,kk]=max(data(i,floor((mai+mii)./2-l/2):floor((mai+mii)./2+l/2))); ma=[ma, mm];
 locma = [locma, [ex(i);em(floor((mai+mii)./2-l/2)+kk-1)] ];
 [mm,kk]=min(data(i,floor((mai+mii)./2-l/2):floor((mai+mii)./2+l/2))); mi=[mi, mm];
 locmi = [locmi, [ex(i);em(floor((mai+mii)./2-l/2)+kk-1)] ];
end
[ma,kk]=max(ma);
ma_loc = locma(:,kk);
[mi,kk]=min(mi);
mi_loc = locmi(:,kk);

% search for data larger than minima inside fluorescence data
for i = 1:m-1,
 index=find(isnan(data(i,:))==0);
 mai=max(index); mii=min(index);
 if isempty(mai) ;   mai=size(data,2); end
 if isempty(mii) ;   mii=1; end
 data(i,mii:mii+4)=[data(i,mii:mii+4).*(data(i,mii:mii+4)>mi)];
 data(i,mai-4:mai)=[data(i,mai-4:mai).*(data(i,mai-4:mai)>mi)];
end
data(data==0)=data(data==0)*NaN;

% still use minimal data also outside
% mi=mi2;

steps = 10;
if linear==1
	data=(data-mi)./(ma-mi);
	data(data>1)=xor(data(data>1),0);
	data(data<0)=xor(data(data<0),0);
   data=reshape(data,1,(m-1)*(n-1));
	v = [0.001:(1-0.001)/steps:1];  
   temp=interp1([0 v],0:1/length(v):1,data,'linear');
elseif linear==0
   data=(data-mi)./(ma-mi);
	data(data>1)=xor(data(data>1),0);
	data(data<0)=xor(data(data<0),0);
	data=reshape(data,1,(m-1)*(n-1));
	v = [0.001:(0.01-0.001)/steps:0.01, 0.01+(0.1-0.01)/steps:(0.1-0.01)/steps:0.1, 0.1+(1-0.1)/steps:(1-0.1)/steps:1];
   temp=interp1([0 v],0:1/length(v):1,data,'linear');
elseif linear==-1
   mi=-1; ma=1;
  	data=(data-mi)./(ma-mi);
	data(data>1)=xor(data(data>1),0);
	data(data<0)=xor(data(data<0),0);
   data=reshape(data,1,(m-1)*(n-1));
   v = [0.001:(1-0.001)/steps:1];  
   temp=interp1([0 v],0:1/length(v):1,data,'linear');
elseif linear==2
   data=(data-mi)./(ma-mi);
	data(data>1)=xor(data(data>1),0);
	data(data<0)=xor(data(data<0),0);
	data=reshape(data,1,(m-1)*(n-1));
	v = [0.001:(0.02-0.001)/steps:0.02, 0.02+(0.2-0.02)/steps:(0.2-0.02)/steps:0.2, 0.2+(1-0.2)/steps:(1-0.2)/steps:1];
   temp=interp1([0 v],0:1/length(v):1,data,'linear');
elseif linear==3
   data=(data-mi)./(ma-mi);
	data(data>1)=xor(data(data>1),0);
	data(data<0)=xor(data(data<0),0);
	data=reshape(data,1,(m-1)*(n-1));
	v = [0.001:(0.03-0.001)/steps:0.03, 0.03+(0.3-0.03)/steps:(0.3-0.03)/steps:0.3, 0.3+(1-0.3)/steps:(1-0.3)/steps:1];
   temp=interp1([0 v],0:1/length(v):1,data,'linear');
end
data=reshape(temp,(m-1),(n-1));
%data(data>1)=xor(data(data>1),1);
%data(data<0)=xor(data(data<0),0);
data(isnan(data))=xor(data(isnan(data)),0);


if ~ishold hold on; washold=0; else washold=1; end

eval(['colormap ' mapstr '(256)']);
map=colormap;
map(256,:)=[1,1,1];

if strcmp(mapstr,'pink')
 t=brightness*(1.-map);
 colormap(map+t);
else
 colormap(map);
 brighten(map,brightness);
end;

if pltmode ~= 5
   map=colormap; map(256,:)=[1,1,1]; colormap(map); 
else
   map=colormap; map(256,:)=[0,0,0]; colormap(map); 
end

set(gca,'NextPlot','replace');
h=image(uint8(data*255),'YData',ex,'XData',em);
set(gca,'YDir','normal')

t=interp1([0:1/length(v):1],[0,v],[0:1/255:1],'linear');
clegend=(ma-mi)*t+mi;
mycolorbar('vertical',0.01,0.0001,clegend)

if ~washold hold off; end