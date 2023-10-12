
ji=find(A2B(:)==max(A2B));
A2Bdeg=sqrt((stInfo(ji,2)-targCen(1,1))^2+(stInfo(ji,3)-targCen(1,2))^2);
rDeg=targRadi*A2Bdeg/lldistkm(stInfo(ji,2:3),targCen(1:2));
sorPosGmt=[];
sorPos=[];
sorPos(1,1:2)=targCen;

sorNumInPart=[];
so=1;

targRadiParti=round(targRadi/minSor2sorDis,0)+1;
sorcNumb=round(pi*targRadiParti^2,0)+targRadiParti
fracSoNumb=[];
for sam=0:targRadiParti-1
    if sam <=targRadiParti-2
        sorNumInPart(sam+1)=round(((1-(sam/targRadiParti))^2-(1-((sam+1)/targRadiParti))^2)*sorcNumb,0)-1;   %     sorNumInPart(sam+1)=round(((1-(sam/targRadiParti))^2-(1-((sam+1)/targRadiParti))^2)*sorcNumb,0)-1;
    end
    if sam==targRadiParti-1
        sorNumInPart(sam+1)=sorcNumb-sum(sorNumInPart);
    end
    for so=so:so+sorNumInPart(sam+1)
        fracSoNumb=sorNumInPart(sam+1);
        sorPos(so+1,1:2)=[(1-(sam/targRadiParti))*rDeg*sin(so*2*pi/fracSoNumb)+targCen(1,1)  (1-(sam/targRadiParti))*rDeg*cos(so*2*pi/fracSoNumb)+targCen(1,2)];%(1/(sam+1))*rDeg  (1-(1/(10^((targRadiParti-sam)/(targRadiParti+2)))))*rDeg
    end
end
stAsSorc=find(A2B(:)<=targRadi);
ssNumb=length(stAsSorc)
coJBin=0;
for ss=1:ssNumb
    j=stAsSorc(ss);
    jBin=[];
    jBin=find(stInvolvStatisticCal4LocalDurMin(:)==j);
    if isempty(jBin)~=1
        coJBin=coJBin+1;
        sorPos(so+1+coJBin,1:2)=stInfo(j,2:3);
    end
end
sorPosGmt(1:length(sorPos(:,1)),1)=sorPos(:,2); sorPosGmt(1:length(sorPos(:,1)),2)=sorPos(:,1);
%--------------------------this part is run once if st2stPhDelayZon() is not located in the same path
meanStdNegativPhasDelayMaxDepth12Zon1Ex=[];
meanStdNegativPhasDelayMaxDepth12Zon2Ex=[];
meanStdNegativPhasDelayMaxDepth12Zon3Ex=[];

