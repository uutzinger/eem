function dualplteem(eem1, eem2, varargin)
%
%function dualplteem(eem_contout, eem_image, pltmode, legend, linear, process, color, markings)
% based on newplteem
% Plots EEMs for publication:
% eem:			your data
% pltmode:     0=bw (default), 1=color, 2=3D, 3=jet color, 4=pink color, 5=slide (jet, colordef black)
% pltlegend:   0=none (default), 1=present, -1= no text at all
% linear:      0,1,2 0 = standard EEM plot
%              0 =  0.001:0.01:0.1:1 contourlines
%              1 =  0.001:0.1:1      contourlines
%              2 =  similar to option 0 between [0.5:1]  but inverted between [0:0.5],
%                   ideal for data in range [-x:+x]
% process:     0|1=remove rayleigh (not implemented)
% color:       'b'=blue
% markings:    0|1= add chromophore markings (0-default)
% scale max:   do not scale, but use this value for scaling
% scale min:   do not scale, but use this value for scaling
% r:           resample data (will affect also image) 2 times, 0 default
%              (no resample)
% ri:          resample image (not the data) ri times, 2 is default
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
% Author: UU 1995-2001
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

if (qq >=7)
   scalemax = varargin{7};
else scalemax = 0; end;

if (qq >=8)
   scalemin = varargin{8};
else scalemin = 0; end;

if (qq >=9)
   r = varargin{9};
else r = 0; end;

if (qq >=10)
   ri = varargin{10};
else ri = 2; end;

if ~ishold hold on; washold=0; else washold=1; end

cver=version;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% plot image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[n,m]=size(eem2);
em=eem2(2:n,1)';
ex=eem2(1,2:m);
rho_max=eem2(1,1);

