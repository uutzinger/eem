% Spectroscopic EEM Processing Toolbox.
% Version 1.0  1-17-97
% Copyright (c) 1993-94 by Spectroscopy Lab, UT Austin, UU
% $Revision: 2.00 $  $Date: 1998/4/14 $
%
% Data input/output.
%   loadfeem  - read raw FEEM data files
%   loadeem   - read saved eem
%   loadspex  - read EEM from SPEX text files
%   loadhita  - read hitatchi absorption spectra
%   load3m    - read processed 3-lamda fluroescence files
%
% Plotting routines. 
%   pltEEM    - 2/3D contour plot of EEM with standard line spacing 
%   lpltEEM   - 2D plot of several eems (by file list) at specified excitation wavelengts  
%   neplot    - 2D plot of eem at specified wavelengths without scaling 
%   eplot     - 2D plot of eem at specified wavelengths with scaling
%   raweplot  - 2D same as eplot but ignoring wavelength information
%   seplot    - 2D plot of eem at one wavelength with specific line type
%   -
%   compseem  - 2D plot of 2 different eems at specified wavelengts with scaling
%   compeem   - 2D plot of 2 different eems at specified wavelengts without scaling
%   -
%   pltxmav   - 2D autocorrelation vector plot of 1 eem
%   pltcxmav  - 2D autocorrelation vector plot of 2 eems
%   -
%   pltref    - plot reflectance data
%   pltcref   - plot reflectance data from 2 sites and compare it
%   -
%   mycolorbar- modified colorbar (very thin and nonuniform text marsk)
%   markeem   - plot known fluorophores
%   imgeem    - 2D image of eem 
%
% Data processing routines.
%   getem     - get emission spectra at specified wavelength with linear interpolation
%   getex     - get excitation spectra at specified wavelength with linear interpolation
%   eeminterp - interpolate eem to new defined emission and excitation steps
%   -
%   eemadd    - add two eems
%   eemsub    - subtract two eems
%   eemsubst  - extract eem subset
%   eemmult   - multiply two eems
%   eemdiv    - divide two eems
%   eemzero   - removes dc offest in emission spectra
%   eemclip   - sets negative values to zero
%   eemshft   - shifts excitation or emission wavelengts
%   eemmatch  - interpolates one eem to fit into an others range
%   -
%   eemcorr   - emission and excitation autocorrelation vectors
%   -
%   cpeakr    - removes one data point if derivative is too big
%   rcosmice  - removes cosmic single peak in eem
%   cutray    - remove rayleigh lines +/- 25nm
%   eems      - scale eem at specified wavelengths to one
%   eemmean   - calculates mean and std eem from a variable amount of eems
%   eemm3     - mean from 3 eems
%
% Metabolic functions.
%   ref_oxy   - calculates oxygenation based on reflectance data (still under development)
%   eem_redox - calculate redox potential (still under development)
%
%Calibration Routines
%   deuter    - uses spline interpolation to produce deuterium lamp emission spectrum
%   tungsten  - uses spline interpolation to produce tungsten lamp emission spectrum
%   eemcf     - calculates correction factors from deuterium and tungsten lamp measurement
%
%Utility Routines
%   blankde    - removes trailing and beginning blanks of string
%   wysiwyg    - what you see is what you get, changes figure and font so that it matches printout
%   -
%   refproc    - processes raw reflection measurements
%   brefprt    - print reflection measurements
%   brefprt2   - newer version batch
%   feemproc   - processes feem measurements
%   feempro2   - newer version of feemproc
%   bfeemprt   - print eem measurements
%   generate_eemmask - scanns eems in directory and generates mask where all eem's have data.
%   -
%   fixbgbias  - adds bias back to eem (use to fix fluorescence background)
%   fixbias    - adds bias and fluorescence background back to eem (use to fix measurement)
%              then subtract fixed fb from fixed eem
%Hamster Study
%   beemcmpprt - ask Andres
%   xmav       - ask Andres
%   xmavplt    - ask Andres
%   hmfeempt   - ask Andres
