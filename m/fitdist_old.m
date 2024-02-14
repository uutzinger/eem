function [a,b,width,typ,p] = fitdist(x)
%Usage:
% function [a,b,width,type] = fitdist(x)
% a,b parameters for distribution
% type n=normal, g=gamma
% p returns Chi Square based quality of fit [0..1]
%
% if data size is to small normal distribution with mean and std will be used
% otherwise two distributions (normal and gamma) will be fitted with least squares
%
% Examples:
% plt = 1 = yes
% x=normrnd(0,0.1,100,1);
% x=gamrnd(0,0.1,100,1);
% x=x+4
% Uses fit_gam and fit_norm for the optimization.

global plt

if (size(x,2)>size(x,1))
 x = x';
end

maxx=max(x);
minx=min(x);
mx=mean(x);
sx=std(x);

%
% find values outside 3 std and set them to NaN
%
index =find(x <= (mx+3*sx) & x >= (mx-3*sx));
x = x(index);
maxx=max(x);
minx=min(x);
mx=mean(x);
sx=std(x);

%
% try to use at least 6 classes and try to keep between 5 and 20 elements per class
% start with approx 3 elements per class
%
num_class = round(length(x)/2.5);
[nx,xx]=hist(x,num_class);
while ((min(nx) < 5) & (max(nx) < 20)) & (num_class > 6)
 num_class=num_class-1;
 [nx,xx]=hist(x,num_class);
end
%
% Check.
%
if length(nx) <4 ; disp('Warning: Fit on less than 4 data points'); end;

width=(xx(2)-xx(1));
nx=nx/max(size(x))/width;
% fit the gamma distribution
if min(x) < 0
 disp(['Warning: Gamma function does not fit to negative values!'])
end
options(1)=0;
options(2)=1e-4;
options(3)=1e-4;
options(14)=500;
ga=fmins('fit_gs',[mx,sx],options,[],xx,nx);
gfx = gampdf(xx,ga(1),ga(2));
gamma_mean_square = sum( (nx - gfx).^2 );
gamma_chi_square=sum(((nx - gfx).^2)./gfx);
dof = max(size(nx))-3;
gp = 1 - chi2cdf(gamma_chi_square,dof);

% fit the normal distribution
options(1)=0;
options(2)=1e-4;
options(3)=1e-4;
options(14)=500;
na=fmins('fit_ns',[mx,sx],options,[],xx,nx);
nfx = normpdf(xx,na(1),na(2));
norm_mean_square = sum( (nx - nfx).^2 );
norm_chi_square=sum(((nx - nfx).^2)./nfx);
np = 1 - chi2cdf(norm_chi_square,dof);

disp(['Number of points to fit: ', sprintf('%2i',num_class)]);
disp(['Gamma Results:  A: ', sprintf('% 5.3f ',ga(1)), 'B: ', sprintf('% 5.3f ',ga(2)), 'P value: ', sprintf('% 5.3f',gp)]);
disp(['Normal Results: M: ', sprintf('% 5.3f ',na(1)), 'S: ', sprintf('% 5.3f ',na(2)), 'P value: ', sprintf('% 5.3f',np)]);

%
% Choose the best fit
%
if(norm_mean_square < gamma_mean_square)
 typ = 'n';
 a = na(1);
 b = na(2);
 p = np;
else
 typ = 'g';
 a = ga(1);
 b = ga(2);
 p = gp;
end

%
% Plot if necessary
%
if plt == 1,
clf
[t,tt]=hist(x,num_class);
t=t./max(size(x))/width;
bar(tt,t);
hold on;
plot(xx,nfx,'r')
plot(xx,gfx,'b')
plot(xx,nx,'c')
legend('normal','gamma','original');
end

