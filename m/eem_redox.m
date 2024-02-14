function [redox,FAD,NADH]=eem_redox(eem,varargin)
% [redox, FAD, NADH]=eem_redox(eem,feem,plt)
% Input:
% eem
% feem = 1 NADH ex is measured red shifted
% plt = 1 produce plots
%
% Output:
% redox=FAD/(FAD+NADH)
% FAD,NADH
qq=length(varargin);
if qq>=1
  feem=varargin{1};
else feem =  0; end;   
   
if qq>=2
  plt=varargin{2};
else plt = 0; end;   

% FAD  450 / 535  +/-20ex +/-20em
% NADH 350 / 450  +/-20em +/-20ex 

if feem
   FAD_ex  = [445,450,455];
   FAD_ems = 530;
   FAD_eme = 540;
   NADH_ex = [360,365,370];
   NADH_ems= 445;
   NADH_eme= 455;
else
   NADH_ex = [345,350,355];
   NADH_ems= 445;
   NADH_eme= 455;
   FAD_ex  = [445,450,455];
   FAD_ems = 530;
   FAD_eme = 540;
end

[em_FAD,  FAD]=getem(eem,FAD_ex);
m_fad=mean(FAD');
id=find(em_FAD>=FAD_ems & em_FAD<=FAD_eme);
FAD=mean(m_fad(id));

[em_NADH,NADH]=getem(eem,NADH_ex);
m_nadh=mean(NADH');
in=find(em_NADH>=NADH_ems & em_NADH<=NADH_eme);
NADH=mean(m_nadh(in));

redox=FAD./(FAD+NADH);

if plt > 0
   subplot(1,2,1); 
   plot(em_FAD, m_fad,'r'); hold on; 
   plot(em_FAD(id),m_fad(id),'go')
   plot(em_NADH, m_nadh,'b')
   plot(em_NADH(in),m_nadh(in),'go')
   title('emission spectra')
   a=axis;
   axis([330 700, a(3), a(4)])
   
   subplot(1,2,2); 
   [ex_FAD,  FADex] =getex(eem,(FAD_ems+FAD_eme)/2); 
   [ex_NADH, NADHex]=getex(eem,(NADH_ems+NADH_eme)/2);
   plot(ex_FAD, FADex,   'r'); hold on; 
   plot(ex_NADH, NADHex, 'b');
   plot(FAD_ex(2),0,'ro')
   plot(NADH_ex(2),0,'bo')
   title('excitation spectra')
   a=axis;
   axis([330 500, a(3), a(4)])
end

