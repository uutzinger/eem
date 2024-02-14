function [data,header]=LoadPowerData(filename)
fid=fopen(filename, 'r', 'b');
if fid>=0
    header=fgetl(fid);
    data=[];
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        tline=str2num(tline);
        data=[data;tline];
    end
    fclose(fid);
else
    warning([filename ' does not exist']);
    data=[];
    header=[];
end;
