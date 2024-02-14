function [eig_sel,Se,Sp,PPV,NPV,class]=select_eig(pcs,diagnosis,varargin)
% [eig_select,se,sp,ppv,npv,class]=select_eig(pcs,diagnosis,q)
% selecting eigenvetors based on pcs
% pcs : principal components: each column = 1 EV
% diagnosis: column, 1|2 (1=normal, 2=abnormal)
% q 1 = verbose
qq=length(varargin);
if qq>=1
   dsp=varargin{1};
else
   dsp=1;
end

if nargin < 2
   error('Need at least 2 inputs, type help select_eig')
end

eig_sel=[]; perf_old=0; % 1 = preformance is chance
pool=1:size(pcs,2);     % all eigenvectors available

while ~isempty(pool)
   clear sen spe perf ppv npv;
   % calculate preformance for all available eigenvectors from the pool combined with the already selected ones
   for i=1:length(pool),
       try
           class=classify(pcs(:,[eig_sel,pool(i)]), pcs(:,[eig_sel,pool(i)]), diagnosis);
           [Sp,Se,NPV,PPV,unique_dagnosis]=stat_sum(diagnosis,class);
           perf(i)=sum(Se); % This is little tricky, stat_sum calulcates Sens. for each diagnosis agains the other ones. If one has only two groups it returns sen(1) for diag==1 and sen(2) for diag==2 which is specificity
       catch
           perf(i)=0; % chance
       end % catch
   end
   [ma,mai]=max(perf);
   % check if prefromance increased
   if ma > perf_old
       eig_sel=[eig_sel,pool(mai)];
       perf_old=ma;
       if dsp disp(['Selected PC ' num2str(pool(mai)) ' Perf ' num2str(ma)]); end;
       % remove it from pool
       indx=ones(length(pool),1);	indx(mai)=0;
       pool=pool(logical(indx));
   else
       if dsp disp(['Rejected PC ' num2str(pool(mai)) ' Perf ' num2str(ma)]); end;
       pool=[]; % no more selection possible
   end;
end
% calculate final perfromance
class=classify(pcs(:,[eig_sel]), pcs(:,[eig_sel]), diagnosis);
[Sp,Se,NPV,PPV,unique_dagnosis]=stat_sum(diagnosis,class);
if dsp disp(['EV: ' num2str(eig_sel) ' | Se:' num2str(Se) ' | Sp:' num2str(Sp) ' | PPV:' num2str(PPV) ' | NPV:' num2str(NPV)]); end;

return;

