function mean_square=fit_gs(a,x,f)
% Use only for the fmins routine 
% mean_square = fit_gam(a,x,f)
  mean_square = sum( ( f - gampdf(x,a(1),a(2))).^2 );

