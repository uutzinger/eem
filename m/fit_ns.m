function mean_square=fit_ns(a,x,f,width)
% for the fmins routine 
% mean_square = fit_norm(a,x,f,width)
  mean_square = sum( ( f - normpdf(x,a(1),a(2)) ).^2 );

