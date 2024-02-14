function data=loadspexraw(file)
% data=loadspexraw(file)
% UU
if nargin < 1
   error('function requires filename input');
elseif ~isstr(file)
   error('input argument must be a string representing a file name');
end

fid = fopen(file);
if fid==-1
  error('File not found or permission denied');
  end

% Start processing.
line1 = fgetl(fid);
line2 = fgetl(fid);
line3 = fgetl(fid);
line4 = fgetl(fid);
line5 = fgetl(fid);
line6 = fgetl(fid);
line7 = fgetl(fid);
line8 = fgetl(fid);
line9 = fgetl(fid);
line10 = fgetl(fid);
line11 = fgetl(fid);
line12 = fgetl(fid);
data = [];
data = [data; fscanf(fid, '%f')];
fclose(fid);
data = reshape(data, 2, length(data)/2)';

