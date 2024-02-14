function [s,r] = pltspxdxstd(StartDir,FilePattern,lm,lg);
% plots SPXDX standards
dos(['dir "' StartDir '\' FilePattern '" /O:N /B  > "' StartDir '\file.tmplst"']);
fidlst = fopen([StartDir '\file.tmplst']);
if fidlst==-1
  error('File not found or permission denied');
  end
hndl=[];
all_dt=[]; lm_i=[]; fl_all = [];

%generate legend location
if FilePattern(1:2) == 'RX'
    lgd = 2;
else if FilePattern(1:2) == 'RE'
        lgd = 2;
    else if FilePattern(1:2) == 'QE'
            lgd = 2;
        else
            lgd = 1;
        end 
    end 
end
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
  fl = yA./yB;
  if lm == 570 %Rhodamine excitation
      if length(fl) > 55
          fl = fl((end-54):end);
      end
  end
 if lm == 445 %Quinine emission
    if length(fl) ~= 61
     fl = [fl;[1:1:61-length(fl)]'];
     fl_all = [fl_all,fl];
    else
     fl_all = [fl_all,fl];
    end
 else
    fl_all = [fl_all,fl];
 end
  % eval(['print -dmeta O_FL_', num2str(name), num2str(biopsy), char(site), '_EEM']);
  % eval(['print -depsc -tiff O_FL_', num2str(name), num2str(biopsy), char(site), '_EEM']);
i=i+1;
end %while
fclose(fidlst)
legend(hndl,num2str(all_dt),lgd)

subplot(1,2,2)
plot(all_dt,lm_i,'-o')
title(['Intensity at: ' num2str(lm)])
wysiwyg

% added date header 4/2005 UU
s = [[0,all_dt']; [xA,fl_all]];  % return spectra
r= [all_dt,lm_i]; % return intensity at selected wavelength
