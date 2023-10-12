function Record=readqfile2struct(fname,withtraces,selectedtraces,endian)
%
%
% Options to use this function:
%
% Record=readqfile2struct(filename)
%
% Record=readqfile2struct(filename,withtraces)
%
% Record=readqfile2struct(filename,withtraces,selectedtraces)
%
% Record=readqfile2struct(filename,withtraces,selectedtraces,endian)
%
%
% This function reads a q-file given by "filename" to a struct. Most Seismic Handler
% info entries are copied. You can use this function with 1 to 4 arguments.
% 
% filename:= name of Q-file with or without ending (necessary)
% filename can be a string or a struct with the field .name containing the filename as string!
% 
% withtraces (optional, default :=1)
% :=0 only info entries are read to struct
% :=1 info entries and traces are read to struct
% 
% selectedtraces optional, default:=NaN:= all traces)
% integer scalar or array with traces to be read
% 
% selectedtraces=2                function reads trace 2 to struct
% selectedtraces=[1 4 6 29 3]     function reads traces 1, 4, 6, 29 and 3 to struct (in this order)
% 
% endian
% string ('big' or 'lil') to define file endian. default is 'big'. Older SH-versions
% are using big-endian q-files, newer one little-endian q-files. Check your SH-Version!!
% 
%
%
% This function/program is part of the KaSoP toolbox and free software under the GNU licencse!
%
% #####################################################################################################
%
 
%
%###############################
%
% SH INFO ENTRIES
%
% LONG
%      LENGTH -> L001 
% 
% NTEGER
% 	 SIGN -> I011
%     EVENTNO -> I012
% 	 MARK -> I014
% 
% REAL   
% 	DELTA -> R000
% 	CALIB -> R026
%    DISTANCE -> R011
%     AZIMUTH -> R012
%    SLOWNESS -> R018
% 	 INCI -> R013
% 	DEPTH -> R014
%   MAGNITUDE -> R015
% 	  LAT -> R016
% 	  LON -> R017
%    SIGNOISE -> R022
% 	 PWDW -> R023
%      DCVREG -> R024
%     DCVINCI -> R025
%
% STRING 
%     COMMENT -> S000
%     STATION -> S001
%      OPINFO -> S002
%
%       FILTER -> S011
%      QUALITY -> S012
%
% CHAR
%	 COMP -> C000
%	CHAN1 -> C001
%	CHAN2 -> C002
%
% TIME (q-type STR) 
%	START -> S021
%     P-ONSET -> S022
%     S-ONSET -> S023
%      ORIGIN -> S024
%
%####################################
%
 
%##########################################################################################################
%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
%#%													 %#
%#%   Copyright (c) 2009 by the KaSP-Team.								 %#
%#%   This file is part of the Karlsruhe Seismology Processing (KaSP) Toolbox for MATLAB!		 %#
%#%													 %#
%#%   The KaSP toolbox is free software under the terms of the GNU General Public License!		 %#
%#%													 %#
%#%   Please see the copyright/licensce notice distributed together with the KaSP Toolbox!		 %#
%#%													 %#
%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
%##########################################################################################################
%
 
