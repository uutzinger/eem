function [h, significance] = ttest3(x,y,alpha,tail)			
%TTEST3 This function is based on the TTEST2 funcion, but
%	assuming unequal variances.  By Vanessa Trujillo on 11/96.
%       It approximates the degrees of freedom.
%
%TTEST2	Hypothesis test: Compares the averages of two samples.
%	[H,SIGNIFICANCE CI] = TTEST(X,Y,ALPHA,TAIL) performs a T-test to  
%	determine whether two samples from a normal distribution
%	(with unknown but equal variances) could have the same mean. 
%
%	The null hypothesis is: "means are equal".
%	For TAIL =  0  the alternative hypothesis is: "means are not equal."
%	For TAIL =  1, alternative: "mean of X is greater than mean of Y."
%	For TAIL = -1, alternative: "mean of X is less than mean of Y."
%	TAIL = 0 by default.
%
%	ALPHA is desired significance level (ALPHA = 0.05 by default). 
%	SIGNIFICANCE is the probability of observing the given result by 
%	chance given that the null hypothesis is true. Small values of 
%	SIGNIFICANCE cast doubt on the validity of the null hypothesis.
%	H=0 => "Do not reject null hypothesis at significance level of alpha."
%	H=1 => "Reject null hypothesis at significance level of alpha."

%	References:
%	   [1] E. Kreyszig, "Introductory Mathematical Statistics",
%	   John Wiley, 1970, section 13.4. (Table 13.4.1 on page 210)

%	Copyright (c) 1993 by The MathWorks, Inc.
%	$Revision: 1.1 $  $Date: 1993/05/24 18:56:46 $

%function [h, significance, ci] = ttest3(x,y,alpha,tail)

if nargin < 2, 
    error('Requires at least two input arguments'); 
end

[m1 n1] = size(x);
[m2 n2] = size(y);
if (m1 ~= 1 & n1 ~= 1) | (m2 ~= 1 & n2 ~= 1)
    error('ttest2 requires that X and Y be vectors.');
end
 
if nargin < 4, 
    tail = 0; 
end 

if nargin < 3, 
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
dfx = lx + 1;
dfy = ly + 1;
%dfe  = dfx + dfy;
sx = var(x);
sy = var(y);

difference = mean(x) - mean(y);
ratio = difference/sqrt( sx/lx + sy/ly );
dfe = round( (sx/lx + sy/ly)^2 / ( ((sx/lx)^2)/dfx + ((sy/ly)^2)/dfy ) -2 );
criticalvalue = tinv(1 - alpha / 2,dfe);

% Find the significance probability for the  tail = 1 test.
significance  = tcdf(ratio,dfe);
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
