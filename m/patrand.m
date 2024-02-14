function [training_index,validation_index]=patrand(meas,split,err);
%
% [training_index,validation_index]=patrand(meas,split,err);
% meas  = [patient_nr ; site];
% split = number of groups, e.g. 10 => 10% of patients in validation
%         will return 10 sets indeces for all measurements
%         which is 10 validation / training set combinations
% meas  = colums of patientnr followed by site number and diagnosis
% err   = maximal allowed difference in disease prevalence in training set from total set
%
% uses a random number generator (clock seed) and creates subgroups until the 
% disease prevalence is in the err limits
%
% Should work for normal conditions, has exception handling but not well checked.
% Check distribution if small groups are present.
%
% UU 7/1999 UT Austin

training_index=[];
validation_index=[];
rand('seed',sum(100*clock));

[t,ti]=sort(meas(1,:));
meas=meas(:,ti);

PT=unique(meas(1,:));
nr_PT=length(PT);
diag=unique(meas(3,:));
nr_diag=length(diag);

% real group size
nr_PT_t(1:split-1)=fix(nr_PT/split);
nr_PT_t(split)=nr_PT-sum(nr_PT_t);
nr_PT_v=nr_PT-nr_PT_t;

% intial diagnostic prevalence
d=unique(meas(3,:));
for i=1:length(d),
  nd(i)=sum(meas(3,:)==d(i));
end
nd=nd./sum(nd);

bound=[0:1/split:1];
cont=1; runs=1; % do loop at least once
q_max=99999; rnd_nr_best=[];

while cont & runs <= 20
   index_tv=[];
   rnd_nr=rand(nr_PT,1);
   % make split number of groups, index_tv=1 if validation set
   for i=1:split,
      tmp=rnd_nr>=bound(i) & rnd_nr<bound(i+1);
      index_tv =[index_tv, tmp];
   end      
   
   nd_t_all=[];
   for i=1:split,
      % find patients in validation and training set
		PT_v=PT(index_tv(:,i));
		PT_t=PT(~index_tv(:,i));
		v=[]; t=[];
      % find measurements in validation and training set
      for i=1:length(PT_v),
         v=[v,find(meas(1,:)==PT_v(i))];
		end;
      for i=1:length(PT_t),
         t=[t,find(meas(1,:)==PT_t(i))];
		end;
		meas_v=meas(:,v);
		meas_t=meas(:,t);

		% prevalence in current training set
		for i=1:length(d), % d is unique number of diagnoses
	  		nd_t(i)=sum(meas_t(3,:)==d(i));
		end
      nd_t_all=[nd_t_all; nd_t./sum(nd_t)];
   end
   q=sum(sum((abs(ones(split,1)*nd-nd_t_all) >err)));
   cont=q>0;
   % disp(num2str([runs,abs(nd-nd_t)]));
   runs=runs+1;
   % save best run   
   if q<q_max
      rnd_nr_best=rnd_nr; q_max=q;
   end
end % while random process

% Check if anything good was found
% if not take best
if runs > 20 
   disp('Warning: tried 20 times to find a random distribution within error limits.'); 
   disp('Aborting and continuing with best distribution found.');
   rnd_nr=rnd_nr_best;
   index_tv=[];
   % make split number of groups, index_tv=1 if validation set
   for i=1:split,
      tmp=rnd_nr>=bound(i) & rnd_nr<bound(i+1);
      index_tv =[index_tv, tmp];
   end      
end % check

% create final indeces
index=zeros(split,size(meas,2));
for i=1:split,
	   % find patients in validation and training set
		PT_v=PT(index_tv(:,i));
		PT_t=PT(~index_tv(:,i));
		v=[]; t=[];
      % find measurements in validation and training set
      for j=1:length(PT_v),
         v=[v,find(meas(1,:)==PT_v(j))];
		end;
      for j=1:length(PT_t),
         t=[t,find(meas(1,:)==PT_t(j))];
      end;
      index(i,v)=0; index(i,t)=1;
end % split

training_index=index;
validation_index=~index;

return;