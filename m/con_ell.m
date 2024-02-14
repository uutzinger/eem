function [x,y,mp]=con_ell(t,ci)
% [x,y]=con_ell(t,ci)
% t data in columns
% ci confidence internval 0..1

%temp=rand(100,1);
%t=[temp,temp.*rand(100,1)];
% anova1(t);
% get covariance
c=cov(t);
% get eigenvectors
[V,D]=eig(c);
% transform data onto eigenvectors
tt=(t*V);
mt=mean(tt);
st=std(tt);
% confidence interval
% ci=.9;
sn=norminv(((ci+1)/2),0,1);

% generate ellipse in ev space
center = mt; a = st(1)*sn; b = st(2)*sn;
numpts=40;
if a/b > 1
 numpts=numpts*round(a/b);
end
if (numpts > 1200 | isnan(numpts)); numpts=1200; end
theta = [0:2*pi/(numpts-1):2*pi,0];
x = center(1)+a*cos(theta);
y = center(2)+b*sin(theta);
% convert back into data space
et=[x',y']*(V^-1);
x=et(:,1);
y=et(:,2);

mp=[mt+[0,sn*st(2)];mt-[0,sn*st(2)]; mt+[sn*st(1),0];mt-[sn*st(1),0]];
mp=mp*(V^-1);

% plot results
% clf; hold on
% plot(t(:,1),t(:,2),'o')
% plot(et(:,1),et(:,2))
% set(gca,'DataApsectRatio',[1,1,1])


