
% the station codes (in number form) that we want to consider their data for detection 
staChek=[1 2 3 4 5 7 8 9 10 11 12 13 14 15 16 17 19 20 23 24 25 26];% each number represents a station code and they are defined in the first column of the following parameter "stInfo".
%-- defining the time period of data for detection 
year='2017';%
monthBeg=11;%
monthEnd=11;%
dayBeg=8;% here the first day is defined which is desired for detection. In the code part called "fromSingl2multi6obspyBased" and "multiPartMastStBackwardTimSel4" detection for each day will be done up to the dayEnd defined in that part of the code. 
%--------------------------------------------------------------------------
morImpoSt=[12 17 16 20 24];
lesImpoSt=[ 4 19];
minLocSearCohStNum=3;%never set to 2 or less, unless seconStON=0
maxLocSearStNum=5;
save('minMaxLocSearStNum','minLocSearCohStNum','maxLocSearStNum')
Zon=[1 2 3];% ZON-1 SHOULD BEGGIN FROM SHALLOWER DEPTH THAN ZON-2 AND 3. ZON-2 SHOULD BEGGIN FROM SHALLOWER DEPTH THAN ZON-3
targDep1=[3 30 45];%in km (for zone 1, 2 and 3 respectively)
targDep2=[30 50 70];%in km (for zone 1, 2 and 3 respectively)


targRadi=25;%in km
targCen=[50.38  7.31];%in decimal degree

minSor2sorDis=3;%in km
sig2NoisWinLenRatio=3;% 4 means 3 discreted windows before the consdering window is taken as a base of relativly judgment amplitude changes regarding the considering window. 
monoBanSig2NoisTher=0.7;%

monoBanList= [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30];
save monoBanList monoBanList
%give the desired signal bands (signal classes) according to borders determined at monoBanList
numSigTyp=11; % write how many signal calasses is defined 
sigClas.typ1= [1    5];
sigClas.typ2= [2    7];
sigClas.typ3= [3    9];
sigClas.typ4= [4   11];
sigClas.typ5= [6   14];
sigClas.typ6= [8   17];
sigClas.typ7= [10  20];
sigClas.typ8= [12  23];
sigClas.typ9= [13  25];
sigClas.typ10=[15  28];
sigClas.typ11=[16  30];

sigClas2NoisTher1=2.5;%begins from 1. bigger means better quality picks are disired. confidence in outputs can be controled by this parameter when it set to higher values
sigClas2NoisTher2=2;% 
sigClas2NoisTher3=2;% 

iniSmoFacVici1=2.7;% 
iniSmoFacVici2=2.9;% 
iniSmoFacVici3=3.1;% 
iniDisperAddi=.16;% for adding additional shift to the dispersion veciniti selection  for frq.class > 3 (for tectonic event).
for sigTyp=1:numSigTyp
    sigNam=['typ',num2str(sigTyp)];
    sigoLeng(1,sigTyp)=sigClas.(sigNam)(2)-sigClas.(sigNam)(1);
end
picQuaSelZon1=sigClas2NoisTher1+(sigoLeng*.04);%
picQuaSelZon2=sigClas2NoisTher2+(sigoLeng*.04);%
picQuaSelZon3=sigClas2NoisTher3+(sigoLeng*.04);%

% for data quality control: records having to much spikes are ignored in
% detection. We control this by the following two parameters:
maxEvPerDay=600;
maxDetecEvPerSt=maxEvPerDay*numSigTyp*2; % 2 is muber of phases possibly can be detected (s + p). This parameter is used to seperate spiki stations from master stations.
%-------------------------------------------the most stable parameters---
diviFrq=[1  29];
%cutting parameter
cutPar=60;%60 in sec 
% a patameter to ingnore data which has more zeros in each component than
% numZeros. It set to station service duration normaly less than 2
% hours (720000 in sample with sample rate 100). During merging process to make mseed file this
% timewindow is filled by zeros.
numZeros=8640000;%720000
detecDivi=0;
%------------------------------------------------------------------------
specificMapPointPos=[50.413226, 7.270208];% it can be added to the map while ploting station locations
stInvolvStatisticCal4LocalDurMin=[1 2 3 4 5 7 8 9 10 11 12 13 14 15 16 17 19 20 23 24 25 26]; % it is recommended to mention all the stations of the network which is supposed to monitor the local seismice target zone, here 
%stations info. The numbers given to each station at the first column are
%the representative name for the stations throughout the code and the out puts of
%detection. The second column is the latitude and the third column is the
%longitude of the stations in decimal degree. 
stInfo=[1   50.3927 7.2069;...   % DEP1
    2   50.4182 7.3181;...   % DEP2
    3   50.3551 7.9935;...   % DEP3
    4   50.1509 7.0550;...   % DEP4
    5   50.3607 7.1025;...   % DEP5
    6   49.7017 7.0590;...   % DEP6
    7   50.1556 7.5312;...   % DEP7
    8   50.2370 7.2897;...   % DEP8
    9   50.3754 7.2842;...   % DEP9
    10  50.4208 7.5865;...   % DEP10
    11  50.5043 7.5774;...   % DEP11
    12  50.5447 7.4338;...   % DEP12
    13  50.5842 7.2414;...   % DEP13
    14  49.8820 7.5480;...   % ABH
    15  50.3551 7.9935;...   % FACH
    16  50.3390 7.3570;...   % OCHT
    17  50.3607 7.1025;...   % LAGB
    18  50.2320 6.288;...    % BLI
    19  50.0760 7.109;...    % FSH
    20  50.5410 7.0760;...   % AHRW
    21  50.2225 8.4473;...   % TNS
    22  49.6646 6.1526;...   % WLF
    23  50.44860 7.25655;... % DEP14
    24  50.353	7.18    ;... % BHE
    25  50.575	6.945   ;... % TDN
    26  50.7310 7.837   ;... % BIW
    ];
