function MosaicBatchJ_1(mydir,Name1,Name2,Name2a,PMT1,PMT2,zposmax,pixelxy,NMosaicX,NMosaicY,Flatness,varargin);
%MosaicBatchJ_1(mydir,Name1,Name2,Name2a, PMT1,PMT2,zposmax,pixelxy,NMosaicX,NMosaicY);
% This routine assembles and processes images recorded with LVBT autosave
% mosaic measurement setting
%
% mydir='C:\Users\utzinger\Desktop\SampleA'
% Where you are working
% Name1  = 'AD1'
% The prefix you set in the software
% Name2  = '18-42-17'
% The text Imspector automatically created based on time stamp
% Name2a  = '18-42-17'
% To fix the error in Imspector where the automatic text changes
% during measurements due to rounding issue in the time stamp.
% PMT1 = 'SHG'
% Name of the first channel
% PMT2 = 'NADH'
% Name of the second channel
% zposmax = 60
% Number of Z stacks
% pixelxy=518;
% Number of pixels, assume to have same in both directions
% NMosaicX=5
% Number of images in X
% NMosaicY=5
% Number of images in Y
%
% Flatness[0,60,15,80] prcentile inclusion percential range for bright and dark areas
% Metric is average of (top 5%) - average of (middle) and average of (bottom 5%) - average of (millde) 
%
% Urs Utzinger, 2010

global plt;

if size(varargin,2) < 1
    SaveName=Name1;
else
    SaveName=varargin{1};
end;

