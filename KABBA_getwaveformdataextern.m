function outstruct = KABBA_getwaveformdataextern(networkin, stationin, locationin, channelin, sdn_start, sdn_end, ... % necessary
                                           varargin)
% This function reads the arclink archives stored in BASEFOLDER and gives
% the user a KaSP timeseries struct with the corresponding data
%
% The mean is removed and missing data is zeropadded!
%
% any2matlab NECESSARY!
%
% Necessary input:
% networkin:        network name (string, e.g. 'KB')
% stationin:        station name (string, e.g. 'TMO07')
% locationin:       location name (string, e.g. '00' or '10') %KABBA default is '00' for channels 1-3 and '10' for channels 4-6!
% channelin:        channel name (string, e.g. 'HHZ')
% sdn_start:        start time (serial date num, e.g. 733621 or datenum('20080801_00:00','yyyymmdd_HH:MM')
% sdn_end:          end time (serial date num, e.g. 733627 or datenum('20080807_00:00','yyyymmdd_HH:MM')
%
%
% Optional (varargin):
% '-sp',SEEDcalibpath:    Path to seedcalib folder. Don't set or set 'std' for
%                         standard folder (defined in seedcalib_count2groundmotiondata.m)
% '-dp',DataPath:         Alternative path for data (e.g. real-time data in /data7/KABBA_archive_NRT_gpimag1
%
% e.g.: KABBA_getwaveformdata('KB','TMO07','00','HHZ',733621,733627,'-dp','/data7/KABBA_archive_NRT_gpimag1')
%
% This function/program is part of the KaSoP toolbox and free software under the GNU GPL licencse!
%
% #####################################################################################################
%

%##########################################################################################################
%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
%#%													 %#
%#%   Copyright (c) 2011 by the KaSP-Team.								 %#
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
% Main author: Johannes Thun (johannes.thun@student.kit.edu)
%
%  created: 2011-05-10 -JT-
% modified: 2011-05-16 -JT- (substituted directory change by direct file access)
% modified: 2011-10-17 -JG- (added locationin arguement)
% modified: 2011-10-26 -JG- (seedcalib_count2groundmotiondata is now applied already to the still fragmented time series obtained from the miniSEED file)
% modified: 2011-10-26 -JG- (included user information to avoid inefficient data requests)
% modified: 2012-07-20 -JG- (now using seismic handler sensitivities.txt file instead of the old seedcalib_ files)
% modifies: 2016-05-19 -TZ- (calculate count2groundmotion from extern data)
%
% #########################################################################################################
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% begin of function
%

if nargin==5 || nargin==7
	outstruct=0;
	disp('ATTENTION! Input of KABBA_getwaveformdata changed!! Now also the location is needed!!')
	disp(' e.g.: KABBA_getwaveformdata(''KB'',''TMO07'',''00'',''HHZ'',733621,733627,''-dp'',''/data7/KABBA_archive_NRT_gpimag1'')')
	return
end


% Set standard arclink server folder here
BASEFOLDER = '/data7/KABBA_archive_SDS';
%BASEFOLDER = '/data7/KABBA_archive_NRT_gpimag1';
ORIGINAL_FOLDER = pwd;


SEEDcalibpath = 'std';
%SEEDcalibpath = '/home/jgross/daten/03_KABBA/00_KABBA_DataCenter_configuration/SeismicHandler_metadata/SeismicHandler_SEEDcalib_KABBA/'


% Checking optional Input
if nargin > 6 % optional args are given                                                                                     
    for k=1:length(varargin)-1
        if ischar(varargin{k}) && strcmp(varargin{k}(1),'-')
            argname  = varargin{k}(2:end);
            argvalue = varargin{k+1};                                                                                                                   
	    
            switch argname
                case 'sp'
                    if ischar(argvalue) && (exist(argvalue,'file') == 7 || strcmp(argvalue,'std'))
	                disp(['Using SEEDcalib path ' argvalue ' ...'])
		        SEEDcalibpath = argvalue;	
		    else
		        disp('Invalid SEEDcalib path! Quitting.')
		        return
		    end

	        case 'dp'
	            if ischar(argvalue) && exist(argvalue,'file') == 7
	                disp(['Using data path ' argvalue ' ...'])
		        BASEFOLDER = argvalue;
		    else
		        disp('Invalid data path! Quitting.')
		        return
		    end
       
	        otherwise
	            disp(['Unknown parameter ' argname '! Skipping.'])
	            continue
		
            end %switch
        end %if
    end %for
end %if


% Separating time window into whole days
day_start = floor(sdn_start);
day_end   = floor(sdn_end);

if mod(sdn_end,1)==0
   disp(' ')
   disp(' ')
   disp('ATTENTION! This is an inefficient way to request data daywise!')
   disp('Request data to 23:59:59.990 to avoid unnecessary loading of miniSEED dayfiles!')
   beep
   pause(5)
   disp(' ')
   disp(' ')
end

sdn_singledays = day_start:day_end;

outstruct = [];

for k=1:length(sdn_singledays)
    
    % Getting strings for actual year and julian day
    DATE_YEAR = datestr(sdn_singledays(k),'yyyy');
    DATE_JULIANDAY = floor(sdn_singledays(k) - datenum(DATE_YEAR,'yyyy'))+1;
    
    % Getting folder name as it should be in arclink format
    datafoldername = [BASEFOLDER filesep DATE_YEAR filesep networkin filesep stationin filesep channelin '.D'];
    
    DATA_AVAILABLE = 1;

    if exist(datafoldername,'file')==7
        % Getting file name as it should be in arclink format
        datafilename = dir([datafoldername filesep networkin '.' stationin '.' locationin '.' channelin '.D.' num2str(DATE_YEAR) '.' num2str(DATE_JULIANDAY,'%03d')]);

        if isempty(datafilename)
            DATA_AVAILABLE = 0;
        end
    else
        DATA_AVAILABLE = 0;
    end

    
    
    if DATA_AVAILABLE
        
        datafile = [datafoldername filesep datafilename(1).name];
        
        disp(['Reading ' datafilename(1).name ' ...'])
        
        % Reading in the data file if available
        newdata = any2matlab(datafile,'mseed:estimateNframes');%  newdata = any2matlab(datafile,'mseed:skipcheck=all');     
        outstruct = [outstruct any2kasp(newdata)]; %#ok<AGROW>
                
        disp('done.')
    
    else
        
        disp(['No data found for day ' datestr(sdn_singledays(k),'dd-mm-yyyy')])
        %outstruct = [];
    end

end %for k=1:length(sdn_singledays)
    

if ~isempty(outstruct)
    % Cutting data (also adding zeros if needed)
    outstruct = sensitivities_count2groundmotiondata(outstruct,SEEDcalibpath);
	
    units=unique({outstruct.unit});
    % only one unit (unknown OR count OR nm/s) should exist!
    
    disp('Removing mean from data...')
    outstruct=demeandata(outstruct);
    outstruct=rmfield(outstruct,'removedmean');
    % the mean is remove due to problems which may occur by connecting
    % fragmented time series with zero padded data gaps due to maybe present offsets
    
    if length(units)==1
       
        % Check if sampling rate changes in the given time period
        if  length(unique([outstruct.delta])) ~= 1

            % set sampling rate to the lowest rate in the given time period
            resampleinfo.dt = max([outstruct.delta]);          
            resampleinfo.timeolddt = NaN;
            resampleinfo.timenewdt = NaN;
            resampleinfo.method = 'linear';

            outstruct = resampledata(outstruct, resampleinfo);

            disp(['Data was resampled to ' num2str(1/resampleinfo.dt) ' samples/sec.']);
        end
        
        outstruct = connecttracesdata(outstruct,sdn_start,sdn_end);
        % the time series fragments have all the same unit an can be
        % connected!
    	outstruct = checkstruct(outstruct);
    	outstruct.location=locationin;
    	outstruct.network=networkin;
    else
        outstruct=[];
        disp(['Error: Partly missing calib information for ' networkin ' _ ' stationin '-' channelin ' - ' datestr(sdn_start,'dd-mmm-yyyy HH:MM:SS') ' - ' datestr(sdn_end,'dd-mmm-yyyy HH:MM:SS')])
        disp('Report to KABBA DMC staff to fix this PROBLEM!')
    end


    
else
    disp(['Error: No data found for ' networkin ' _ ' stationin '-' channelin ' - ' datestr(sdn_start,'dd-mmm-yyyy HH:MM:SS') ' - ' datestr(sdn_end,'dd-mmm-yyyy HH:MM:SS')])
end
    
    
    
% Returning to initial folder
cd(ORIGINAL_FOLDER);

end
