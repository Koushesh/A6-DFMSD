function jday=dm2jd(day,month,year)

%function converting the month-day to Julian day
%==========================================================================
% Author :              Sebe O.
% Date of creation :    2004-2005
% last modification:    2012/05/16 Felicitas Stein
%==========================================================================

if isnumeric(day)
    jday=datenum(year,month,day)-datenum(year,1,1)+1;
elseif ischar(day)
    jday=datenum([month,'/',day,'/',year])-datenum(['01/01/',year])+1;
end


%disp([int2str(year) '.' num2str(jday, '%03d') ' -> ' num2str(day, '%02d') '.' num2str(month, '%02d') '.' int2str(year)])


return
