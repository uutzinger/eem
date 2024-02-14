function [significance]=utest(data1,data2,sign,verb)
%Usage:
% [significance]=test(data1,data2,significance_goal,verbose)
% test for euqual mean of data1 and data2
% returns significance, if low are not equal
% checks for variance equal or not and deciceds based on significance_goal
% 
significance = [];

 % CHECK VARIANCE
 %
 % Hypothesis is:  variances are equal
 % Alternative is: variances are not equal (two sided t-test)
 % H = 1 (are not equal) if significance is more than 0.95
 %
 [H,s] = ftest2(data1,data2,sign,0);

 if H == 0
  if verb disp('Variances are equal'); end;
  % CHECK MEAN
  %
  % Hypothesis is:  means are equal
  % Alternative is: means are not equal (two sided t-test)
  % H = 1 (are not equal) if significance is more than 0.95
  %
  [H,significance] = ttest2(data1,data2,sign,0);
 else
  if verb disp('Variances are NOT equal'); end
  [H,significance] = ttest3(data1,data2,sign,0);
 end


