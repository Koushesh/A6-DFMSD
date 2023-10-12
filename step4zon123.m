


for sigTyp=1:numSigTyp
    sigNam=['typ',num2str(sigTyp)];
    sumSigA.(sigNam)=[];
    sumSigB.(sigNam)=[];
    sumSigC.(sigNam)=[];
    sumSigA.(sigNam)(1:length(me.(partFilA)))=0;
    sumSigB.(sigNam)(1:length(me.(partFilB)))=0;
    sumSigC.(sigNam)(1:length(me.(partFilC)))=0;
    for pa=sig.(sigNam)(1):sig.(sigNam)(2)-1   % -1 is new
        partFilA=['pa',num2str(pa),'A',num2str(pa)];
        partFilB=['pa',num2str(pa),'B',num2str(pa)];
        partFilC=['pa',num2str(pa),'C',num2str(pa)];
        if locaWinA~=0
            sumSigA.(sigNam)=sumSigA.(sigNam)+me.(partFilA);
        end
        if locaWinB~=0
            sumSigB.(sigNam)=sumSigB.(sigNam)+me.(partFilB);
        end
        if locaWinC~=0
            sumSigC.(sigNam)=sumSigC.(sigNam)+me.(partFilC);
        end
    end
end
if lta==0
    ltaShif=1;
else
    ltaShif=0;
end
localA=[0 0 0 0];
localB=[0 0 0 0];
localC=[0 0 0 0];
evNumA=0;%for each day it should become 0
evNumB=0;%for each day it should become 0
evNumC=0;%for each day it should become 0
if length(Zon(:))==3
    step4_zonABC
end
if length(Zon(:))==2
    if min(Zon(:))==1 && max(Zon(:))==2
        step4_zonBC
    end
    if min(Zon(:))==2 && max(Zon(:))==3
        step4_zonAB
    end
    if min(Zon(:))==1 && max(Zon(:))==3
        step4_zonAC
    end
end
if length(Zon(:))==1
    if Zon==1
        step4_zonC
    elseif Zon==2
        step4_zonB
    elseif Zon==3
        step4_zonA
    end
end
save(stDate,'localA','localB','localC')
