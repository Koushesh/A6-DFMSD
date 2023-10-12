
dateEv=['date',date];
dateNetDelay=['date',date,'netDelay'];
onceDoneContr=0;

if sepZonOutput==0  || sepZonOutput==2
    %     Zon=123;
    for ni=1:length(Zon(1,:)) % ni is used in all printing selecting-printing scripts like step8zon123 finalOutPut outputControlerNet1,2,3
        staChek=[];
        detectablSt=[];
        removSt=[];
        seconSt=[];
        mastSt=[];
        locT.(dateEv)=[];
        locF.(dateEv)=[];
        locD.(dateEv)=[];
        locZ.(dateEv)=[];
        load('minMaxLocSearStNum')
        if Zon(ni)==1
            removSt=removStC;
            detectablSt=detectablStC;
            seconSt=seconStC;
            mastSt=mastStC;
            staChek=detectablStC;
            maxLocSearStNum=maxLocSearStNumC;
            load('minStatisDurZon-1')
            load('st2stPhDelayZon-1')
            picQuaSel=picQuaSelZon1;
            iniSmoFacVici=iniSmoFacVici1;
            % disperVeciSel=disperVeciSelZon1;
            maxNegativPhasDelayMaxC=maxNegativPhasDelayMax;
            maxPositivPhasDelayMaxC=maxPositivPhasDelayMax;
            minNegativPhasDelayMinC=minNegativPhasDelayMin;
            minPositivPhasDelayMinC=minPositivPhasDelayMin;
        elseif Zon(ni)==2
            removSt=removStB;
            detectablSt=detectablStB;
            seconSt=seconStB;
            mastSt=mastStB;
            staChek=detectablStB;
            maxLocSearStNum=maxLocSearStNumB;
            load('minStatisDurZon-2')
            load('st2stPhDelayZon-2')
            picQuaSel=picQuaSelZon2;
            iniSmoFacVici=iniSmoFacVici2;
            % disperVeciSel=disperVeciSelZon2;
            maxNegativPhasDelayMaxB=maxNegativPhasDelayMax;
            maxPositivPhasDelayMaxB=maxPositivPhasDelayMax;
            minNegativPhasDelayMinB=minNegativPhasDelayMin;
            minPositivPhasDelayMinB=minPositivPhasDelayMin;
        elseif Zon(ni)==3
            removSt=removStA;
            detectablSt=detectablStA;
            seconSt=seconStA;
            mastSt=mastStA;
            staChek=detectablStA;
            maxLocSearStNum=maxLocSearStNumA;
            load('minStatisDurZon-3')
            load('st2stPhDelayZon-3')
            picQuaSel=picQuaSelZon3;
            iniSmoFacVici=iniSmoFacVici3;
            % disperVeciSel=disperVeciSelZon3;
            maxNegativPhasDelayMaxA=maxNegativPhasDelayMax;
            maxPositivPhasDelayMaxA=maxPositivPhasDelayMax;
            minNegativPhasDelayMinA=minNegativPhasDelayMin;
            minPositivPhasDelayMinA=minPositivPhasDelayMin;
        end
        for xxx=1:length(staChek)
            newStCod=staChek(xxx);
            st=['St',num2str(newStCod)];
            stDate  = [st,date,'.mat'];
            if exist(stDate, 'file') == 2
                load(stDate)
                if isequal(localC,[0 0 0 0])==0 && Zon(ni)==1 %&& length(localC(:,1)) < 8000
                    localC(:,5)=1;
                    localPic=[];
                    localPic4=[];
                    for sigTyp=1:numSigTyp
                        sigNam=['typ',num2str(sigTyp)];
                        localPic4.(sigNam)=localC(find(localC(:,4) >= picQuaSel(1,sigTyp) & localC(:,2)==sigTyp),1:5);
                        if sigTyp==1
                            localPic=localPic4.(sigNam);
                        else
                            localPic=cat(1,localPic,localPic4.(sigNam));
                        end  
                    end
                else
                    localC=[0 0 0 0 0];
                end
                if isequal(localB,[0 0 0 0])==0 && Zon(ni)==2 %&& length(localB(:,1)) < 8000
                    localB(:,5)=2;
                    localPic=[];
                    localPic4=[];
                    for sigTyp=1:numSigTyp
                        sigNam=['typ',num2str(sigTyp)];
                        localPic4.(sigNam)=localB(find(localB(:,4) >= picQuaSel(1,sigTyp) & localB(:,2)==sigTyp),1:5);
                        if sigTyp==1
                            localPic=localPic4.(sigNam);
                        else
                            localPic=cat(1,localPic,localPic4.(sigNam));
                        end  
                    end
                else
                    localB=[0 0 0 0 0];
                end
                if isequal(localA,[0 0 0 0])==0 && Zon(ni)==3 %&& length(localA(:,1)) < 8000
                    localA(:,5)=3;
                    localPic=[];
                    localPic4=[];
                    for sigTyp=1:numSigTyp
                        sigNam=['typ',num2str(sigTyp)];
                        localPic4.(sigNam)=localA(find(localA(:,4) >= picQuaSel(1,sigTyp) & localA(:,2)==sigTyp),1:5);
                        if sigTyp==1
                            localPic=localPic4.(sigNam);
                        else
                            localPic=cat(1,localPic,localPic4.(sigNam));
                        end  
                    end
                else
                    localA=[0 0 0 0 0];
                end
                %                 %             local=cat(1,localC,localB,localA);
                locT.(dateEv)(1:length(localPic(:,1)),newStCod)=localPic(:,1);
                locF.(dateEv)(1:length(localPic(:,1)),newStCod)=localPic(:,2);
                locD.(dateEv)(1:length(localPic(:,1)),newStCod)=localPic(:,3);
                locZ.(dateEv)(1:length(localPic(:,1)),newStCod)=Zon(ni);
            end
        end
        clearvars localA localB localC
        display('______________________________________________________________');
        pause(2);
        if length(detectablSt) == 3
            minLocSearCohStNum = 2;
            display('length(detectablSt) == 3 then we set minLocSearCohStNum = 2')
        elseif length(detectablSt) == 4
            minLocSearCohStNum = 3;
            display('length(detectablSt) == 4 then we set minLocSearCohStNum = 3')
        elseif length(detectablSt) == 5
            minLocSearCohStNum = 3;
            display('length(detectablSt) == 5 then we set minLocSearCohStNum = 3')
        elseif length(detectablSt) == 6
            minLocSearCohStNum = 3;
            display('length(detectablSt) == 6 then we set minLocSearCohStNum = 3')
        end
        
        autoNetConfigPar %never put it before finding of detectablSt. this has effect on selection part system like 3-6 or any
        if ismember([1 2 3],Zon)==[1 1 1]
            save(dateNetDelay,'mastStA','mastStB','mastStC','LocalALeng','LocalBLeng','LocalCLeng',...
                'detectablStA','detectablStB','detectablStC','netStimatorMast','LocaSerRadiMast','netStimator','LocaSerRadi',...
                'removStA','removStB','removStC','seconStA','seconStB','seconStC','maxLocSearStNumA','maxLocSearStNumB','maxLocSearStNumC')
        end
        step6zon123
        if Zon(ni)==1
            com3LocEv.(dateEv)(:,7)=1;
            sortComLocEv.(dateEv)(:,7)=1;
            com3LocEvC.(dateEv)=com3LocEv.(dateEv);
            sortComLocEvC.(dateEv)=sortComLocEv.(dateEv);
        elseif Zon(ni)==2
            com3LocEv.(dateEv)(:,7)=2;
            sortComLocEv.(dateEv)(:,7)=2;
            com3LocEvB.(dateEv)=com3LocEv.(dateEv);
            sortComLocEvB.(dateEv)=sortComLocEv.(dateEv);
        elseif Zon(ni)==3
            com3LocEv.(dateEv)(:,7)=3;
            sortComLocEv.(dateEv)(:,7)=3;
            com3LocEvA.(dateEv)=com3LocEv.(dateEv);
            sortComLocEvA.(dateEv)=sortComLocEv.(dateEv);
        end
    end
    com3LocEvCBA.(dateEv)=cat(1,com3LocEvC.(dateEv),com3LocEvB.(dateEv),com3LocEvA.(dateEv));
    sortComLocEvCBA.(dateEv)=cat(1,sortComLocEvC.(dateEv),sortComLocEvB.(dateEv),sortComLocEvA.(dateEv));
    
    com3LocEvCBA.(dateEv)= sortrows(com3LocEvCBA.(dateEv),1);
    sortComLocEvCBA.(dateEv)=sortrows(sortComLocEvCBA.(dateEv),1);
    display([' step 6  all stations checking finished']);
    
    mastSt=[];
    seconSt=[];
    seconSt1=[];
    detectablSt=[];
    staChek=[];
    detectablSt=cat(1,detectablStA,detectablStB,detectablStC);
    detectablSt=unique(detectablSt,'rows')
    staChek=detectablSt;
    mastSt=cat(1,mastStA,mastStB,mastStC);
    mastSt=unique(mastSt(:,1),'rows');
    %     seconSt1=intersect(seconStA(:,2)',seconStB(:,2)'); should be edited
    %     if you want to use
    %     seconSt=intersect(seconSt1,seconStC(:,2)');
    %     seconSt=unique(seconSt,'rows')
    load('minMaxLocSearStNum')
    if length(mastSt) < maxLocSearStNum
        maxLocSearStNum = length(mastSt);
        display('length(mastSt) < maxLocSearStNum then we set maxLocSearStNum = length(mastSt) = ',num2str(length(mastSt)))
    end
    if length(detectablSt) == 3
        minLocSearCohStNum = 2;
        display('length(detectablSt) == 3 then we set minLocSearCohStNum = 2')
    elseif length(detectablSt) == 4
        minLocSearCohStNum = 3;
        display('length(detectablSt) == 4 then we set minLocSearCohStNum = 3')
    elseif length(detectablSt) == 5
        minLocSearCohStNum = 3;
        display('length(detectablSt) == 5 then we set minLocSearCohStNum = 3')
    elseif length(detectablSt) == 6
        minLocSearCohStNum = 3;
        display('length(detectablSt) == 6 then we set minLocSearCohStNum = 3')
    end
    
    autoNetConfigPar
    
    pause(1);%10
    step8zon123
    
    load('netDelayZon123')
    finalOutPutBackwardInTimeSelectorRestictedSameF
    onceDoneContr=onceDoneContr+1;
    outputControlerNet1
    outputControlerNet2
    outputControlerNet3
    outputControlerNet4
    outputControlerNet5
    outputControlerNet6
    display([' step 8  day-division ',num2str(detecDivi),'  ',date,' finished']);
    
end
if sepZonOutput==1   || sepZonOutput==2
    for ni=1:length(Zon(1,:))% ni is used in all printing selecting-printing scripts like step8zon123 finalOutPut outputControlerNet1,2,3
        staChek=[];
        detectablSt=[];
        removSt=[];
        seconSt=[];
        mastSt=[];
        netDelay=[];% CARE
        locT.(dateEv)=[];
        locF.(dateEv)=[];
        locD.(dateEv)=[];
        locZ.(dateEv)=[];
        load('minMaxLocSearStNum')
        if Zon(ni)==1
            removSt=removStC;
            detectablSt=detectablStC;
            seconSt=seconStC;
            mastSt=mastStC;
            staChek=detectablStC;
            maxLocSearStNum=maxLocSearStNumC;
            load('minStatisDurZon-1')
            load('st2stPhDelayZon-1')
            picQuaSel=picQuaSelZon1;
            iniSmoFacVici=iniSmoFacVici1;
            % disperVeciSel=disperVeciSelZon1;
            maxNegativPhasDelayMaxC=maxNegativPhasDelayMax;
            maxPositivPhasDelayMaxC=maxPositivPhasDelayMax;
            minNegativPhasDelayMinC=minNegativPhasDelayMin;
            minPositivPhasDelayMinC=minPositivPhasDelayMin;
        elseif Zon(ni)==2
            removSt=removStB;
            detectablSt=detectablStB;
            seconSt=seconStB;
            mastSt=mastStB;
            staChek=detectablStB;
            maxLocSearStNum=maxLocSearStNumB;
            load('minStatisDurZon-2')
            load('st2stPhDelayZon-2')
            picQuaSel=picQuaSelZon2;
            iniSmoFacVici=iniSmoFacVici2;
            % disperVeciSel=disperVeciSelZon2;
            maxNegativPhasDelayMaxB=maxNegativPhasDelayMax;
            maxPositivPhasDelayMaxB=maxPositivPhasDelayMax;
            minNegativPhasDelayMinB=minNegativPhasDelayMin;
            minPositivPhasDelayMinB=minPositivPhasDelayMin;
        elseif Zon(ni)==3
            removSt=removStA;
            detectablSt=detectablStA;
            seconSt=seconStA;
            mastSt=mastStA;
            staChek=detectablStA;
            maxLocSearStNum=maxLocSearStNumA;
            load('minStatisDurZon-3')
            load('st2stPhDelayZon-3')
            picQuaSel=picQuaSelZon3;
            iniSmoFacVici=iniSmoFacVici3;
            % disperVeciSel=disperVeciSelZon3;
            maxNegativPhasDelayMaxA=maxNegativPhasDelayMax;
            maxPositivPhasDelayMaxA=maxPositivPhasDelayMax;
            minNegativPhasDelayMinA=minNegativPhasDelayMin;
            minPositivPhasDelayMinA=minPositivPhasDelayMin;
        end
        for xxx=1:length(staChek)
            newStCod=staChek(xxx);
            st=['St',num2str(newStCod)];
            stDate  = [st,date,'.mat'];
            if exist(stDate, 'file') == 2
                load(stDate)
                if isequal(localC,[0 0 0 0])==0 && Zon(ni)==1 %&& length(localC(:,1)) < 8000  
                    localC(:,5)=1;
                    localPic=[];
                    localPic4=[];
                    for sigTyp=1:numSigTyp
                        sigNam=['typ',num2str(sigTyp)];
                        localPic4.(sigNam)=localC(find(localC(:,4) >= picQuaSel(1,sigTyp) & localC(:,2)==sigTyp),1:5);
                        if sigTyp==1
                            localPic=localPic4.(sigNam);
                        else
                            localPic=cat(1,localPic,localPic4.(sigNam));
                        end  
                    end
                else
                    localC=[0 0 0 0 0];
                end
                if isequal(localB,[0 0 0 0])==0 && Zon(ni)==2 %&& length(localB(:,1)) < 8000
                    localB(:,5)=2;
                    localPic=[];
                    localPic4=[];
                    for sigTyp=1:numSigTyp
                        sigNam=['typ',num2str(sigTyp)];
                        localPic4.(sigNam)=localB(find(localB(:,4) >= picQuaSel(1,sigTyp) & localB(:,2)==sigTyp),1:5);
                        if sigTyp==1
                            localPic=localPic4.(sigNam);
                        else
                            localPic=cat(1,localPic,localPic4.(sigNam));
                        end  
                    end
                else
                    localB=[0 0 0 0 0];
                end
                if isequal(localA,[0 0 0 0])==0 && Zon(ni)==3 %&& length(localA(:,1)) < 8000
                    localA(:,5)=3;
                    localPic=[];
                    localPic4=[];
                    for sigTyp=1:numSigTyp
                        sigNam=['typ',num2str(sigTyp)];
                        localPic4.(sigNam)=localA(find(localA(:,4) >= picQuaSel(1,sigTyp) & localA(:,2)==sigTyp),1:5);
                        if sigTyp==1
                            localPic=localPic4.(sigNam);
                        else
                            localPic=cat(1,localPic,localPic4.(sigNam));
                        end  
                    end
                else
                    localA=[0 0 0 0 0];
                end
                %                 %             local=cat(1,localC,localB,localA);
                locT.(dateEv)(1:length(localPic(:,1)),newStCod)=localPic(:,1);
                locF.(dateEv)(1:length(localPic(:,1)),newStCod)=localPic(:,2);
                locD.(dateEv)(1:length(localPic(:,1)),newStCod)=localPic(:,3);
                locZ.(dateEv)(1:length(localPic(:,1)),newStCod)=Zon(ni);
            end
        end
        clearvars localA localB localC
        display('______________________________________________________________');
        pause(2);
        if length(detectablSt) == 3
            minLocSearCohStNum = 2;
            display('length(detectablSt) == 3 then we set minLocSearCohStNum = 2')
        elseif length(detectablSt) == 4
            minLocSearCohStNum = 3;
            display('length(detectablSt) == 4 then we set minLocSearCohStNum = 3')
        elseif length(detectablSt) == 5
            minLocSearCohStNum = 3;
            display('length(detectablSt) == 5 then we set minLocSearCohStNum = 3')
        elseif length(detectablSt) == 6
            minLocSearCohStNum = 3;
            display('length(detectablSt) == 6 then we set minLocSearCohStNum = 3')
        end
        autoNetConfigPar %never put it before finding of detectablSt. this has effect on selection part system like 3-6 or any
        if ismember([1 2 3],Zon)==[1 1 1]
            if onceDoneContr==0
                if Zon(ni)==1
                    dateNetDelayC=['date',date,'netDelayZon-1'];
                    save(dateNetDelayC,'mastStA','mastStB','mastStC','LocalALeng','LocalBLeng','LocalCLeng',...
                        'detectablStA','detectablStB','detectablStC','netStimatorMast','LocaSerRadiMast','netStimator','LocaSerRadi',...
                        'removStA','removStB','removStC','seconStA','seconStB','seconStC','maxLocSearStNumA','maxLocSearStNumB','maxLocSearStNumC')
                elseif Zon(ni)==2
                    dateNetDelayB=['date',date,'netDelayZon-2'];
                    save(dateNetDelayB,'mastStA','mastStB','mastStC','LocalALeng','LocalBLeng','LocalCLeng',...
                        'detectablStA','detectablStB','detectablStC','netStimatorMast','LocaSerRadiMast','netStimator','LocaSerRadi',...
                        'removStA','removStB','removStC','seconStA','seconStB','seconStC','maxLocSearStNumA','maxLocSearStNumB','maxLocSearStNumC')
                elseif Zon(ni)==3
                    dateNetDelayA=['date',date,'netDelayZon-3'];
                    save(dateNetDelayA,'mastStA','mastStB','mastStC','LocalALeng','LocalBLeng','LocalCLeng',...
                        'detectablStA','detectablStB','detectablStC','netStimatorMast','LocaSerRadiMast','netStimator','LocaSerRadi',...
                        'removStA','removStB','removStC','seconStA','seconStB','seconStC','maxLocSearStNumA','maxLocSearStNumB','maxLocSearStNumC')
                end
            end
        end
        step6zon123
        com3LocEvCBA.(dateEv)=[];
        sortComLocEvCBA.(dateEv)=[];
        if Zon(ni)==1
            %             minStatisDur=minStatisDurC; % connect to netDelayCal4
            com3LocEv.(dateEv)(:,7)=1;
            sortComLocEv.(dateEv)(:,7)=1;
            com3LocEvCBA.(dateEv)=com3LocEv.(dateEv);
            sortComLocEvCBA.(dateEv)=sortComLocEv.(dateEv);
        elseif Zon(ni)==2
            %             minStatisDur=minStatisDurB; % connect to netDelayCal4
            com3LocEv.(dateEv)(:,7)=2;
            sortComLocEv.(dateEv)(:,7)=2;
            com3LocEvCBA.(dateEv)=com3LocEv.(dateEv);
            sortComLocEvCBA.(dateEv)=sortComLocEv.(dateEv);
        elseif Zon(ni)==3
            %             minStatisDur=minStatisDurA; % connect to netDelayCal4
            com3LocEv.(dateEv)(:,7)=3;
            sortComLocEv.(dateEv)(:,7)=3;
            com3LocEvCBA.(dateEv)=com3LocEv.(dateEv);
            sortComLocEvCBA.(dateEv)=sortComLocEv.(dateEv);
        end
        display([' step 6  all stations checking finished']);
        pause(1);%10
        %         if sepZonOutput==1
        %             netDelayCal4sep
        if sepZonOutput~=2
            load('netDelayZon123')
        end
        if sepZonOutput==2
            sepZonOutput=1;% since in case we set 2 means we want to have both typ of outputs then in steps higher than finalOutputs we need to change name of the file
            step8zon123
            finalOutPutBackwardInTimeSelector
            outputControlerNet1
            outputControlerNet2
            outputControlerNet3
            outputControlerNet4
            outputControlerNet5
            outputControlerNet6
            sepZonOutput=2;
        elseif sepZonOutput==1
            step8zon123
            finalOutPutBackwardInTimeSelector
            outputControlerNet1
            outputControlerNet2
            outputControlerNet3
            outputControlerNet4
            outputControlerNet5
            outputControlerNet6
        end
        display([' step 8  day-division ',num2str(detecDivi),'  ',date,' finished']);
    end
end



