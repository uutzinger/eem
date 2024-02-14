function eem_corrected=eemzero(eem,correct);
% eem_corrected=eemzero(eem,correct);
% corrects zero offset problems
% eem          = uncorrected eem
%
% allways sets NaN to zero
% allways shifts spectrum so that negative values > -100.0
%
%       correct =  0, apply no subtraction
%       correct =  1, apply DC subtraction 9 pixels from values at the end of the spectrum;
%       correct = -1, apply DC subtraction 9 pixels from values at the beginning of the spectrum;
%       correct =  x, apply DC subtraction x pixels from values at the end of the spectrum;
%       correct = -x, apply DC subtraction from values at the beginning of the spectrum;

% critical value

c1=-100;
[n,m]=size(eem);
eem_d=eem(2:n,2:m);
em=eem(2:n,1);
ex=eem(1,2:m);
r=eem(1,1);
flag =0;

input_size=size(eem_d);

if ~(correct==0)

 if (correct==1)
  for i=1:input_size(1,2)
    DC_value=mean(eem_d(input_size(1,1)-8:input_size(1,1),i));
    % subtract
    eem_d(:,i)=eem_d(:,i)-DC_value;
  end %for
 end %if
 if (correct==-1)
  for i=1:input_size(1,2)
     % get DC value from the first 9 points
     DC_value=mean(eem_d(1:9,i));
     % subtract
     eem_d(:,i)=eem_d(:,i)-DC_value;
  end %for
 end %if
 if (correct<-1)
  for i=1:input_size(1,2)
     % get DC value from the first correct points
     DC_value=mean(eem_d(1:correct,i));
     % subtract
     eem_d(:,i)=eem_d(:,i)-DC_value;
  end %for
 end %if
 if (correct>1)
  for i=1:input_size(1,2)
     % get DC value from the last correct points
     DC_value=mean(eem_d(input_size(1,1)-correct+1:input_size(1,1),i));
     % subtract
     eem_d(:,i)=eem_d(:,i)-DC_value;
  end %for
 end %if
end %if

% rest zeros
%eem_d(eem_d<0) = 0.0*eem_d(eem_d<0);
for i=1:input_size(1,2)
 min_eem=min(eem_d(:,i));
 if min_eem < c1
  flag = 1;
  eem_d(find(eem_d(:,i)),i) = eem_d(find(eem_d(:,i)),i) - min_eem + c1;
 end
end %for
if flag disp('Warning: negative values in EEM adjusted'); end
% reset NaN
[i,j]=find(isnan(eem_d));
eem_d(i,j)=zeros(size(eem_d(i,j)));
eem_corrected=[[r,ex];em,eem_d];

end



