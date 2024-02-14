function [eem_corrected,factor] = eemsub_bgc(EEM,BG);
% eem      = uncorrected eem
% eem_sub  = eem to subtract
% factor = multiplation factor to multiply background by before subtraction
% eem_corrected = eem of the size of eem with subtraction applied: EEM -
% factor*BG
%
[n,m]=size(EEM);
eem_d=EEM(2:n,2:m);
em=EEM(2:n,1);
ex=EEM(1,2:m);
r=EEM(1,1);

[nn,mm]=size(BG);
BG_d=BG(2:nn,2:mm);

EEM_C = zeros(size(eem_d));
factor = [];

%if (n-nn~=0) | (m-mm~=0)
% warning('Not the same size of eems')
 %em_sub=eem_sub(2:nn,1);
 %ex_sub=eem_sub(1,2:mm);
 %eem_sub_d = INTERP2(ex_sub,em_sub,eem_sub_d,ex,em);
 %end

for i = 1:1:length(ex),
        l_ex = ex(i);
        bg_em = [em(2*i-1):5:em(end)]';
        sp_em = bg_em;
        sp = eem_d((2*i-1):length(em),i);
        bg = BG_d((2*i-1):length(em),i);  
        fctr = fminsearch(@bg_fit,1,[],bg_em,bg,sp_em,sp,l_ex);
        
        factor = [factor;fctr];
        
      if i == 1
                          
                             %%Check the residuals prior to subtracting
       res = fctr*bg;
        
          EEM_C(:,i) = sp - fctr*bg;   
    else   
        a = zeros(i,1);
        b = zeros(i-2,1);
        EEM_C(:,i) = [a;b;(sp - fctr*bg)];  
    end  
    
    end

    

  eem_corrected=[[r,ex];em,EEM_C];
