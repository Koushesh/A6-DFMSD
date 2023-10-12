function instruct = i_noMessTDN_BHE_sensitivities_count2groundmotiondata(instruct,varargin)

% in line 114 there is a message that is muted for specific no-needed
% calibrated-wave-value-case. this is the only change relative to its
% mother version. Mohsen 2018 September.
%
% This function converts KaSP time series structs from unit counts to nm/s
% using seedcalib-files found in folder specified by seedcalib_folder
% or optionally given as function argument
%
%
% This function/program is part of the KaSoP/Metseis toolbox and free software under the GNU licencse!
%
% #####################################################################################################
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
% Main author: Johannes Thun (johannes.thun@student.kit.edu)
%
%  created: 2011-05-06 -JT-
% modified: 2011-05-16 -JT- (changed unit set behaviour)
% modified: 2015-04-01 -MG- (value of timeseries struct field "calib" is set to zero if no calibration factor is available in sensitivity file)
%
% TODO: Use different calib factors in one single trace
%
% #########################################################################################################
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% begin of function
%


%PARAMETERS

seedcalib_folder_std = '/usr/local/sh_feb2011/inputs';
sdnps = 1/(24*60*60);



if ~isfield(instruct,'processinghistory')
    instruct=checkstruct(instruct);
end


% Checking input
if (nargin==1) || ~ischar(varargin{1}) || strcmp(varargin{1},'std')
    seedcalib_folder = seedcalib_folder_std;
else
    seedcalib_folder = varargin{1};
    if strcmp(seedcalib_folder(end),'/')
        seedcalib_folder = seedcalib_folder(1:end-1);
    end
    disp(' ')
    disp(['Using given path to sensitivities.txt file: ' seedcalib_folder ])
    disp(' ') 
end
% %i did----->
% if exist(seedcalib_folder,'file')~=7
%     seedcalib_folder = input('sensitivities.txt folder not found. Give path: ','s');
% end
% %--------<
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calibfname = [seedcalib_folder filesep 'sensitivities.txt'];

        if exist(calibfname,'file')~=2
            disp(['No sensitivities.txt file found! Leaving data in counts.']);
            pause(10)
            sensitivities=[];

        else
            
            sensitivities=read_SH_sensitivities(calibfname);
            
        end


if ~isempty(sensitivities)

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for k=1:length(instruct)
        
        calibfactor=[];
    
        if ~strcmp(instruct(k).unit,'unknown') && ~strcmp(instruct(k).unit,'count')
            disp(['Trace #' num2str(k) '/' num2str(length(instruct)) ' '  instruct(k).staname '.' instruct(k).channel ' not in counts. Skipping.'])
            instruct(k).calib = 0;
            continue
        end
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        sensitivities_station=sensitivities(find(strcmp({sensitivities.staname},instruct(k).staname)));
        
        if isempty(sensitivities_station)
