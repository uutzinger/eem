function plteem(eem,varargin)
%
%function plteembw(eem, pltmode, legend, linear, process, color, markings)
% Plots EEMs for publication:
% eem:			your data
% pltmode:     0=bw (default), 1=color, 2=3D (Andres), 3=jet color, 4=pink color, 5=slide (jet, colordef black)
% pltlegend:   0=none (default), 1=present -1 no text at all
% linear:      0,1,2,x 0=3decades linear inside decate, 1=linear, 0=0.001:0.01:0.1:1, -1=-1:1, x>10 number of steps
% process:     0|1=remove rayleigh (not implemented)
% color:       'b'=blue
% markings:    0|1= add chromophore markings (0-default)
%
% -
% The maximum is searched in the fluroescence spectrum in the area of
% 1.2*start_emission_wavelength and 0.8*end_emission_wavlength
% The EEM is scaled so that the max is 1.0.
% Countour lines are drawn in between the 3 intenisites
% 0.001-0.01-0.1-1
% with 10 equally spaced distances in each area.
% -
% Some of the EEMs are already scaled to 1 at the Tryptophan peak.
% Scale external with:
% [n,m]=size(abn09);
% abn09(2:n,2:m)=ab_mean.*abn09(2:n,2:m);
%
% Author: UU 1995-99
% Usage and changes of this software is restricted, contact:
% Urs Utzinger, Spectroscopy Laboratory UT Austin 1999

qq=length(varargin);

% Assign defaults if not all arguments were specified
if (qq >= 1)
   pltmode = varargin{1};
else pltmode = 0; end;

if (qq >= 2)
   pltlegend = varargin{2};
  else pltlegend = 0; end;
  
if (qq >=3)
   pltline = varargin{3};
  else pltline = 0; end;
  
if (qq >=4)
   process = varargin{4};
  else process = 0; end;
  
if (qq >=5)
   pltstr = varargin{5};
else pltstr = 'k'; end;

if (qq >=6)
   markings = varargin{6};
else markings = 0; end;

if ~ishold hold on; washold=0; else washold=1; end

cver=version;
[n,m]=size(eem);
em=eem(2:n,1)';
ex=eem(1,2:m);
rho_max=eem(1,1);

%min_em=10*floor(min(em)/10.);
%max_em=10*ceil(max(em)/10.);
%min_ex=10*floor(min(ex)/10.);
%max_ex=10*ceil(max(ex)/10.);
min_em=min(em);
max_em=max(em);
min_ex=min(ex);
max_ex=max(ex);

% some eems have zeros where no data was measured, cut it off in emission wavelength
[t1,t2]=getem(eem,max_ex);
if t1(max(find(t2~=0))) < max_em
   max_em=5*ceil(t1(max(find(t2~=0)))/5);
end

data=eem(2:n,2:m)';
%remove all possible NaN;
[i,j]=find(isnan(data));
data(i,j)=zeros(size(data(i,j)));

[tmax,temp1]=max(data);
[tmax,temp2]=max(tmax);
tmax_loc=[em(temp2),ex(temp1(temp2))];
%
% find maximum outside scatering lines
%

mi2=min(min(data));

ma=[];mi=[];locma=[];locmi=[];
ll=0.8;
for i = 1:m-1,
 index=find(data(i,:)~=0);
 mai=max(index); mii=min(index);
 if isempty(mai);    mai=size(data,2); end;
 if isempty(mii);    mii=1;  end;
 l = ll*(mai-mii);
 [mm,kk]=max(data(i,floor((mai+mii)./2-l/2):floor((mai+mii)./2+l/2))); ma=[ma, mm];
 locma = [locma, [ex(i);em(floor((mai+mii)./2-l/2)+kk-1)] ]; 
 [mm,kk]=min(data(i,floor((mai+mii)./2-l/2):floor((mai+mii)./2+l/2))); mi=[mi, mm];
 locmi = [locmi, [ex(i);em(floor((mai+mii)./2-l/2)+kk-1)] ];
end
[ma,kk]=max(ma);
ma_loc = locma(:,kk);
[mi1,kk]=min(mi);
mi_loc = locmi(:,kk);

% its better to use the total minimum for graphical representation
mi=mi2;

if mi <0 disp('Warning negative values in EEM!'); end
if mi >0 mi=0; end
%
% # of contour lines
%
steps = 10;
%
% The contour lines on a scale from 0-1

