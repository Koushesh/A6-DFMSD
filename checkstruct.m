function Record=checkstruct(Record)
%
% function Record=checkstruct(Record)
%
% 
% This function calls the check-function corresponding to the
% struct given in 'Record'
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
%      modified: 2009-05-27
%
%      VERSION: 2009-06-02
%
% See Documentation below!!
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isfield(Record,'delta')
Record=checkstruct_timeseries(Record);
% Record is a time series struct
end

if isfield(Record,'order')
Record=checkstruct_filterinfo(Record);
% Record is a filterinfo struct
end

return
