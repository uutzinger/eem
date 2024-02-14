function [data,header,xbin,ybin]=LoadCameraData(filename,binary)
%[data,header,xbin,ybin]=LoadCameraData(filename,binary)
%

%reading of the core
if(binary==0)
    %reading of a normal text file
    fid=fopen(filename, 'r');
    %Reading of the header
    header=fgetl(fid);
    sep=find(header==',');
    binning=header(sep(end)+1:end);
    bin=sscanf(binning,'%fX%f');
    xbin=bin(1);
    ybin=bin(2);

    %reading the data
    data=[];
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        tline=str2num(tline);
        data=[data;tline];
    end
    data=data';
    fclose(fid);
else
    %reading of a binary file
    fid=fopen(filename, 'r','b');
    %Reading of the header
    header=fgetl(fid);
    sep=find(header==',');
    binning=header(sep(end)+1:end);
    bin=sscanf(binning,'%fX%f');
    xbin=bin(1);
    ybin=bin(2);

    %reading the data
    fseek(fid,0,0);
    temp=fread(fid,'uint16');
    fclose(fid);
    
    switch length(temp)
        case 1024/xbin*124/ybin
            data=reshape(temp,1024/xbin,124/ybin);
        case 1024/xbin * 16 %the binning by 8 in y-direction results in 16 pixels
            data=reshape(temp,1024/xbin,16);
        case 1024/xbin * 8 %the binning by 16 in y-direction results in 8 pixels
            data=reshape(temp,1024/xbin,8);
        otherwise
            data=[];
            disp('Data format not supported');
    end

end
