function [emwav,fl]=flspectrum(r,c,data)
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

for k=1:length(r)
    for n=1:8
        fl(k,n)=data.cube(r(k),c(k),x(n)+8); 
    end
    
    %normalize by area (if desired)
    %if sum(fl(k,:))>0
    %    fl(k,:)=fl(k,:)/sum(fl(k,:));  
    %end
end
