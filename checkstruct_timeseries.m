function Record=checkstruct_timeseries(Record)
%
%
% function Record=checkstruct_timeseries(Record)
%
%
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





% Author: Joern Groos
%
% Geophysical Institute
% Universitaet Karlsruhe (TH)
% Germany
%
% joern.groos@gpi.uni-karlsruhe.de
%
%       created: 
%      modified: 2009-04-29
%
%      VERSION: 2009-05-27
%      modified: 2011-02-04 (Added handling of fields time_seconds and
%      time_serialnumber
%
% See Documentation below!!
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isfield(Record,'processinghistory') || isfield(Record,'kcomp')
Record=updatetimeseriesstruct(Record);
end

%%%%%%%%%%%%%%%%%%%

original_fieldnames_order=Record(1);
    if isfield(Record,'trace')
    original_fieldnames_order.trace=0;
    end
% this helps to keept the order of fieldnames (without deleted old fields), see the end of this function!
%%%%%%%%%%%%%%%%%%%%

if isfield(Record,'trace')
    oldfilters=removetracedata(Record);
else
    oldfilters=Record;
end

Record=rmfield(Record,'filters');

numtraces=length(Record);

for k=1:numtraces

if isfield(Record,'trace')
	if length(Record(k).trace)>1
        Record(k).npts=length(Record(k).trace);
	end
end

%%%%%%%%%%%%%%%%%%%%

Record(k).filters=checkstruct_filterinfo(oldfilters(k).filters);

%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%% Starttime of Trace

Record(k).t0trace = datestr(Record(k).tsn,'dd-mmm-yyyy_HH:MM:SS.FFF');

Record(k).staname=strrep(Record(k).staname,' ','');
% removes blanks from stationname


[traceyr,tracemon,traceday,tracehr,tracemin,tracesec]=time2num(Record(k).tsn,0.001);

recdatvec=[traceyr tracemon traceday tracehr tracemin tracesec];

tracejulianday=dm2jd(recdatvec(3),recdatvec(2),recdatvec(1));


Record(k).tdate=recdatvec;
% date vector with start times of trace

Record(k).tracejulianday = tracejulianday; % Julian Day of starting date

%%%%%%%%%%%%%%%%%%%% Eventtime

if isnan(Record(k).esn)==0

Record(k).t0event = datestr(Record(k).esn,'dd-mmm-yyyy_HH:MM:SS.FFF');             % Focal time of Event as text string in SeismicHandler format

[traceyr,tracemon,traceday,tracehr,tracemin,tracesec]=time2num(Record(k).esn,0.001);

recdatvec=[traceyr tracemon traceday tracehr tracemin tracesec];


Record(k).eventjulianday=dm2jd(recdatvec(3),recdatvec(2),recdatvec(1));

Record(k).edate = recdatvec;                 % Date vector of Focal time of Event [year month day hour minute seconds]
                     
Record(k).evt0=round(etime(Record(k).edate,Record(k).tdate)/Record(k).delta).*Record(k).delta;                     
% Difference between Focal time and starting time of time series in seconds
% If the time series is starting before the focal time, evt0 is positive!

else
eventyr(k)=NaN;
eventmon(k)=NaN;
eventday(k)=NaN;
eventhr(k)=NaN;
eventmin(k)=NaN;
eventsec(k)=NaN;
eventjulianday(k)=NaN;
esn(k)=NaN;
% if no eventtime is specified (eventtime=NaN), all details are also NaN
edate(k,:)=[NaN NaN NaN NaN NaN NaN];
evt0(k)=NaN;
end

end %for k=1:numtraces
 

if isfield(Record,'time_seconds')
    Record=get_timeseries_time_seconds(Record);
end

if isfield(Record,'time_serialnumber')
    Record=get_timeseries_time_serialnumber(Record);   
end



 Record=orderfields(Record,original_fieldnames_order);
 % This ensures that the output struct has the same order of fieldnames than
 % the input struct (of course without maybe deleted old fields!)
 
return
