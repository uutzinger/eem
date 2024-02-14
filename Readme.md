# Utilities to Process Fluorolog spectra into EEMs

The main folder contains the emission and excitation intensity correction files.
It also contains one example matlab program to process and plot the data

This is work in progress to restore old code for EEM processing.
Urs Utzinger 2024

## m

%   newpltEEM - 2/3D contour plot of EEM with standard line spacing 
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
%   generate_eemmask - scanns eems in directory and generates mask where all eem's have data.
%   -

## data