if pltline==1
	v = [0.001:(1-0.001)/steps:1];  
elseif pltline==0
	v = [0.001:(0.01-0.001)/steps:0.01, 0.01+(0.1-0.01)/steps:(0.1-0.01)/steps:0.1, 0.1+(1-0.1)/steps:(1-0.1)/steps:1];
elseif pltline==-1
   v = [-1:.1:1];
elseif pltline==2
	v = [0.001:(0.02-0.001)/steps:0.02, 0.02+(0.2-0.02)/steps:(0.2-0.02)/steps:0.2, 0.2+(1-0.2)/steps:(1-0.2)/steps:1];
elseif pltline==3
	v = [0.001:(0.03-0.001)/steps:0.03, 0.03+(0.3-0.03)/steps:(0.3-0.03)/steps:0.3, 0.3+(1-0.3)/steps:(1-0.3)/steps:1];
end
% sets zeros to nan so they won't be plotted
data(data==0) = nan * data(data==0); 
if cver(1)=='4'
   if markings;   markeem; end
   [c,h]=contour(em,ex,(data-mi)./(ma-mi),v);
elseif (pltmode==0)
   if markings;   markeem; end
   [c,h]=contour(em,ex,(data-mi)./(ma-mi),v,[pltstr,'-']);
elseif pltmode==1
   if markings;   markeem; end
   [c,h]=contour(em,ex,(data-mi)./(ma-mi),v);
elseif pltmode==2
   if markings;   markeem; end
   [c,h]=contourf(em,ex,(data-mi)./(ma-mi),v);
   %surf(em,ex,(data-mi)./(ma-mi)); view([0,90]);
   %shading interp;
   colormap(jet); colorbar; hold on;
elseif pltmode==3
   clf; colordef white; pltstr='k';
   if pltline==0
      em_step=(em(2)-em(1))/2; ex_step=(ex(2)-ex(1))/2;
   else
      em_step=(em(2)-em(1)); ex_step=(ex(2)-ex(1));
   end
   imgeem(eem,em_step,ex_step,'pink',.4,pltline,pltmode); hold on;
   if markings;   markeem; end
   [c,h]=contour(em,ex,(data-mi)./(ma-mi),v,[pltstr,'-']);
elseif pltmode==4
   clf; colordef white; pltstr='k';
   if pltline==0
      em_step=(em(2)-em(1))/2; ex_step=(ex(2)-ex(1))/2;
   else
      em_step=(em(2)-em(1)); ex_step=(ex(2)-ex(1));
   end
   imgeem(eem,em_step,ex_step,'jet',.4,pltline,pltmode); hold on;
   if markings;   markeem; end
   [c,h]=contour(em,ex,(data-mi)./(ma-mi),v,[pltstr,'-']);
elseif pltmode==5
   clf; colordef black; pltstr='w';
   if pltline==0
      em_step=(em(2)-em(1))/2; ex_step=(ex(2)-ex(1))/2;
   else
      em_step=(em(2)-em(1)); ex_step=(ex(2)-ex(1));
   end
   imgeem(eem,em_step,ex_step,'jet',-.4,pltline,pltmode); hold on;
   if markings;   markeem; end
   [c,h]=contour(em,ex,(data-mi)./(ma-mi),v,[pltstr,'-']);
else
   disp('pltmode must be [0,1,2,3,4,5]! Using default');
   pltmode=0;
   if markings;   markeem; end
   [c,h]=contour(em,ex,(data-mi)./(ma-mi),v,[pltstr,'-']);
end   
lc=length(c);

% Find Positions for values beeing ploted
 i=1; list=[]; level_old = 0; level_used = []; test1 = []; test2 = []; level_list=[];
 while i<=lc,
   level = c(1,i); % level   , 1, 2, pairs, level
   level_list=[level_list,level];
   pairs = c(2,i); % # pairs , 1, 2, pairs, # pairs
   if (level ~= level_old)
     level_used=[level_used;level];
     level_old = level;
   end
   test1 = [test1;level];
   temp1 = c(1,i+1:i+pairs);
   temp2 = c(2,i+1:i+pairs);
   temp3 = temp1 ./ temp2;
   % values must be inside the plot area
   % index=find((temp3>1.285) & (temp3<1.357) );
   index=find((temp3>1.15) & (temp3<1.6) );
   index_s = length(index);
   % save 2 possible positions
   if (index_s > 1)
    list=[list; level, c(1,index(round(index_s/2))+i), c(2,index(round(index_s/2))+i), c(1,index(index_s)+i), c(2,index(index_s)+i)];
   elseif (index_s > 0)
    list=[list; level, c(1,index(1)+i), c(2,index(1)+i),c(1,index(1)+i), c(2,index(1)+i)];
   end;
   i=i+pairs+1;
 end

