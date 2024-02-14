function [x,y,spcdate,cmnt,catxt, logtxt]=readSPC(filename);
% [x,y,spcdate,comment,labels, logtext]=readSPC(filename)
%
% filename: string
% x:        scan settings
% y:        data values
% spcdate:  string
% comment:  string
% lables:   concatenated string with label text
% logtext:  experiment description (contains experiment settings for Fluorolog) 
%
% Reads GRAMS SPC files
% This is optimized for reading binary data from fluorolog (JYHoriba) SPC files:
%    does not support multitracks
%    expects new SPC file format
%    many SPC fields are empty in fluorolog files
%
% UU, University of Arizona, December 2002, January 2003
% Copyright: If you modify this file you need to e-mail me your new version utzinger@u.arizona.edu

%* Thus an SPC trace file normally has these components in the following order:
%*	SPCHDR		Main header (512 bytes in new format, 224 or 256 in old)
%*      [X Values]	Optional FNPTS 32-bit floating X values if TXVALS flag
%*	SUBHDR		Subfile Header for 1st subfile (32 bytes)
%*	Y Values	FNPTS 32 or 16 bit fixed Y fractions scaled by exponent
%*      [SUBHDR	]	Optional Subfile Header for 2nd subfile if TMULTI flag
%*      [Y Values]	Optional FNPTS Y values for 2nd subfile if TMULTI flag
%*	...		Additional subfiles if TMULTI flag (up to FNSUB total)
ww=warning;
warning off;

fid=fopen(filename, 'r');

% read 512 bytes for header
ftflgs  = fread(fid,   1, 'uchar');  % byte (32)         /* Flag bits defined below */
ffvrsn  = fread(fid,   1, 'uchar');  % byte 75 is new    /* 4Bh=> new LSB 1st, 4Ch=> new MSB 1st, 4Dh=> old format */
fexper  = fread(fid,   1, 'uchar');  % byte (0)          /* Instrument technique code */
fexp    = fread(fid,   1, 'uchar');  % char (2)          /* Fraction scaling exponent integer (80h=>float) */
fnpts   = fread(fid,   1, 'int32');  % dword (73)        /* Integer number of points (or TXYXYS directory position) */
ffirst  = fread(fid,   1, 'double'); % double ffirst     /* Floating X coordinate of first point */
flast   = fread(fid,   1, 'double'); % double flast      /* Floating X coordinate of last point */
fnsub   = fread(fid,   1, 'int32');  % dword (1 0 0 0)   /* Integer number of subfiles (1 if not TMULTI) */
fxtype  = fread(fid,   1, 'uchar');  % byte              /* Type of X units (see definitions below) */            
fytype  = fread(fid,   1, 'uchar');  % byte              /* Type of Y units (see definitions below) */
fztype  = fread(fid,   1, 'uchar');  % byte              /* Type of Z units (see definitions below) */
fpost   = fread(fid,   1, 'uchar');  % byte              /* Posting disposition (see GRAMSDDE.H) */
fdate   = fread(fid,   4, 'uchar');  % dword             /* Date/Time LSB: min=6b,hour=5b,day=5b,month=4b,year=12b */
fres    = fread(fid,   9, 'uchar');  % 9 chars           /* Resolution description text (null terminated) */
fsource = fread(fid,   9, 'uchar');  % 9 chars           /* Source instrument description text (null terminated) */
fpeakpt = fread(fid,   1, 'int16');  % word              /* Peak point number for interferograms (0=not known) */
fspare  = fread(fid,   8, 'single'); % 8 floats          /* Used for Array Basic storage */
fcmnt   = fread(fid, 130, 'uchar');  % 130 chars         /* Null terminated comment ASCII text string */
fcatxt  = fread(fid,  30, 'uchar');  % 30 chars          /* X,Y,Z axis label strings if ftflgs=TALABS */
flogoff = fread(fid,   1, 'int32');  % dword             /* File offset to log block or 0 (see above) */
fmods   = fread(fid,   4, 'uchar');  % dword             /* File Modification Flags (see below: 1=A,2=B,4=C,8=D..)*/
fprocs  = fread(fid,   1, 'uchar');  % byte              /* Processing code (see GRAMSDDE.H) */
flevel  = fread(fid,   1, 'uchar');  % byte              /* Calibration level plus one (1 = not calibration data) */
fsampin = fread(fid,   1, 'int16');  % word              /* Sub-method sample injection number (1 = first or only )*/
ffactors= fread(fid,   1, 'single'); % 32 bit float      /* Floating data multiplier concentration factor */
fmethod = fread(fid,  48, 'uchar');  % 48 chars          /* Method/program/data filename w/extensions comma list*/
fzinc   = fread(fid,   1, 'single'); % float             /* Z subfile increment (0 = use 1st subnext-subfirst)*/
t       = fread(fid, 196, 'uchar');  % 196 char must be 0/* Reserved (must be set to zero) */