%             disp(['No calib information found for station ' instruct(k).staname ' in sensitivities-file. Leaving data in counts.']);
            instruct(k).calib = 0;
            continue
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        sensitivities_station=analyse_sensitivities_infoentry(sensitivities_station);
        % get serial date number from sensitivities.txt time strings
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Checking if time period of interest is in calib data
        tracestart = instruct(k).tsn;
        traceend   = tracestart + sdnps*instruct(k).delta*(instruct(k).npts-1);
    
        for l=1:length(sensitivities_station)
            if tracestart >= sensitivities_station(l).sdn_start && traceend <= sensitivities_station(l).sdn_end
                sensitivities_station(l).timematch = 1;
            else
                sensitivities_station(l).timematch = 0;
            end
        end
    
        sensitivities_station_time=sensitivities_station(find([sensitivities_station.timematch]));
        
        if isempty(sensitivities_station_time)
            disp(['No calib information found for station ' instruct(k).staname ' for time span ' datestr(tracestart,'yyyy-mm-dd HH:MM:SS') '-' datestr(traceend,'yyyy-mm-dd HH:MM:SS')  ' in sensitivities-file. Leaving data in counts.']);
            instruct(k).calib = 0;
            continue
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        sensitivities_station_time_channel=sensitivities_station_time(find(strcmp({sensitivities_station_time.channel2D},instruct(k).channel(1:2))));
                  
        if isempty(sensitivities_station_time_channel)
            disp(['No calib information found for station.channel ' instruct(k).staname '.' instruct(k).channel(1:2) ' in sensitivities-file. Leaving data in counts.']);
            instruct(k).calib = 0;
            continue
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if [length(sensitivities_station_time_channel)==1] && strcmp(sensitivities_station_time_channel(1).comp,'?')
            
            calibfactor=sensitivities_station_time_channel.calibfactor;
            
        else
            
            sensitivities_station_time_channel_comp=sensitivities_station_time_channel(find(strcmp({sensitivities_station_time_channel.comp},instruct(k).comp)));
            
            if isempty(sensitivities_station_time_channel_comp)
                disp(['No calib information found for station.channel.comp ' instruct(k).staname '.' instruct(k).channel(1:2) '.' instruct(k).comp ' in sensitivities-file. Leaving data in counts.']);
                instruct(k).calib = 0;
                continue
            else
                if length(sensitivities_station_time_channel_comp)==1
                    calibfactor=sensitivities_station_time_channel_comp.calibfactor;
                else
                    disp(['ERROR: Found more than one calib information for station.channel.comp ' instruct(k).staname '.' instruct(k).channel(1:2) '.' instruct(k).comp ' '  datestr(tracestart,'yyyy-mm-dd HH:MM:SS') '-' datestr(traceend,'yyyy-mm-dd HH:MM:SS')  ' in sensitivities-file. Leaving data in counts.']);
                    instruct(k).calib = 0;
                    continue
                end
            end
        end
        
    
        if isempty(calibfactor)
            disp(['No calibration factor found for station' instruct(k).staname ' ' instruct(k).channel ...
                ' for desired time window (' datestr(tracestart) ' - ' datestr(traceend)])
            instruct(k).calib = 0;
            continue
        end
    
        % multiplying factor to trace & changing unit fields
        instruct(k).trace  = instruct(k).trace * calibfactor;
        instruct(k).unit   = 'nm/s';
        instruct(k).unitid = 2;
        instruct(k).calib = 1;
        %disp(['multiplying sensitivity ' num2str(calibfactor,'%06.4f') ' (nm/s)/count to '  instruct(k).staname '.' instruct(k).channel(1:2) instruct(k).comp ': '  datestr(tracestart,'yyyy-mm-dd HH:MM:SS') ' -> ' datestr(traceend,'yyyy-mm-dd HH:MM:SS')])
        %%%
        instruct(k).processinghistory(end+1).operation='Converted from counts (NaN) to ground motion (nm/s) from SH sensitivities.txt';
        instruct(k).processinghistory(end).domain='time domain';
        instruct(k).processinghistory(end).comment=['Factor: ' num2str(calibfactor) '  sensitivities-file: ' calibfname];
        instruct(k).processinghistory(end).timestamp=now;
        
    end


end %if ~isempty(sensitivities)







%################################################################################################################################

function serialdatenum = getstringdatenum(datestring)
    
    % this function tries to get the datenum from date strings with
    % different formats


    % trying to identify string format

    stringlength = length(datestring);

	if stringlength<4
		if strcmp(datestring,'.') || strcmp(datestring,'..') || strcmp(datestring,'...')
			serialdatenum=NaN;
			return
		end
	end

    switch stringlength

        case {10 , 11}
            formatstring = 'dd-mmm-yyyy';
            
        case {16, 17}
            formatstring = 'dd-mmm-yyyy_HH:MM';
            
        case {20}
            formatstring = 'dd-mmm-yyyy_HH:MM:SS';
            
        case {21, 22}
            datestring   = [datestring '00'];
            formatstring = 'dd-mmm-yyyy_HH:MM:SS.FFF';
            
        case {24}
            formatstring = 'dd-mmm-yyyy_HH:MM:SS.FFF';
            
        otherwise    %unknown format: getting input from user
            formatstring=input(['Unknown date format (' datestring ') enter format string: '],'s');
    end
    
    
    % trying to get date number - on error user input asked
    
    successful = 0;
    
    while successful == 0;
        
        try
            serialdatenum = datenum(datestring,formatstring);
            successful = 1;
        catch %#ok<CTCH>
            formatstring=input(['Unknown date format (' datestring ') enter format string: '],'s');
        end
        
    end
    
return


function sensitivities=analyse_sensitivities_infoentry(sensitivities)


for k=1:length(sensitivities)


	sensitivities(k).sdn_start=getstringdatenum(sensitivities(k).string_start);
	if isnan(sensitivities(k).sdn_start)
		sensitivities(k).sdn_start=0;
	end

	sensitivities(k).sdn_end=getstringdatenum(sensitivities(k).string_end);
	if isnan(sensitivities(k).sdn_end)
		sensitivities(k).sdn_end=datenum([2100 1 1 0 0 0]);
    end
    
	vec_start=datevec(sensitivities(k).sdn_start);
	sensitivities(k).JD_start=dm2jd(vec_start(3),vec_start(2),vec_start(1));
    
	vec_end=datevec(sensitivities(k).sdn_end);
	sensitivities(k).JD_end=dm2jd(vec_end(3),vec_end(2),vec_end(1));

end

return