for sio=1:length(Zon(:))
    currentZon=Zon(sio);
    if currentZon==1
        seisZonDep1=targDep1(1);
        seisZonDep2=targDep2(1);
    elseif currentZon==2
        seisZonDep1=targDep1(2);
        seisZonDep2=targDep2(2);
    elseif currentZon==3
        seisZonDep1=targDep1(3);
        seisZonDep2=targDep2(3);
    end
    
    st2stPhDelayZon=['st2stPhDelayZon-',num2str(currentZon),'.mat'];
    locaDurStaticMinZon=['minStatisDurZon-',num2str(currentZon),'.mat'];
    if exist( st2stPhDelayZon, 'file' ) ~= 2
        TsMinusTp=[];%new
        dam=0;%new
        sor2st=[];
        j=[];
        for dal=1:length(stInfo(:,1))
            j=stInfo(dal,1);
            for i=1:sorcNumb+1+coJBin
                sor2st(j,i)=lldistkm(stInfo(j,2:3),sorPos(i,1:2));
                epi=sor2st(j,i);
                for po=1:2
                    if po==1
                        depth=seisZonDep1;
                    elseif po==2
                        depth=seisZonDep2;
                    end
                    eventDelayCalFinalFast
                    Tp(j,i,po)=tp;
                    Ts(j,i,po)=ts;
                    if po==1 && isempty(find(stInvolvStatisticCal4LocalDurMin(:)==j))==0%new
                        dam=dam+1;%new
                        TsMinusTp(dam)= Ts(j,i,po)-Tp(j,i,po);%new
                    end%new
                end
            end
        end
        %--- added to cal localDurMin statisticaly
        gMeanTsMinusTp=[];%new
        MeanTsMinusTp=[];%new
        gMeanTsMinusTpMinusGStd=[];%new
        MeanTsMinusTpMinusStd=[];%new
        minStatisDur=[];
        gMeanTsMinusTp=geomean(TsMinusTp);%new
        MeanTsMinusTp=mean(TsMinusTp);%new
        gMeanTsMinusTpMinusGStd=geomean(TsMinusTp)-geostd(TsMinusTp);%new
        MeanTsMinusTpMinusStd=mean(TsMinusTp)-std(TsMinusTp);%new
        if currentZon==1
            minStatisDurC=gMeanTsMinusTpMinusGStd
            save(locaDurStaticMinZon,'minStatisDurC')
            minStatisDur=minStatisDurC;
        elseif currentZon==2
            minStatisDurB=gMeanTsMinusTpMinusGStd
            save(locaDurStaticMinZon,'minStatisDurB')
            minStatisDur=minStatisDurB;
        elseif currentZon==3
            minStatisDurA=gMeanTsMinusTpMinusGStd
            save(locaDurStaticMinZon,'minStatisDurA')
            minStatisDur=minStatisDurA;
        end
        lta=sig2NoisWinLenRatio-1%15    30 13. not less than 2. 0 means we do not want to consider any event gap. best value is fix(minPeriodSourceActivity/minStatisDur) =fix(5/0.4)
        %         lta=round(minEvSep/minStatisDur)-1%15    30 13. not less than 2. 0 means we do not want to consider any event gap. best value is fix(minPeriodSourceActivity/minStatisDur) =fix(5/0.4)
        display(['minimum event separation in time set to the closest discreted value of: ', num2str(lta*minStatisDur+minStatisDur),' sec. In practice, lta becomes ',num2str(lta+1),'means, such number of window (practical lta) before considering wondow is compared to the considering window ']);
        
        
        %---------
        for po=1:2
            namPo1=['po',num2str(po),'1'];
            namPo2=['po',num2str(po),'2'];
            tstpTargStVeciSt.(namPo1)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
            tstpTargStVeciSt.(namPo2)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
            negativPhasDelayMax.(namPo1)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
            negativPhasDelayMax.(namPo2)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
            positivPhasDelayMax.(namPo1)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
            positivPhasDelayMax.(namPo2)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
            negativPhasDelayMin.(namPo1)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
            negativPhasDelayMin.(namPo2)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
            positivPhasDelayMin.(namPo1)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
            positivPhasDelayMin.(namPo2)(1:max(stInfo(:,1)),1:max(stInfo(:,1)),1:sorcNumb+1+coJBin)=-1000;
        end
        maxNegativPhasDelayMaxExact(1:max(stInfo(:,1)),1:max(stInfo(:,1)))=-1000;
        maxPositivPhasDelayMaxExact(1:max(stInfo(:,1)),1:max(stInfo(:,1)))=-1000;
        minNegativPhasDelayMinExact(1:max(stInfo(:,1)),1:max(stInfo(:,1)))=-1000;
        minPositivPhasDelayMinExact(1:max(stInfo(:,1)),1:max(stInfo(:,1)))=-1000;
        maxNegativPhasDelayMax(1:max(stInfo(:,1)),1:max(stInfo(:,1)))=-1000;
        maxPositivPhasDelayMax(1:max(stInfo(:,1)),1:max(stInfo(:,1)))=-1000;
        minNegativPhasDelayMin(1:max(stInfo(:,1)),1:max(stInfo(:,1)))=-1000;
        minPositivPhasDelayMin(1:max(stInfo(:,1)),1:max(stInfo(:,1)))=-1000;%-1;
        
        for dal=1:length(stInfo(:,1))%for dal=1:length(detecnessSt(1,:))
            j=stInfo(dal,1);
            %     jMatrPos=find(netStimator(:,1)==j);
            %     veciSt(j,1:netStimator(jMatrPos,2))=netStimator(jMatrPos,3:2+netStimator(jMatrPos,2));
            for dif=1:length(stInfo(:,1))%for dif=1:netStimator(jMatrPos,2)
                daf=stInfo(dif,1);
                if j~=daf
                    for i=1:sorcNumb+1+coJBin
                        for po=1:2
                            namPo1=['po',num2str(po),'1'];% '1' connected to S and '2' connected to P. it is not something relevant to 'po' ! be careful not to remove it later or mixt up
                            namPo2=['po',num2str(po),'2'];
                            tstpTargStVeciSt.(namPo1)(j,daf,i)=Ts(j,i,po)-Ts(daf,i,po);
                            tstpTargStVeciSt.(namPo2)(j,daf,i)=Tp(j,i,po)-Tp(daf,i,po);
                            %s check
                            if tstpTargStVeciSt.(namPo1)(j,daf,i) > 0
                                negativPhasDelayMax.(namPo1)(j,daf,i)=Ts(j,i,po)-Tp(daf,i,po);
                                negativPhasDelayMin.(namPo1)(j,daf,i)=Ts(j,i,po)-Ts(daf,i,po);
                            end
                            if tstpTargStVeciSt.(namPo1)(j,daf,i) < 0
                                positivPhasDelayMax.(namPo1)(j,daf,i)=Ts(daf,i,po)-Tp(j,i,po);
                                positivPhasDelayMin.(namPo1)(j,daf,i)=Ts(daf,i,po)-Ts(j,i,po);
                            end
                            if tstpTargStVeciSt.(namPo1)(j,daf,i) == 0
                                negativPhasDelayMax.(namPo1)(j,daf,i)=0;
                                positivPhasDelayMax.(namPo1)(j,daf,i)=0;
                                negativPhasDelayMin.(namPo1)(j,daf,i)=0;
                                positivPhasDelayMin.(namPo1)(j,daf,i)=0;
                            end
                            %p check
                            if tstpTargStVeciSt.(namPo2)(j,daf,i) > 0
                                negativPhasDelayMax.(namPo2)(j,daf,i)=Ts(j,i,po)-Tp(daf,i,po);
                                negativPhasDelayMin.(namPo2)(j,daf,i)=Tp(j,i,po)-Tp(daf,i,po);
                            end
                            if tstpTargStVeciSt.(namPo2)(j,daf,i) < 0
                                positivPhasDelayMax.(namPo2)(j,daf,i)=Ts(daf,i,po)-Tp(j,i,po);
                                positivPhasDelayMin.(namPo2)(j,daf,i)=Tp(daf,i,po)-Tp(j,i,po);
                            end
                            if tstpTargStVeciSt.(namPo2)(j,daf,i) == 0
                                negativPhasDelayMax.(namPo2)(j,daf,i)=0;
                                positivPhasDelayMax.(namPo2)(j,daf,i)=0;
                                negativPhasDelayMin.(namPo2)(j,daf,i)=0;
                                positivPhasDelayMin.(namPo2)(j,daf,i)=0;
                            end
                        end
                    end
                    h1=[]; h2=[];h3=[]; h4=[];
                    h1(:,1)=negativPhasDelayMax.po11(j,daf,:);
                    h2(:,1)= positivPhasDelayMax.po11(j,daf,:);
                    h3(:,1)=negativPhasDelayMin.po11(j,daf,:);
                    h4(:,1)=positivPhasDelayMin.po11(j,daf,:);
                    
                    h1(:,2)=negativPhasDelayMax.po12(j,daf,:);
                    h2(:,2)= positivPhasDelayMax.po12(j,daf,:);
                    h3(:,2)=negativPhasDelayMin.po12(j,daf,:);
                    h4(:,2)=positivPhasDelayMin.po12(j,daf,:);
                    
                    h1(:,3)=negativPhasDelayMax.po22(j,daf,:);
                    h2(:,3)= positivPhasDelayMax.po22(j,daf,:);
                    h3(:,3)=negativPhasDelayMin.po22(j,daf,:);
                    h4(:,3)=positivPhasDelayMin.po22(j,daf,:);
                    
                    h1(:,4)=negativPhasDelayMax.po21(j,daf,:);
                    h2(:,4)= positivPhasDelayMax.po21(j,daf,:);
                    h3(:,4)=negativPhasDelayMin.po21(j,daf,:);
                    h4(:,4)=positivPhasDelayMin.po21(j,daf,:);
                    
                    if j==1 && daf==6
                        strango=h1
                    end
                    
                    %                     koop=[];
                    if currentZon==1
