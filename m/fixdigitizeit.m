function [lf,sf]=fixdigitiazeit(l,s);
figure(99); clf; plot(l,s);
% Average repeated entries
lu=unique(l);
for i=1:length(lu); k=find(l==lu(i)); su(i)=mean(s(k)); end; su=su';  
% sort the entries
[t,ti]=sort(lu);
su=su(ti);
lu=lu(ti);
hold on; plot(lu,su,'r'); % this will plot cleaned up double entries on top of previous plot
% create wavelenth axis every 5nm
% and interpolate data to new sampling
lf=[min(lu):1:max(lu)]'; 
sf=interp1(lu,su,lf,'linear'); % this will resample your data to equally spaced interval as defined above
plot(lf,sf,'g') % this should now show the equally spaced data 
% filter the data to remove noise
sffilt=sgolayfilt(sf,2,5);  % now we filter the data using a method developed for spectra
% avoid negative numbers
sffilt(sffilt<0)=0;
plot(lf,sffilt, 'k'); % looks good yes? Zoom in if you want to
sf=sffilt;
end

