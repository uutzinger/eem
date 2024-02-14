function [emwav,fl,av]=flspectrum4(r,c,data)
%same as flspectrum except calculates average blue reflectance in ROI and
%returns that as well...

%this function receives the row and column location of selcected pixel(s) in an image,
%retrieves the fluorescence emission collected at each pixel and returns that
%spectral data (8 different fluorescence emission wavelengths)

if length(r)~= length(c)
    msgbox('The input vectors of row and column data need to be same length','Error','error');
    return
end
emwav=[418 437 457 485 507 530 562 601];
x=[3 1 4 2 6 8 5 7];
fl=zeros(length(r),8);
%B=zeros(length(r),1);
G=zeros(length(r),1);
%R=zeros(length(r),1);

for k=1:length(r)
    for n=1:8
        fl(k,n)=data.cube(r(k),c(k),x(n)+8); 
    end
    
    %B(k)=data.cube(r(k),c(k),7); %collect all blue reflectance values in ROI
    G(k)=data.cube(r(k),c(k),6); %collect all green reflectance values in ROI
    %R(k)=data.cube(r(k),c(k),5); %collect all red reflectance values in ROI
    %normalize by area (if desired)
    %if sum(fl(k,:))>0
    %    fl(k,:)=fl(k,:)/sum(fl(k,:));  
    %end
end

av=mean(G); %find the mean Green Reflectance in ROI

data.cube(:,:,6)=data.cube(:,:,6)/av;  %normalize the Green Reflect. image by the mean value in the ROI

%get rid of zeros so that we do not divide by zero in next step
%    [rr,cc]=find(data.cube(:,:,7)==0);
%    for n=1:length(rr)
%        data.cube(rr(n),cc(n),7)=1;
%    end

 %divide each ROI pixel of fluorescence images by normalized blue reflectance
 %at that pixel to account for tissue properties
for k=1:length(r)
    fl(k,:)=fl(k,:)/data.cube(r(k),c(k),6);  
end
