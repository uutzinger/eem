function [m]=ReadPowerCalib(StartDir);
CurrentDir=pwd;

FilePattern='pwr__rm_*.eem';
%eval(['cd ' '''' StartDir '''' ]);
dos(['dir "' StartDir '\' FilePattern '" /O:N /B   > "' StartDir '\pwrfile.tmplst"']);

% generate list and puts it in a file pwrfile.tmplst

fidlst = fopen('pwrfile.tmplst');
if fidlst==-1
  error('File not found or permission denied');
end;
m=[]; 
j=1;
while 1
  fline = fgetl(fidlst);
  if ~isstr(fline), break, end
  m(1,j)=sscanf(fline,'pwr__rm_%i');
  [data,header]=LoadPowerData(fline); if isempty(data); warning(['File ' fline ' is empty or does not exist']); end;
  %m_location=sscanf();
  %m_time=sscanf();
  m(2,j)=mean(data);
 % fline=['pwr__sp_',sscanf(fline,'pwr__sp_%s')];
  %[data,header]=LoadPowerData(fline); if isempty(data); warning(['File ' fline ' is empty or does not exist']); end;
  %m_interval=sscanf();
  %m_time=sscanf();
  j=j+1;
end;
fclose(fidlst);
%eval(['cd ' '''' CurrentDir '''' ]);


FilePattern='pwr__sp_*.eem';
dos(['dir "' StartDir '\' FilePattern '" /O:N /B   > "' StartDir '\pwrfile1.tmplst"']);
fidlst1 = fopen('pwrfile1.tmplst');
if fidlst1==-1
  error('File not found or permission denied');
end;
n=[]; 
i=1;
while 1
  fline1 = fgetl(fidlst1);
  [data1,header1]=LoadPowerData(fline1); if isempty(data1); warning(['File ' fline1 ' is empty or does not exist']); end;
  n(1,i)=mean(data1);
  i=i+1;
end;  %end while
fclose(fidlst1);
m=[m;n];


