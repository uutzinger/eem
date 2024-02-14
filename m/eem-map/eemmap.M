%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% EEM MAP
% =======
% 
% Data for this fluroescence emission matrice map originated
% - RRKs Spex library
% - FAD phantom measurements
% - Shih Hui Cheng collagen/ellastin master thesis
% - Initial map programming by Youseph Yazdi
%
% Needs routines, wysiwyg, spot, ellipse
%
% University of Texas Austin, Urs Utzinger
% utzinger@mail.utexas.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clf
z=0;
axis([250 800 250 550])
grid
wysiwyg;

h=patch([330 600 770 500 330], [330 330 500 500 330],[.9 .9 .9]);
set(h,'LineStyle','-')
% set(h,'Color','black')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Raley
h=line([250 550],[250 550]); %RA
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)
h=line([500 800],[250 400]); %RA
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Water Raman
h=line([274 679],[250 550]); %WR
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HbO2 345
h=line([345 345],[250 345],[z z]);
set(h,'LineStyle','-')
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)
h=line([345 800],[345 345],[z z]);
set(h,'LineStyle','-')
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)

% HbO2 414
h=line([414 414],[250 414],[z z]);
set(h,'LineStyle','-')
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)
h=line([414 800],[414 414],[z z]);
set(h,'LineStyle','-')
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)

% HbO2 543
h=line([543 543],[250 543],[z z]); 
set(h,'LineStyle','-')
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)
h=line([543 800],[543 543],[z z]); 
set(h,'LineStyle','-')
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)

% HbO2 578
h=line([578 578],[250 550],[z z]);
set(h,'LineStyle','-')
set(h,'Color',[.6 .6 1])
set(h,'LineWidth',2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hb 430
h=line([430 430],[250 430],[z z]); 
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',2)
h=line([430 800],[430 430],[z z]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',2)

% Hb 556 
h=line([556 556],[250 556],[z z]); 
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',2)
h=line([556 800],[556 556],[z z]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',2)
% Hb 758
h=line([758 758],[250 758],[z z]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',2)
h=line([758 800],[758 758],[z z]);
set(h,'LineStyle','-')
set(h,'Color','red')
set(h,'LineWidth',2)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Amino Acids
c=[0.7 0.9 0.7];
hold on

% Tryptophan 290 / 330 .5
spot(280,300,310,360,c) %tryptophan
plot(330,290,'xk')

% Tyrosin 270 / 303 1.
spot(260,280,290,310,c) %tyrosine
plot(303,270,'xk')

% Phenylalanine 260 / 282 .25
spot(250,270,270,290,c) %ph
plot(282,260,'xk')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Structural Proteins

c=[.9 .9 0];
% Shih hui Cheng
% Collagen type III 280 / 295 9.0e5
% Collagen type III 280 / 350 9.7e5
% Collagen type III 330 / 410 1.3e4
spot(270,285,290,300,c); 
plot(295,280,'xk')
spot(260,300,330,370,c);
plot(350,280,'xk')
spot(320,340,400,420,c);
plot(410,330,'xk')

c=[.8 .8 0];
% Shih hui Cheng
% Type I is most common
% Collagen type I 280 / 310 1.0e6
% Collagen type I 280 / 340 1.16e6
% Collagen type I 340 / 410 4.4e4
% Collagen type I 500 / 520 4.5e4
spot(270,290,300,320,c)
plot(310,280,'xk')
spot(265,295,320,360,c)
plot(340,280,'xk')
spot(330,350,400,420,c)
plot(410,340,'xk')
spot(485,515,505,535,c)
plot(520,500,'xk')

c=[.5 .5 0];
% Shih hui Cheng 
% Elastin 280 / 305 1.1e6
% Elastin 280 / 345 8.8e5
% Elastin 330 / 400 2.37e5
spot(275,285,300,310,c) 
plot(305,280,'xk')
spot(275,285,335,355,c) 
plot(345,280,'xk')
spot(320,340,390,410,c) 
plot(400,330,'xk')

% Elastin contains also FAD  450/530
% Elastin contains als0 NADH 350/460

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redox = FAD/(FAD+NADH)
%
c=[1 0 0];
% RRK notes / literature
% NADH 350 / 450 5.0 e5 +/-20em +/-20ex 
spot(330,370,430,470,c)
plot(450,350,'xk')
% NADH 290 / 450 4.5 e5 +/-10em +/-10ex
spot(280,300,440,460,c)
plot(450,290,'xk')

c=[.6 .6 1];
% Tissue phantom SPEX
% FAD 450 / 535  0.425 +/-20ex +/-20 em
spot(425,475,510,560,c)
plot(535,450,'xk')
% FAD 370 / 535  0.3   +/-10ex +/-20 em
spot(355,385,510,560,c)
plot(535,370,'xk')
% FAD 270 / 535  0.35   +/-10ex +/-20 em
spot(255,285,520,550,c)
plot(535,270,'xk')

c=[.8 0 .8];
% Porphyrin
% Porphyrin 400/630 +/-50ex   +/-10em
spot(350,450,625,635,c) 
plot(630,400,'xk')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% Locations
% 
% nadh
plot(450,350,'xk')
plot(450,290,'xk')
% fad
plot(535,450,'xk')
plot(535,370,'xk')
plot(535,270,'xk')
% prophyrin
plot(630,400,'xk')

% elastin
plot(400,330,'xk')
plot(345,280,'xk')
plot(305,280,'xk')

% collagen I
plot(310,280,'xk')
plot(340,280,'xk')
plot(410,340,'xk')
plot(520,500,'xk')

% collagen III
plot(295,280,'xk')
plot(350,280,'xk')
plot(410,330,'xk')

% Tryptophan 290 / 330 .5
plot(330,290,'xk')
% Tyrosin 270 / 303 1.
plot(303,270,'xk')
% Phenylalanine 260 / 282 .25
plot(282,260,'xk')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% labels
text(330,350,'RA') 
text(630,300,'RA')
text(360,350,'HbO2')
text(405,270,'HbO2')
text(530,340,'HbO2')
text(570,340,'HbO2')
text(650,410,'HbO2')
text(650,435,'Hb')
text(425,280,'Hb')
text(560,400,'Hb')
text(620,520,'R_H_2_O')

text(280,295,'Tryptophan')    %tryptophan
text(260,270,'Tyrosine')      %tyrosine
text(280,260,'Phenylalanine') %ph

text(635,390,'Porphyrin')
text(550,440,'FAD')
text(550,360,'FAD')
text(460,340,'NADH')
text(350,265,'Collagen I')
text(520,490,'Collagen I')
text(310,275,'Collagen III')
text(345,280,'Elastin')

box on;

set(gca, 'FontSize', 14)
xlabel('Emission(nm)')
ylabel('Excitation(nm)')
title('EEM Map')

set(gca,'Xtick',[250,300,350,400,450,500,550,600,650,700,750])
% set(gca,'Ytick',[])

% cd T:\users\urs\optics\tissue-optics
% print -dmeta eemmap
% print -depsc eemmap

% cd T:\applicat\pc\programming\matlab\toolbox\eem-map