%
% Adjust the plot size to 0.8 drawsize
%
set(gcf,'PaperUnits', 'inches', 'PaperOrientation', 'portrait', 'PaperPosition', [0.25 2.5 8 6]);
set(gcf,'InvertHardcopy','off');
wysiwyg; set(gca,'Fontsize',14);

if pltlegend==1
	%
	% Create listings of intensities
	% Print the locations
	%
 Extent = [0 0 0 0];
 Offset = round((max_em-min_em)/100);
 ll=size(list,1); if ll > 200 ll=200; end
 lv=length(v);
 kk=0;
 level_old = -99999999; legend_t = [];
 for jj = 1:ll
  % Print value on contour line
  if list(jj,1) ~= level_old kk=kk+1; legend_t=[legend_t;kk,list(jj,1)]; end
  h1=text(list(jj,2)+Offset,list(jj,3) , num2str(kk));
  level_old = list(jj,1); 
  set(h1, 'FontSize', 8);
  k=find(list(jj,1)==level_used);
  % set(h1, 'Color', map(k*lm/lh,:));
  % Check Position
  temp = get(h1,'Extent');
  Position =  get(h1, 'Position');
  % Does number overlap with old plot
  overlap=0;
  for i=1:length(Extent(:,1)),
   % New Text
   A=temp(1);
   B=temp(2);
   C=temp(1)+temp(3);
   D=temp(2)+temp(4);
   % Check with old Text
   AA=Extent(i,1);
   BB=Extent(i,2);
   CC=Extent(i,1)+Extent(i,3);
   DD=Extent(i,2)+Extent(i,4);
   if ~((C<AA) | ...
        (A>CC) | ...
        (D<BB) | ...
        (B>DD) )
    % disp(['Interaction: ', num2str(i)])
    overlap = 1;
   end
  end
  % It does overlap
  if overlap == 1
    Position(1)=Offset+list(jj,4);
    Position(2)=list(jj,5);
    set(h1, 'Position', Position);
  end;
  % Save list of used area by printing
  temp = get(h1,'Extent');
  Extent=[Extent; temp];
  % Mark location
  h2=plot(Position(1)-Offset,Position(2),'w+');
  % set(h2, 'Color', map(k*lm/lh,:));
 end
 %%
end

%
% Adjust Graphics
%
% adjust colors & draw style
map=colormap;
lm=length(map);
lh=length(h);
if pltline>1
   fact=pltline;
else
  fact=1;
end
for jj=1:lh
    if cver(1)=='4'
       if pltmode==0 set(h(jj),'Color',pltstr); end
       if (level_used(jj) < 0.01*fact )
          set(h(jj),'LineStyle','-')
       elseif (level_used(jj) < 0.1*fact)
          set(h(jj),'LineStyle',':')   
       else 
          set(h(jj),'LineStyle','-')
       end
    else
       if ~pltmode set(h(jj),'Color',pltstr); end
       if (level_list(jj) < 0.01*fact )
          set(h(jj),'LineStyle','-')
       elseif (level_list(jj) < 0.1*fact)
          set(h(jj),'LineStyle',':')   
       else 
          set(h(jj),'LineStyle','-')
       end
    end
end

% Create some axis text

if pltlegend==-1
 grid on; 
 h=xlabel('Emission(nm)');set(h,'FontSize', 14);
 h=ylabel('Excitation(nm)');set(h,'FontSize', 14);
 set(gca,'Box','on');set(gca,'FontSize', 14);
 axis([min_em max_em min_ex max_ex])
 if (ex(3)-ex(2) <= 10) & (length(ex) > 15)
    ext=ex(1:2:length(ex));
    set(gca,'YTick',ext);
 else
    set(gca,'YTick',ex);
 end
% scattering lines 
 h=plot([min(ex),max(ex)],[min(ex),max(ex)],'k-'); set(h,'Color',pltstr); 
 h=plot(2*[min(ex),max(ex)],[min(ex),max(ex)],'k-'); set(h,'Color',pltstr);