if (r~=0)
    data=eem2(2:end,2:end);
    emn=sort([em,em(1:end-1)+(em(2:end)-em(1:end-1))/2]);
    exn=sort([ex,ex(1:end-1)+(ex(2:end)-ex(1:end-1))/2]);
    datan=interp2(ex,em,data,exn',emn);
    eem2=[[rho_max,exn];[emn',datan]];
    ex=exn;
    em=emn;
    [n,m]=size(eem2);
end;

% min_em=10*floor(min(em)/10.);
% max_em=10*ceil(max(em)/10.);
% min_ex=10*floor(min(ex)/10.);
% max_ex=10*ceil(max(ex)/10.);
min_em=min(em);
max_em=max(em);
min_ex=min(ex);
max_ex=max(ex);

% some eems have larger emission range than actually measured
% data is zero at these locations, cut it off in emission wavelength

[t1,t2]=getem(eem2,max_ex);
if t1(max(find(t2~=0))) < max_em
   max_em=5*ceil(t1(max(find(t2~=0)))/5);
end
[t1,t2]=getem(eem2,min_ex);
if t1(min(find(t2~=0))) > min_em
   min_em=5*ceil(t1(min(find(t2~=0)))/5);
end

data=eem2(2:n,2:m)';

% remove data where no data can be
for i=1:length(ex),
    indx=(em<=(ex(i)-5) | em>2*(ex(i)+5));
    data(i,indx)=NaN;
end

% remove all possible NaN;
NaNloc=isnan(data);
data(NaNloc)=0;

% NODATA IS 0

% find absolute maximum and minimum in data set
[tmax,temp1]=max(data);
[tmax,temp2]=max(tmax);
tmax_loc=[em(temp2),ex(temp1(temp2))];
%
[tmin,temp1]=min(data);
[tmin,temp2]=min(tmin);
tmin_loc=[em(temp2),ex(temp1(temp2))];

%
% find maximum and minimum outside scatering lines 
% search in 80% of data range 
%

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
[mi,kk]=min(mi);
mi_loc = locmi(:,kk);

% Absolute values are
% tmin;
% tmax;
% Values within eem data are
% ma, mi
%
% its better to use the total minimum for graphical representation
% mi=tmin;

if scalemin~=0; mi=scalemin; end
if scalemax~=0; ma=scalemax; end

disp(['Absolute Max is ' num2str(tmax)])
disp(['Absolute Min is ' num2str(tmin)])
disp(['Scaling Max is ' num2str(ma)])
disp(['Scaling Min is ' num2str(mi)])

disp(['Min emission wavelength is ' num2str(min_em)])
disp(['Max emission wavelength is ' num2str(max_em)])
disp(['Min excitation wavelength ' num2str(min_ex)])
disp(['Max excitation is ' num2str(max_ex)])
%
% code removed by UU 5/27/2001
% if mi <0 disp('Warning negative values in EEM!'); end
% if mi >0 mi=0; end

%
% # of contour lines
%
steps = 10;
%
% The contour lines not scaled to the data (0-1)

%if pltline==1
    v = [1/steps:1/steps:1]; % linear in 10 steps
    my_range=[0,1];
%	% v = [0.001:(1-0.001)/steps:1];  % linear in 10 steps
%elseif pltline==0 % 0.001-0.01-0.1-1 3 decades but linear in between
%	v = [0.001:(0.01-0.001)/steps:0.01, 0.01+(0.1-0.01)/steps:(0.1-0.01)/steps:0.1, 0.1+(1-0.1)/steps:(1-0.1)/steps:1];
%    my_range=[0,0.01,0.1,1];
%elseif pltline==2
%    % symmetric around 0.5
%    v=  [[0.5+(0.01-0.001)/steps/2:(0.01-0.001)/steps:0.51],[0.51+(0.1-0.01)/steps:(0.1-0.01)/steps:0.6],[0.6+(1-0.1)/steps:(1-0.1)/steps:1]];
%    v=  [fliplr(1-v),v];
%    my_range=[0, 0.4, 0.49, 0.51, 0.6, 1];
%else
%    v = [0.001:(0.01-0.001)/steps:0.01, 0.01+(0.1-0.01)/steps:(0.1-0.01)/steps:0.1, 0.1+(1-0.1)/steps:(1-0.1)/steps:1];
%    my_range=[0,0.01,0.1,1];
%end

% sets zeros to nan so they won't be plotted
data(data==0) = NaN; 
data(NaNloc) = NaN;
eem2(2:end,2:end)=data';

if pltmode==3
   clf; colordef white; 
   pltstr='k';
   em_step=(em(2)-em(1))/ri; ex_step=(ex(2)-ex(1))/ri;
   newimgeem(eem2,em_step,ex_step,'pink',.4,ma,mi,v); hold on;
   if markings;   markeem; end
elseif pltmode==4
   clf; colordef white; pltstr='k';
   em_step=(em(2)-em(1))/ri; ex_step=(ex(2)-ex(1))/ri;
   newimgeem(eem2,em_step,ex_step,'jet',.4,ma,mi,v); hold on;
   if markings;   markeem; end
else
   disp('pltmode must be [3,4]! Not supported');
end   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%
% Contour plot
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n,m]=size(eem1);
em=eem1(2:n,1)';
ex=eem1(1,2:m);
rho_max=eem1(1,1);

if (r~=0)
    data=eem1(2:end,2:end);
    emn=sort([em,em(1:end-1)+(em(2:end)-em(1:end-1))/2]);
    exn=sort([ex,ex(1:end-1)+(ex(2:end)-ex(1:end-1))/2]);
    datan=interp2(ex,em,data,exn',emn);
    eem1=[[rho_max,exn];[emn',datan]];
    ex=exn;
    em=emn;
    [n,m]=size(eem1);
end;

% min_em=10*floor(min(em)/10.);
% max_em=10*ceil(max(em)/10.);
% min_ex=10*floor(min(ex)/10.);
% max_ex=10*ceil(max(ex)/10.);
min_em=min(em);
max_em=max(em);
min_ex=min(ex);
max_ex=max(ex);

% some eems have larger emission range than actually measured
% data is zero at these locations, cut it off in emission wavelength

[t1,t2]=getem(eem1,max_ex);
if t1(max(find(t2~=0))) < max_em
   max_em=5*ceil(t1(max(find(t2~=0)))/5);
end
[t1,t2]=getem(eem1,min_ex);
if t1(min(find(t2~=0))) > min_em
   min_em=5*ceil(t1(min(find(t2~=0)))/5);
end

data=eem1(2:n,2:m)';

% remove data where no data can be
for i=1:length(ex),
    indx=(em<=(ex(i)-5) | em>2*(ex(i)+5));
    data(i,indx)=NaN;
end

% remove all possible NaN;
NaNloc=isnan(data);
data(NaNloc)=0;

% NODATA IS 0

% find absolute maximum and minimum in data set
[tmax,temp1]=max(data);
[tmax,temp2]=max(tmax);
tmax_loc=[em(temp2),ex(temp1(temp2))];
%
[tmin,temp1]=min(data);
[tmin,temp2]=min(tmin);
tmin_loc=[em(temp2),ex(temp1(temp2))];

%
% find maximum and minimum outside scatering lines 
% search in 80% of data range 
%

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
[mi,kk]=min(mi);
mi_loc = locmi(:,kk);

% Absolute values are
% tmin;
% tmax;
% Values within eem data are
% ma, mi
%
% its better to use the total minimum for graphical representation
% mi=tmin;
ma_loc_s=ma_loc;
mi_loc_s=mi_loc;
ma_s=ma;
mi_s=mi;

if scalemin~=0; mi=scalemin; end
if scalemax~=0; ma=scalemax; end

disp(['Absolute Max is ' num2str(tmax)])
disp(['Absolute Min is ' num2str(tmin)])
disp(['Scaling Max is ' num2str(ma)])
disp(['Scaling Min is ' num2str(mi)])

disp(['Min emission wavelength is ' num2str(min_em)])
disp(['Max emission wavelength is ' num2str(max_em)])
disp(['Min excitation wavelength ' num2str(min_ex)])
disp(['Max excitation is ' num2str(max_ex)])
%
% code removed by UU 5/27/2001
% if mi <0 disp('Warning negative values in EEM!'); end
% if mi >0 mi=0; end

%
% # of contour lines
%
steps = 10;
%
% The contour lines not scaled to the data (0-1)

if pltline==1
    v = [1/steps:1/steps:1]; % linear in 10 steps
    my_range=[0,1];
	% v = [0.001:(1-0.001)/steps:1];  % linear in 10 steps
elseif pltline==0 % 0.001-0.01-0.1-1 3 decades but linear in between
	v = [0.001:(0.01-0.001)/steps:0.01, 0.01+(0.1-0.01)/steps:(0.1-0.01)/steps:0.1, 0.1+(1-0.1)/steps:(1-0.1)/steps:1];
    my_range=[0,0.01,0.1,1];
elseif pltline==2
    % symmetric around 0.5
    v=  [[0.5+(0.01-0.001)/steps/2:(0.01-0.001)/steps:0.51],[0.51+(0.1-0.01)/steps:(0.1-0.01)/steps:0.6],[0.6+(1-0.1)/steps:(1-0.1)/steps:1]];
    v=  [fliplr(1-v),v];
    my_range=[0, 0.4, 0.49, 0.51, 0.6, 1];
else
    v = [0.001:(0.01-0.001)/steps:0.01, 0.01+(0.1-0.01)/steps:(0.1-0.01)/steps:0.1, 0.1+(1-0.1)/steps:(1-0.1)/steps:1];
    my_range=[0,0.01,0.1,1];
end

% sets zeros to nan so they won't be plotted
data(data==0) = NaN; 
data(NaNloc) = NaN;
eem1(2:end,2:end)=data';

dd=(data-mi)./(ma-mi); 

[c,h]=contour(em,ex,dd,v,[pltstr,'-']);
lc=length(c);

% Find Positions for values beeing ploted
 i=1; list=[]; level_old = 0; level_used = []; test1 = []; test2 = []; level_list=[];
 % c and h are handel from contour plot
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
  h2=plot(Position(1)-Offset,Position(2), [pltstr, '+']);
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
       % this is not updated
       if pltmode==0 set(h(jj),'Color',pltstr); end
       if (level_used(jj) < 0.01*fact )
          set(h(jj),'LineStyle','-')
       elseif (level_used(jj) < 0.1*fact)
          set(h(jj),'LineStyle',':')   
       else 
          set(h(jj),'LineStyle','-')
       end
    else
       % this is updated to work with symmetry plot levels
       if ~pltmode set(h(jj),'Color',pltstr); end
       if mod(max(find(my_range<=level_list(jj))),2); % figure if level is in 1st,2nd,etc range, alternate plot style between odd and even range number
          set(h(jj),'LineStyle','-')
       else 
          set(h(jj),'LineStyle',':')   
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
 h=text(loc_x,loc_y,['Highest value: ', num2str(ma_s,2),' ', num2str(ma_loc_s(1)),'/',num2str(ma_loc_s(2))]);
 set(h, 'FontSize', 12);
 Extent = get(h,'Extent');
 loc_y=loc_y-1.02*Extent(4);
 h=text(loc_x,loc_y,['Lowest value: ', num2str(mi_s,2), ' ', num2str(mi_loc_s(1)),'/',num2str(mi_loc_s(2))]);
 set(h, 'FontSize', 12);
 % Mark it on the graph!
 h1=text(ma_loc_s(2), ma_loc_s(1),'M');
 set(h1, 'FontSize', 12, 'FontWeight', 'bold');
 h1=text(mi_loc_s(2), mi_loc_s(1),'m');
 set(h1, 'FontSize', 12, 'FontWeight', 'bold');
 
 % h=text(loc_x,loc_y,['Highest value: ', num2str(tmax),' ', num2str(tmax_loc(1)),'/',num2str(tmax_loc(2))]);
 % set(h, 'FontSize', 12);
 % Extent = get(h,'Extent');
 % loc_y=loc_y-1.02*Extent(4);
 % h=text(loc_x,loc_y,['Lowest value: ',num2str(tmin), ' ', num2str(tmin_loc(1)),'/',num2str(tmin_loc(2))]);
 % set(h, 'FontSize', 12);
 % % Mark it on the graph!
 % h1=text(tmax_loc(1),tmax_loc(2),'M');
 % set(h1, 'FontSize', 12, 'FontWeight', 'bold');
 % h1=text(tmin_loc(1),tmin_loc(2),'S');
 % set(h1, 'FontSize', 12, 'FontWeight', 'bold');

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
name = 'U of A'; logo = 'UU';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos = [0.9*max_em min_ex+2];
fontsize = 6; color = [0 0 0]; ftname = 'helvetica';
d = date; di=findstr(d,'-'); d=d(di(1)+1:length(d));
string = [name ' ' d ' ' logo];
th = text(pos(1,1),pos(1,2),string); set(th,'fontsize',fontsize(1),'fontname',ftname,'color',color)

if ~washold hold off; end

function clegend=newimgeem(eem,em_s,ex_s,mapstr,brightness,ma,mi,v);
% clegend=newimgeem(eem,em_s,ex_s,mapstring,brightness,max,min,v);
% produces an eem image, data is interpolated in uniform grid according to 
% em_s, ex_s usually 5nm
% map could be pink or jet
% c is colormap brightness factor 
% UU 4/98, 5/2001
% Usage and changes of this software is restricted, contact:
% Urs Utzinger, Spectroscopy Laboratory UT Austin 1999

eem_s=eeminterp(eem,em_s,ex_s);
[n,m]=size(eem_s);
em=eem_s(2:n,1)';
ex=eem_s(1,2:m);
data=eem_s(2:n,2:m)';

% search for data larger than minima inside fluorescence data
%for i = 1:m-1,
% index=find(isnan(data(i,:))==0);
% mai=max(index); mii=min(index);
%% if isempty(mai) ;   mai=size(data,2); end
% if isempty(mii) ;   mii=1; end
% data(i,mii:mii+4)=[data(i,mii:mii+4).*(data(i,mii:mii+4)>mi)];
% data(i,mai-4:mai)=[data(i,mai-4:mai).*(data(i,mai-4:mai)>mi)];
%end

    % if min(v)>0
    data(data==0)=data(data==0)*NaN;
    data(data>ma)=NaN;
    data(data<mi)=NaN;
    data=(data-mi)./(ma-mi);
    % convert to color range
    temp=interp1([0 v],0:1/(length(v)):1,data,'linear');
    t=interp1([0:1/(length(v)):1],[0 v],[0:1/255:1],'linear');
    % temp=interp1([0 v],0:1/length(v):1,data,'linear');
    % t=interp1([0:1/length(v):1],[0,v],[0:1/255:1],'linear');
    clegend=(ma-mi)*t+mi;
    %else
    %temp=interp1([v],0:1/(length(v)-1):1,data,'linear');
    %t=interp1([0:1/(length(v)-1):1],[v],[0:1/255:1],'linear');
    %clegend=t;
    %end;

data=reshape(temp,(m-1),(n-1));
% data(isnan(data))=xor(data(isnan(data)),0);
data(isnan(data))=1;

if ~ishold hold on; washold=0; else washold=1; end

eval(['colormap ' mapstr '(256)']);
map=colormap;
map(256,:)=[1,1,1];

if strcmp(mapstr,'pink')
 t=brightness*(1.-map);
 colormap(map+t);
else
 colormap(map);
 brighten(map,brightness);
end;

map=colormap; map(256,:)=[1,1,1]; colormap(map); 

set(gca,'NextPlot','replace');
h=image(uint8(data*255),'YData',ex,'XData',em);
set(gca,'YDir','normal')

mycolorbar('vertical',0.01,0.0001,clegend)

if ~washold hold off; end