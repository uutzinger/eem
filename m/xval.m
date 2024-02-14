function [Se,Sp,classification,varargout]=xval(diagnosis,data,varargin);
% function [Se,Sp,classification,NPV,PPV,unique_diagnosis,pc_slected,SIG_EV,Training_Se,Training_SP,Training_NPV,Training_PPV]= 
%          xval(diagnosis,data,pca,SIG_EV,covariance_method,q);
% Jackknife approach for normal vs abnormal
% Input:  diagnosis is a column vector [1|2], 2 is considered diseased
%	  data is the data matrix with the first two columns containing the patient number and site number
% 	  SIG_EV signigicance need to include eigenvector, if -1 will search for appropriate number
%    pca: 0 do not perform pca
%	  covariance_method, see prepZ (use 2 if dont know)
%	  q: 1=verbose
% Output: Sensitivity,Specificity,Classification, NPV, PPV
%         Sensitivity(1) = found measurements with classification==diagnosis_type(1) towards ~= diagnosis_type(1)
%         unique diagnosis
%         pc_selected = counts how many times pc has been selected, only meanging full if pca is turned off, because otherwise PCs vary from patient to patient

if nargin <2
   error('Need at least 2 inputs, type help xval')
end

qq=length(varargin);

if qq>=1
   pca = varargin{1};
else pca = 1; end;

if qq>=2
   SIG_EV = varargin{2};
else SIG_EV = .9; end;

if qq>=3
 covariance_method=varargin{3};
else covariance_method=2; end

if qq>=4
 dsp=varargin{4};
else dsp=0; end

if (dsp==1 & pca==1)
   disp(['Covariance Method is: ' num2str(covariance_method)]);
   disp(['Variance for Eigenvectors is: ' num2str(SIG_EV)]); end

more off;

if SIG_EV==-1
   % Find EV_significance based on random diagnosis
   pca=1; % PCA needs to used otherwise no significance is selectable
	rand('state',sum(100*clock)) % intialize random number generator
	% figure normal-abnormal site distribution
	st=data(:,2);
	normal_sites=st(find(diagnosis==1));      lns=length(normal_sites);
   abnormal_sites=st(find(diagnosis==2));    las=length(abnormal_sites);
   % limits for random diagnosis for SE and SP
   pp1=lns/(lns+las); rg1=1.3*lns/(lns+las); if rg1>1 rg1=1; end;
   pp2=las/(lns+las); rg2=1.3*las/(lns+las); if rg2>1 rg2=1; end;
   % DO THIS 10 TIMES TO BE SURE
   for u=1:10,
	rSp=[pp1,pp2]; SIG_EV(u)=.6; % initialize, are lowest expected values
   	% create similar distribution with random diagnosis, thanks Doug
   	rdiagnosis=ones(lns+las,1);
	rindex=randperm(lns+las);
	raindex=rindex(1:las);
	rdiagnosis(raindex)=2;
      	% need to check towards prior probability! see at end of this routine
   	while ((rSp(1) < rg1) & (rSp(2) < rg2) & (SIG_EV(u)<1)) 
       		 rSp_old(u,:)=rSp; % keep old performance since the loop will go one step over
		 % Intitialize xval loop
		 [m,n]=size(data);
		 classification=zeros(m,1);
		 done=zeros(m,1); % true of measurement has been validated
		 j=0;
		 pc_selected=zeros(n,1);
		 % Cross Validation Loop
		 while (j<m)
		   j=j+1;
		   if done(j)==0
		      % search for all measurements in same patient as current measurement
		      h=find(data(:,1)==data(j,1)); % define validation set
		      done(h)=1; % set all measurements of this patient as done
		      k=find(data(:,1)~=data(j,1)); % define training set
		      % prepare covariance matrix    
		      if pca==1
		      	[Z,A,B]=prepZ(data(k,3:n),covariance_method);
		      	[variance,eigval,eigvec,compload]=pcaZ(Z,SIG_EV(u),0);
		         pcs = scoreD(data(:,3:n), eigvec, A, B,0);
		      else
               		pcs=data(:,3:n);
            	      end
		      [ev_index,se,sp,ppv,npv]=select_eigq(pcs(k,:), rdiagnosis(k));
		      % [ev_index,se,sp,ppv,npv]=select_eig(pcs(k,:), rdiagnosis(k),0);
		      tclass = classify(pcs(h,ev_index),pcs(k,ev_index),rdiagnosis(k));
		      classification(h)=tclass;
		      pc_selected(ev_index)=pc_selected(ev_index)+1;
		   end; % if done
		 end;  % while j<m 
       		 [rSp,rSe,rNPV,rPPV,runique_diagnosis]=stat_sum(rdiagnosis,classification);
		 if dsp 
 	      disp(['SIG_EV:' num2str(SIG_EV(u))]);
  	      disp( '===============')
   	      disp(['Sp, Se:' num2str(rSp)]);end;
  	      if SIG_EV(u)<.8
  	      	inc=.1;
  	      elseif SIG_EV(u)<.9
  	        inc=.05;
  	      elseif SIG_EV(u)<.99
  	       inc=0.01;
  	      else
  	       inc=0.001;  end % if
  	    SIG_EV(u)=SIG_EV(u)+inc;
	   end % while
	   SIG_EV(u)=SIG_EV(u)-inc; % correct to last good one before loop terminated
   end % for 10 times loop
   if dsp disp(['SIG_EV: ' num2str(SIG_EV)]); disp(strvcat('Sp, Se: ', num2str(rSp_old))); disp( '============================='); end
   SIG_EV=median(SIG_EV);   
