function [h, significance] = ftest2(x,y,alpha,tail)			
%FTEST2	Hypothesis test: Compares the variance of two samples.
%	[H,SIGNIFICANCE CI] = fTEST2(X,Y,ALPHA,TAIL) performs a T-test to  
%	determine whether two samples from a normal distribution
%	could have the same variance. 
%
%	The null hypothesis is: "variances are equal".
%	For TAIL =  0  the alternative hypothesis is: "variances are not equal."
%	For TAIL =  1, alternative: "variance of X is greater than variance of Y."
%	For TAIL = -1, alternative: "variance of X is less than variance of Y."
%	TAIL = 0 by default.
%
%	ALPHA is desired significance level (ALPHA = 0.05 by default). 
%	SIGNIFICANCE is the probability of observing the given result by 
%	chance given that the null hypothesis is true. Small values of 
%	SIGNIFICANCE cast doubt on the validity of the null hypothesis.
%	H=0 => "Do not reject null hypothesis at significance level of alpha."
%	H=1 => "Reject null hypothesis at significance level of alpha."

if nargin < 2, 
    error('Requires at least two input arguments'); 
end

[m1 n1] = size(x);
[m2 n2] = size(y);
if (m1 ~= 1 & n1 ~= 1) | (m2 ~= 1 & n2 ~= 1)
    error('ttest2 requires that X and Y be vectors.');
end
 
if nargin < 3, 
    tail = 0; 
end 

if nargin < 4, 
    alpha = 0.05; 
end 

if (alpha <= 0 | alpha >= 1)
    fprintf('Warning: significance level must be between 0 and 1\n'); 
    h = NaN;
    sig = NaN;
    return;
end

lx=length(x);
ly=length(y);
dfx = lx - 1;
dfy = ly - 1;
sx = var(x);
sy = var(y);

ratio = sx/sy;
criticalvalue = finv(1 - alpha / 2,dfx,dfy);

% Find the significance probability for the  tail = 1 test.
significance  = fcdf(ratio,dfx,dfy);
% Adjust the significance probability for other null hypotheses.
if tail == -1
    significance = 1 - significance;
elseif tail == 0
    significance = 2 * min(significance,1 - significance);
end

% Determine if the actual significance exceeds the desired significance
h = 0;
if significance <= alpha, 
    h = 1; 
end 

if isnan(significance), 
    h = NaN; 
end