%station codes and their belonging network code
stNetInfo={
    'DP01' 'KB'  ; ...% 1
    'DP02' 'KB'  ; ...% 2
    'DP03' 'KB'  ; ...% 3
    'DP04' 'KB'  ; ...% 4
    'DP05' 'KB'  ; ...% 5
    'DP06' 'KB'  ; ...% 6
    'DP07' 'KB'  ; ...% 7
    'DP08' 'KB'  ; ...% 8
    'DP09' 'KB'  ; ...% 9
    'DP10' 'KB'  ; ...% 10
    'DP11' 'KB'  ; ...% 11
    'DP12' 'KB'  ; ...% 12
    'DP13' 'KB'  ; ...% 13    
    'ABH ' 'LE'  ; ...% 14
    'FACH' 'LE'  ; ...% 15
    'OCHT' 'LE'  ; ...% 16
    'LAGB' 'LE'  ; ...% 17
    'BLI ' 'LE'  ; ...% 18
    'FSH ' 'LE'  ; ...% 19    
    'AHRW' 'GR'  ; ...% 20
    'TNS ' 'GR'  ; ...% 21
    'WLF ' 'GR'  ; ...% 22    
    'DP14' 'KB'  ; ...% 23    
    'BHE ' 'NH'  ; ...% 24
    'TDN ' 'NH'  ; ...% 25    
    'BIW ' 'LE'  ; ...% 26   
    };
% locationin1={'00'    ''};
% dataTypVariation={'HH' 'SH' 'EH'};
% dataPathVariation={'/data_scc/KABBA_archive_SDS/' '/data_scc/KIT_archive_ED-SW/'};

% according to a 1D velocity model, for each kilometer depth a value is defined here for P-wave: 
velP(1:111,1)=[5.53;
             5.53;5.65;5.75;5.75;5.75;5.75;5.75;6.09;6.09;6.10;  6.10;6.20;6.20;6.20;6.32;6.32;6.32;6.32;6.43;6.43;...
             6.43;6.43;6.43;6.43;6.43;6.43;6.43;6.43;6.43;7.15;  7.15;7.15;7.15;7.15;7.15;7.80;7.80;7.80;7.80;7.80;...
             8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;  8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;...
             8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;  8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;...
             8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;  8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;...
             8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00;8.00];
% for S-wave:
velS(1:111,1)=[3.24; 
             3.25;3.32;3.38;3.38;3.55;3.55;3.55;3.73;3.73;3.77;  3.77;3.77;3.77;3.77;3.80;3.80;3.80;3.80;3.83;3.83;...
             3.83;3.83;3.83;3.83;3.83;3.83;3.83;3.83;3.83;4.76;  4.76;4.76;4.76;4.76;4.76;4.77;4.77;4.77;4.77;4.77;...
             4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;  4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;...
             4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;  4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;...
             4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;  4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;...
             4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77;4.77];

pausedTimInterv=[0 0];% in hour. it is a range that the code is stopped to run in it. 
seconStON=1;% =1 it does not consider any category as secondary station. instead it considers [] as seconSt and all station except the removSt as mastSt and detactablSt. =0 it consider all statistically obtainable categories of mastSt, seconSt and removSt detectablSt
sepZonOutput=2; %  if 1 it prints outputs regarding to each zon separately. if 0 it merjed outputs of all the mentioned zones once. if 2 it does both.
timErrPhDel=0;
magniTher=0;%1.1  2 find in step4! 0.1 0.3BRG