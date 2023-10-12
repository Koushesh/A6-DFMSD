function [unit,unitid,filterinfo,deconv,demean,trend]=filenameinfo_extract(filename)
%
% function [unit,unitid,filterinfo,deconv,demean,trend]=filenameinfo_extract(filename)
%
%
%
% This function extracts information about filters
% applied to ALL traces in a q-file with name 'filename'. To use this function
% there must be a strict filename convention!!
%
% e.g. filename='humantitle-PI_DM-TR-HP0.02_4-DC-BP0.2_25_4'
%
% After the human title filename their must be a '-PI_' to indicate the begin of
% the filename part with processing information
% Different steps of processing are seperated by '-'
% please keep order of the processing steps to easily reconstruct data processing!
%
% Processing shortnings:
%
% DM := Demean trace
% TR := Removal of trend
%
% BP0.1_45_4 is a Bandpass between 0.1 - 45Hz(!!)         and order 4
% HP0.1_4    is a Highpass with corner frequency 0.1Hz(!) and order 4
% LP10_4     is a Lowpass  with corner frequency 10Hz(!)  and order 4
% 
% DC0.1_45   removal of istrument transfer function (deconvolution) with input data between 0.1-45Hz
%
% use function extractputz to get information about basic processing and deconvolution
% and function extractunit to get information about the traces unit (VEL=nm/s, DISP=nm, ACC=nm/s^2).

%
% Joern Groos, Geophysical Institute, Universitaet Karlsruhe, Germany
% 2008-07-22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


if isempty(strfind(filename,'VEL'))
	if isempty(strfind(filename,'DISP'))
		if isempty(strfind(filename,'ACC'))
			if isempty(strfind(filename,'COUNT'))
			unit='NaN';
			unitid=NaN;
			else
			unit='count';
			unitid=0;
		end

		else
		unit='nm/(s*s)';
		unitid=1;
		end
	else
	unit='nm';
	unitid=3;
	end
else
unit='nm/s';
unitid=2;
end


if (isempty(strfind(filename,'-PI'))==0)
allinfo=1;
infostart=findstr('-PI_',filename);
putzinfo=filename(infostart+4:end);
else
allinfo=0;
filterinfo=get_struct_filterinfo;
demean=NaN;
trend=NaN;
deconv=NaN;
filtertext=NaN;
filtervalue=NaN;
end



if allinfo==1


if (isempty(strfind(putzinfo,'DM'))==0)
demean=1;
else
demean=0;
end


if (isempty(strfind(putzinfo,'TR'))==0)
trend=1;
else
trend=0;
end

if (isempty(strfind(putzinfo,'DC'))==0)
deconv=1;
else
deconv=0;
end


filterinfo=strrep(putzinfo,'DC','-');
filterinfo=strrep(filterinfo,'DM','-');
filterinfo=strrep(filterinfo,'TR','-');
filterinfo=strrep(filterinfo,'VEL','-');
filterinfo=strrep(filterinfo,'DISP','-');
filterinfo=strrep(filterinfo,'ACC','-');
filterinfo=strrep(filterinfo,'COUNT','-');
filterinfo=strrep(filterinfo,'-----','-');
filterinfo=strrep(filterinfo,'----','-');
filterinfo=strrep(filterinfo,'---','-');
filterinfo=strrep(filterinfo,'--','-');

bpinfo=findstr('BP',filterinfo);
lpinfo=findstr('LP',filterinfo);
hpinfo=findstr('HP',filterinfo);
dcinfo=findstr('DC',filterinfo);

filterstarts=sort(cat(2,bpinfo,lpinfo,hpinfo,dcinfo));


if isempty(filterstarts)

filtertext=0;
filtervalue=0;

else
	filtertext='a';
	
	for k=1:length(filterstarts)	
	posfil=filterstarts(k);
	postrich=findstr('-',filterinfo(posfil:end));
	
	if k==length(filterstarts)
	filtext{k}=filterinfo(posfil:end);
	else
	filtext{k}=filterinfo(posfil:(posfil+postrich(1)-2));
	end
	
	filtertext=[filtertext '-' filtext{k}];
	end
	filtertext=filtertext(3:end);
	
	for k=1:length(filterstarts)
	if(isempty(strfind(filtext{k},'BP'))==0)
	tex=filtext{k};
	posunder=findstr('_',tex);
	filtervalue(k,1)=str2num(tex(3:(posunder(1)-1)));
	filtervalue(k,2)=str2num(tex((posunder(1)+1):(posunder(2)-1)));
	filtervalue(k,3)=str2num(tex((posunder(2)+1):end));	
	end
	if(isempty(strfind(filtext{k},'HP'))==0)
	tex=filtext{k};
	posunder=findstr('_',tex);
	filtervalue(k,1)=NaN;
	filtervalue(k,2)=str2num(tex(3:(posunder(1)-1)));
	filtervalue(k,3)=str2num(tex((posunder(1)+1):end));
	end
	if(isempty(strfind(filtext{k},'LP'))==0)
	tex=filtext{k};
	posunder=findstr('_',tex);
	filtervalue(k,1)=str2num(tex(3:(posunder(1)-1)));
	filtervalue(k,2)=NaN;
	filtervalue(k,3)=str2num(tex((posunder(1)+1):end));
	end	
	if(isempty(strfind(filtext{k},'DC'))==0)
	tex=filtext{k};
	filtervalue(k,1)=NaN;
	filtervalue(k,2)=NaN;
	filtervalue(k,3)=NaN;
	end		
	end
	
	
end %if isempty(filterstarts)

clear filterinfo

[numfil,numfilpara]=size(filtervalue);

if numfilpara>1
    
for t=1:numfil

filterinfo(t)=get_struct_filterinfo;

filterinfo(t).order=filtervalue(t,3);

if isnan(filtervalue(t,1))
filterinfo(t).type='high';
filterinfo(t).Fhz=[filtervalue(t,2) NaN];
filterinfo(t).direction='NaN';
filterinfo(t).domain='NaN';
filterinfo(t).timestamp=now;
else
	if isnan(filtervalue(t,2))
	filterinfo(t).type='low';
	filterinfo(t).Fhz=[NaN filtervalue(t,1)];
	filterinfo(t).direction='NaN';
	filterinfo(t).domain='NaN';
	filterinfo(t).timestamp=now;
	else
	filterinfo(t).type='bandpass';
	filterinfo(t).Fhz=[filtervalue(t,1) filtervalue(t,2)];
	filterinfo(t).direction='NaN';
	filterinfo(t).domain='NaN';
	filterinfo(t).timestamp=now;
	end
end
end

else
filterinfo=get_struct_filterinfo;
end

end %if allinfo==1

