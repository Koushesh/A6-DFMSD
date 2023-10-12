function [varargout]=readqhd(headin,varargin)
%
%RQHD  Read seismic handler (SH) header variables 
%
%      usage:
%      [output]=rqhd('header_file','header_variable',occurrence);
%
%      Where:  header_file     = SH format header file
%              header_variable = SH format header variable name 
%              occurrence      = n - only display value of the nth 
%                                occurrence of variable in header file
%                              = 0 - create array of values containing
%                                each occurrence of variable in header file
%
%      examples:
%
%      To assign the first occurrence of the SH header value 'R000'
%      to the matlab variable 'delta' from the SH header file foo.QHD:
%
%      delta=rqhd('foo','R000',1); 
%
%      To create an array containing the number of records in each
%      trace from the SH header file foo.QHD and store in the matlab
%      variable 'length': 
%
%      length=rqhd('foo','L001',0);
%
%      To read both variables in the above example in one line:
%
%      [delta,length]=rqhd('foo','R000',1,'L001',0);
%
%      some useful SH header variables are:
%  
%        SH           purpose 
%      ------    ------------------
%       L001       length
%       R000       delta
%       R011       distance
%       R012       azimuth
%       R014       depth
%       R015       magnitude
%       R016       lat
%       R017       lon
%       S000:S     slowness
%       S021       trace origin time
%       S024       event begin time
%
%    Rk: for URS experiment:
%       S001       station name
%       c000       component name
%
%        By, Michael Thorne (mthorne@asu.edu)  4/2004
% Edited By, Joern Groos (joern.groos@gpi.uni-karlsruhe.de) 8/2007 and 12/2009
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


if (nargin < 3)
  error('not enough input arguments ...')
end

headfile=strcat(headin,'.QHD');

fid=fopen(headfile,'r');

junk=fgets(fid);  %read first line of file

%read in header file line by line and paste into array 'g'
%------------------------------------------------------------------------
h=1;
bline=1;
lines=1;
while h ~= -1  %h=-1 indicates end of file

  h=fgetl(fid);
  lbreak=find(h=='|');
  hh=h(lbreak+1:length(h));
 
  if ~isempty(hh)
    eline=bline + length(hh) - 1;
    g(bline:eline) = hh;
    bline = eline + 1;
  end

lines=lines+1;
end   %end while

%grab requested header variables from array 'g'
%------------------------------------------------------------------------

lineL001=findstr('L001',g);
lineL000=findstr('L000',g);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check for the first info entry! Usually it should be L001, but it can be L000

if lineL001(1)==1
linetest=lineL001;
else
	if lineL000(1)==1
	linetest=lineL000;
	else
	error('Unknown QHD!')
	end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numtraces=length(linetest);


count = 1;
for recs=1:2:(nargin-1)

clear outindex

header=varargin{recs};
occurrence=varargin{recs+1};

clear output

ltilde=find(g=='~');      %locations of all tildes
location=findstr(header,g);  %start locations of requested variables


if isempty(location) == 1
output(1:numtraces)=NaN;
varargout{count} = output;
count = count + 1;
continue
end


if header(1)=='R'

    output(1:numtraces)=NaN;
    for j=1:length(location)
      e1 = find(ltilde>location(j));
      e2 = ltilde(e1(1)) - 1; 
      if numtraces>1     
       for w=2:numtraces
        if ((location(j)>linetest(w-1)) && (location(j)<linetest(w)))
        outindex=w-1;
        end
	if location(j)>linetest(numtraces)
	outindex=numtraces;
	end
       end %for w=2:numtraces
      else
      outindex=1;
      end %if numtraces>1
      output(outindex) = str2double(g(location(j)+length(header)+1:e2));
    end
  
elseif (header(1)=='L') || (header(1)=='I')

    output(1:numtraces)=NaN;
    for j=1:length(location)
      e1 = find(ltilde>location(j));
      e2 = ltilde(e1(1)) - 1;
      if numtraces>1
                  
       for w=2:numtraces
        	if ((location(j)>linetest(w-1)) && (location(j)<linetest(w)))
	        outindex=w-1;
        	end
		if location(j)>linetest(numtraces)
		outindex=numtraces;
		end
		if location(j)==linetest(w-1)
		outindex=w-1;
		end
		if location(j)==linetest(numtraces)
		outindex=numtraces;
		end
       end %for w=2:numtraces

      else
      outindex=1;
      end %if numtraces>1 
          
      output(outindex) = round(str2double(g(location(j)+length(header)+1:e2)));
    end
                  
elseif (header(1)=='C') || (header(1)=='S') || (header(1)=='T')


    output=num2cell(ones(1,numtraces)*NaN);
    
    for j=1:length(location)
      e1 = find(ltilde>location(j));
      e2 = ltilde(e1(1)) - 1; 
      if numtraces>1     
       for w=2:numtraces
        if ((location(j)>linetest(w-1)) && (location(j)<linetest(w)))
        outindex=w-1;
        end
	if location(j)>linetest(numtraces)
	outindex=numtraces;
	end
       end %for w=2:numtraces
      else
      outindex=1;
      end %if numtraces>1            
      output{outindex} = g(location(j)+length(header)+1:e2);
    end

else

   varargout{count} = output;
   count = count + 1;
   continue

end

varargout{count} = output;
count = count + 1;

end

fclose(fid);

%==========================================================================
return
%CODE AND SYNTAX END OF NESTED FUNCTION readqhd
%==========================================================================
 
