function [variance,eigval,eigvec,compload]=pcaZ2(Z,var_goal,varargin)
%Usage:
% function [variance,eigval,eigvec,compload]=pca(Z,var_goal,q,plt)
% 
% PCA analysis acording to Ramanujam in LSM
%
% Z is the preprocessed matrix, either the covariance 
% or correlation matrix of the data matrix
% var_goal=0..1, suppresses pcs associated with low variance by only
% selectig the largest ones up to summed variance reaches var_goal
% q quiet mode
% plt plot the eig vectors
%
% variance of each pc (sorted decreasing)
% eigval of each pc
% eigvec column is each eigvec
% compload column goes with corresponding eigvec
%

qq=length(varargin);
dsp=0;
plt=0;
if qq==1;
   dsp=varargin{1};
end
if qq==2;
   dsp=varargin{1};
   plt=varargin{2};
end

wa=warning;
warning off;

%[evc,evl]=eig(Z); % eigenvectors and eigenvalues
%evl=diag(evl);
%var=evl/sum(evl); % variance of PC
[eig_vec,eig_val]=eig(Z); % eigenvectors and eigenvalues
eig_val=diag(eig_val);
var_pc=eig_val/sum(eig_val); % variance of PC

% select ev up to desired variance
%if var_goal<1
%    b=flipud(cumsum(flipud(var_pc))<var_goal); b(end)=1; %(at least take largest PC with largest variance
%    % Original code
%    %%var=var_pc;
%    %[o]=size(var);
%    %count=0;
%    %b=[];
%    %for a=o:-1:1;
%    %	 count=count+var(a);
%    %	 b=[a;b];
%    %	 if count>=var_goal,break,end
%    %end
%    var_pc=(var_pc(b,:));
%    eig_val=(eig_val(b,:));
%    eig_vec=(eig_vec(:,b));
%end
if var_goal>0
    b=var_pc>=var_goal;
    % b=flipud(cumsum(flipud(var_pc))<var_goal); b(end)=1; %(at least take largest PC with largest variance
    % Original code
    %%var=var_pc;
    %[o]=size(var);
    %count=0;
    %b=[];
    %for a=o:-1:1;
    %	 count=count+var(a);
    %	 b=[a;b];
    %	 if count>=var_goal,break,end
    %end
    var_pc=(var_pc(b,:));
    eig_val=(eig_val(b,:));
    eig_vec=(eig_vec(:,b));
end

[p,q]=size(eig_val);
%
% Why do we need to flip eingenvectors? This screws the component loadings! Urs 10/30/97
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
% load_a=((ones(size(eig_vec,1),1)*sqrt_eig_val).*eig_vec)';
compload=((ones(size(eig_vec,1),1)*sqrt_eig_val).*eig_vec)';
%for c=1:r;
%	 load_a(c,:)=(sqrt_eig_val(:,c).*eig_vec(:,c)');
%end
%load_b=(ones(size(load_a,1),1)*sqrt_var).\load_a;
compload=(ones(size(compload,1),1)*sqrt_var).\compload;
%for d=1:r;
%	 load_b(d,:)=sqrt_var.\load_a(d,:);
%end
%comp_load=load_b';
compload=compload';
variance=flipud(var_pc);
eigval=flipud(eig_val);
eigvec=[fliplr(eig_vec)];
compload=[fliplr(compload)];

warning(wa);

if dsp
 disp(['Found ', num2str(size(eigval,1)), ' Eigenvectors for ', num2str(var_goal*100) '% variance'])
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
   indx=find(abs(compload(:,iel))<=0.5 & abs(compload(:,iel))>0.25);
   plot(indx,eigvec(indx,iel),'go')
   title(['EV: ', num2str(iel),' Percent: ',num2str(variance(iel))])
 end
 hold off;
end
