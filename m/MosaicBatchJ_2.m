function MosaicBatchJ_2(mydir,Name1,Name2,Name2a,PMT1,PMT2,zposmax,pixelxy,NMosaicX,NMosaicY);
%MosaicBatchJ_2(mydir,Name1,Name2,PMT1,PMT2,zposmax,pixelxy,NMosaicX,NMosaicY);
%
%mydir='C:\Users\utzinger\Desktop\SampleA'
%Name1  = 'AD1'
%Name2  = '18-42-17'
%PMT1 = 'SHG'
%PMT2 = 'NADH'
%zposmax = 60
%pixelxy=518;
%NMosaicX=5
%NMosaicY=5
%
% Urs Utzinger, 2010%%%

global plt

load([mydir, '\','ICorr.mat']);

%%%%
%% Smooth Image
%
disp('Smooth Flat Field Image')
F=medfilt2(Icorr,[5,5],'symmetric'); % remove out-layers, appear mostly at boundary
h=fspecial('average',20); % moving average
%'corr', 'conv'  %'same', 'full' %'symmetric', 'replicate', 'circular'
F=imfilter(F,h,'replicate'); % outside boundary values assume to be nearast neighbor

if plt % check filter
    figure(1); clf; 
    plot(Icorr(250,:)); hold on; plot(F(250,:),'r')
    plot(Icorr(:,250)); hold on; plot(F(:,250),'r')
    figure(2); imagesc(F);
    figure(3); imagesc(Icorr);
end

%% Fit Gaussian to the flat field
%disp('GaussFit to FlatField')
%[a,res]=gaussfit(double(IcorrD),'2d',1,'no')
%[a,res]=gaussfit(double(IcorrD),'2d',1,'no',a)
%F2=plotgaussfit(a , double(IcorrD), 1, 'no');
%a2=a;

%%%%%
%% 2D Lowess Fit to the data
%
% decimate to smaller size 10%
[lx,ly]=size(F); [Fr]=resizem(F,0.1); [lxd,lyd]=size(Fr);
R=1:1:lx; R=ones(lx,1)*R; Rr=resizem(R,0.1); Rr=Rr(1,:); % location of elements in reference to previous sized matrix
[Xr,Yr]=meshgrid(Rr,Rr); % location of data
% prep data to become vector
X=reshape(Xr,[],1);
Y=reshape(Yr,[],1);
Fr=reshape(Fr,[],1);
% sftool, can find fir procedure manually
ft = fittype( 'loess' );
opts = fitoptions( ft );
opts.Span = 0.05;
opts.Weights = zeros(1,0);
[fitresult, gof] = fit( [X, Y], Fr, ft, opts );

Ffit=fitresult([X,Y]); 
Ffit=reshape(Ffit,lxd,lyd); % make square again

if plt
    % Create a figure for the plots.
    figure(11);
    % Plot fit with data.
    subplot( 2, 1, 1 );
    h = plot( fitresult, [X, Y], Fr );
    legend( h, 'Flat Field Fit', 'F vs. X, Y', 'Location', 'NorthEast' );
    % Label axes
    xlabel( 'X' );  
    ylabel( 'Y' );
    zlabel( 'F' );
    grid on
    view( -12.5, 66 );

    % Plot residuals.
    subplot( 2, 1, 2 );
    h = plot( fitresult, [X, Y], Fr, 'Style', 'Residual' );
    legend( h, 'Flat Field - residuals', 'Location', 'NorthEast' );
    % Label axes
    xlabel( 'X' );
    ylabel( 'Y' );
    zlabel( 'F' );
    grid on
    view( -12.5, 66 );
end

Fr=reshape(Fr,lxd,lyd);
% check fit
if plt
    for i=1:1:size(Fr,2)
        figure(1); clf; 
        plot(Fr(i,:)); hold on; plot(Ffit(i,:),'r');
        plot(Fr(:,i)); hold on; plot(Ffit(:,i),'r');
        pause
    end
end

% Expand to original image size
[XI,YI]=meshgrid(1:1:lx,1:1:ly); % resized pixel coordinates
FI=interp2(Xr,Yr,Ffit,XI,YI,'spline'); % expand
%FI=resizem(Ffit,[lx ly],'bicubic');

if plt
    for i=1:10:size(Icorr,2)
        figure(1); clf; 
        plot(Icorr(i,:)); hold on; plot(FI(i,:),'r'); plot(F(i,:),'g');
        plot(Icorr(:,i)); hold on; plot(FI(:,i),'r'); plot(F(:,i),'g');
        pause
    end
    figure(2); imagesc(FI);
    figure(3); imagesc(Icorr);
end

% create Flat Field for the whole mosaic
FI = (FI/max(max(FI)));
FF=ones(NMosaicX*pixelxy,NMosaicY*NMosaicX);
for i=0:(NMosaicX-1)
    for j=0:(NMosaicY-1)
        FF(i*pixelxy+1:i*pixelxy+pixelxy,j*pixelxy+1:j*pixelxy+pixelxy)=FI;
    end
end

if plt
    figure(1); imagesc(FF);
end

clear stack1 stack2
disp('Load Stacks');
%%%%%
% Load Stack
t1=Tiff([mydir, '\', Name1,'_',PMT1,'.tif'], 'r');
t2=Tiff([mydir, '\', Name1,'_',PMT2,'.tif'], 'r');
for i=1:zposmax
    stack1(:,:,i)=t1.read();
    t1.nextDirectory();
    stack2(:,:,i)=t2.read();
    t2.nextDirectory()
    cprintf('Text', '%s', num2str(i))
end
cprintf('Text', '%s\n', '')
i=i+1;
stack1(:,:,i)=t1.read();
stack2(:,:,i)=t2.read();
t1.close();
t2.close();

%%%%%
%% Apply Flat Field correction

% Check Flatfield correction, somehow it undercorrects at the borders.
if plt
    l1=sum(FF,2); l1=l1./max(l1); 
    % check a few different locations in the stack
    l2=sum(stack1(:,:,1),2); l2=l2./max(l2);
    clf;
    for c=1:0.1:3
        clf;
        plot(l1,'b'); hold on;  % Flat Field
        plot(l2,'r');           % Summ of Image
        plot((1-c*(1-l1)),'g')  % Adjusted flat field
        plot(l2./(1-c*(1-l1)),'k'); % correction
        cprintf('Text', '%s', num2str(c))
    pause
    end
    cprintf('Text', '%s\n', '')
end

disp('Apply FlatField Correction')
for i=1:size(stack1,3); 
    stack1(:,:,i)=uint16((double(stack1(:,:,i))./FF));
    stack2(:,:,i)=uint16((double(stack2(:,:,i))./FF));
    cprintf('Text', '%s', num2str(i))
end;
cprintf('Text', '%s\n', '')

% Show Stack
if plt
    for i=1:size(stack1,3); 
        figure(1); imshow(stack1(:,:,i));
        figure(2); imshow(stack2(:,:,i));
        cprintf('Text', '%s', num2str(i))
        pause;
    end;
    cprintf('Text', '%s\n', '')
end

%%%
%% Save Stacks
ImageLength = size(stack1,1);
ImageWidth = size(stack1,2);
imwrite(stack1(:,:,1),[mydir, '\', Name1,'_',PMT1,'_FF.tif'],'Compression','none',...
    'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','overwrite');
for i=2:size(stack1,3); 
    imwrite(stack1(:,:,i),[mydir, '\', Name1,'_',PMT1,'_FF.tif'],'Compression','none',...
        'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','append');
     cprintf('Text', '%s', num2str(i))
end
cprintf('Text', '%s\n', '')

ImageLength = size(stack2,1);
ImageWidth = size(stack2,2);
imwrite(stack2(:,:,1),[mydir, '\', Name1,'_',PMT2,'_FF.tif'],'Compression','none',...
    'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','overwrite');
for i=2:size(stack2,3); 
    imwrite(stack2(:,:,i),[mydir, '\', Name1,'_',PMT2,'_FF.tif'],'Compression','none',...
        'Description','Matlab SPXLAB','Resolution',[ImageLength, ImageWidth],'Writemode','append');
     cprintf('Text', '%s', num2str(i))
end
cprintf('Text', '%s\n', '')

%% Save Stack
%t=Tiff([mydir, '\', Name1,'_FF.tif'],'w');
%tagstruct.Compression           = Tiff.Compression.None;
%tagstruct.ImageLength           = size(stack1,1);
%tagstruct.ImageWidth            = size(stack1,2);
%tagstruct.BitsPerSample         = 16;
%tagstruct.Photometric           = Tiff.Photometric.MinIsBlack;
%tagstruct.PlanarConfiguration   = Tiff.PlanarConfiguration.Chunky;
%tagstruct.SamplesPerPixel       = 2;
%tagstruct.RowsPerStrip          = 16;
%tagstruct.Software              = 'MATLAB';
%tagstruct.Copyright             = 'University of Arizona';
%ct=clock; s=[num2str(ct(1)) ' ' num2str(ct(2)) ' ' num2str(ct(3)) ' ' num2str(ct(4)) ' ' num2str(ct(5)) ' ' num2str(int16(ct(6)))]
%tagstruct.DateTime              = s;
%tmp=uint16(zeros(tagstruct.ImageLength,tagstruct.ImageWidth,tagstruct.SamplesPerPixel));
%for i=1:size(stack1,3); 
%    t.setTag(tagstruct);
%    tmp(:,:,1)=stack1(:,:,i);
%    tmp(:,:,2)=stack2(:,:,i);
%    t.write(tmp);
%    t.writeDirectory
%    cprintf('Text', '%s', num2str(i) );
%end
%clear tmp;
%t.close();


