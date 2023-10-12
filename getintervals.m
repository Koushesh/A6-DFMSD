 function instruct=getintervals(instruct)

% created 2008-08-20
% Version 2009-01-14

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

for k=1:length(instruct)

perc=0.6827;
instruct(k).interval68=quantile(instruct(k).trace,[(1-perc)/2 perc+((1-perc)/2)]);

perc=0.9545;
instruct(k).interval95=quantile(instruct(k).trace,[(1-perc)/2 perc+((1-perc)/2)]);

perc=0.9973;
instruct(k).interval99=quantile(instruct(k).trace,[(1-perc)/2 perc+((1-perc)/2)]);

instruct(k).interval100=[min(instruct(k).trace) max(instruct(k).trace)];

instruct(k).standarddeviation=std(instruct(k).trace);

%%%%%%%%%%%%%%%%%%%%%%%%%%%

instruct(k).peakfactor=instruct(k).interval99./instruct(k).interval95;
instruct(k).sigma2=instruct(k).interval95./instruct(k).interval68;
instruct(k).sigma3=instruct(k).interval99./instruct(k).interval68;

%%%%%%%%%%%%%%%%%%%%%%%%%%%

instruct(k).sigma1deviation=((abs(instruct(k).interval68)./instruct(k).standarddeviation)-1)*100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
