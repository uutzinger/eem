function [E,w,t]=releffUV(wl,output)

% [E,corected_wl,corrected_output]=releffUV(wl,ouptut)
%
% caluclates relative effectiveness corrected integrated output
% wl is wavelength [nm], sorted
% output should be in J/cm^2/nm at wl[nm]
% E should be smaller then 0.003
%

global dbg;

% DATA
% lambda	TLV	RSE		
% TLV = Threshold Limit Value (J/cm^2) 
% RSE = Relative Spectral Effectiveness 
% Source: ACGIH (american conference of govermental industrial hygienists)
ACGIH=[...
180	2.50E-01	0.012
190	1.60E-01	0.01875
200	1.00E-01	0.03
205	5.90E-02	0.050847458
210	4.00E-02	0.075
215	3.20E-02	0.09375
220	2.50E-02	0.12
225	2.00E-02	0.15
230	1.60E-02	0.1875
235	1.30E-02	0.230769231
240	1.00E-02	0.3
245	8.30E-03	0.361445783
250	7.00E-03	0.428571429
254	6.00E-03	0.5
255	5.80E-03	0.517241379
260	4.60E-03	0.652173913
265	3.70E-03	0.810810811
270	3.00E-03	1
275	3.10E-03	0.967741935
280	3.40E-03	0.882352941
285	3.90E-03	0.769230769
290	4.70E-03	0.638297872
295	5.60E-03	0.535714286
297	6.50E-03	0.461538462
300	1.00E-02	0.3
303	2.50E-02	0.12
305	5.00E-02	0.06
308	1.20E-01	0.025
310	2.00E-01	0.015
313	5.00E-01	0.006
315	1.00E+00	0.003
316	1.30E+00	0.002307692
317	1.50E+00	0.002
318	1.90E+00	0.001578947
319	2.50E+00	0.0012
320	2.90E+00	0.001034483
322	4.50E+00	0.000666667
323	5.60E+00	0.000535714
325	6.00E+00	0.0005
328	6.80E+00	0.000441176
330	7.30E+00	0.000410959
333	8.10E+00	0.00037037
335	8.80E+00	0.000340909
340	1.10E+01	0.000272727
345	1.30E+01	0.000230769
350	1.50E+01	0.0002
355	1.90E+01	0.000157895
360	2.30E+01	0.000130435
365	2.70E+01	0.000111111
370	3.20E+01	0.00009375
375	3.90E+01	7.69231E-05
380	4.70E+01	6.38298E-05
385	5.70E+01	5.26316E-05
390	6.80E+01	4.41176E-05
395	8.30E+01	3.61446E-05
400	1.00E+02	0.00003];


% interpolate relative effectiveness
RE=spline(ACGIH(:,1),ACGIH(:,3), wl);
% plot(ACGIH(:,1),ACGIH(:,3))
indx=find(wl>=400); RE(indx)=RE(indx)*0;
indx=find(wl<=180); RE(indx)=RE(indx)*0;

% apply relative effectivenesss
t=output.*RE;
% integral
E=trapz(wl,t);

if dbg
 figure
 plot(wl,output,'k-');
 plot(wl,t,'g');
 disp([num2str(E) 'J/cm^2/nm']);
end

w=wl(wl>=180&wl<=400);
t= t(wl>=180&wl<=400);