disp('Load Data');
stack1=zeros(pixelxy*NMosaicX,pixelxy*NMosaicY,60,'uint16');
stack2=zeros(pixelxy*NMosaicX,pixelxy*NMosaicY,60,'uint16');
for posz = 0:zposmax
    for mosaicx = 0:(NMosaicX-1)
        for mosaicy = 0:(NMosaicY-1)
            cnumPMT1 = mosaicy*2 + mosaicx*NMosaicX*2;
            cnumPMT2 = cnumPMT1+1;
            posx=mosaicx*518;
            posy=mosaicy*518;
            try
                tr = Tiff([mydir, '\', Name1, '_',  Name2, '_PMT - PMT [', PMT1, ' - xyz-Table[', num2str(mosaicx), '] - xyz-Table[', num2str(mosaicy), ']] _C', num2str(cnumPMT1), '_Z', num2str(posz), '.ome.tif']);
                Img=tr.read();
                tr.close;
                stack1(posx+1:posx+pixelxy,posy+1:posy+pixelxy, posz+1)=Img;
            catch exception1
                try
                    tr = Tiff([mydir, '\', Name1, '_', Name2a, '_PMT - PMT [', PMT1, ' - xyz-Table[', num2str(mosaicx), '] - xyz-Table[', num2str(mosaicy), ']] _C', num2str(cnumPMT1), '_Z', num2str(posz), '.ome.tif']);
                    Img=tr.read();
                    tr.close;
                    stack1(posx+1:posx+pixelxy,posy+1:posy+pixelxy, posz+1)=Img;
                catch exception2
                    try
                        tr = Tiff([mydir, '\', Name1, '_',  Name2, '_PMT - PMT [', PMT1, ' - xyz-Table[', num2str(mosaicx), '] - xyz-Table[', num2str(mosaicy), ']] _C', num2str(cnumPMT1), '_Z', num2str(posz), '.tif']);
                        Img=tr.read();
                        tr.close;
                        stack1(posx+1:posx+pixelxy,posy+1:posy+pixelxy, posz+1)=Img;
                    catch exception3
                        disp(['Can not find file ', PMT1, ' - X ', num2str(mosaicx), '- Y ', num2str(mosaicy), '- Z ', num2str(posz)]);
                        stack1(posx+1:posx+pixelxy,posy+1:posy+pixelxy, posz+1)=0;
                    end
                end
            end
            
            try
                tr = Tiff([mydir, '\', Name1, '_', Name2, '_PMT - PMT [', PMT2, ' - xyz-Table[', num2str(mosaicx), '] - xyz-Table[', num2str(mosaicy), ']] _C', num2str(cnumPMT2), '_Z', num2str(posz), '.ome.tif']);
                Img=tr.read();
                tr.close;
                stack2(posx+1:posx+pixelxy,posy+1:posy+pixelxy, posz+1)=Img;
            catch exception4
                try
                    tr = Tiff([mydir, '\', Name1, '_', Name2a, '_PMT - PMT [', PMT2, ' - xyz-Table[', num2str(mosaicx), '] - xyz-Table[', num2str(mosaicy), ']] _C', num2str(cnumPMT2), '_Z', num2str(posz), '.ome.tif']);
                    Img=tr.read();
                    tr.close;
                    stack2(posx+1:posx+pixelxy,posy+1:posy+pixelxy, posz+1)=Img;
                catch exception5
                    try
                        tr = Tiff([mydir, '\', Name1, '_', Name2, '_PMT - PMT [', PMT2, ' - xyz-Table[', num2str(mosaicx), '] - xyz-Table[', num2str(mosaicy), ']] _C', num2str(cnumPMT2), '_Z', num2str(posz), '.tif']);
                        Img=tr.read();
                        tr.close;
                        stack2(posx+1:posx+pixelxy,posy+1:posy+pixelxy, posz+1)=Img;
                    catch exception6
                        disp(['Can not find file ', PMT2, ' - X ', num2str(mosaicx), ' - Y ', num2str(mosaicy), ' - Z ', num2str(posz)]);
                        stack2(posx+1:posx+pixelxy,posy+1:posy+pixelxy, posz+1)=0;
                    end
                end
            end
        end
    end
    cprintf('Text', '%s', num2str(posz) );
end
cprintf('Text', '\n', '' );

% Save under different name if necessary

Name1=SaveName;

%
% Save Raw Stack
%
if 0 % do not want to save
    disp('Save Stacks');
    ImageLength = size(stack1,1);
    ImageWidth = size(stack1,2);
    imwrite(stack1(:,:,1),[mydir, '\', Name1,'_',PMT1,'_raw.tif'],'Compression','none',...
        'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','overwrite');
    for i=2:size(stack1,3); 
        imwrite(stack1(:,:,i),[mydir, '\', Name1,'_',PMT1,'_raw.tif'],'Compression','none',...
            'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','append');
        cprintf('Text', '%s', num2str(i) );
    end

    ImageLength = size(stack2,1);
    ImageWidth = size(stack2,2);
    imwrite(stack2(:,:,1),[mydir, '\', Name1,'_',PMT2,'_raw.tif'],'Compression','none',...
        'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','overwrite');
    for i=2:size(stack2,3); 
        imwrite(stack2(:,:,i),[mydir, '\', Name1,'_',PMT2,'_raw.tif'],'Compression','none',...
            'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','append');
        cprintf('Text', '%s', num2str(i) );
    end

    if plt
        for i=1:size(stack2,3)
           figure(1); imagesc(stack1(:,:,i)); figure(2); imagesc(stack2(:,:,i))
           cprintf('Text', '%s', num2str(i) );
           pause
        end
    end
end % if 0

%%%%%    Check again if PMT off is detected correctly
% Was the PMT off?? 
% If PMT was off image is not used to calculate limits for histogram 
% stretching for later processing.
disp('PMT off?')
clear sl1 sl2
for i=1:size(stack1,3); sl1(:,i)=stretchlim(stack1(:,:,i), [0.01 0.999]);  cprintf('Text', '%s', num2str(i) ); end;
cprintf('Text', '\n', '' );
for i=1:size(stack2,3); sl2(:,i)=stretchlim(stack2(:,:,i), [0.01 0.9999]); cprintf('Text', '%s', num2str(i) ); end;
cprintf('Text', '\n', '' );
no1=find((sl1(2,:)-sl1(1,:))<0.0015);
no2=find((sl2(2,:)-sl2(1,:))<0.0015);
ok1=find((sl1(2,:)-sl1(1,:))>=0.0015);
ok2=find((sl2(2,:)-sl2(1,:))>=0.0015);
save([mydir, '\', Name1,'_PMTOFF.mat'],'no1', 'no2', 'ok1', 'ok2');
load([mydir, '\', Name1,'_PMTOFF.mat']);

%%%%%%
% Define Background, only from images where PMT was on
% Find Outlayers in bg (it might be that PMT was on for short period)
% We want to avoid defining BG on data where PMT was off
%
disp('Remove BG')
clear bg1 bg2
for i=1:size(stack1,3); bg1(:,i)=stretchlim(stack1(:,:,i), [0 0.0015]); cprintf('Text', '%s', num2str(i) ); end;
cprintf('Text', '\n', '' );
mbg=mean(bg1(2,ok1)); sbg=std(bg1(2,ok1)); m1=(bg1(2,ok1)<mbg+2*sbg & bg1(2,ok1)>mbg-2*sbg); % remove outlayers
bg1=(2^16 -1)* min(bg1(2,ok1(m1))); % calculate bg
if isempty(bg1) | isnan(bg1); bg1=0; end;
for i=1:size(stack2,3); bg2(:,i)=stretchlim(stack2(:,:,i), [0 0.0015]); cprintf('Text', '%s', num2str(i) ); end;
cprintf('Text', '\n', '' );
mbg=mean(bg2(2,ok2)); sbg=std(bg2(2,ok2)); m2=(bg2(2,ok2)<mbg+2*sbg & bg2(2,ok2)>mbg-2*sbg); % remove outlayers
bg2=(2^16 -1)* min(bg2(2,ok2(m2))); % calcualte bg
if isempty(bg2) | isnan(bg2); bg2=0; end;
save([mydir, '\', Name1,'_bg.mat'],'bg1', 'bg2', 'm1', 'm2');
load([mydir, '\', Name1,'_bg.mat']);

%%%%
% Remove BG
stack1=stack1-uint16(floor(bg1));
stack2=stack2-uint16(floor(bg2));

%
% Save BG removed Stack
%
disp('Save Stacks');
ImageLength = size(stack1,1);
ImageWidth = size(stack1,2);
imwrite(stack1(:,:,1),[mydir, '\', Name1,'_',PMT1,'_bg.tif'],'Compression','none',...
    'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','overwrite');
for i=2:size(stack1,3); 
    imwrite(stack1(:,:,i),[mydir, '\', Name1,'_',PMT1,'_bg.tif'],'Compression','none',...
        'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','append');
    cprintf('Text', '%s', num2str(i) );
end
cprintf('Text', '\n', '' );

ImageLength = size(stack2,1);
ImageWidth = size(stack2,2);
imwrite(stack2(:,:,1),[mydir, '\', Name1,'_',PMT2,'_bg.tif'],'Compression','none',...
    'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','overwrite');
for i=2:size(stack2,3); 
    imwrite(stack2(:,:,i),[mydir, '\', Name1,'_',PMT2,'_bg.tif'],'Compression','none',...
        'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','append');
    cprintf('Text', '%s', num2str(i) );
end
cprintf('Text', '\n', '' );

if 0 % for debug purpose
    disp('Load BG removed Stacks');
    %%%%%
    % Load Stack
    t1=Tiff([mydir, '\', Name1,'_',PMT1,'_bg.tif'], 'r');
    t2=Tiff([mydir, '\', Name1,'_',PMT2,'_bg.tif'], 'r');
    for i=1:zposmax
        stack1(:,:,i)=t1.read();
        t1.nextDirectory();
        stack2(:,:,i)=t2.read();
        t2.nextDirectory()
        cprintf('Text', '%s', num2str(i) );
    end
    i=i+1;
    stack1(:,:,i)=t1.read();
    stack2(:,:,i)=t2.read();
    t1.close();
    t2.close();
end

%%%
% Cleanup Noise
disp('Median Filter')
for i=1:size(stack1,3); stack1(:,:,i)=medfilt2(stack1(:,:,i),[3,3],'symmetric'); cprintf('Text', '%s', num2str(i) ); end
cprintf('Text', '\n', '' );
for i=1:size(stack2,3); stack2(:,:,i)=medfilt2(stack2(:,:,i),[3,3],'symmetric'); cprintf('Text', '%s', num2str(i) ); end
cprintf('Text', '\n', '' );
%%%

disp('Adjust Dynamic Range')
%%%%%    
% Find stretchlims
for i=1:size(stack1,3); sl1(:,i)=stretchlim(stack1(:,:,i), [0.01 0.9999]); cprintf('Text', '%s', num2str(i) ); end;
cprintf('Text', '\n', '' );
for i=1:size(stack2,3); sl2(:,i)=stretchlim(stack2(:,:,i), [0.01 0.9999]); cprintf('Text', '%s', num2str(i) ); end;
save([mydir, '\', Name1,'_sl.mat'],'sl1', 'sl2');
cprintf('Text', '\n', '' );
% figure out smallest and largest limit
misl1=min(sl1(1,ok1(m1)))*0.9; if misl1>1; misl1=1; end;
misl2=min(sl2(1,ok2(m2)))*0.9; if misl2>1; misl2=1; end;
masl1=max(sl1(2,ok1(m1)))*1.20; if masl1>1; masl1=1; end;
masl2=max(sl2(2,ok2(m2)))*1.20; if masl2>1; masl2=1; end;
%
% Dynamically adjust min and max for each frame but keep transitions smooth
% It is assumed that images would get darker deeper inside, meaning that
% the highest values should change monotonocally, trial and error was used
% to come up with ploynomial fit and finding outlayers. Its a hack but
% works more or less.
%
%%%% Stack1
% Cleanup Minimum
% Clean up outlayers and make stretchlimits smooth
%%ys=smooth(x,y,10,'sgolay',2)
%%p=polyfit(x,y,1); f=polyval(p,x); err=f-y;
%%o=find(abs(err)<=2*std(err));
if length(ok1(m1)) > 3
    y=sl1(1,ok1(m1)); x=[ok1(m1)];
    p=polyfit(x,y,2); f=polyval(p,x); err=f-y;
    o=find(abs(err)<=2*std(err));
    %% second & third run without outlayers
    yn=y(o); xn=x(o);
    %p=polyfit(xn,yn,2); fn=polyval(p,x);
    p=polyfit(xn,yn,1); fn=polyval(p,xn); errn=fn-yn;
    on=find(abs(errn)<=1.5*std(errn));
    yn=yn(on); xn=xn(on);
    pn=polyfit(xn,yn,3); fn=polyval(pn,x);
    fn=fn*0.9; fn(fn<0)=0; fn(fn>1)=1;
    if plt figure(11); clf; plot(x,y,'o'), hold on; plot(xn,yn,'or'); plot(x,fn); end
    % if plt figure(11); clf; plot(x,y,'o'), hold on; plot(x,y,'ro'), plot(x,f); plot(x,fn,'r'), end
    sl1(1,:)=misl1; sl1(1,ok1(m1))=fn;
else
    if isempty(misl1)
        sl1(1,:)= 0;
    else
        sl1(1,:)= misl1;
    end
end
% Cleanup Maximum
if length(ok1(m1)) > 3
    y=sl1(2,ok1(m1)); x=[ok1(m1)];
    p=polyfit(x,y,1); f=polyval(p,x); err=f-y;
    o=find(abs(err)<=2*std(err));
    % second run without outlayers
    yn=y(o); xn=x(o);
    p=polyfit(xn,yn,1); fn=polyval(p,xn); errn=fn-yn;
    on=find(abs(errn)<=1.5*std(errn));
    yn=yn(on); xn=xn(on);
    pn=polyfit(xn,yn,3); fn=polyval(pn,x);
    fn=fn*1.2; fn(fn<0)=0; fn(fn>1)=1;
    if plt figure(12); clf; plot(x,y,'o'), hold on; plot(xn,yn,'or'); plot(x,fn); end
    sl1(2,:)=masl1; sl1(2,ok1(m1))=fn;
else
    if isempty(masl1)
        sl1(2,:)= 1;
    else
        sl1(2,:)= masl1;
    end
end

%%%% Stack2
% Cleanup Minimum
% Clean up outlayers and make stretchlimits smooth
%%ys=smooth(x,y,10,'sgolay',2)
%%p=polyfit(x,y,1); f=polyval(p,x); err=f-y;
%%o=find(abs(err)<=2*std(err));
if length(ok2(m2)) > 3
    y=sl2(1,ok2(m2)); x=[ok2(m2)];
    p=polyfit(x,y,2); f=polyval(p,x); err=f-y;
    o=find(abs(err)<=2*std(err));
    %% second & third run without outlayers
    yn=y(o); xn=x(o);
    %p=polyfit(xn,yn,2); fn=polyval(p,x);
    p=polyfit(xn,yn,1); fn=polyval(p,xn); errn=fn-yn;
    on=find(abs(errn)<=1.5*std(errn));
    yn=yn(on); xn=xn(on);
    pn=polyfit(xn,yn,3); fn=polyval(pn,x);
    fn=fn*0.9; fn(fn<0)=0; fn(fn>1)=1;
    if plt figure(13); clf; plot(x,y,'o'), hold on; plot(xn,yn,'or'); plot(x,fn); end
    % if plt figure(11); clf; plot(x,y,'o'), hold on; plot(x,y,'ro'), plot(x,f); plot(x,fn,'r'), end
    sl2(1,:)=misl2; sl2(1,ok2(m2))=fn;
else
    if isempty(misl2)
        sl2(1,:)= 0;
    else
        sl2(1,:)= misl2;
    end
end

% Cleanup Maximum
if length(ok2(m2)) > 3
    y=sl2(2,ok2(m2)); x=[ok2(m2)];
    p=polyfit(x,y,1); f=polyval(p,x); err=f-y;
    o=find(abs(err)<=2*std(err));
    % second run without outlayers
    yn=y(o); xn=x(o);
    p=polyfit(xn,yn,1); fn=polyval(p,xn); errn=fn-yn;
    on=find(abs(errn)<=1.5*std(errn));
    yn=yn(on); xn=xn(on);
    pn=polyfit(xn,yn,3); fn=polyval(pn,x);
    fn=fn*1.2; fn(fn<0)=0; fn(fn>1)=1;
    if plt figure(14); clf; plot(x,y,'o'), hold on; plot(xn,yn,'or'); plot(x,fn); end
    sl2(2,:)=masl2; sl2(2,ok2(m2))=fn;
else
    if isempty(masl2)
        sl2(2,:)= 1;
    else
        sl2(2,:)= masl2;
    end
end

%%%%%%%
% Apply Stretch Limits
for i=1:size(stack1,3); 
    stack1(:,:,i)=imadjust(stack1(:,:,i),sl1(:,i)); 
    stack2(:,:,i)=imadjust(stack2(:,:,i),sl2(:,i));
    cprintf('Text', '%s', num2str(i) );
end;
cprintf('Text', '\n', '' );
stack1(:,:,no1)=0;
stack2(:,:,no2)=0;

%%%%%%
% Show Stack
if plt
    for i=1:size(stack1,3); 
        figure(1); imshow(stack1(:,:,i));
        figure(2); imshow(stack2(:,:,i));
        cprintf('Text', '%s', num2str(i) ); 
        pause
    end;
    cprintf('Text', '\n', '' );
end

disp('Save Stacks');
ImageLength = size(stack1,1);
ImageWidth = size(stack1,2);
imwrite(stack1(:,:,1),[mydir, '\', Name1,'_',PMT1,'.tif'],'Compression','none',...
    'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','overwrite');
for i=2:size(stack1,3); 
    imwrite(stack1(:,:,i),[mydir, '\', Name1,'_',PMT1,'.tif'],'Compression','none',...
        'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','append');
    cprintf('Text', '%s', num2str(i) );
end
cprintf('Text', '\n', '' );

ImageLength = size(stack2,1);
ImageWidth = size(stack2,2);
imwrite(stack2(:,:,1),[mydir, '\', Name1,'_',PMT2,'.tif'],'Compression','none',...
    'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','overwrite');
for i=2:size(stack2,3); 
    imwrite(stack2(:,:,i),[mydir, '\', Name1,'_',PMT2,'.tif'],'Compression','none',...
        'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','append');
    cprintf('Text', '%s', num2str(i) );
end
cprintf('Text', '\n', '' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Determine Flat Field Illumination Function
% This attempts to extract an average image from all the measured 
% data. Attempt is made to not include data where there is strong
% contrast or signal. Data will need to be collected from multiple
% image sessions and assembled in second step later.
%
% Only data where PMT was on and bg was in reasonable range is used.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Load BG removed Stacks');
%%%%%
% Load Stack
t1=Tiff([mydir, '\', Name1,'_',PMT1,'_bg.tif'], 'r');
t2=Tiff([mydir, '\', Name1,'_',PMT2,'_bg.tif'], 'r');
for i=1:zposmax
    stack1(:,:,i)=t1.read();
    t1.nextDirectory();
    stack2(:,:,i)=t2.read();
    t2.nextDirectory()
    cprintf('Text', '%s', num2str(i) );
end
cprintf('Text', '\n', '' );
i=i+1;
stack1(:,:,i)=t1.read();
stack2(:,:,i)=t2.read();
t1.close();
t2.close();

% exclude images with bright areas and low areas.
%for k=0:zposmax
%    for i=0:(NMosaicX-1)
%        for j=0:(NMosaicY-1)
%            I=stack1(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy,k+1);
%            I=adapthisteq(I,'NumTiles',[4 4], 'clipLimit',0.005,'Distribution','rayleigh');
%            flatness1(i+1,j+1,k+1)=std2(I);
%            % imhist
%            I=stack2(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy,k+1);
%            I=adapthisteq(I,'NumTiles',[4 4], 'clipLimit',0.005,'Distribution','rayleigh');
%            flatness2(i+1,j+1,k+1)=std2(I);
%        end
%    end
%    cprintf('Text', '%s', num2str(k) );
%end


% exclude images with bright areas and low areas.
for k=0:zposmax
    for i=0:(NMosaicX-1)
        for j=0:(NMosaicY-1)
            I=stack1(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy,k+1);
            %I=adapthisteq(I,'NumTiles',[4 4], 'clipLimit',0.005,'Distribution','rayleigh');
            
            temp=single(reshape(I,1,[]));
            tbound=prctile(temp,[5,95]);
            a1(i+1,j+1,k+1)=mean(temp(temp<=tbound(1))); % top 5% average
            b1(i+1,j+1,k+1)=mean(temp(temp>tbound(1)&temp<tbound(2))); % middle average
            c1(i+1,j+1,k+1)=mean(temp(temp>=tbound(2))); % bottom 5% average
   
            I=stack2(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy,k+1);
            %I=adapthisteq(I,'NumTiles',[4 4], 'clipLimit',0.005,'Distribution','rayleigh');
            
            temp=single(reshape(I,1,[]));
            tbound=prctile(temp,[5,95]);
            a2(i+1,j+1,k+1)=mean(temp(temp<=tbound(1)));
            b2(i+1,j+1,k+1)=mean(temp(temp>tbound(1)&temp<tbound(2)));
            c2(i+1,j+1,k+1)=mean(temp(temp>=tbound(2)));

        end
    end
    cprintf('Text', '%s', num2str(k) );
end
cprintf('Text', '\n', '' );

%(c1-b1)./b1 % bright ones
%(b1-a1)./b1 % dark ones
%flatness1=(c1-a1)./b1;
%flatness2=(c2-a2)./b2;

% stack 1
flatness11=(c1-b1)./b1; % bright ones
flatness12=(b1-a1)./b1; % dark ones

% stack 2
flatness21=(c2-b2)./b2; % bright ones
flatness22=(b2-a2)./b2; % dark ones

ImgAcc1=zeros(pixelxy,pixelxy); N1=0;
ImgAcc2=zeros(pixelxy,pixelxy); N2=0;

incl11=Flatness(1);
incl12=Flatness(2);
incl21=Flatness(3);
incl22=Flatness(4);

for k=1:zposmax+1
    if plt
        figure(1); clf
        subplot(2,3,1); imagesc(flatness11(:,:,k)); colorbar
        subplot(2,3,2); imagesc(flatness12(:,:,k)); colorbar
        subplot(2,3,3); imagesc(stack1(:,:,k))
        subplot(2,3,4); imagesc(flatness21(:,:,k)); colorbar
        subplot(2,3,5); imagesc(flatness22(:,:,k)); colorbar
        subplot(2,3,6); imagesc(stack2(:,:,k))
    end

    % stack 1
    [bot11]=prctile(reshape(flatness11(:,:,k),1,[]),[incl11 incl12]); % bright
    [m11,n11]=find( flatness11(:,:,k)>=bot11(1) & flatness11(:,:,k)<=bot11(2) );
    if plt; subplot(2,3,1), hold on; plot(n11,m11,'ko'); end

    [bot12]=prctile(reshape(flatness12(:,:,k),1,[]),[incl21 incl22]); % dark
    [m12,n12]=find( flatness12(:,:,k)>=bot12(1) & flatness12(:,:,k)<=bot12(2) );
    if plt; subplot(2,3,2), hold on; plot(n12,m12,'ko'); end
    
    mychoice1=intersect([n11,m11],[n12,m12],'rows');
    if plt; subplot(2,3,1), hold on; plot(mychoice1(:,1),mychoice1(:,2),'ro'); end
    
    % stack 2
    [bot21]=prctile(reshape(flatness21(:,:,k),1,[]),[incl11 incl12]); % bright
    [m21,n21]=find( flatness21(:,:,k)>=bot21(1) & flatness21(:,:,k)<=bot21(2) );
    if plt; subplot(2,3,4), hold on; plot(n21,m21,'ko'); end

    [bot22]=prctile(reshape(flatness22(:,:,k),1,[]),[incl21 incl22]); % dark
    [m22,n22]=find( flatness22(:,:,k)>=bot22(1) & flatness22(:,:,k)<=bot22(2) );
    if plt; subplot(2,3,5), hold on; plot(n22,m22,'ko'); end

    mychoice2=intersect([n21,m21],[n22,m22],'rows');
    if plt; subplot(2,3,4), hold on; plot(mychoice2(:,1),mychoice2(:,2),'ro'); end

    if plt; pause; end
    
    for l=1:size(mychoice1,1)
        j=mychoice1(l,1)-1;
        i=mychoice1(l,2)-1;
        I=stack1(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy,k);
        if plt; figure(2); imagesc(I); pause; end
        ImgAcc1=ImgAcc1+double(I);
    end
    N1=N1+size(mychoice1,1);
    
    for l=1:size(mychoice2,1)
        j=mychoice2(l,1)-1;
        i=mychoice2(l,2)-1;
        I=stack2(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy,k);
        if plt; figure(2); imagesc(I); pause; end
        ImgAcc2=ImgAcc2+double(I);
    end
    N2=N2+size(mychoice2,1);

end

Icorr1=ImgAcc1./N1;
Icorr2=ImgAcc2./N2;

save([mydir, '\', Name1,'_Icorr.mat'],'Icorr1', 'Icorr2', 'N1', 'N2');

% old version

if 0
    % Calculate Average Image
    ImgAcc=zeros(size(stack1,1), size(stack1,2));
    NumImg=single(zeros(size(ImgAcc)));
    r1=ok1(m1); % only use the images with PMT on (ok1) and bg in reasonable range (m1)
    % collapse the stack into one image
    for i=1:length(r1) 
        Img=stack1(:,:,r1(i));
        I=imadjust(Img,stretchlim(Img, [0.1 0.9])); % try to exclude brigth intensity areas and areas without specimen
        mask=(I > 0 & I < 2^16-1); % imagesc(mask);
        ImgAcc(mask)=ImgAcc(mask)+single(Img(mask));
        NumImg=NumImg+single(mask);
        cprintf('Text', '%s', num2str(r1(i)) );
    end
    cprintf('Text', '\n', '' );
    %% Caculate the Average Image Intensity and Background
    %ImgAve=uint16(ImgAcc./NumImg); % average stack image
    % Assemble all fields on top of each other
    Icorr=zeros(pixelxy,pixelxy);
    Ncorr=zeros(pixelxy,pixelxy);
    for i=0:(NMosaicX-1)
        for j=0:(NMosaicY-1)
            % I=ImgAve(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy);
            I=ImgAcc(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy);
            N=NumImg(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy);
            mask=N>5; % do not trust if have only few datapoits within stack, can take info form other section of the mosaic
            Icorr(mask)=Icorr(mask)+single(I(mask));
            Ncorr(mask)=Ncorr(mask)+single(N(mask));
        end
    end
    % Icorr=Icorr./Ncorr;
    % Icorr(isnan(Icorr))=min(min(Icorr));
    save([mydir, '\', Name1,'_',PMT1,'_Icorr.mat'],'Icorr', 'Ncorr');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate Average Image
    ImgAcc=zeros(size(stack2,1), size(stack2,2));
    NumImg=single(zeros(size(ImgAcc)));
    r2=ok2(m2);
    for i=1:length(r2) % only use the files with PMT on (ok2) and bg in reasonable range (m22)
        Img=stack2(:,:,r2(i));
        I=imadjust(Img,stretchlim(Img, [0.1 0.9])); % try to exclude bright and low areas in samples
        mask=(I > 0 & I < 2^16-1); % imagesc(mask);
        ImgAcc(mask)=ImgAcc(mask)+single(Img(mask));
        NumImg=NumImg+single(mask);
       cprintf('Text', '%s', num2str(r2(i)) );
    end
    cprintf('Text', '\n', '' );
    %% Caculate the Average Image Intensity and Background
    %ImgAve=uint16(ImgAcc./NumImg);
    % Assemble all fields on top of each other
    Icorr=zeros(pixelxy,pixelxy);
    Ncorr=zeros(pixelxy,pixelxy);
    for i=0:(NMosaicX-1)
        for j=0:(NMosaicY-1)
            % I=ImgAve(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy);
            I=ImgAcc(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy);
            N=NumImg(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy);
            mask=N>5; % do not trust if have only few datapoits within stack, can take info form other section of the mosaic
            Icorr(mask)=Icorr(mask)+single(I(mask));
            Ncorr(mask)=Ncorr(mask)+single(N(mask));
        end
    end
    % Icorr=Icorr./Ncorr;
    % Icorr(isnan(Icorr))=min(min(Icorr)); % if there is locatin where no BG was measured at all set it to min
    save([mydir, '\', Name1,'_',PMT2,'_Icorr.mat'],'Icorr', 'Ncorr');
end


%%%%%%
%% Save Stack
%t1=Tiff([mydir, '\', Name1,'_',PMT1,'_FF.tif'],'w');
%t2=Tiff([mydir, '\', Name1,'_',PMT2,'_FF.tif'],'w');
%tagstruct.Compression = Tiff.Compression.None;
%tagstruct.ImageLength = size(stack1,1);
%tagstruct.ImageWidth = size(stack1,2);
%tagstruct.BitsPerSample = 16;
%tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
%tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
%tagstruct.SamplesPerPixel = 1;
%tagstruct.RowsPerStrip = 16;
%tagstruct.Software = 'MATLAB';
%for i=1:size(stack1,3); 
%    t1.setTag(tagstruct);
%    t2.setTag(tagstruct);
%    t1.write(stack1(:,:,i));
%    t1.writeDirectory
%    t2.write(stack2(:,:,i));
%    t2.writeDirectory
%    cprintf('Text', '%s', num2str(i) );
%end
%cprintf('Text', '\n', '' );
%t1.close();
%t2.close();
