function [r]=pltspxdxstd(StartDir,FilePattern,lm,lg)
% plots SPXDX standards
dos(['dir "' StartDir '\' FilePattern '" /O:N /B  > "' StartDir '\Processed\file.tmplst"']);
fidlst = fopen([StartDir '\Processed\file.tmplst']);
if fidlst==-1
  error('File not found or permission denied');
  end
hndl=[];
all_dt=[]; lm_i=[];
figure(1); clf;  colordef white; set(gcf, 'Color', [1,1,1]);  
i=1;
while 1
  fline = fgetl(fidlst);
  if ~isstr(fline), break, end;
  dum    = max(findstr(fline,'\'));
  dum2   = max(findstr(fline,'.'));
  if isempty(dum)
   fpath='.';
   dum=0;
  else
   fpath=fline(1,1:dum-1);
  end;
  file   = fline(1,dum+1:dum2-1);
  tmp=double(file); tmp=(tmp<=57 &tmp>=48);
  dt=str2num(file(tmp));
  
  [xA,yA,spcdate1,commentA,labelsA, logtextA]=readspc([StartDir, '\', fline]);
  [xB,yB,spcdateB,commentB,labelsB, logtextB]=readspc([StartDir, '\', fline(1:end-5), 'B.SPC']);
  subplot(1,2,1)
  title([FilePattern(1:2), ' ', StartDir(end-3:end)]);
  m=colormap;
  if lg
      h=semilogy(xA,yA./yB); set(h, 'Color', [random('unif',0,1,1,3)]); hold on;
  else
      h=plot(xA,yA./yB); set(h, 'Color', [random('unif',0,1,1,3)]); hold on;
  end
  hndl=[hndl,h];
  all_dt=[all_dt;dt];
  t=find(xA==lm); lm_i=[lm_i;yA(t)/yB(t)];
  % eval(['print -dmeta O_FL_', num2str(name), num2str(biopsy), char(site), '_EEM']);
  % eval(['print -depsc -tiff O_FL_', num2str(name), num2str(biopsy), char(site), '_EEM']);
i=i+1;
end %while
fclose(fidlst)
legend(hndl,num2str(all_dt))

subplot(1,2,2)
plot(all_dt,lm_i,'-o')
title(['Intensity at: ' num2str(lm)])
r=[all_dt,lm_i]; % return intensity at selected wavelength
wysiwyg