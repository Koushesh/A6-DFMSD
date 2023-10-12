clear all;
% clearvars -except wave;
% close all;
runTrigerCon=1;
parameters
load('monoBanList.mat');

for sigTyp=1:numSigTyp
    sigNam=['typ',num2str(sigTyp)];
    sig.(sigNam)(1:2)=sigClas.(sigNam)(1:2);
end
for monthBeg=monthBeg:monthEnd % in function of "KABBA_getwaveformdata" there is a problem since if you set date as 20150230 and get data it gives you data!! there is NOT such date in calendar
    if monthBeg==1||monthBeg==3||monthBeg==5||monthBeg==7||monthBeg==8||monthBeg==10||monthBeg==12
        dayEnd=31;%31
    elseif monthBeg==4||monthBeg==6||monthBeg==9||monthBeg==11
        dayEnd=30;%30
    elseif monthBeg==2
        if str2num(year)==2016  || str2num(year)==2020
            dayEnd=29;% 29
        else
            dayEnd=28;% 28
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
        %info in to detection this part is desigened to check if SSD file
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
        sdn_start=datenum(begi,'yyyymmdd_HH:MM');
        sdn_end=datenum(endi,'yyyymmdd_HH:MM');
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
                for locaVar=1:length(locationin1)
                    locationin=locationin1{locaVar};
                    %                 locationin=cell2mat(stNetInfo(newStCod,3));%'00';-----<
                    for dTyp=1:length(dataTypVariation)%noXX
                        dataTyp=cell2mat(dataTypVariation(dTyp));
                        for varPath=1:length(dataPathVariation)%noXX
                            DataPath=cell2mat(dataPathVariation(varPath));
                            for j=1:5
                                if j==1
                                    compo='Z';
                                elseif j==2
                                    compo='N';
                                elseif j==3
                                    compo='E';
                                elseif j==4
                                    compo='1';
                                elseif j==5
                                    compo='2';
                                end
                                st=['St',num2str(newStCod)];
                                stDate  = [st,date];
                                if compo=='2'
                                    nam=['N',stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];
                                end
                                if compo=='1'
                                    nam=['E',stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];
                                end
                                if compo~='1' && compo~='2'
                                    nam=[compo,stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];
                                end
                                if ((newStCod~=24 || newStCod~=25) && j<= 3 ) || ((newStCod~=24 || newStCod~=25) && j> 3 && isempty(wave.(nam))==1)
                                    wave.(nam)= KABBA_getwaveformdataextern(networkin, stationin, locationin, [dataTyp, compo], sdn_start, sdn_end,'-dp',DataPath);
                                elseif ((newStCod==24 || newStCod==25) && j<= 3 ) || ((newStCod==24 || newStCod==25) && j> 3 && isempty(wave.(nam))==1)
                                    wave.(nam)= i_noMessTDN_BHE_KABBA_getwaveformdataextern(networkin, stationin, locationin, [dataTyp, compo], sdn_start, sdn_end,'-dp',DataPath);
                                end
                            end
                            ZcompDismis=['Z',stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];
                            NcompDismis=['N',stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];
                            EcompDismis=['E',stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];
                            if isempty(wave.(ZcompDismis))== 0 && isempty(wave.(NcompDismis))== 0 && isempty(wave.(EcompDismis))== 0
                                zZero = categorical(wave.(ZcompDismis).trace,[0]);
                                [numZZero] = histcounts(zZero);
                                nZero = categorical(wave.(NcompDismis).trace,[0]);
                                [numNZero] = histcounts(nZero);
                                eZero = categorical(wave.(EcompDismis).trace,[0]);
                                [numEZero] = histcounts(eZero);
                                if numZZero < numZeros && numNZero < numZeros && numEZero < numZeros
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
                                    break
                                end
                            end
                        end
                        if (isempty(wave.(ZcompDismis))== 0 && isempty(wave.(NcompDismis))== 0 && isempty(wave.(EcompDismis))== 0) && ...
                                (numZZero < numZeros && numNZero < numZeros && numEZero < numZeros)
                            break
                        end
                    end
                    if (isempty(wave.(ZcompDismis))== 0 && isempty(wave.(NcompDismis))== 0 && isempty(wave.(EcompDismis))== 0) && ...
                            (numZZero < numZeros && numNZero < numZeros && numEZero < numZeros)
                        break
                    end
                end
            catch
                display([stDate,'  in mseed data an error occurred'])
                continue
            end
        end
        % new place in code for para calculator6 due to new statisticaly
        % calculation for minStatisDur
        if runTrigerCon==1
            targetCentr2StCentr
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

        lta=sig2NoisWinLenRatio-1

        %------------------
        runTrigerCon=runTrigerCon+1;
        for xxx=1:length(staChek)
            try
                newStCod=staChek(xxx);
                stationin=cell2mat(stNetInfo(newStCod,1));%['DEP0', num2str(newStCod)]
                networkin=cell2mat(stNetInfo(newStCod,2));
                for locaVar=1:length(locationin1)
                    locationin=locationin1{locaVar};
                    %                 locationin=cell2mat(stNetInfo(newStCod,3));%'00';-----<
                    for dTyp=1:length(dataTypVariation)%noXX
                        dataTyp=cell2mat(dataTypVariation(dTyp));
                        for varPath=1:length(dataPathVariation)%noXX
                            DataPath=cell2mat(dataPathVariation(varPath));
                            st=['St',num2str(newStCod)];
                            stDate  = [st,date];
                            % diva=['D',num2str(detecDivi),st];
                            diva=['D0'];
                            ZcompDismis=['Z',stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];
                            NcompDismis=['N',stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];
                            EcompDismis=['E',stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];

                            if isempty(wave.(ZcompDismis))== 0 && isempty(wave.(NcompDismis))== 0 && isempty(wave.(EcompDismis))== 0
                                zZero = categorical(wave.(ZcompDismis).trace,[0]);
                                [numZZero] = histcounts(zZero);
                                nZero = categorical(wave.(NcompDismis).trace,[0]);
                                [numNZero] = histcounts(nZero);
                                eZero = categorical(wave.(EcompDismis).trace,[0]);
                                [numEZero] = histcounts(eZero);

                                if numZZero < numZeros && numNZero < numZeros && numEZero < numZeros
                                    for j=1:3
                                        if j==1
                                            compo='Z';
                                        elseif j==2
                                            compo='N';
                                        else
                                            compo='E';
                                        end
                                        nam=[compo,stDate,networkin,dataTyp,num2str(locaVar),num2str(varPath)];
                                        delta=wave.(nam).delta;

                                        step1
                                    end
                                    step23zon123
                                    display(['st ', num2str(newStCod),' step 2 and 3 finished']);
                                    step4zon123
                                    display(['st ', num2str(newStCod),' step 4  finished']);
                                    wave.wat=[];
                                    if detecDivi==0
                                        wave.(ZcompDismis)=[];
                                        wave.(NcompDismis)=[];
                                        wave.(EcompDismis)=[];
                                    end
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
                                break
                            end
                        end
                        if (isempty(wave.(ZcompDismis))== 0 && isempty(wave.(NcompDismis))== 0 && isempty(wave.(EcompDismis))== 0) && ...
                                (numZZero < numZeros && numNZero < numZeros && numEZero < numZeros)
                            break
                        end
                    end
                    if (isempty(wave.(ZcompDismis))== 0 && isempty(wave.(NcompDismis))== 0 && isempty(wave.(EcompDismis))== 0) && ...
                            (numZZero < numZeros && numNZero < numZeros && numEZero < numZeros)
                        break
                    end
                end
            catch
                display([stDate,'  due to using try-catch-continue an errore was skiped'])
                continue
            end
            pause(10)
        end
        save('infoBetweenRuns','monthBeg','dayBeg')
        clearvars -except sig frDiviAv runTrigerCon A2B;
        parameters
        load('infoBetweenRuns')
        pause(1);
        runBegEnd = clock

        if runBegEnd(4)*60 + runBegEnd(5) > pausedTimInterv(1)*60  && runBegEnd(4)*60 + runBegEnd(5) < pausedTimInterv(2)*60 && runTrigerCon~=1

            pause((pausedTimInterv(2)*60-(runBegEnd(4)*60 + runBegEnd(5)))*60)%32400
        end
    end
end