%/* Date/Time LSB: min=6b,hour=5b,day=5b,month=4b,year=12b */
spcdate = dec2bin(bytes2dec(flipud(fdate)));
try spcmin  = bin2dec(spcdate(end-5:end)); catch  spcmin  = 0; end
try spchour = bin2dec(spcdate(end-6-4:end-6)); catch  spchour = 0;  end
try spcday  = bin2dec(spcdate(end-6-5-4:end-6-5)); catch  spcday  = 0;  end
try spcmonth= bin2dec(spcdate(end-6-5-5-3:end-6-5-5)); catch  spcmonth= 0;  end
try spcyear = bin2dec(spcdate(1:end-6-5-5-4)); catch  spcyear = 0; end
% generate data string for output
spcdate = [num2str(spchour),':',num2str(spcmin),',',num2str(spcmonth),'-',num2str(spcday),'-',num2str(spcyear)];
%
cmnt  = char(fcmnt');
%
catxt = char(fcatxt');
%
mods=log2(bytes2dec(flipud(fmods)));
%/* FMODS spectral modifications flag setting conventions: */
%/*  "A" (2^01) = Averaging (from multiple source traces) */
%/*  "B" (2^02) = Baseline correction or offset functions */
%/*  "C" (2^03) = Interferogram to spectrum Computation */
%/*  "D" (2^04) = Derivative (or integrate) functions */
%/*  "E" (2^06) = Resolution Enhancement functions (such as deconvlv.ab) */
%/*  "I" (2^09) = Interpolation functions */
%/*  "N" (2^14) = Noise reduction smoothing */
%/*  "O" (2^15) = Other functions (add, subtract, noise, etc.) */
%/*  "S" (2^19) = Spectral Subtraction  */
%/*  "T" (2^20) = Truncation (only a portion of original X axis remains) */
%/*  "W" (2^23) = When collected (date and time information) has been modified */
%/*  "X" (2^24) = X units conversions or X shifting */
%/*  "Y" (2^25) = Y units conversions (transmission->absorbance, etc.) */
%/*  "Z" (2^26) = Zap functions (features removed or modified) */

if ffvrsn ~= 75
    error('Not supported old SPC format')
end

% ftflgs
%#define TSPREC	1   /* Single precision (16 bit) Y data if set. */
%#define TCGRAM	2   /* Experiment (fexper+1) used if set.  (SPC otherwise.) */
%#define TMULTI	4   /* Multiple traces format (set if more than one subfile) */
%#define TRANDM	8   /* If TMULTI and TRANDM=1 then arbitrary time (Z) values */
%#define TORDRD	16  /* If TMULTI abd TORDRD=1 then ordered but uneven subtimes*/
%#define TALABS	32  /* Set if should use fcatxt axis labels, not fxtype etc.  */
%#define TXYXYS	64  /* If TXVALS and multifile, then each subfile has own X's */
%#define TXVALS	128 /* Floating X value array preceeds Y's  (New format only) */

TSPREC=bitget(ftflgs,1);
TCGRAM=bitget(ftflgs,2);
TMULTI=bitget(ftflgs,3);
TRANDM=bitget(ftflgs,4);
TORDRD=bitget(ftflgs,5);
TALABS=bitget(ftflgs,6);
TXYXYS=bitget(ftflgs,7);
TXVALS=bitget(ftflgs,8);

if (TSPREC | TCGRAM | TMULTI | TRANDM | TXYXYS)
 error('Not supported flags (should be easy to update)')
end

% Calculate x values
x=[ffirst:(flast-ffirst)/(fnpts-1):flast]';
if TXVALS
    %read X values
    if fexp < 128 % data is storted in fixed point format
        temp=fread(fid, fnpts, 'int32');
        x=(2^fexp)*temp./(2^32);
    else % data is stored in floating format
        x=fread(fid, fnpts, 'single');
    end % read
end % read X values

% Jump ovber subheader
temp=fread(fid, 32, 'uchar');

%#define SUBCHGD 1	/* Subflgs bit if subfile changed */
%#define SUBNOPT 8	/* Subflgs bit if peak table file should not be used */
%#define SUBMODF 128	/* Subflgs bit if subfile modified by arithmetic */
subflgs=temp(1);     % 128 = modified by arithmetic /* Flags as defined above */
subexp =temp(2);     % char exponent /* Exponent for sub-file's Y values (80h=>float) */
subindx=temp(3:4);   % word /* Integer index number of trace subfile (0=first) */
subtime=temp(5:8);   % float /* Floating time for trace (Z axis corrdinate) */
subnext=temp(9:12);  % float /* Floating time for next trace (May be same as beg) */
subnois=temp(13:16); % float /* Floating peak pick noise level if high byte nonzero*/
subpnts=temp(17:20); % dword /* Integer number of subfile points for TXYXYS type*/
subscan=temp(21:24); % dword /*Integer number of co-added scans or 0 (for collect)*/
subresv=temp(25:32); % 8 chars /* Reserved area (must be set to zero) */
   
%Read Y values
if subexp < 128 % read data in fixed point format
    temp=fread(fid, fnpts, 'int32');
    y=(2^subexp)*temp./(2^32);
else % read data in floating point format
    y=fread(fid,fnpts, 'single');
end

%/* Y values are represented as fixed-point signed fractions (which are similar
%/* to integers except that the binary point is above the most significant bit
%/* rather than below the least significant) scaled by a single exponent value.
%/* For example, 40000000h represents 0.25 and C0000000h represents -0.25 and
%/* if the exponent is 2 then they represent 1 and -1 respectively.  Note that
%/* in the old 4Dh format, the two words in a 4-byte DP Y value are reversed.
%/* To convert the fixed Y values to floating point:
%/*	    FloatY = (2^Exponent)*FractionY
%/* or:	FloatY = (2^Exponent)*IntegerY/(2^32)		  -if 32-bit values
%/* or:	FloatY = (2^Exponent)*IntegerY/(2^16)		  -if 16-bit values

% Read Log Info
%* This structure defines the header at the beginning of a flogoff block. */
%/* The logsizd should be large enough to hold the text and its ending zero. */
%/* The logsizm is normally set to be a multiple of 4096 and must be */
%/* greater than logsizd.  It is normally set to the next larger multiple. */
%/* The logdsks section is a binary block which is not read into memory. */
if flogoff ~= 0

    % 64 bytes 
    logsizd = fread(fid,   1, 'int32');  % DWROD        /* byte size of disk block */
    logsizm = fread(fid,   1, 'int32');  % DWROD        /* byte size of memory block */
    logtxto = fread(fid,   1, 'int32');  % DWORD        /* byte offset to text */
    logbins = fread(fid,   1, 'int32');  % DWORD        /* byte size of binary area (immediately after logstc) */
    logdsks = fread(fid,   1, 'int32');  % DWORD 	    /* byte size of disk area (immediately after logbins) */
    logpar  = fread(fid,  44, 'char');   % char     	/* reserved (must be zero) */

    % read binary area
    if logbins > 0
        logbin = fread(fid,   logbins, 'uchar');
    end
    % read disk area
    if logdsks > 0
        logdsks = fread(fid,   logdsks, 'uchar');
    end
    % read text
    logtxt = fread(fid, logsizd-64, 'char');
    logtxt = char(logtxt');    
end

fclose(fid); % cleanup
warning(ww);

% check range
i=find(y>2E6);
if ~isempty(i)
    warning([filename, ': data above 2 Million counts at: ', num2str(x(i)')])
end % if isempty

% used to extract date (data is big endian on PC)
function [result] = bytes2dec(bytes)
[m,n]=size(bytes);
result=sum(bytes.*[[256.^[m-1:-1:0]']*[ones(1,n)]],1);

%/**************************************************************************
%* In the old 4Dh format, fnpts is floating point rather than a DP integer,
%* ffirst and flast are 32-bit floating point rather than 64-bit, and fnsub
%* fmethod, and fextra do not exist.  (Note that in the new formats, the
%* fcmnt text may extend into the fcatxt and fextra areas if the TALABS flag
%* is not set.  However, any text beyond the first 130 bytes may be
%* ignored in future versions if fextra is used for other purposes.)
%* Also, in the old format, the date and time are stored differently.
%* Finally, note that when saved in the dbstc structure's dbh area, the
%* new spchdr format is always used (old files are converted in memory)
%* except that the fsubh1 area is ommitted and fsubhdr is moved down.
%* Note that the new format header has 512 bytes while old format headers
%* have 256 bytes and in memory all headers use 288 bytes.  Also, the
%* new header does not include the first subfile header but the old does.
%* The following constants define the offsets in the old format header:
%***************************************************************************/