%                         if isnan(mean(h1(h1~=-1000)) + std(h1(h1~=-1000)))==1
%                             meanStdMaxMinusPhDelDepth12Zon1Ex(j,daf)=0;%
%                         else
                            meanStdNegativPhasDelayMaxDepth12Zon1Ex(j,daf)=mean(h1(h1~=-1000)) + std(h1(h1~=-1000)); % since in matlab max([NaN 0 2]) -> = 2. then NaN values are egnored. but you can force here to replace NaN to 0. I did not
                            
%                         end
                    elseif currentZon==2
%                         if isnan(mean(h1(h1~=-1000)) + std(h1(h1~=-1000)))==1
%                             meanStdMaxMinusPhDelDepth12Zon2Ex(j,daf)=0;
%                         else
                            meanStdNegativPhasDelayMaxDepth12Zon2Ex(j,daf)=mean(h1(h1~=-1000)) + std(h1(h1~=-1000));
                            
%                         end
                    elseif currentZon==3
%                         if isnan(mean(h1(h1~=-1000)) + std(h1(h1~=-1000)))==1
%                             meanStdMaxMinusPhDelDepth12Zon3Ex(j,daf)=0;
%                         else
                            meanStdNegativPhasDelayMaxDepth12Zon3Ex(j,daf)=mean(h1(h1~=-1000)) + std(h1(h1~=-1000));
                            
