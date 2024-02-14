function markcoll()
%this function will mark the EEM with the literature values for collagen fluorescence plus amino acids
%values were found from cited literature in fluorescence tables from Biomedical Photonics Handbook, 2003, Tuan Vo-Dinh ed.
%the superscript citation number corresponds to the citation number in the book

%Amino Acids are blue
%Collagen is black

%Phenylalanine 260/280 
%symbol 'Phe'
h=text(280,260,'O');
get(h);
set(h,'FontSize',14);
set(h,'Color','r');
set(h,'FontWeight','bold');
f = text(270,250,'Phe^2^2');
set(f,'Color','b');

%Tyrosine
%symbol 'Tyr'
h=text(300,275,'O');
get(h);
set(h,'FontSize',14);
set(h,'Color','r');
set(h,'FontWeight','bold');
f = text(300,265,'Tyr^2^2');
set(f,'Color','b');

%Tryptophan
%symbol 'Tryp'
h=text(350,280,'O');
get(h);
set(h,'FontSize',14);
set(h,'Color','r');
set(h,'FontWeight','bold');
f = text(355,290,'Tryp^3^,^8^,^2^2');
set(f,'Color','b');

%Collagen type I
%symbol 'CI'
h=text(320,280,'O');
get(h);
set(h,'FontSize',14);
set(h,'FontWeight','bold');
f = text(310,290,'CI^3^,^6^,^8^,^1^0');
set(f,'Color','b');

h=text(340,280,'O');
get(h);
set(h,'FontSize',14);
set(h,'FontWeight','bold');
f = text(335,265,'CI^1^0, El^1^0');
set(f,'Color','b');

h=text(385,265,'O');
get(h);
set(h,'FontSize',14);
set(h,'FontWeight','bold');
f = text(385,255,'CI^6');
set(f,'Color','b');

h=text(390,270,'O');
get(h);
set(h,'FontSize',14);
set(h,'FontWeight','bold');
f = text(390,280,'CI^3^,^8');
set(f,'Color','b');

h=text(390,330,'O');
get(h);
set(h,'FontSize',14);
set(h,'FontWeight','bold');
f = text(380,320,'CI^6');
set(f,'Color','b');

h=text(395,340,'O');
get(h);
set(h,'FontSize',14);
set(h,'FontWeight','bold');
f = text(395,350,'CI^3^,^8');
set(f,'Color','b');

h=text(410,340,'O');
get(h);
set(h,'FontSize',14);
set(h,'FontWeight','bold');
f = text(420,340,'CI^1^0');
set(f,'Color','b');

%LP and HP are known fluorescent cross-links found in type I Collagen
h=text(400,325,'O');
get(h);
set(h,'FontSize',14);
set(h,'FontWeight','bold');
f = text(400,315,'El,CI,HP,LP^1^1^,^1^2');
set(f,'Color','b');

%
% Elastin
%
h=text(410,360,'O'); get(h); set(h,'FontSize',14); set(h,'FontWeight','bold');
f = text(410,360,'EL^3^,^8'); set(f,'Color','b');

h=text(420,350,'O'); get(h); set(h,'FontSize',14); set(h,'FontWeight','bold');
f = text(420,350,'EL^6'); set(f,'Color','b');

h=text(410,260,'O'); get(h); set(h,'FontSize',14); set(h,'FontWeight','bold');
f = text(410,260,'EL^3^,^8'); set(f,'Color','b');

h=text(500,410,'O'); get(h); set(h,'FontSize',14); set(h,'FontWeight','bold');
f = text(500,410,'EL^6^'); set(f,'Color','b');

h=text(490,420,'O'); get(h); set(h,'FontSize',14); set(h,'FontWeight','bold');
f = text(490,420,'EL^3^,^8'); set(f,'Color','b');

%
%
%

h=text(530,450,'O'); get(h); set(h,'FontSize',14); set(h,'FontWeight','bold');
f = text(530,450,'EL^3^,^6^,^8, Cl^6'); set(f,'Color','b');