end % SIG_EV==-1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Do the real thing with right significance level
% Intitialize
[m,n]=size(data);
classification=zeros(m,1);
done=zeros(m,1); % true of measurement has been validated
j=0;
pc_selected=zeros(n,1);
% Cross Validation Loop
while (j<m)
   j=j+1;
   if done(j)==0
      % search for all measurements in same patient as current measurement
      h=find(data(:,1)==data(j,1)); % define validation set
      done(h)=1; % set all measurements of this patient as done
      k=find(data(:,1)~=data(j,1)); % define training set
      % prepare covariance matrix    
      if pca==1
      	[Z,A,B]=prepZ(data(k,3:n),covariance_method);
      	[variance,eigval,eigvec,compload]=pcaZ(Z,SIG_EV,dsp);
         pcs = scoreD(data(:,3:n), eigvec, A, B,dsp);
      else
         pcs=data(:,3:n);
      end
      [ev_index,se,sp,ppv,npv]=select_eig(pcs(k,:), diagnosis(k),dsp);
      % [ev_index,se,sp,ppv,npv]=select_eigq(pcs(k,:), diagnosis(k));
      tclass = classify(pcs(h,ev_index),pcs(k,ev_index),diagnosis(k));
      classification(h)=tclass;
      pc_selected(ev_index)=pc_selected(ev_index)+1;
      if dsp disp(['Patient: ' num2str(data(j,1)) ' done.']); end;
   end; % if done
end;  % while j<m 

[Sp,Se,NPV,PPV,unique_diagnosis]=stat_sum(diagnosis,classification);
if dsp 
   disp(['Se:' num2str(Se)]);
   disp(['Sp:' num2str(Sp)]);
   disp(['PPV:' num2str(PPV)]);
   disp(['NPV:' num2str(NPV)]); end;
classification=[diagnosis classification];

% Training classification: all data no xval
if pca==1
	[Z,A,B]=prepZ(data(:,3:n),covariance_method);
      	[variance,eigval,eigvec,compload]=pcaZ(Z,SIG_EV,dsp);
        pcs = scoreD(data(:,3:n), eigvec, A, B,dsp);
else
        pcs=data(:,3:n);
end
[tev_index,tse,tsp,tppv,tnpv]=select_eig(pcs(:,:), diagnosis(:),dsp);

more on;

varargout(1)={PPV};
varargout(2)={NPV};
varargout(3)={unique_diagnosis};
varargout(4)={pc_selected};
varargout(5)={SIG_EV};

varargout(6)={tse};
varargout(7)={tsp};
varargout(8)={tppv};
varargout(9)={tnpv};

return; % end of function xval

% test xval
%twl=0:0.2:2*3.141
%m1=sin(twl)
%m2=cos(twl)
%d=[]; k=1
%for i=1:20
% for j=1:3
%  r=unifrnd(-1,4);
%  a=normpdf(r, 1,1);
%  b=normpdf(r, 2,1);
%  d=[d;[i,j,(a*m1+b*m2)/(a+b)]];
%  if unifrnd(0,1)>0.1 p(k)= (a>b); else p(k)= (a<b); end;
%  k=k+1;
% end
%end
% plot(twl,d(logical(p),3:size(d,2)),'r')
% plot(twl,d(logical(~p),3:size(d,2)),'b')
% [Se,Sp,classification,NPV,PPV,unique_diagnosis,pc_slected]=xval(p+1,d,1,.999,2,0)


% check for what SE and SP would be expected based on amount of normals and abnormals
%lns=9000;
%las=1000;
%
%rdiagnosis1=ones(lns+las,1);
%rindex=randperm(lns+las);
%raindex=rindex(1:las);
%rdiagnosis1(raindex)=2;
%
%rdiagnosis2=ones(lns+las,1);
%rindex=randperm(lns+las);
%raindex=rindex(1:las);
%rdiagnosis2(raindex)=2;
%
%stat_sum(rdiagnosis1,rdiagnosis2)
