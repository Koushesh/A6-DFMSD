
% detectedDiviPhase=['Divi',num2str(detecDivi),'Phase'];
detectedDiviLoc=['Divi',num2str(detecDivi),'Loc'];

% detected.(detectedDiviPhase)=[0 0];
detected.(detectedDiviLoc)=[0 0];

% loc
if sepZonOutput~=1
    %     Zon=123;
    partZon=num2str(Zon(1,1));
    for i=2:length(Zon(1,:))
        partZon=[partZon,num2str(Zon(1,i))];
    end
    dateEvTxt=[dateEv,'Zon-',partZon,'.txt'];
elseif sepZonOutput==1
    dateEvTxt=[dateEv,'Zon-',num2str(Zon(1,ni)),'.txt'];
end
fileID = fopen(dateEvTxt,'a');
iii=1;

for comEvNum=1:length(com3LocEvCBA.(dateEv)(:,1))%length(comUnic3LocEv.(dateEv)(:,1))
    stDet=[];
    stDet0=[];
    stDet1=[];
    filDet=0;
    comLocList=0;
    eve=com3LocEvCBA.(dateEv)(comEvNum,1);
    filDet= com3LocEvCBA.(dateEv)(comEvNum,4);
    evZon= com3LocEvCBA.(dateEv)(comEvNum,7);
    evDisper=com3LocEvCBA.(dateEv)(comEvNum,6);
    evMastSt=com3LocEvCBA.(dateEv)(comEvNum,2);
    if evZon==1
        iniSmoFacVici=iniSmoFacVici1;
        % disperVeciSel=disperVeciSelZon1;
        maxNegativPhasDelayMax=maxNegativPhasDelayMaxC;
        maxPositivPhasDelayMax=maxPositivPhasDelayMaxC;
        minNegativPhasDelayMin=minNegativPhasDelayMinC;
        minPositivPhasDelayMin=minPositivPhasDelayMinC;
    elseif evZon==2
        iniSmoFacVici=iniSmoFacVici2;
        % disperVeciSel=disperVeciSelZon2;
        maxNegativPhasDelayMax=maxNegativPhasDelayMaxB;
        maxPositivPhasDelayMax=maxPositivPhasDelayMaxB;
        minNegativPhasDelayMin=minNegativPhasDelayMinB;
        minPositivPhasDelayMin=minPositivPhasDelayMinB;
    elseif evZon==3
        iniSmoFacVici=iniSmoFacVici3;
        % disperVeciSel=disperVeciSelZon3;
        maxNegativPhasDelayMax=maxNegativPhasDelayMaxA;
        maxPositivPhasDelayMax=maxPositivPhasDelayMaxA;
        minNegativPhasDelayMin=minNegativPhasDelayMinA;
        minPositivPhasDelayMin=minPositivPhasDelayMinA;
    end
    ji=[];
    veciSt=[];
    ji=evMastSt;
    jiMatrPos=find(netStimator(:,1)==ji);
    veciSt(ji,1:netStimator(jiMatrPos,2))=netStimator(jiMatrPos,3:2+netStimator(jiMatrPos,2));

    for dif=1:length(veciSt(ji,:))
        daf=[];
        daf=veciSt(ji,dif);
        if daf~=0
            if filDet < 4
                if maxNegativPhasDelayMax(ji,daf) == -1000%if maxNegativPhasDelayMax(ji,daf) < 0
                    stDet0=sortComLocEvCBA.(dateEv)(find(sortComLocEvCBA.(dateEv)(:,1)>=eve+(minPositivPhasDelayMin(ji,daf)-timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,1)<=eve+(maxPositivPhasDelayMax(ji,daf)+timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,4)==filDet & sortComLocEvCBA.(dateEv)(:,6)>=evDisper-(evDisper*0.3061+0.113) ...
                        & sortComLocEvCBA.(dateEv)(:,6)<=evDisper+(evDisper*0.3061+0.113) & sortComLocEvCBA.(dateEv)(:,2)==evMastSt ...
                        & sortComLocEvCBA.(dateEv)(:,3)==daf),2:3);%& sortComLocEvCBA.(dateEv)(:,7)==evZon
                end
                if maxPositivPhasDelayMax(ji,daf) == -1000%if maxPositivPhasDelayMax(ji,daf) < 0
                    stDet0=sortComLocEvCBA.(dateEv)(find(sortComLocEvCBA.(dateEv)(:,1)>=eve-(maxNegativPhasDelayMax(ji,daf)+timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,1)<=eve-minNegativPhasDelayMin(ji,daf)+timErrPhDel...
                        & sortComLocEvCBA.(dateEv)(:,4)==filDet  & sortComLocEvCBA.(dateEv)(:,6)>=com3LocEvCBA.(dateEv)(comEvNum,6)-(evDisper*0.3061+0.113) ...
                        & sortComLocEvCBA.(dateEv)(:,6)<=com3LocEvCBA.(dateEv)(comEvNum,6)+(evDisper*0.3061+0.113) & sortComLocEvCBA.(dateEv)(:,2)==evMastSt...
                        & sortComLocEvCBA.(dateEv)(:,3)==daf),2:3);%& sortComLocEvCBA.(dateEv)(:,7)==evZon
                end
                if maxNegativPhasDelayMax(ji,daf) >= 0 &&  maxPositivPhasDelayMax(ji,daf) >= 0
                    stDet0=sortComLocEvCBA.(dateEv)(find(sortComLocEvCBA.(dateEv)(:,1)>=eve-(maxNegativPhasDelayMax(ji,daf)+timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,1)<=eve+(maxPositivPhasDelayMax(ji,daf)+timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,4)==filDet  & sortComLocEvCBA.(dateEv)(:,6)>=com3LocEvCBA.(dateEv)(comEvNum,6)-(evDisper*0.3061+0.113) ...
                        & sortComLocEvCBA.(dateEv)(:,6)<=com3LocEvCBA.(dateEv)(comEvNum,6)+(evDisper*0.3061+0.113) & sortComLocEvCBA.(dateEv)(:,2)==evMastSt...
                        & sortComLocEvCBA.(dateEv)(:,3)==daf),2:3);%& sortComLocEvCBA.(dateEv)(:,7)==evZon
                end
            end
            if filDet > 3
                if maxNegativPhasDelayMax(ji,daf) == -1000%if maxNegativPhasDelayMax(ji,daf) < 0
                    stDet0=sortComLocEvCBA.(dateEv)(find(sortComLocEvCBA.(dateEv)(:,1)>=eve+(minPositivPhasDelayMin(ji,daf)-timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,1)<=eve+(maxPositivPhasDelayMax(ji,daf)+timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,4)==filDet & sortComLocEvCBA.(dateEv)(:,6)>=evDisper-1.6^(-evDisper-iniSmoFacVici) ...
                        & sortComLocEvCBA.(dateEv)(:,6)<=evDisper+1.6^(-evDisper-iniSmoFacVici) & sortComLocEvCBA.(dateEv)(:,2)==evMastSt ...
                        & sortComLocEvCBA.(dateEv)(:,3)==daf),2:3);%& sortComLocEvCBA.(dateEv)(:,7)==evZon
                end
                if maxPositivPhasDelayMax(ji,daf) == -1000%if maxPositivPhasDelayMax(ji,daf) < 0
                    stDet0=sortComLocEvCBA.(dateEv)(find(sortComLocEvCBA.(dateEv)(:,1)>=eve-(maxNegativPhasDelayMax(ji,daf)+timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,1)<=eve-minNegativPhasDelayMin(ji,daf)+timErrPhDel...
                        & sortComLocEvCBA.(dateEv)(:,4)==filDet  & sortComLocEvCBA.(dateEv)(:,6)>=com3LocEvCBA.(dateEv)(comEvNum,6)-1.6^(-evDisper-iniSmoFacVici) ...
                        & sortComLocEvCBA.(dateEv)(:,6)<=com3LocEvCBA.(dateEv)(comEvNum,6)+1.6^(-evDisper-iniSmoFacVici) & sortComLocEvCBA.(dateEv)(:,2)==evMastSt...
                        & sortComLocEvCBA.(dateEv)(:,3)==daf),2:3);%& sortComLocEvCBA.(dateEv)(:,7)==evZon
                end
                if maxNegativPhasDelayMax(ji,daf) >= 0 &&  maxPositivPhasDelayMax(ji,daf) >= 0
                    stDet0=sortComLocEvCBA.(dateEv)(find(sortComLocEvCBA.(dateEv)(:,1)>=eve-(maxNegativPhasDelayMax(ji,daf)+timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,1)<=eve+(maxPositivPhasDelayMax(ji,daf)+timErrPhDel)...
                        & sortComLocEvCBA.(dateEv)(:,4)==filDet  & sortComLocEvCBA.(dateEv)(:,6)>=com3LocEvCBA.(dateEv)(comEvNum,6)-1.6^(-evDisper-iniSmoFacVici) ...
                        & sortComLocEvCBA.(dateEv)(:,6)<=com3LocEvCBA.(dateEv)(comEvNum,6)+1.6^(-evDisper-iniSmoFacVici) & sortComLocEvCBA.(dateEv)(:,2)==evMastSt...
                        & sortComLocEvCBA.(dateEv)(:,3)==daf),2:3);%& sortComLocEvCBA.(dateEv)(:,7)==evZon
                end
            end
        end
        stDet1=[stDet1;stDet0];
    end
    stDet1=stDet1(any(stDet1,2),:);
    stDet1=stDet1';
    stDet= reshape(stDet1,[],1);
    [bp,ip,jp]=unique(stDet, 'first');
    stDet=stDet(sort(ip));

    comLocList=[str2num(date);str2num(hourBeg)+fix((fix(fix(eve+cutPar)/60)+str2num(minutBeg))/60);rem((fix(fix(eve+cutPar)/60)+str2num(minutBeg)),60);rem(fix(eve+cutPar),60)];

    if (filDet==1 && length(stDet)>=minLocSearCohStNum+1) || (filDet~=1 && length(stDet)>=minLocSearCohStNum)
        detected.(detectedDiviLoc)(iii,1:2)=[eve+str2num(hourBeg)*3600+str2num(minutBeg)*60+cutPar;length(stDet)];
        iii=iii+1;
        fprintf(fileID,'%8d  %2d:%2d:%2d  %2d st: %2d ',comLocList,length(stDet),stDet(1));
        for ggg=2:length(stDet)-1
            fprintf(fileID,'%2d ',stDet(ggg));
        end
        fprintf(fileID,'%2d F:%3d FD: %.2f Z: %d\n',stDet(end),filDet,evDisper,evZon);
    end
end
pause(1);


dateEvDetec=[dateEv,'Detec'];
if sepZonOutput==2
    save('detected','detected')
    save(dateEvDetec,'com3LocEvCBA','sortComLocEvCBA','cutPar','year','monthBeg','monthEnd','dayBeg','hourBeg','minutBeg','hourEnd','minutEnd'); %,'sortComEifEv','comEifList','eifelicFrBand'
end


fclose(fileID)