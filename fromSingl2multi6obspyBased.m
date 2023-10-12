clear all;
% clearvars -except wave;
runTrigerCon=1; % if it is 1 then it calculate targetCentr2StCentr, esle it load A2B
parameters
load('monoBanList.mat');

if runTrigerCon==1
    targetCentr2StCentr
    runTrigerCon=runTrigerCon+1;
else
    load('A2B')
end
for i=1:length(Zon(:))
    currentZon=Zon(i);
    % st2stPhDelayZon=['st2stPhDelayZon-',num2str(currentZon),'.mat'];
    locaDurStaticMinZon=['minStatisDurZon-',num2str(currentZon),'.mat'];
    if exist( locaDurStaticMinZon, 'file' ) == 2
        %     load(st2stPhDelayZon)
        load(locaDurStaticMinZon)
    else
        paraCalculator6multiTasks
    end
end
%------------------
lta=sig2NoisWinLenRatio-1;% not less than 2.
%------------------
for sigTyp=1:numSigTyp
    sigNam=['typ',num2str(sigTyp)];
    sig.(sigNam)(1:2)=sigClas.(sigNam)(1:2);
end
for monthBeg=monthBeg:monthEnd % 
    if monthBeg==1||monthBeg==3||monthBeg==5||monthBeg==7||monthBeg==8||monthBeg==10||monthBeg==12
        dayEnd=31;%31
    elseif monthBeg==4||monthBeg==6||monthBeg==9||monthBeg==11
        dayEnd=8;%30
    elseif monthBeg==2
        if str2num(year)==2016  || str2num(year)==2020
            dayEnd=29;% 29
        else
            dayEnd=7;% 28
        end
    end
    %     save('monthBeg','monthBeg')
    save('dayEnd','dayEnd')
    for dayBeg=dayBeg:dayEnd
        load('dayEnd')
        if (monthBeg<10 && dayBeg<10)
            date=[year,'0',num2str(monthBeg),'0',num2str(dayBeg)];
        elseif (monthBeg<10 && dayBeg>9)
            date=[year,'0',num2str(monthBeg),num2str(dayBeg)];
        elseif (monthBeg>9 && dayBeg<10)
            date=[year,num2str(monthBeg),'0',num2str(dayBeg)];
        elseif (monthBeg>9 && dayBeg>9)
            date=[year,num2str(monthBeg),num2str(dayBeg)];
        end
        %---when some data is added to the server and you need to add their
        %info in to detection list this part is desigened to check if SSD file
        %for the data is already generated or not.
        staChekNoSSD=[];
        noSSD=0;
        for xAll=1:length(staChek)
            naSSD= ['St',num2str(staChek(xAll)),date,'.mat'];
            if exist( naSSD, 'file' ) ~= 2
                noSSD=noSSD+1;
                staChekNoSSD(noSSD,1)=staChek(xAll);
            end
        end
        staChek=[];
        staChek=staChekNoSSD;
        %-------------------------------
        dateEv=['date',date];
        % taking a day waveform
        hourBeg='00'; minutBeg='00';
        begi=[date,'_',hourBeg,':',minutBeg];
        hourEnd='23'; minutEnd='59';
        %---------------------------
        endi=[date,'_',hourEnd,':',minutEnd];
        if monthBeg<monthEnd && dayBeg==dayEnd
            dayBeg=1;
        end
        %--------------------------------------------------------------------------
        conSt=0;
        exisWavSt=[];
        for xxx=1:length(staChek)
            try
            newStCod=staChek(xxx);
            stationin=cell2mat(stNetInfo(newStCod,1));%['DEP0', num2str(newStCod)]
            networkin=cell2mat(stNetInfo(newStCod,2));
            st=['St',num2str(newStCod)];
            stDate  = [st,date];
            namZ=['ZSt',num2str(newStCod)];
            namN=['NSt',num2str(newStCod)];
            namE=['ESt',num2str(newStCod)];
            mSt=[];

            if isfile([stationin,date,'.QBN'])
                mSt=readqfile2struct([stationin,date],'lil');%'big'
                if isempty(mSt(3))==0 && isempty(mSt(2))==0 && isempty(mSt(1))==0 && abs(mSt(1).npts-mSt(2).npts)<=100 && abs(mSt(3).npts-mSt(2).npts)<=100 && mSt(3).npts > 1*3600*100
                    
                    for j=1:3
                        if j==1
                            compo='E';
                        elseif j==2
                            compo='N';
                        elseif j==3
                            compo='Z';
                        end
                        nam=[compo,'St',num2str(newStCod)];
                        wave.(nam)=mSt(j);
                        conSt=conSt+1;
                        exisWavSt(conSt)=newStCod;
                        % basicProcessor
                        wave.(nam)=demeandata(wave.(nam));
                        wave.(nam)=detrenddata(wave.(nam));
                        BP.type='bandpass';
                        BP.order=4;
                        BP.Fhz=[1 30];
                        % bandpassing
                        maxfreq=(0.5*(1/max([wave.(nam).delta])));
                        if BP.Fhz(2)>=maxfreq
                            disp(' ')
                            disp(['Upper corner of BP (' num2str(BP.Fhz(2)) ' Hz) is to high for sample rate!!'])
                            BP.Fhz(2)=0.9*maxfreq;
                            disp(['Adjusting upper corner frequency to ' num2str(BP.Fhz(2)) ' Hz!'])
                            disp(' ')
                        end
                        wave.(nam)=filterbuttertimedomainzerophasedata(wave.(nam),BP);% 'ZHigRem'=vector
                        wave.(nam)=demeandata(wave.(nam));
                        wave.(nam)=detrenddata(wave.(nam));

                        delta=wave.(nam).delta;
                        step1
                    end
                    step23zon123
                    display(['st ', num2str(newStCod),' step 2 and 3 finished']);
                    step4zon123
                    display(['st ', num2str(newStCod),' step 4  finished']);
                    wave.wat=[];
                    wave.Z=[];
                    wave.N=[];
                    wave.E=[];
                    for pa=diviFrq(1,1):diviFrq(1,2)
                        partFilC=['pa',num2str(pa),'C',num2str(pa)];
                        partFilB=['pa',num2str(pa),'B',num2str(pa)];
                        partFilA=['pa',num2str(pa),'A',num2str(pa)];
                        me.(partFilC)=[];
                        me.(partFilB)=[];
                        me.(partFilA)=[];
                    end
                end
            end
            catch
                display([stDate,'  --->  an error occurred'])
                continue
            end
        end
    end
end

