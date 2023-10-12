function instruct=demeandata(instruct)
%
% The function demeandata() removes the mean of the given time series!
%
%
% usage: tsstruct=demeandata(tsstruct)
% 
% tsstruct: KaSoP time series struct (tsstruct=get_struct_timeseries()) with one or several time series
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
%
% #########################################################################################################
%
% Main author: Joern Groos (joern.groos@kit.edu)
%
%  created: 2008 -JG-
%
% modified: 2008-08-22 -JG-
% modified: 2009-11-16 -JG- (Documentation, License)
%
% #########################################################################################################
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% begin of function
%




if ~isfield(instruct,'processinghistory')
instruct=checkstruct(instruct);
end

for k=1:length(instruct)

rmean=mean(instruct(k).trace);

if isfield(instruct,'removedmean')
instruct(k).removedmean=rmean+instruct(k).removedmean;
else
instruct(k).removedmean=rmean;
end

instruct(k).trace=detrend(instruct(k).trace,'constant');

instruct(k).demean=1;

%%%
instruct(k).processinghistory(end+1).operation=['Mean removed ( ' num2str(rmean) ')'];
instruct(k).processinghistory(end).domain='time domain';
instruct(k).processinghistory(end).comment=' function demeandata';
instruct(k).processinghistory(end).timestamp=now;
	
end
