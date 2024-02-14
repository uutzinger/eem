function [index,significance]=ttestR(index1,index2,R,sign)
%Usage:
% function [index,significance]==ttestR(index1,index2,R,significance_goal)
% Selects the principal components with the largest significant difference
% R is the Score Matrix (PCS)
% index1 and index2 is the pointer list for the two groups
% Returns an index to the EVs and the significance

m = size(R,2);
index = [];
significance = [];

for i=1:m,
 dist1=R(index1,i);
 dist2=R(index2,i);
 % CHECK VARIANCE
 %
 % Hypothesis is:  variances are equal
 % Alternative is: variances are not equal (two sided t-test)
 % H = 1 (are not equal) if significance is more than 0.95
 %
 [H,s] = ftest2(dist1,dist2,sign,0);
 if H == 0
  % disp('Variances are equal');
  % CHECK MEAN
  %
  % Hypothesis is:  means are equal
  % Alternative is: means are not equal (two sided t-test)
  % H = 1 (are not equal) if significance is more than 0.95
  %
  [H,s] = TTEST2(dist1,dist2,sign,0);
  %if H == 1
   % disp(num2str(H));
   index = [index;i];
   significance = [significance; s];
  %end
 else
  % disp('Variances are NOT equal');
  [H,s] = TTEST3(dist1,dist2,sign,0);
  %if H == 1
   index = [index;i];
   significance = [significance; s]; % mean difference is dominant
  %end
 end
end

[significance,i] = sort(significance);
index = index(i);

