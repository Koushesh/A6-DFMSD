function filterinfo=checkstruct_filterinfo(filterinfo)
%
% usage: filterinfo=checkstruct_filterinfo(filterinfo);
% 
% 
% This function checks the struct filterinfo to be a valid struct
% containing filter information for the SeisNoiseToolBox.
%
% Valid filter information are:
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
% If the field .Fhz is a scalar, the given value is used as upper or lower corner frequency
% regarding to the filter information given in field .type!
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%
% Author: Joern Groos
%
% Geophysical Institute
% Universitaet Karlsruhe (TH)
% Germany
%
% joern.groos@gpi.uni-karlsruhe.de
%
%       created: 2009-05-27
%
%      VERSION: 2009-05-27
%      VERSION: 2009-07-16 Added further error handling (handling of fieldnames .FHz and .fhz), corrected Error handling (added missing returns in lines 63, 69 and 75)
%
% See Documentation below!!
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

info=filterinfo;

clear filterinfo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~isfield(info,'order')
disp('No sufficient filter information - ORDER!')
filterinfo.order=0;
return
end

if ~isfield(info,'type')
disp('No sufficient filter information - TYPE!')
filterinfo.order=0;
return
end

if (~isfield(info,'Wn')) && (~isfield(info,'Fhz')) && (~isfield(info,'FHz')) && (~isfield(info,'fhz'))
disp('No sufficient filter information - Fhz!')
filterinfo.order=0;
return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (length(info)==1) && ((info.order==0) || isnan(info.order))
filterinfo=get_struct_filterinfo;
return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isfield(info,'Fhz') && isfield(info,'Wn')

disp(' ')
disp('Due to an inconsistency the field .Wn was changed to .Fhz in May 2009!')
disp('Your actual struct contains both fiels .Wn and .Fhz! The field .Wn is removed!')
disp('Please check that the information given in field .Fhz is correct!')
disp(' ')
disp('Please change also your programs for future usage! Sorry for the inconvenience!!')
disp(' ')

info=rmfield(info,'Wn');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isfield(info,'Fhz') && isfield(info,'FHz')

disp(' ')
disp('Field .FHz is removed. Only field .Fhz is used!')
disp(' ')

info=rmfield(info,'FHz');

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isfield(info,'Fhz') && isfield(info,'fhz')

disp(' ')
disp('Field .fhz is removed. Only field .Fhz is used!')
disp(' ')

info=rmfield(info,'fhz');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~isfield(info,'Fhz')


	if isfield(info,'Wn')
	disp(' ')
	disp('Due to an inconsistency the field .Wn was changed to .Fhz in May 2009!')
	disp('The actual field .Wn in your filterinfo-struct is changed now from .Wn')
	disp('to .Fhz, assuming that the quantities given in field .Wn are corner frequencies in Hz!!!')
	disp(' ')
	disp('Please change also your programs for future usage! Sorry for the inconvenience!!')
	disp(' ')

		for k=1:length(info)
		info(k).Fhz=info(k).Wn;	
		end

	info=rmfield(info,'Wn');
		
	end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~isfield(info,'Fhz')


	if isfield(info,'FHz')
	disp(' ')
	disp('Changed field .FHz to .Fhz! Please use .Fhz as fieldname!')
	disp(' ')

		for k=1:length(info)
		info(k).Fhz=info(k).FHz;	
		end

	info=rmfield(info,'FHz');
		
	end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~isfield(info,'Fhz')


	if isfield(info,'fhz')
	disp(' ')
	disp('Changed field .fhz to .Fhz! Please use .Fhz as fieldname!')
	disp(' ')

		for k=1:length(info)
		info(k).Fhz=info(k).fhz;	
		end

	info=rmfield(info,'fhz');
		
	end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for k=1:length(info)

	if ~strcmp(info(k).type,'bandpass') && ~strcmp(info(k).type,'high') && ~strcmp(info(k).type,'low') && ~strcmp(info(k).type,'stop')
	disp(['Unknown filter type -> filterinfo #' int2str(k) ' is rejected!'])
	info(k).order=0;
	info(k)
	end

end %for k=1:length(info)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for k=1:length(info)

	if info(k).order>0


	if strcmp(info(k).type,'bandpass')
		if (length(info(k).Fhz)~=2) || (sum(isnan(info(k).Fhz))>0)
		disp(['Inconsistent Corner Frequencies -> filterinfo #' int2str(k) ' is rejected!'])
		info(k).order=0;
		info(k)
		end
    end
    
    if strcmp(info(k).type,'stop')
		if (length(info(k).Fhz)~=2) || (sum(isnan(info(k).Fhz))>0)
		disp(['Inconsistent Corner Frequencies -> filterinfo #' int2str(k) ' is rejected!'])
		info(k).order=0;
		info(k)
		end
	end
    

	if strcmp(info(k).type,'high')
		if (length(info(k).Fhz)<1)||(length(info(k).Fhz)>2) ||  isnan(info(k).Fhz(1))
		disp(['Inconsistent Corner Frequencies -> filterinfo #' int2str(k) ' is rejected!'])
		info(k).order=0;
		info(k)
		end
	end
	
	if strcmp(info(k).type,'low')
		if (length(info(k).Fhz)<1)||(length(info(k).Fhz)>2) ||  isnan(info(k).Fhz(end))
		disp(['Inconsistent Corner Frequencies -> filterinfo #' int2str(k) ' is rejected!'])
		info(k).order=0;
		info(k)
		end
	end

	end

end %for k=1:length(info)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

count=0;

for k=1:length(info)

	if (info(k).order>0) && ~(isnan(info(k).order))
	count=count+1;
	
	filterinfo(count)=get_struct_filterinfo;
	
	filterinfo(count).order=info(k).order;
	filterinfo(count).type=info(k).type;
	
		if strcmp(filterinfo(count).type,'bandpass')
		filterinfo(count).Fhz=info(k).Fhz;
        end

        if strcmp(filterinfo(count).type,'stop')
		filterinfo(count).Fhz=info(k).Fhz;
		end
        
        
		if strcmp(filterinfo(count).type,'high')
		filterinfo(count).Fhz=[info(k).Fhz(1) NaN];		
		end

		if strcmp(filterinfo(count).type,'low')
		filterinfo(count).Fhz=[NaN info(k).Fhz(end)];
		end
		
		if isfield(info,'direction')
		filterinfo(count).direction=info(k).direction;		
		end

		if isfield(info,'domain')
		filterinfo(count).domain=info(k).domain;		
		end		
		
		if isfield(info,'timestamp')
		filterinfo(count).timestamp=info(k).timestamp;		
		end		
						
	end

end %for k=1:length(info)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if count==0
filterinfo=get_struct_filterinfo;
end

return
