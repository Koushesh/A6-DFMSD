 

detectablSt

maxDetecnessA2B=0;
maxDetecnessA2Bst=0;
maxDetecnessA2B=max(A2B(1,detectablSt(1,1:length(detectablSt(1,:)))));
maxDetecnessA2Bst=find(A2B(1,:)==maxDetecnessA2B);

epi=targRadi+maxDetecnessA2B;
for zo=1:length(Zon(:))
    currentZon=Zon(zo);
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
    for pim=1:2
        if pim==1
            depth=seisZonDep1;
            eventDelayCalFinalFast
            dur1=ts-tp;
        elseif pim==2
            depth=seisZonDep2;
            eventDelayCalFinalFast
            dur2=ts-tp;
        end
    end
    locaDurMax(zo)=max(dur1,dur2);
end
locaDurMax;
%-------------------------------
% distace between stations relative to each other is calculated
netDisStimator1Mast=[];
netDisStimator2Mast=[];
netDisStimator3Mast=[];
netDisStimator3SortMast=[];
unicNetDisMast=[];
for ji=1:length(mastSt)
    con=0;
    jiVeci=[];
    for jo=1:length(mastSt)
        if ji~=jo
            con=con+1;
            netDisStimator1Mast(ji,con)=lldistkm(stInfo(mastSt(ji),2:3),stInfo(mastSt(jo),2:3));
        end
    end
end
netDisStimator1Mast;
netDisStimator2Mast=netDisStimator1Mast(:);
netDisStimator3Mast=netDisStimator2Mast(any(netDisStimator2Mast,2),:);
netDisStimator3SortMast=sortrows(netDisStimator3Mast,1);
unicNetDisMast=unique(netDisStimator3SortMast);

netStimatorMast=[];
LocaSerRadiMast=[];
for ji=1:length(mastSt)
    for i=1:length(unicNetDisMast(:,1))
        LocaSerRadiMast(mastSt(ji),1:2)=[mastSt(ji) unicNetDisMast(i,1)];
        
        con=0;
        jiVeci=[];
        for jo=1:length(mastSt)
            if lldistkm(stInfo(mastSt(ji),2:3),stInfo(mastSt(jo),2:3))<=LocaSerRadiMast(mastSt(ji),2) && lldistkm(stInfo(mastSt(ji),2:3),stInfo(mastSt(jo),2:3)) > 0.1 % 0.1 is a value to prevent acceptance of same position station as a vecinity station. this prevents from very very site local noise  wrong detection
                con=con+1;
                jiVeci(con)=mastSt(jo);
            end
        end
        if con>=maxLocSearStNum
            netStimatorMast(ji,1:2+con)=[mastSt(ji) con jiVeci(1:con)];
            
            break
        end
    end
end
netStimatorMast;
LocaSerRadiMast;

%---------------------------------------
% distace between stations relative to each other is calculated
netDisStimator1=[];
netDisStimator2=[];
netDisStimator3=[];
netDisStimator3Sort=[];
unicNetDis=[];
for ji=1:length(detectablSt)
    con=0;
    jiVeci=[];
    for jo=1:length(detectablSt)
        if ji~=jo
            con=con+1;
            netDisStimator1(ji,con)=lldistkm(stInfo(detectablSt(ji),2:3),stInfo(detectablSt(jo),2:3));
        end
    end
end
netDisStimator1;
netDisStimator2=netDisStimator1(:);
netDisStimator3=netDisStimator2(any(netDisStimator2,2),:);
netDisStimator3Sort=sortrows(netDisStimator3,1);
unicNetDis=unique(netDisStimator3Sort);


netStimator=[];
LocaSerRadi=[];
for ji=1:length(detectablSt)
    for i=1:length(unicNetDis(:,1))
        LocaSerRadi(detectablSt(ji),1:2)=[detectablSt(ji) unicNetDis(i,1)];
        
        con=0;
        jiVeci=[];
        for jo=1:length(detectablSt)
            if lldistkm(stInfo(detectablSt(ji),2:3),stInfo(detectablSt(jo),2:3))<=LocaSerRadi(detectablSt(ji),2) && lldistkm(stInfo(detectablSt(ji),2:3),stInfo(detectablSt(jo),2:3)) > 0.1 % 0.1 is a value to prevent acceptance of same position station as a vecinity station. this prevents from very very site local noise  wrong detection
                con=con+1;
                jiVeci(con)=detectablSt(jo);
            end
        end
        if con>=maxLocSearStNum
            netStimator(ji,1:2+con)=[detectablSt(ji) con jiVeci(1:con)];
            
            break
        end
    end
end
netStimator;
LocaSerRadi;



