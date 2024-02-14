function mean_square=fit_ns(a,x,f)
% Use only for the fmins routine 
% mean_square = fit_ns(a,x,f)
  mean_square = sum( ( f - normpdf(x,a(1),a(2)) ).^2 );

