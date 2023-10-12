function instruct=detrenddata(instruct)
%
% The function detrenddata() removes the linear trend of the given time series!
%
%
% usage: tsstruct=detrenddata(tsstruct)
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
%#%   Copyright (c) 2009 by the KaSP-Team.								 %#
%#%   This file is part of the Karlsruhe Seismology Processing (KaSP) Toolbox for MATLAB!		 %#
%#%													 %#
%#%   The KaSP toolbox is free software under the terms of the GNU General Public License!		 %#
%#%													 %#
%#%   Please see the copyright/licensce notice distributed together with the KaSP Toolbox!		 %#
%#%													 %#
%#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
%##########################################################################################################

% #########################################################################################################
%
% Main author: Joern Groos (joern.groos@kit.edu)
%
%  created: 2008 -JG-
%
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
instruct(k).trace=detrend(instruct(k).trace);
instruct(k).detrend=1;

%%%
instruct(k).processinghistory(end+1).operation=['Linear Trend removed'];
instruct(k).processinghistory(end).domain='time domain';
instruct(k).processinghistory(end).comment=' function detrenddata';
instruct(k).processinghistory(end).timestamp=now;
	
end
