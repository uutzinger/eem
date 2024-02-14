function [eem]=loadeem(file)
% function [eem]=loadeem('filename')
% loads any eem file into matrix eem
% works for any file type with vectorized data
fid=fopen(file);
if fid==-1
  warning('cannot read file');
  eem=[];
else
  eem=[];
  while 1
    line = fgetl(fid);
    if ~isstr(line), break, end
    vector=sscanf(line,'%f');
    eem = [eem; vector'];
  end
  fclose(fid);
end
 
