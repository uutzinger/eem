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
