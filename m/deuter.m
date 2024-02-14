function [y] = deuterium(x)

% Use spline interpolation to generate corresponding spectral iradiance for deuterium
% calibration lamp. x should be in the 200-400nm range 

% wavel.	spectral irradiance micro watts / cm^2 nm
dat = [	200 ,	.438
	210 ,	.371
	220 ,	.317
	230 ,	.280
	240 ,	.242
	250 ,	.205
	260 ,	.173
	270 ,	.148
	280 ,	.127
	290 ,	.112
	300 ,	.0989
	310 ,	.0881
	320 ,	.0788
	330 ,	.0711
	340 ,	.0642
	350 ,	.0577
	360 ,	.0521
	370 ,	.0468
	380 ,	.0421
	390 ,	.0387
	400 ,	.0365 ];


y = spline( dat(:,1), dat(:,2), x);



