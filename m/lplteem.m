function lplteem(filelst,l)
% function lplteem(filelst,l)
% plots several eems at specified excitation wavelengths l
% input filelist
% saves output at filelst.wmf
%
po=get(gcf,'PaperOrientation');
if ~strcmp(po, 'portrait')
 disp('Set Paperorientation to portrait and adjust drawing size, then restart command')
 pageset;
 break;
end
unis = get(gcf,'units');
ppos = get(gcf,'paperposition');
set(gcf,'units',get(gcf,'paperunits'));
pos = get(gcf,'position');
pos(3:4) = ppos(3:4);
set(gcf,'position',pos);
set(gcf,'units',unis);

clf
c= [ ' -c'; ' -r'; ' -g'; ' -b'; ' -w'; ' -y'; ' -m'; ...
     '--c'; '--r'; '--g'; '--b'; '--w'; '--y'; '--m'; ...
     '-.c'; '-.r'; '-.g'; '-.b'; '-.w'; '-.y'; '-.m'; ...
     ' :c'; ' :r'; ' :g'; ' :b'; ' :w'; ' :y'; ' :m';];

fidlst = fopen(filelst);
if fidlst==-1
  error('File not found or permission denied');
  end

headerc=[]; n=1;
for i=1:length(l)
    eval(['h'   num2str(i) '= [];']);
    eval(['lgd' num2str(i) '= [];']);
end
while 1
   line = fgetl(fidlst);
   if ~isstr(line), break, end
   disp(line)
   eval(['[data]=loadeem(''' line ''');']);
   namec = line(1:size(line,2)-4);
   headerc = [headerc; sprintf('%16s',namec)];
   for i=1:length(l)
    subplot(length(l),1,i); set(gca,'FontSize', 11); hold on;
    [ht,lg]=seplot(data,l(i),c(n,:));
        eval(['h'   num2str(i) '= [h'   num2str(i) '; ht];']);
    eval(['lgd' num2str(i) '= [lgd' num2str(i) '; [sprintf(''%16s '',namec),num2str(lg)]];'])
   end
   n=n+1;
end
fclose(fidlst);

for i=1:length(l)
 subplot(length(l),1,i)
 set(gca,'Box','on'); set(gca,'FontSize', 11);
 title(num2str(l(i))); refresh;
 eval(['legend(h' num2str(i) ', lgd' num2str(i) ');']);
end

nf=size(filelst,2)-4;
filename = [filelst(1:nf),'.wmf'];
eval(['print -dmeta ', filename]);


