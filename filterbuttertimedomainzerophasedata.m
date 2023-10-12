function instruct=filterbuttertimedomainzerophasedata(instruct,filterinfo)
%
%
% usage: tsstruct=filterbuttertimedomainzerophasedata(tsstruct,filterinfo)
%
%
% This functions applies the filters given in 'filterinfo' (see below) to all time series
% given in 'tsstruct' in the TIME DOMAIN!
%
% Every filter is applied forward and reverse to obtain an effective zero-phase filter.
% The order of the effective filter is therefore 2 times the order of the filter given in filterinfo!!
%
%
% tsstruct: KaSoP time series struct (tsstruct=get_struct_timeseries()) with one or several time series
% 
% filterinfo:	filter info struct of the KaSoP-ToolBox!
%
% e.g.: filterinfo=get_struct_filterinfo();
%
% A valid filter info struct is:
%
%
% k=1;
% filterinfo(k).type='bandpass';	% string (bandpass, high or low, see also documentation of MATLAB-Function 'butter'
% filterinfo(k).order=2;		% integer value >0. The filter information is rejected if this value is zero or NaN!
% filterinfo(k).Fhz=[0.1 0.5];		% corner frequencies in Hz
%
% k=2;
% filterinfo(k).type='high';
% filterinfo(k).order=2;
% filterinfo(k).Fhz=[0.02 NaN]; 	% in Hz, the upper (low-pass) corner frequency is NaN!
%
% k=3;
% filterinfo(k).type='low';
% filterinfo(k).order=2;
% filterinfo(k).Fhz=[NaN 0.7];		% in Hz, the lower (high-pass) corner frequency is NaN!
%
%
%
% This function/program is part of the KaSoP toolbox and free software under the GNU licencse!
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

% #########################################################################################################
%
% Main author: Joern Groos (joern.groos@kit.edu)
%
%
%       created: 2008 -JG-
%
%      modified: 2009-04-29 -JG-
%      modified: 2009-05-27 -JG-
%      modified: 2009-11-16 -JG- (Documentation, License)
%
%
% #########################################################################################################
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% begin of function
%


filterinfo=checkstruct_filterinfo(filterinfo);
% checks filterinfo to be a valid struct with filter information


if (~isfield(instruct,'processinghistory')) || (isfield(instruct(1).filters(1),'Wn')) || (~isfield(instruct(1).filters(1),'Fhz'))
instruct=checkstruct(instruct);
end


if (filterinfo(1).order==0) || isnan(filterinfo(1).order)
instruct=0;
disp('No valid filter information. Please check filterinfo-struct!')
return
end

numfilters=length(filterinfo);

for y=1:numfilters


	for k=1:length(instruct)
	clear b a
	
		if strcmp(filterinfo(y).type,'bandpass')
		[b,a]=butter(filterinfo(y).order,filterinfo(y).Fhz.*(2*instruct(k).delta),filterinfo(y).type);
		% determination of digital butterworth iir filter with prewarpning for time domain filtering
		end

		if strcmp(filterinfo(y).type,'stop')
		[b,a]=butter(filterinfo(y).order,filterinfo(y).Fhz.*(2*instruct(k).delta),filterinfo(y).type);
		% determination of analog butterworth iir filter
		end


		if strcmp(filterinfo(y).type,'high')
		[b,a]=butter(filterinfo(y).order,filterinfo(y).Fhz(1).*(2*instruct(k).delta),filterinfo(y).type);
		% determination of digital butterworth iir filter with prewarpning for time domain filtering		
		end

		if strcmp(filterinfo(y).type,'low')
		[b,a]=butter(filterinfo(y).order,filterinfo(y).Fhz(end).*(2*instruct(k).delta),filterinfo(y).type);
		% determination of digital butterworth iir filter with prewarpning for time domain filtering		
		end	
		
	tstamp=now;
	
	instruct(k).trace=filtfilt(b,a,instruct(k).trace);
	% forward and reverse zero phase time domain filtering
	
	numappfilters=length(instruct(k).filters);
	
	if (instruct(k).filters(numappfilters).order==0) || isnan(instruct(k).filters(numappfilters).order)
	numappfilters=numappfilters-1;
	end
	
	instruct(k).filters(numappfilters+1).order=filterinfo(y).order;
	instruct(k).filters(numappfilters+1).Fhz=filterinfo(y).Fhz;
	instruct(k).filters(numappfilters+1).type=filterinfo(y).type;
	instruct(k).filters(numappfilters+1).direction='forward';
	instruct(k).filters(numappfilters+1).domain='time domain';
	instruct(k).filters(numappfilters+1).timestamp=tstamp;	

	instruct(k).filters(numappfilters+2).order=filterinfo(y).order;
	instruct(k).filters(numappfilters+2).Fhz=filterinfo(y).Fhz;
	instruct(k).filters(numappfilters+2).type=filterinfo(y).type;	
	instruct(k).filters(numappfilters+2).direction='reverse';
	instruct(k).filters(numappfilters+2).domain='time domain';
	instruct(k).filters(numappfilters+2).timestamp=tstamp;
	% Saving filterinformation in struct!

	%%%
	
	instruct(k).processinghistory(end+1).operation=['Filter Butterworth ' filterinfo(y).type ' [' num2str(filterinfo(y).Fhz(1)) ' ' num2str(filterinfo(y).Fhz(2)) '] Hz Order: ' int2str(filterinfo(y).order)];
	instruct(k).processinghistory(end).domain='time domain zero phase (forward)';
	instruct(k).processinghistory(end).comment=' function filterbuttertimedomainzerophasedata';
	instruct(k).processinghistory(end).timestamp=tstamp;

	instruct(k).processinghistory(end+1).operation=['Filter Butterworth ' filterinfo(y).type ' [' num2str(filterinfo(y).Fhz(1)) ' ' num2str(filterinfo(y).Fhz(2)) '] Hz Order: ' int2str(filterinfo(y).order)];
	instruct(k).processinghistory(end).domain='time domain zero phase (reverse)';
	instruct(k).processinghistory(end).comment=' function filterbuttertimedomainzerophasedata';
	instruct(k).processinghistory(end).timestamp=tstamp;	
	%%%


	end %for k=1:length(instruct): loop over all traces in struct

end %for y=1:numfilters: loop over all filters in filterinfo


for k=1:length(instruct)
instruct(k).filters=checkstruct_filterinfo(instruct(k).filters);
%checks filter information for all traces
end

return