end

if pltlegend>-1
 loc_x= 1.03*min_em;
 loc_y= 0.99*max_ex;
 grid on; 
 h=xlabel('Emission(nm)');set(h,'FontSize', 14);
 h=ylabel('Excitation(nm)');set(h,'FontSize', 14);
 set(gca,'Box','on');set(gca,'FontSize', 14);
 axis([min_em max_em min_ex max_ex])
 if (ex(3)-ex(2) <= 10) & (length(ex) > 15)
    ext=ex(1:2:length(ex));
    set(gca,'YTick',ext);
 else
    set(gca,'YTick',ex);
 end
 %[i,j]=find(data==ma);
 %plot(em(j),ex(i),'+');
 %plot(em(j),ex(i),'o');
 h=text(loc_x,loc_y,['Highest value: ', num2str(tmax),' ', num2str(tmax_loc(1)),'/',num2str(tmax_loc(2))]);
 set(h, 'FontSize', 10);
 Extent = get(h,'Extent');
 loc_y=loc_y-1.02*Extent(4);
 h=text(loc_x,loc_y,['Scaled @: ',num2str(ma), ' ', num2str(ma_loc(2)),'/',num2str(ma_loc(1))]);
 set(h, 'FontSize', 10);
 % Mark it on the graph!
 h1=text(tmax_loc(1),tmax_loc(2),'M');
 set(h1, 'FontSize', 8);
 h1=text(ma_loc(2),ma_loc(1),'S');
 set(h1, 'FontSize', 8);
 if rho_max ~= 0
  loc_y=loc_y-1.02*Extent(4);
  h=text(loc_x,loc_y,['Rhodamine @: ',num2str(rho_max)]);
  set(h, 'FontSize', 10);
 end
% scattering lines 
 h=plot([min(ex),max(ex)],[min(ex),max(ex)],[pltstr '-']);
 h=plot(2*[min(ex),max(ex)],[min(ex),max(ex)],[pltstr '-']);
end

if pltlegend==1
 %
 % Make legend
 %
 th=0;
 mxextent=[];
 loc_y=loc_y-1.02*Extent(4);
 loc_yy=loc_y;
 if kk > 15
  for jj = 1:15
   % disp(['First: ', num2str(jj)])
   % Print value on contour line
   h1=text(loc_x, loc_y, [num2str(legend_t(jj,1)),': ',num2str((ma-mi)*legend_t(jj,2)+mi)]);
   set(h1, 'FontSize', 8);
   k=find(legend_t(jj,2)==level_used);
   % set(h1, 'Color', map(k*lm/lh,:));
   Extent = get(h1,'Extent');
   loc_y=loc_y - 1.02*Extent(4);
   mxextent=max([mxextent;Extent(3)]);
  end
  loc_x=loc_x+1.04*mxextent;
  loc_y=loc_yy;
  for jj = 16:kk
   % disp(['First: ', num2str(jj)])
   % Print value on contour line
   h1=text(loc_x, loc_y, [num2str(legend_t(jj,1)),': ',num2str((ma-mi)*legend_t(jj,2)+mi)]);
   set(h1, 'FontSize', 8);
   k=find(legend_t(jj,2)==level_used);
   % set(h1, 'Color', map(k*lm/lh,:));
   Extent = get(h1,'Extent');
   loc_y=loc_y - 1.02*Extent(4);
  end
 else
  for jj = 1:kk
   % disp(['First: ', num2str(jj)])
   % Print value on contour line
   h1=text(loc_x, loc_y, [num2str(legend_t(jj,1)),': ',num2str((ma-mi)*legend_t(jj,2)+mi)]);
   set(h1, 'FontSize', 8);
   k=find(legend_t(jj,2)==level_used);
   % set(h1, 'Color', map(k*lm/lh,:));
   Extent = get(h1,'Extent');
   loc_y=loc_y - 1.02*Extent(4);
  end
 end
end %legend

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not edit this line without contacting UU
name = 'UT Austin'; logo = 'UU';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos = [0.9*max_em min_ex+2];
fontsize = 6; color = [0 0 0]; ftname = 'helvetica';
d = date; di=findstr(d,'-'); d=d(di(1)+1:length(d));
string = [name ' ' d ' ' logo];
th = text(pos(1,1),pos(1,2),string); set(th,'fontsize',fontsize(1),'fontname',ftname,'color',color)

if ~washold hold off; end
