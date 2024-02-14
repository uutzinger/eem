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
set(h,'EdgeColor',c);