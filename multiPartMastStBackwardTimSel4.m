clear all;
% clearvars -except wave;
close all;
runTrigerCon=0;
load('monoBanList.mat');
parameters
for sigTyp=1:numSigTyp
    sigNam=['typ',num2str(sigTyp)];
    sig.(sigNam)(1:2)=sigClas.(sigNam)(1:2);
end
for monthBeg=monthBeg:monthEnd 
    if monthBeg==1||monthBeg==3||monthBeg==5||monthBeg==7||monthBeg==8||monthBeg==10||monthBeg==12
        dayEnd=31;%31
    elseif monthBeg==4||monthBeg==6||monthBeg==9||monthBeg==11
        dayEnd=30;%30
    elseif monthBeg==2
        if str2num(year)==2016  || str2num(year)==2020  
            dayEnd=29;% 29;
        else
            dayEnd=28;% 28;
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

        lta=sig2NoisWinLenRatio-1;
                    try
        %multipart begins from here
        removStA=[];
        removStB=[];
        removStC=[];
        detectablStA=[];
        detectablStB=[];
        detectablStC=[];
        seconStA=[];
        seconStB=[];
        seconStC=[];
        mastStA=[];
        mastStB=[];
        mastStC=[];
        lengC=0;
        lengB=0;
        lengA=0;
        LocalCLeng=[];
        LocalBLeng=[];
        LocalALeng=[];
        for xxx=1:length(staChek)
            newStCod=staChek(xxx);
            st=['St',num2str(newStCod)];
            stDate  = [st,date,'.mat'];
            if exist( stDate, 'file' ) == 2
                load(stDate)
                justLeng=0;

                if isequal(localC,[0 0 0 0])==0% && length(localC(:,1)) < 8000
                    lengC=lengC+1;
                    for sigTyp=1:numSigTyp
                        sigNam=['typ',num2str(sigTyp)];
                        justLeng1.(sigNam)=0;
                        justLeng1.(sigNam)=find(localC(:,4) >= picQuaSelZon1(1,sigTyp) & localC(:,2)==sigTyp);
                        justLeng(sigTyp)=length(justLeng1.(sigNam));
                    end
                    LocalCLeng(lengC,1:2)=[sum(justLeng) newStCod];
                end
                justLeng=0;

                if isequal(localB,[0 0 0 0])==0% && length(localB(:,1)) < 8000
                    lengB=lengB+1;
                    for sigTyp=1:numSigTyp
                        sigNam=['typ',num2str(sigTyp)];
                        justLeng1.(sigNam)=0;
                        justLeng1.(sigNam)=find(localB(:,4) >= picQuaSelZon2(1,sigTyp) & localB(:,2)==sigTyp);
                        justLeng(sigTyp)=length(justLeng1.(sigNam));
                    end
                    LocalBLeng(lengB,1:2)=[sum(justLeng) newStCod];
                end
                justLeng=0;

                if isequal(localA,[0 0 0 0])==0% && length(localA(:,1)) < 8000
                    lengA=lengA+1;
                    for sigTyp=1:numSigTyp
                        sigNam=['typ',num2str(sigTyp)];
                        justLeng1.(sigNam)=0;
                        justLeng1.(sigNam)=find(localA(:,4) >= picQuaSelZon3(1,sigTyp) & localA(:,2)==sigTyp);
                        justLeng(sigTyp)=length(justLeng1.(sigNam));
                    end
                    LocalALeng(lengA,1:2)=[sum(justLeng) newStCod];
                end
            end
            %                     end
        end
        removStC=LocalCLeng(find(LocalCLeng(:,1) > maxDetecEvPerSt),2);
        detectablStC=LocalCLeng(find(LocalCLeng(:,1) <= maxDetecEvPerSt),2);
        LocalCLeng=sortrows(LocalCLeng,1);
        if length(detectablStC) >= 3
            mastStC=LocalCLeng(1:numMasStBasedLenDetectabSt4(length(detectablStC),LocalCLeng,seconStON),2);% exisWavSt -> detectablStC
            if seconStON==1
                seconStC=LocalCLeng(numMasStBasedLenDetectabSt4(length(detectablStC),LocalCLeng,seconStON)+1:length(detectablStC),1:2);% spikiStC ->
            elseif seconStON==0
                seconStC=[0 0];
            end
        end
        removStB=LocalBLeng(find(LocalBLeng(:,1) > maxDetecEvPerSt),2);
        detectablStB=LocalBLeng(find(LocalBLeng(:,1) <= maxDetecEvPerSt),2);
        LocalBLeng=sortrows(LocalBLeng,1);
        if length(detectablStB) >= 3
            mastStB=LocalBLeng(1:numMasStBasedLenDetectabSt4(length(detectablStB),LocalBLeng,seconStON),2);% exisWavSt -> detectablStC
            if seconStON==1
                seconStB=LocalBLeng(numMasStBasedLenDetectabSt4(length(detectablStB),LocalBLeng,seconStON)+1:length(detectablStB),1:2);% spikiStC ->
            elseif seconStON==0
                seconStB=[0 0];
            end
        end

        removStA=LocalALeng(find(LocalALeng(:,1) > maxDetecEvPerSt),2);
        detectablStA=LocalALeng(find(LocalALeng(:,1) <= maxDetecEvPerSt),2);
        LocalALeng=sortrows(LocalALeng,1);
        if length(detectablStA) >= 3
            mastStA=LocalALeng(1:numMasStBasedLenDetectabSt4(length(detectablStA),LocalALeng,seconStON),2);% exisWavSt -> detectablStC
            if seconStON==1
                seconStA=LocalALeng(numMasStBasedLenDetectabSt4(length(detectablStA),LocalALeng,seconStON)+1:length(detectablStA),1:2);% spikiStC ->
            elseif seconStON==0
                seconStA=[0 0];
            end
        end
        if length(mastStC) < maxLocSearStNum
            maxLocSearStNumC = length(mastStC);
            display('length(mastStC) < maxLocSearStNum then we set maxLocSearStNum = length(mastStC) = ',num2str(length(mastStC)))
        else
            maxLocSearStNumC = maxLocSearStNum;
        end
        if length(mastStB) < maxLocSearStNum
            maxLocSearStNumB = length(mastStB);
            display('length(mastStB) < maxLocSearStNum then we set maxLocSearStNum = length(mastStB) = ',num2str(length(mastStB)))
        else
            maxLocSearStNumB = maxLocSearStNum;
        end
        if length(mastStA) < maxLocSearStNum
            maxLocSearStNumA = length(mastStA);
            display('length(mastStA) < maxLocSearStNum then we set maxLocSearStNum = length(mastStA) = ',num2str(length(mastStA)))
        else
            maxLocSearStNumA = maxLocSearStNum;
        end
        %             mastStPlot
        step5zon123
        save('infoBetweenRuns','monthBeg','dayBeg')
                    catch
                        display([stDate,'  due to using try-catch-continue an errore was skiped'])
                        continue
                    end
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
