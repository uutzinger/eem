function markeem()
% markeem()
% No documentation available
% Usage and changes of this software is restricted, contact:
% Urs Utzinger, Spectroscopy Laboratory UT Austin 1999

xlim=get(gca,'Xlim');
ylim=get(gca,'Ylim');

if ylim(1) < 300
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Amino Acids
c=[.9,.9,.9];
% c=[0.7 0.9 0.7];
% Tryptophan 290 / 330 .5
spot(280,300,310,360,c) %tryptophan
% Tyrosin 270 / 303 1.
spot(260,280,290,310,c) %tyrosine
% Phenylalanine 260 / 282 .25
spot(250,270,270,290,c) %ph
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Structural Proteins
c=[.9,.9,.9];
% Shih hui Cheng
% Type I is most common
% Collagen type I 280 / 310 1.0e6
% Collagen type I 280 / 340 1.16e6
% Collagen type I 340 / 410 4.4e4
% Collagen type I 500 / 520 4.5e4
if ylim(1) < 300
spot(270,290,300,320,c)
spot(265,295,320,360,c)
end
spot(330,350,400,420,c)
spot(485,515,505,535,c)

c=[.9,.9,.9];
% Shih hui Cheng 
% Elastin 280 / 305 1.1e6
% Elastin 280 / 345 8.8e5
% Elastin 330 / 400 2.37e5
if ylim(1) < 300
spot(275,285,300,310,c) 
spot(275,285,335,355,c) 
end
spot(320,340,390,410,c) 

% Elastin contains also FAD  450/530
% Elastin contains als0 NADH 350/460

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redox = FAD/(FAD+NADH)
%
c=[.9,.9,.9];
% RRK notes / literature
% NADH 350 / 460 5.0 e5 +/-20em +/-20ex 
spot(330,370,440,480,c)
% NADH 300 / 450 4.5 e5 +/-10em +/-10ex
spot(290,310,450,470,c)

c=[.9,.9,.9];
% Tissue phantom SPEX
% FAD 450 / 535  0.425 +/-20ex +/-20 em
spot(425,475,510,560,c)
% FAD 370 / 535  0.3   +/-10ex +/-20 em
spot(355,385,510,560,c)
% FAD 270 / 535  0.35   +/-10ex +/-20 em
spot(255,285,520,550,c)

c=[.9,.9,.9];
% Porphyrin
% Porphyrin 400/630 +/-50ex   +/-10em
spot(350,450,625,635,c) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% labels
if ylim(1) < 300
text(330,290,'Try') %tryptophan
text(303,270,'Tyr') %tyrosine
text(282,260,'Phe') %ph
end

text(630,400,'P')

text(535,450,'F')
text(535,370,'F')
if ylim(1) < 300
text(535,270,'F')
end

text(450,350,'N')
if ylim(1) < 300
text(450,290,'N')
end

if ylim(1) < 300
text(310,280,'CI')
text(340,280,'CI')
end
text(410,340,'CI')
text(520,500-5,'CI')

if ylim(1) < 300
text(305,280,'E')
text(345,280,'E')
end
text(400,330,'E')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Raley
h=line([250 550],[250 550]); %RA
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
h=line([500 800],[250 400]); %RA
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HbO2 345
h=line([345 345],[250 345]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
h=line([345 800],[345 345]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)

% HbO2 414
h=line([414 414],[250 414]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
h=line([414 800],[414 414]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)

% HbO2 543
h=line([543 543],[250 543]); 
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
h=line([543 800],[543 543]); 
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)

% HbO2 578
h=line([578 578],[250 550]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hb 430
h=line([430 430],[250 430]); 
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)
h=line([430 800],[430 430]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)

% Hb 556 
h=line([556 556],[250 556]); 
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)
h=line([556 800],[556 556]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)
% Hb 758
h=line([758 758],[250 758]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)
h=line([758 800],[758 758]);
set(h,'LineStyle','-')
set(h,'Color','red')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Raley
h=line([250 550],[250 550]); %RA
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
h=line([500 800],[250 400]); %RA
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HbO2 345
h=line([345 345],[250 345]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
h=line([345 800],[345 345]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)

% HbO2 414
h=line([414 414],[250 414]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
h=line([414 800],[414 414]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)

% HbO2 543
h=line([543 543],[250 543]); 
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)
h=line([543 800],[543 543]); 
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)

% HbO2 578
h=line([578 578],[250 550]);
set(h,'LineStyle','-')
set(h,'Color',[.1 .1 1])
set(h,'LineWidth',.5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hb 430
h=line([430 430],[250 430]); 
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)
h=line([430 800],[430 430]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)

% Hb 556 
h=line([556 556],[250 556]); 
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)
h=line([556 800],[556 556]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)
% Hb 758
h=line([758 758],[250 758]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)
h=line([758 800],[758 758]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',.5)




function spot(y0,y1,x0,x1,c);
% function spot(y0,y1,x0,x1,c);
% y is excitation, x emission axis
% create an oval spot at lower LH corner=(x0,y0) to upper RH corner (x1,y1)
% c:color,string
axlim=axis;
axlim=axlim(1:4);
dx=x1-x0;
dy=y1-y0;
[xdata,ydata]=ellipse([x0 y0 dx dy],200,axlim);
h=fill(xdata,ydata,c);
%h=plot(xdata,ydata,'kx');
%set(h,'MarkerSize',10)
%set(h,'LineWidth',.5)
set(h,'EdgeColor',c);

function [XData,YData] = ellipse(extent,numpts,axlims)
% function [XData,YData] = ellipse(extent,numpts,axlims)
%ELLIPSE Draw an ellipse
%H = ELLIPSE(EXTENT,NUMPTS,AXLIMS)
%Draws an ellipse in the rectangle specfified by EXTENT
%returning handle H to the line object. If a value is 
%given for AXLIMS, the EXTENT is assumed to be in axis-
%normalized components, and the ellipse will be scaled
%accordingly.
%
%[XDATA,YdATA] = ELLIPSE(EXTENT,NUMPTS,AXLIMS)
%does not plot the ellipse, instead returning the X and
%Y Data
%
%NUMPTS defaults to 50 if not specified.
%
%Keith Rogers 11/94

% Copyright (c) 1995 by Keith Rogers
 
if(nargin < 3)
	axlims = [0 1 0 1];
	if(nargin < 2)
		numpts = 50;
	end
end
center = extent(1:2)+.5*extent(3:4);
a = extent(3)/2/(axlims(2)-axlims(1));
b = extent(4)/2/(axlims(4)-axlims(3));
theta = 0:2*pi/(numpts-1):2*pi;
radius = a*b./sqrt(a^2+(b^2-a^2)*cos(theta).^2);
XData = center(1)+radius.*cos(theta)*(axlims(2)-axlims(1));
YData = center(2)+radius.*sin(theta)*(axlims(4)-axlims(3));
if(nargout < 2)
	XData = plot(XData,YData);
end;
