
sampBeg=(str2num(hourBeg)*60+str2num(minutBeg))*60/delta+1;
% sampEnd=(str2num(hourEnd)*60+str2num(minutEnd))*60/delta;
sampEnd=(str2num('2')*60+str2num('0'))*60/delta;

wave.(compo)=0;
wave.(compo)=wave.(nam);
wave.(compo).trace=wave.(nam).trace(sampBeg:sampEnd);
wave.(compo).npts = length(wave.(compo).trace);
wave.(compo).vel=wave.(compo).trace;%wave.(nam).trace;

