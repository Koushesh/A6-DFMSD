function Record=get_struct_timeseries()

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
k=1;

%
% Joern Groos, 2008-10-30
%
% 2010-12-21 Added the missing fields ponset and sonset for the p and s onset times 
%
% This script produces an empty time series datastruct for testing!
% The trace can be overwritten with synthetic test signals or whatever you want!
%
% If you change the trace or the trace start time (.tsn) use the function checkstruct
% to correct all other depending entries!
%



Record(k).delta = 0.01;	% sampling rate of time series in seconds

Record(k).npts  = 100;	% Number of samples (points) (also O. Sebe)

Record(k).trace=zeros(Record(k).npts,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).unit = 'unknown';		% Text string with information about time series unit (e.g. nm/s, count, etc.)
Record(k).unitid=NaN;        % Number indentifying common seismological time series units (0:= counts; 1:=nm/(s*s); 2:= nm/s; 3:=nm; NaN:=other).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Record(k).network='NaN';
Record(k).location='NaN';
Record(k).channel='NaN';       % ID of DATA STREAM/CHANNEL
Record(k).comp = 'A';      % component of time series: Z, N, E, R, T

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).tsn = now;         % PRIMARY INFORMATION! Serial Time of Starttime, all other trace time information depend on this!

Record(k).t0trace = 'NaN';               % Starting time of time series as text string in SeismicHandler format
                                              % (dd-mm-yyyy_HH:MM:SS.FFF, e.g. 22-JAN-2003_02:15:30.000)
Record(k).tracejulianday = NaN; % Julian Day of starting date

Record(k).tdate = [NaN NaN NaN NaN NaN NaN];   % Date vector of starting time of time series [year month day hour minute seconds]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).staname = 'TEST'; % Station name      (also O. Sebe)
Record(k).slat = NaN;           % Station Latitude in degrees  (also O. Sebe)
Record(k).slon = NaN;           % Station Longitude in degrees (also O. Sebe)
Record(k).salt = NaN;           % Station Altitude  (also O. Sebe)
Record(k).sdep = NaN;		% Station Depth     (also O. Sebe)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).comment = 'NOCOMMENT';	% Comment concering time series (equals comment of SeismicHandler)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).esn = NaN;                          % PRIMARY INFORMATION! Serial Time of Eventtime, all other eventtime information depend on this!

Record(k).evname = NaN;		% Event Name        (also O. Sebe)
Record(k).elat = NaN;	% Event Latitude in degrees    (also O. Sebe)
Record(k).elon = NaN;	% Event Longitude in degrees   (also O. Sebe)
Record(k).ealt = NaN;		% Event Altitude    (also O. Sebe)
Record(k).edep = NaN;	% Event Depth       (also O. Sebe)
Record(k).emag = NaN;	% Event Magnitude   (also O. Sebe)

Record(k).t0event = NaN;             % Focal time of Event as text string in SeismicHandler format
Record(k).eventjulianday = NaN; % Julian Day of Focal time

Record(k).edate = NaN;                 % Date vector of Focal time of Event [year month day hour minute seconds]

Record(k).evt0 = NaN;                     % Difference between Focal time and starting time of time series in seconds
                                              % If the time series is starting before the focal time, evt0 is positive!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).ponset=NaN;                      % P-Onset as serial date number

Record(k).sonset=NaN;      


Record(k).distrad = NaN;                      % Distance between event and station in distance radians
Record(k).distkm = NaN; % Distance between event and station in km               (also O. Sebe)
Record(k).distdeg = NaN;                            % Distance between event and station in distance degrees

Record(k).azdeg = NaN;                % Azimuth (Event to Station) against North in degrees
Record(k).azrad = NaN;                % Azimuth (Event to Station) against North in radians

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).bazdeg = NaN;          % Backazimuth (Station to Event) against North in degrees						        
Record(k).bazrad = NaN; % Backazimuth (Station to Event) against North in radians						         

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).filters=get_struct_filterinfo;  % A struct is stored with all apllied filters (hp,lp,bp,bs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).processinghistory=get_struct_processinghistory;

Record(k).processinghistory.operation='get_struct_timeseries';
Record(k).processinghistory.timestamp=now;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).calib = 1;    % Calibration Constant (bit to ground motion unit, see above) of seismometer applied to the trace (e.g. SH Info Entry R026) (e.g. STS-2: 0.6667 (nm/s)/bit)
                        % only some kind of historic but unreliabel information! no function!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).file.path='NaN';
Record(k).file.name='NaN';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record(k).deconv = 0;   % Time series is deconvolved (1) oder not (0). Unknown = NaN.
Record(k).demean = 0;   % Constant mean value (offset) of time series is removed (1) or not (0). Unknown = NaN.
Record(k).detrend =  0;  % Linear trend in time series is removed (1) or not (0). Unknown = NaN. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Record=checkstruct(Record);

return