% #########################################################################################################
%
% Main author: Joern Groos (joern.groos@kit.edu)
%
%
%  created: 2007-08 -JG-
%
% modified: 2008-07-03 -JG-
% modified: 2009-04-02 -JG-
% modified: 2009-05-29 -JG-
% modified: 2009-12-04 -JG- (License, documentation, handling of input variable 'filename')
%   REMARK: 2009-12-11 -JG- (fixed a minor bug caused by readqhd.m. This function failed to read only selected traces
%                           from Q-files saved by Q-Cut (NOT X-CUT!!) at GPI KIT, because in this Q-Cut case the first info entry of the traces
%                           is L000 instead of L001, as it is usually in SH Q-files. There was no problem to read Q-Cut Qfiles completly!
%                           Now readqhd is capable to work with L000 and L0001 as first info entry. The 'problem' is also solved by
%                           read and resave the Q-Cut with Seismic Handler. The Q-files saved by SH have the L001 as first info entry!
% modified: 2010-02-04 -JG- (Removed transpose from line record=newrecord in case of reading selected traces of a Q-File)
% modified: 2010-09-26 -JG- Included error handling for qfiles with less samples in the binary QBN than defined in the QHD file (possible XCUT errors!)
% modified: 2011-05-13 -JG- Improved handling of input variable "endian"due to new SH version. Now the change between little and big endian is easier!
%                           Furhtermore a simple check is included if the data was read with the correct endian!  
% modified: 2011-05-19 -JG- Improved logic of endian test           
% modified: 2011-06-14 -BW- Improved warning message regarding npts           
%
%
% #########################################################################################################
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% begin of function
%

defaultendian='big';

if (nargin==0)
error('No filename given!')
end

if nargin==1
withtraces=1;
selectedtraces=NaN;
endian=defaultendian;
end

if nargin==2

    if ischar(withtraces)
    endian=withtraces;
    withtraces=1;
    selectedtraces=NaN;
    else
    
    	if length(withtraces)==1
	    if withtraces==0 || withtraces==1
	    	    selectedtraces=NaN;
		    endian=defaultendian;
	    else
		    disp(' ')
		    disp('ATTENTION!')
       		    disp('Argument ''withtraces'' should be boolean! The actually given argument is interpreted to be meant as ''selectedtraces'' with withtraces=1')
		    disp(' ')
		    selectedtraces=withtraces;
		    withtraces=1;
		    endian=defaultendian;	    	    
	    end
	else
	    disp(' ')
	    disp('ATTENTION!')
       	    disp('Argument ''withtraces'' should be boolean! The actually given argument is interpreted to be meant as ''selectedtraces'' with withtraces=1')
	    disp(' ')
	    selectedtraces=withtraces;
            withtraces=1;
	    endian=defaultendian;
    	end
    end
    

end

if nargin==3
	if (withtraces==0 || withtraces==1) && ischar(selectedtraces)
	endian=selectedtraces;
	selectedtraces=NaN;
	else
	endian=defaultendian;
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ERROR CHECKING INPUT VARIABLES

inputerror=0;


if withtraces~=0 && withtraces~=1
disp(' ')
disp('ATTENTION!')
disp('Argument ''withtraces'' is not correct!')
disp(' ')
inputerror=1;
fname
withtraces
selectedtraces
endian
disp(' ')
end

if ischar(selectedtraces)
disp('ATTENTION!')
disp('Argument ''selectedtraces'' is not correct (string)!')
inputerror=1;
disp(' ')
fname
withtraces
selectedtraces
endian
disp(' ')
Record=0;
return
end



if sum(selectedtraces>0)~=length(selectedtraces)
if ~isnan(selectedtraces)
disp('ATTENTION!')
disp('Argument ''selectedtraces'' is not correct!')
inputerror=1;
disp(' ')
fname
withtraces
selectedtraces
endian
disp(' ')
end
end


if ((strcmp(endian,'big')==0) && (strcmp(endian,'lil')==0))
disp(' ')
disp('ATTENTION!')
disp('Argument ''endian'' is not correct!')
inputerror=1;
disp(' ')
fname
withtraces
selectedtraces
endian
disp(' ')
end

% checks input arguements

if inputerror==1
Record=0;
return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




if ~isstruct(fname)
filename=fname;
else
	if isfield(fname,'name')
		if length(fname)==1
		filename=fname.name;
		else
		filename=fname(1).name;
		disp('This function reads only ONE qfile at once! The first given filename is used!')
		end
	
	else
	disp('Unknown input!')
	Record=0;
	return
	end

end

if strcmp(filename(end-3:end),'.QHD') || strcmp(filename(end-3:end),'.QBN')
    filename=filename(1:end-4);
end

if (exist([filename,'.QHD'],'file')~=2) || (exist([filename,'.QBN'],'file')~=2)
    error('File not found!');
end

fpath=cd;
absolutpath = fullfile(fpath, [filename '.QBN']);

% checks given filename and cuts possible fileextensions

 
%==========================================================================
%------ header reading ------

%[elat,elon,edep,emag,edist,ebazi,eventtime]=readqhd(filename,'R016',0,'R017',0,'R014',0,'R015',0,'R011',0,'R012',0, 'S024',0);

%[npts,tau]=readqhd(filename,'L001',0,'R000',0);

%[staname,t0trace,comp1,comp2,comp3]=readqhd(filename,'S001',0,'S021',0,'C001',0,'C002',0,'C000',0);

%[r26,s2,lnull]=readqhd(filename,'R026',0,'S002',0,'L000',0);


[elat,elon,edep,emag,edist,ebazi,incideg,eventtime,npts,tau,staname,t0trace,comp1,comp2,comp3,r26,s2,lnull,comment,ponsetSH,sonsetSH]=readqhd(filename,'R016',0,'R017',0,'R014',0,'R015',0,'R011',0,'R012',0,'R013',0,'S024',0,'L001',0,'R000',0,'S001',0,'S021',0,'C001',0,'C002',0,'C000',0,'R026',0,'S002',0,'L000',0,'S000',0,'S022',0,'S023',0);
% 25% faster!
% reads infoentries from Q-File Header. Not specified infoentries have the value NaN.

if iscell(s2)==0
s2=num2cell(s2);
end

if iscell(comment)==0
comment=num2cell(comment);
end
% if no comment is specified, eventtime must be converted from numeric to cell array before furhter processing

% conversion of cell array to numeric array (problem of Sxxx identifier with numeric instead char value)

%==========================================================================

% getting trace information from filename

if sum(strcmp(t0trace,filename))==length(npts)

filterinfo=get_struct_filterinfo;

unit='nm/s';
unitid=2;
demean=0;
trend=0;
deconv=0;
% checks if filename is identical to start time of trace in SH-Format
% this is the case, if traces where written to q-files by XCUT (data cutting tool
% at the Geophysical Institute Universitaet Karlsruhe (TH). Q-Files generated by
% XCUT are ground motion velocity in nm/s.

else

[unit,unitid,filterinfo,deconv,demean,trend]=filenameinfo_extract(filename);

% processing information is extracet from coded filename.
% if no processing information is given in the filename, all variables are set to
% NaN which has to be interpreted as "unknown".

end

%==========================================================================


%==========================================================================
%----- creation of the Record structure ------

tsn=datenum((strrep(t0trace,'_',' ')),0.001);
[traceyr,tracemon,traceday,tracehr,tracemin,tracesec]=time2num(tsn,0.001);
tracejulianday=dm2jd(traceday,tracemon,traceyr);
% Year, Month, Day, Hour, Min, sec and julianday of trace starttime is extracted from SH-Datestring format in t0trace

tdate=[traceyr tracemon traceday tracehr tracemin tracesec];
% date vector with start times of traces

traceyr=traceyr';
tracemon=tracemon';
traceday=traceday';
tracehr=tracehr';
tracemin=tracemin';
tracesec=tracesec';
tracejulianday=tracejulianday';
% transpose vectors to correct dimensions


if iscell(eventtime)==0
eventtime=num2cell(eventtime);
end
% if no eventtime is specified, eventtime must be converted from numeric to cell array before furhter processing

if iscell(ponsetSH)==0
ponsetSH=num2cell(ponsetSH);
end

if iscell(sonsetSH)==0
sonsetSH=num2cell(sonsetSH);
end



tracenum=length(tau);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable allocation

esn=ones(tracenum,1)*NaN;
eventyr=ones(tracenum,1)*NaN;
eventmon=ones(tracenum,1)*NaN;
eventday=ones(tracenum,1)*NaN;
eventhr=ones(tracenum,1)*NaN;
eventmin=ones(tracenum,1)*NaN;
eventsec=ones(tracenum,1)*NaN;
eventjulianday=ones(tracenum,1)*NaN;
edate=ones(tracenum,6)*NaN;

evt0=ones(tracenum,1)*NaN;
psn=ones(tracenum,1)*NaN;
ssn=ones(tracenum,1)*NaN;

% Variable allocation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for k=1:tracenum

	if (isnan(eventtime{k})==0)
	
	Esn=datenum(strrep(eventtime{k},'_',' '),0.001);
	
	[Eventyr,Eventmon,Eventday,Eventhr,Eventmin,Eventsec]=time2num(Esn,0.001);
	
	esn(k,1)=Esn;
	eventyr(k,1)=Eventyr;
	eventmon(k,1)=Eventmon;
	eventday(k,1)=Eventday;
	eventhr(k,1)=Eventhr;
	eventmin(k,1)=Eventmin;
	eventsec(k,1)=Eventsec;
	eventjulianday(k,1)=dm2jd(Eventday,Eventmon,Eventyr);


	edate(k,:)=[Eventyr Eventmon Eventday Eventhr Eventmin Eventsec];
	%date vector of eventtime

	evt0(k)=round(etime(edate(k,:),tdate(k,:))/tau(k))*tau(k);
	% Difference between eventtime and start time of trace in seconds. If the trace is starting before the eventtime,
	% evt0 is positive.
	end %if (isnan(eventtime{k})==0)

	if (isnan(ponsetSH{k})==0)
	psn(k)=datenum(strrep(ponsetSH{k},'_',' '),0.001);
	else
	psn(k)=NaN;		
	end

	if (isnan(sonsetSH{k})==0)
	ssn(k)=datenum(strrep(sonsetSH{k},'_',' '),0.001);
	else
	ssn(k)=NaN;		
	end

end %for k=1:length(tau)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Trace component extraction
%%% Very specific behaviour of SeismicHandler. Sometimes 3 Components (2 without explanation)
%%% or only 1 Component are stored in different infoentries. Comp3 is the correct Component of
%%% the seismometer (Z:=Vertical; N=North-South; E=East-West)
%%% If only one Component is given, .kcomp and .comp (see struct definition below) are identical
%%% e.g. Z.
%%% If not, .comp is the component of the trace (e.g. Z) and .kcomp are all given components
%%% e.g. SHZ
%%%
%%% Variable (see above) | SH Info Entry      |  given Information from SH
%%%  comp1 | C001 | CHAN1        
%%%  comp2 | C002 | CHAN2
%%%  comp3 | C000 | COMP

if iscell(comp1)==0
comp1=num2cell(comp1);
end
if iscell(comp2)==0
comp2=num2cell(comp2);
end
if iscell(comp3)==0
comp3=num2cell(comp3);
end

for k=1:length(comp1)

if isnan(comp1{k})
xcomp1{k}='X';
else
xcomp1{k}=comp1{k};
end

if isnan(comp2{k})
xcomp2{k}='X';
else
xcomp2{k}=comp2{k};
end

if isnan(comp3{k})
xcomp3{k}='X';
else
xcomp3{k}=comp3{k};
end

end

kcomp=cellstr([strvcat(xcomp1),strvcat(xcomp2),strvcat(xcomp3)])';

clear xcomp1 xcomp2 xcomp3

%%% /Trace component extraction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Definition of struct Record, first all infoentries, trace see below

Record(1:tracenum)=get_struct_timeseries();

for k=1:tracenum

% Construction of struct for further processing

Record(k).delta = tau(k);	% sampling rate of time series in seconds
Record(k).npts  = npts(k);	% Number of samples (points) (also O. Sebe)

Record(k).unit = unit;		% Text string with information about time series unit (e.g. nm/s, count, etc.)
Record(k).unitid=unitid;        % Number indentifying common seismological time series units (0:= counts; 1:=nm/(s*s); 2:= nm/s; 3:=nm; NaN:=other).

Record(k).channel = kcomp{k};     % all three component abbreviations possibly used by SeismicHandler -> for struct to be compatible to O.Sebe programms
Record(k).comp = comp3{k};      % component of time series: Z, N, E, R, T

Record(k).t0trace = t0trace{k};               % Starting time of time series as text string in SeismicHandler format
                                              % (dd-mm-yyyy_HH:MM:SS.FFF, e.g. 22-JAN-2003_02:15:30.000)

Record(k).tracejulianday = tracejulianday(k); % Julian Day of starting date

Record(k).tdate = tdate(k,:);   % Date vector of starting time of time series [year month day hour minute seconds]
Record(k).tsn = tsn(k);         % PRIMARY INFORMATION! Serial Time of Starttime, all other trace time information depend on this!

Record(k).staname = staname{k}; % Station name      (also O. Sebe)
%Record(k).slat = NaN;           % Station Latitude in degrees  (also O. Sebe)
%Record(k).slon = NaN;           % Station Longitude in degrees (also O. Sebe)
%Record(k).salt = NaN;           % Station Altitude  (also O. Sebe)
Record(k).sdep = NaN;		% Station Depth     (also O. Sebe)

Record(k).comment = comment{k};	% Comment concering time series (equals comment of SeismicHandler)

%Record(k).evname = NaN;		% Event Name        (also O. Sebe)
Record(k).elat = elat(k);	% Event Latitude in degrees    (also O. Sebe)
Record(k).elon = elon(k);	% Event Longitude in degrees   (also O. Sebe)
%Record(k).ealt = NaN;		% Event Altitude    (also O. Sebe)
Record(k).edep = edep(k);	% Event Depth       (also O. Sebe)
Record(k).emag = emag(k);	% Event Magnitude   (also O. Sebe)

Record(k).t0event = eventtime{k};             % Focal time of Event as text string in SeismicHandler format
Record(k).eventjulianday = eventjulianday(k); % Julian Day of Focal time

Record(k).edate = edate(k,:);                 % Date vector of Focal time of Event [year month day hour minute seconds]
Record(k).esn = esn(k);                          % PRIMARY INFORMATION! Serial Time of Eventtime, all other eventtime information depend on this!

Record(k).evt0 = evt0(k);                     % Difference between Focal time and starting time of time series in seconds
% If the time series is starting before the focal time, evt0 is positive!

Record(k).ponset=psn(k);                      % P-Onset as serial date number

Record(k).sonset=ssn(k);                      % S-Onset as serial date number
                                            
Record(k).distrad = edist(k)*(pi/180);                      % Distance between event and station in distance radians (also O. Sebe)
Record(k).distkm = edist(k)*(((6378137*2*pi)/360)/1000); % Distance between event and station in km               (also O. Sebe)
Record(k).distdeg = edist(k);                            % Distance between event and station in distance degrees

%Record(k).azdeg = NaN;                % Azimuth (Event to Station) against North in degrees
%Record(k).azrad = NaN;                % Azimuth (Event to Station) against North in radians

Record(k).bazdeg = ebazi(k);          % Backazimuth (Station to Event) against North in degrees						        
Record(k).bazrad = ebazi(k)*(pi/180); % Backazimuth (Station to Event) against North in radians						         

if ~isnan(incideg(k))
Record(k).incideg = incideg(k);          % incident angle in degree						        
Record(k).incirad = incideg(k)*(pi/180); % incident angle in radians		
end

Record(k).filters = filterinfo;  % A struct is stored with all apllied filters (hp,lp,bp,bs)
                             % struct format: 
			     %		     filter.order   Order of filter (for MATLAB-function butter: n=filter.order/length(filter.Wn) !!!!!)
			     %				    order:=0 No Filter was applied; order=NaN applied filters are unknown!
			     %		     filter.Wn      Corner Frequency or Frequencies in Hz! eg. [1 12.5] bandpass/stop or [0.04] high/lowpass
			     %		     filter.type    Type of Filter as string ('high','low','stop','bandpass')
			     %
			     % usage of filter struct: [b,a]=butter((Record(x).filter(y).order/(length(Record(x).filter(y).Wn))),...
			     %			      Record(x).filter(y).Wn.*(Record(x).delta*2),Record(x).filter(y).type)
				     

Record(k).calib = r26(k);    % Calibration Constant of seismometer applied to the trace (SH Info Entry R026) (e.g. STS-2: 0.6667 (nm/s)/bit)

Record(k).file.path=fpath; 	% Path of Q-File
Record(k).file.name=filename;	% Name of Q-File  

Record(k).deconv = deconv;   % Time series is deconvolved (1) oder not (0). Unknown = NaN.
Record(k).demean = demean;   % Constant mean value (offset) of time series is removed (1) or not (0). Unknown = NaN.
Record(k).detrend =  trend;  % Linear trend in time series is removed (1) or not (0). Unknown = NaN.

Record(k).processinghistory.operation='readqfile';
Record(k).processinghistory.comment='function readqfile2struct';
Record(k).processinghistory.timestamp=now;

end

%==========================================================================

if isnan(selectedtraces)==0

numselectedtraces=length(selectedtraces);

for t=1:numselectedtraces
newRecord(t)=Record(selectedtraces(t));
%startelement(t)=Record(selectedtraces(t)).lnull;
startelement(t)=lnull(selectedtraces(t));
elements(t)=Record(selectedtraces(t)).npts;
end
end
% selects starting elements and lengths of selected traces

%==========================================================================
%------ trace reading ------

if withtraces==1

binfile = strcat(filename,'.QBN');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% identifier of file endian!
%%
%% ATTENTION:
%%
%% old SH versions are working with BIG Endian Q-files
%% but newer versions with little Endian Q-Files!!
%% check your Q-Files if problems occour!!


%endian = 'big';
% see input arguments

if strcmp(endian,'big')
  fid = fopen(binfile,'r','ieee-be');
elseif strcmp(endian,'lil')
  fid = fopen(binfile,'r','ieee-le');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isnan(selectedtraces)==0
%% read selected traces
	for t=1:numselectedtraces
	fseek(fid,(startelement(t)*4),'bof');
	% factor 4 is dependent to file precision single
	newRecord(t).trace=fread(fid,elements(t),'single');  
	end

else
%% read all traces
	ntraces=length(npts);
	for jj=1:ntraces
    	Record(jj).trace=fread(fid,npts(jj),'single');
	end
end


fclose(fid);

end

if isnan(selectedtraces)==0
Record=newRecord;
end

clear newRecord


for k=1:length(Record)
        if (length(Record(k).trace)~=Record(k).npts) && (withtraces==1)
        disp(' ')
        disp(' ')
        disp(['Trace ' int2str(k) ' in struct has ' int2str(length(Record(k).trace)) ' samples but should have ' int2str(Record(k).npts) ' samples as defined in file header!'])
        disp([Record(k).staname ' ' Record(k).comp ' ' Record(k).t0trace])
        disp(' ')
        end
        
    Record(k).npts=length(Record(k).trace);
end
  
  if withtraces==1
  
  endiantest=getintervals(demeandata(Record(1)));
  rec1=getintervals(Record(1));
  
	if mean(endiantest.peakfactor)>1000 || prod(endiantest.peakfactor)==0 || max(abs(endiantest.interval99))<10^-30 || isnan(mean(endiantest.peakfactor)) || isnan(mean(endiantest.interval68))
	disp(' ')
	disp('################################################################################')
	disp(' ')
	disp('Please check endian of file!!!!')
	disp(' ')
	figure();plot(Record(1).trace)
	xlabel('Sample');
	ylabel('Sample Value')
	title([binfile ': ' endiantest.staname ' ' endiantest.comp ' ' endiantest.t0trace])
	disp(' ')
	disp([binfile ': ' endiantest.staname ' ' endiantest.comp ' ' endiantest.t0trace])
	disp(' ')
	disp(['68% interval: ' num2str(rec1.interval68)])
	disp(['95% interval: ' num2str(rec1.interval95)])
	disp(['99% interval: ' num2str(rec1.interval99)])
	disp(' ')
	disp(['Peakfactor: ' num2str(round(mean(rec1.peakfactor)))])
	disp(' ')
	%Record=0;
	disp(' ')
	disp('Please check endian of file!!!!')
	disp(' ')
	disp(' ')
	disp('################################################################################')
	disp(' ')
	return	
	end

  end
  
  
%==========================================================================
%CODE END OF FUNCTION readqfile2struct
%==========================================================================
