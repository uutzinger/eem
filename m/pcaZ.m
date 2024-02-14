function [variance,eigval,eigvec,compload]=pcaZ(Z,var_goal,varargin)
%Usage:
% function [variance,eigval,eigvec,compload]=pca(Z,var_goal)
% 
% PCA analysis acording to Ramanujam in LSM
%
% Z is the preprocessed matrix, either the covariance 
% or correlation matrix of the data matrix
%
global plt dsp

qq=length(varargin);

if qq>=1;
   dsp=varargin{1};
end

wa=warning;
warning off;

[evc,evl]=eig(Z); % eigenvectors and eigenvalues
evl=diag(evl);
var=evl/sum(evl); % variance

% select ev up to desired variance
test=cumsum(var)<var_goal;

[o]=size(var);
count=0;
b=[];
for a=o:-1:1;
	 count=count+var(a);
	 b=[a;b];
	 if count>=var_goal,break,end
end
var_pc=(var(b,:));
eig_val=(evl(b,:));
eig_vec=(evc(:,b));
[p,q]=size(eig_val);
%
% Why do we need to flip eingenvectors? This screws the component loadings! Urs 10/30/97
% 
%
%	for h=1:p;
%	 if eig_vec(4,h)<0		%%% I change from 5 to 4... VT on 6/14/97 for only 337 exc on reduced emission
%	  eig_vec(:,h)=-eig_vec(:,h);
%	 end
%	end
%
sqrt_eig_val=sqrt(eig_val');
%
% Needs to be checked
%
sqrt_var=(sqrt(diag(Z)))';
[r,s]=size(eig_val);
	for c=1:r;
	 load_a(c,:)=(sqrt_eig_val(:,c).*eig_vec(:,c)');
	end
	for d=1:r;
	 load_b(d,:)=sqrt_var.\load_a(d,:);
	end
comp_load=load_b';
variance=flipud(var_pc);
eigval=flipud(eig_val);
eigvec=[fliplr(eig_vec)];
compload=[fliplr(comp_load)];

warning(wa);

if dsp
 disp(['Found ', num2str(size(eigval,1)), ' Eigenvectors for ', num2str(var_goal) '% variance'])
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plt
 figure; clf; wysiwyg;
 el=size(eigvec,2);
 for iel = 1:el,
   subplot(round(sqrt(el)), ceil(el/round(sqrt(el))), iel)
   plot(eigvec(:,iel),'k');
   indx=find(abs(compload(:,iel))>0.5);
   hold on;
   plot(indx,eigvec(indx,iel),'ro')
   title(['EV: ', num2str(iel),' Percent: ',num2str(variance(iel))])
 end
 hold off;
end
