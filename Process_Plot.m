%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Example fluorolog processing file of EEM data
% Urs Utzinger 2024
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make sure this program can access 
% assmbleSPC.m
% readSPC.mhas 
% newplteem.m
% getem.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%
% Go to your project folder where you want files to be saved
cd ''

% Make sure you have MCORRECT.SPC and XCORRECT.SPC in your project folder

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%
% Load Emissions Correction Factors
[x,y]=readSPC('MCORRECT.SPC');
indx=find(x<=320 & x>=250);
[P,S]=polyfit(x(indx),y(indx),2);
xn=[270:1:320];
yn=polyval(P,xn);
indx=find(xn<290);
mcorr=[[xn(indx)';x],[yn(indx)'+.045;y]];
% Load Excitation Correction Factors
[x,y]=readSPC('XCORRECT.SPC');
% Attempt to extrapolate to 650, not very good, should measure
xcorr=[[x,y]; ...
    [[605;     610 ;    615;     620;      625;       630;       635;       640;       645;       650], ...
     [0.92;    0.948; 0.9660;    0.9765;    0.9849;    0.9943;    1.0007;    1.0080;    1.0133;    1.0185]]];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Correcting for slit width if applicable
% 1nm ex 26.2 24.36
% 3nm ex 1 1
% 5nm ex 0.352 0.352

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preprocess Data
% EEM measured with
% ex 250..600
% em 270..700
% Intensity Corrections
% mcorr 270..850
% xcorr 240..650

% 1ex 1em Barium Sulfate
clear EEM ref
StartDir='\BaS_TiOx';
FilePattern='BAS???.SPC';
[EEM,Ref]=assembleSPC(StartDir, FilePattern, xcorr, mcorr);
save BaS.eem EEM -ASCII -TABS;
save BaS.ref Ref -ASCII -TABS;

% 1ex-1em Titanium Oxide
clear EEM ref
StartDir='BaS_TiOx';
FilePattern='TiO???.SPC';
[EEM,Ref]=assembleSPC(StartDir, FilePattern, xcorr, mcorr);
save TiO.eem EEM -ASCII -TABS;
save TiO.ref Ref -ASCII -TABS;

% 1ex-1em Water
clear EEM ref
StartDir='BaS_TiOx';
FilePattern='W???.SPC';
[EEM,Ref]=assembleSPC(StartDir, FilePattern, xcorr, mcorr);
save W.eem EEM -ASCII -TABS;
save W.ref Ref -ASCII -TABS;

% 1ex-1em water
clear EEM ref
StartDir='S:\projects\DATA Fluorolog\TiOx BaS\BaS_TiOx';
FilePattern='W???.SPC';
[EEM,Ref]=assembleSPC(StartDir, FilePattern, xcorr, mcorr);
save W.eem EEM -ASCII -TABS;
save W.ref Ref -ASCII -TABS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load and Plot Data

EEM=load('BaS.eem'); 
figure(11); clf
colordef white; set(gcf, 'Color', [1,1,1])
clf; newplteem(EEM,3,-1,0,0,'k',0,100000,1); 
%clf; newplteem(EEM,3); 
title('Barium Sulfate');
print -dmeta BaS_eem;

EEM=load('TiO.eem'); 
figure(12); clf
colordef white; set(gcf, 'Color', [1,1,1])
clf; newplteem(EEM,3,-1,0,0,'k',0,100000,1); 
%clf; newplteem(EEM,3); 
title('Titanium Oxide');
print -dmeta TiO_eem;

EEM=load('W.eem'); 
figure(13); clf
colordef white; set(gcf, 'Color', [1,1,1])
clf; newplteem(EEM,3,-1,0,0,'k',0,100000,1); 
%clf; newplteem(EEM,3); 
title('Water');
print -dmeta Water_eem;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Compare Data

W=load('W.eem'); 
T=load('TiO.eem'); 
B=load('BaS.eem'); 

l=[ 280, 320, 350, 450, 550];

[w,Wp]=getem(W,l);
[w,Tp]=getem(T,l);
[w,Bp]=getem(B,l);

f=figure(1); clf; 
%
set(f, 'PaperOrientation', 'portrait'); 
set(f, 'PaperPositionMode', 'manual'); 
set(f, 'PaperPosition',[0.25,0.25,8,10.5]);
set(f, 'PaperSize',[8.5 11]);
set(f, 'PaperUnits','inches');
%
set(f, 'Units', 'pixels');
set(f, 'Position', [1 1 1024 1024*11/8.5]);
set(f, 'Color',[1 1 1]);
set(f, 'Resize','on');
%
subplot(3,2,1)
indx=(Tp(:,1)>0); h1=plot(w(indx),Tp(indx,1),'-'); set(h1,'Color','k','LineWidth',3)
hold on;
indx=(Wp(:,1)>0); h2=plot(w(indx),Wp(indx,1),'-.'); set(h2,'Color','k','LineWidth',1)
legend([h2,h1],'Water','TiOx')
set(title([num2str(l(1)),'nm ex']),'FontSize',12);
set(ylabel('Fluorescence [c.u.]'), 'FontSize',12);
set(gca,'FontSize',12);

subplot(3,2,2)
indx=(Tp(:,2)>0); h1=plot(w(indx),Tp(indx,2),'-'); set(h1,'Color','k','LineWidth',3)
hold on;
indx=(Wp(:,2)>0); h2=plot(w(indx),Wp(indx,2),'-.'); set(h2,'Color','k','LineWidth',1)
legend([h2,h1],'Water','TiOx')
set(title([num2str(l(2)),'nm ex']),'FontSize',12);
set(gca,'FontSize',12);

subplot(3,2,3)
indx=(Tp(:,3)>0); h1=plot(w(indx),Tp(indx,3),'-'); set(h1,'Color','k','LineWidth',3)
hold on;
indx=(Wp(:,3)>0); h2=plot(w(indx),Wp(indx,3),'-.'); set(h2,'Color','k','LineWidth',1)
legend([h2,h1],'Water','TiOx')
set(title([num2str(l(3)),'nm ex']),'FontSize',12);
% a=axis; axis([a(1),a(2),a(3),50000]);
set(gca,'FontSize',12);

subplot(3,2,4)
indx=(Tp(:,4)>0); h1=plot(w(indx),Tp(indx,4),'-'); set(h1,'Color','k','LineWidth',3)
hold on;
indx=(Wp(:,4)>0); h2=plot(w(indx),Wp(indx,4),'-.'); set(h2,'Color','k','LineWidth',1)
legend([h2,h1],'Water','TiOx')
set(title([num2str(l(4)),'nm ex']),'FontSize',12);
set(gca,'FontSize',12);

subplot(3,2,5)
indx=(Tp(:,5)>0)&(w>560); h1=plot(w(indx),Tp(indx,5),'-'); set(h1,'Color','k','LineWidth',3)
hold on;
indx=(Wp(:,5)>0)&(w>560); h2=plot(w(indx),Wp(indx,5),'-.'); set(h2,'Color','k','LineWidth',1)
legend([h2,h1],'Water','TiOx')
% a=axis; axis([200, 1600, 0, 100]);
set(title([num2str(l(4)),'nm ex']),'FontSize',12);
set(gca,'FontSize',12);
set(xlabel('Wavelength [nm]'), 'FontSize',12);
%
print(f,'-dmeta','TiO_Comparison.emf');
print(f,'-depsc','-tiff','TiO_Comparison.eps');
%