%                         end
                    end
                    
                    
                    h11=[]; h22=[]; h33=[]; h44=[];
                    %---  -1000 should not be removed from array, because -1000 is a criteria in step6 and 8 to decide to apply which condion in event detection
                    %         h11=h1(h1~=-1000); it can be applied the same system of allocation value -1000 to the empty results as was done in next lines in h33 and h44
                    %         h22=h2(h2~=-1000);
                    h11=h1;
                    h22=h2;
                    %------------
                    h33=h3(h3~=-1000);
                    h44=h4(h4~=-1000);
                    %--
                    maxNegativPhasDelayMaxExact(j,daf)=max(h11(:));%==max(max(h11))
                    maxPositivPhasDelayMaxExact(j,daf)=max(h22(:));
                    if j~=daf
                        if isempty(min(h33(:)))==1
                            minNegativPhasDelayMinExact(j,daf)=-1000;
                        else
                            minNegativPhasDelayMinExact(j,daf)=min(h33(:));
                        end
                        if isempty(min(h44(:)))==1
                            minPositivPhasDelayMinExact(j,daf)=-1000;
                        else
                            minPositivPhasDelayMinExact(j,daf)=min(h44(:));
                        end
                    end
                    if j==daf
                        maxNegativPhasDelayMax(j,daf)=0;%here if dis j and daf separation was not done then for j==daf state a dleay equal to minStatisDur is applied, only when j==daf
                        maxPositivPhasDelayMax(j,daf)=0;%(round(maxPositivPhasDelayMaxExact(j,daf)/minStatisDur,0))*minStatisDur
                        
                        minNegativPhasDelayMin(j,daf)=0;
                        minPositivPhasDelayMin(j,daf)=0;
                    end
                    %latest edition replace round(  ,0) by fix
                    if j~=daf
                        if maxNegativPhasDelayMaxExact(j,daf)~=-1000
                            maxNegativPhasDelayMax(j,daf)=(fix(maxNegativPhasDelayMaxExact(j,daf)/minStatisDur)+1)*minStatisDur;
                        end
                        if maxPositivPhasDelayMaxExact(j,daf)~=-1000
                            maxPositivPhasDelayMax(j,daf)=(fix(maxPositivPhasDelayMaxExact(j,daf)/minStatisDur)+1)*minStatisDur;
                        end
                        if minNegativPhasDelayMinExact(j,daf)~=-1000
                            if minNegativPhasDelayMinExact(j,daf) < 0
                                minNegativPhasDelayMin(j,daf)=(fix(minNegativPhasDelayMinExact(j,daf)/minStatisDur)-1)*minStatisDur;%latest addition
                            else
                                minNegativPhasDelayMin(j,daf)=(fix(minNegativPhasDelayMinExact(j,daf)/minStatisDur))*minStatisDur;
                            end
                        end
                        if minPositivPhasDelayMinExact(j,daf)~=-1000
                            if minPositivPhasDelayMinExact(j,daf) < 0
                                minPositivPhasDelayMin(j,daf)=(fix(minPositivPhasDelayMinExact(j,daf)/minStatisDur)-1)*minStatisDur;
                            else
                                minPositivPhasDelayMin(j,daf)=(fix(minPositivPhasDelayMinExact(j,daf)/minStatisDur))*minStatisDur;
                            end
                        end
                    end
                end
            end
        end
        save(st2stPhDelayZon,'maxNegativPhasDelayMaxExact','minNegativPhasDelayMinExact','maxNegativPhasDelayMax','minNegativPhasDelayMin'...
            ,'maxPositivPhasDelayMaxExact','minPositivPhasDelayMinExact','maxPositivPhasDelayMax','minPositivPhasDelayMin',...
            'negativPhasDelayMax','positivPhasDelayMax','negativPhasDelayMin','positivPhasDelayMin')
        
    end
   
    fo=0;
    phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus=[];
    phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact=[];
    for dal=1:length(stInfo(:,1))
        j=stInfo(dal,1);
        for dif=1:length(stInfo(:,1))
            daf=stInfo(dif,1);
            fo=fo+1;
            phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,1:6)=[j daf maxNegativPhasDelayMaxExact(j,daf) ...
                minNegativPhasDelayMinExact(j,daf) minPositivPhasDelayMinExact(j,daf) maxPositivPhasDelayMaxExact(j,daf)];
            phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,1:6)=[j daf maxNegativPhasDelayMax(j,daf) ...
                minNegativPhasDelayMin(j,daf) minPositivPhasDelayMin(j,daf) maxPositivPhasDelayMax(j,daf)];
        end
    end
    phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact;
    phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus;
end

save('netDelayZon123','meanStdNegativPhasDelayMaxDepth12Zon1Ex',... 
    'meanStdNegativPhasDelayMaxDepth12Zon2Ex',... 
    'meanStdNegativPhasDelayMaxDepth12Zon3Ex') 