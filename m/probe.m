CurrentDir=pwd;

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
eval(['cd ' '''' CurrentDir '''' ]);