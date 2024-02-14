function mean_mat=meanscal(mat)
% mean_mat = meanscale(mat);
% mean scaling of spectral data by wavelength region and per patient
% mat: column oriented spectra with patient nr and site nr as first 2 rows

[n,m]=size(mat);
mean_mat=[];

% find patients indexes

i=2; upper=[]; lower=[2];
while i<m
 if ~(mat(1,i)==mat(1,i+1))
  upper=[upper,i];
  lower=[lower,i+1];
 end
 i=i+1;
end
upper=[upper,m];
disp(['Found ' num2str(length(upper)) ' patients.'])

% mean subtract them

for i=1:size(upper,2),
 ma=mat([3:n],[lower(i):upper(i)]);
 mam=(mean(ma'))';
 ma=ma-(mam*ones(1,size(ma,2)));
 mean_mat=[mean_mat,ma];
end
mean_mat=[mat(1:2,:); [mat(3:n,1),mean_mat]];

