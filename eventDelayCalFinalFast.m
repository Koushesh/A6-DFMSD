
mCon=0;
mBox=[];
takeOffTheta=[];
tp=0;
ts=0;
dil=0;
minMisEpiP=[];
minMisEpiS=[];
minMisEpiPS=[];
minMinMisEpiPS=[];
degTakeOffTheta=[];
inciAngl=[];
degInciAngl=[];
misEpiP=[];
misEpiS=[];

rayNumMax=5000;%10000; 500% 2000
for Theta3=0:1/rayNumMax:pi/2% m=sin(Theta3)
    m=sin(Theta3);
    mCon=mCon+1;
    mBox(mCon)=m;
    misEpiP(mCon)=0;
    misEpiS(mCon)=0;
    for layer=depth:-1:1
        misEpiP(mCon)=misEpiP(mCon)+(velP(layer)/velP(depth))*(m/sqrt(1-((velP(layer)*m)/velP(depth))^2));
        misEpiS(mCon)=misEpiS(mCon)+(velS(layer)/velS(depth))*(m/sqrt(1-((velS(layer)*m)/velS(depth))^2));
    end
    misEpiP(mCon)=abs(misEpiP(mCon)-epi);
    misEpiS(mCon)=abs(misEpiS(mCon)-epi);
    
end
minMisEpiP=[find(misEpiP(:)==min(misEpiP)) min(misEpiP)];
minMisEpiS=[find(misEpiS(:)==min(misEpiS)) min(misEpiS)];

minMisEpiPS=[find(misEpiP(:)==min(misEpiP)) min(misEpiP);...
             find(misEpiS(:)==min(misEpiS)) min(misEpiS)];
dil=min(minMisEpiPS(:,2));
minMinMisEpiPS=[find(minMisEpiPS(:,2)==dil,1) dil];

if minMinMisEpiPS(1,1)==1
    takeOffTheta=asin(mBox(minMisEpiP(1)));
    degTakeOffTheta=takeOffTheta*360/(2*pi);
    inciAngl=asin((velP(1)/velP(depth))*mBox(minMisEpiP(1)));
    degInciAngl=inciAngl*360/(2*pi);
elseif minMinMisEpiPS(1,1)==2
    takeOffTheta=asin(mBox(minMisEpiS(1)));
    degTakeOffTheta=takeOffTheta*360/(2*pi);
    inciAngl=asin((velS(1)/velS(depth))*mBox(minMisEpiS(1)));
    degInciAngl=inciAngl*360/(2*pi);
end

for layer=depth:-1:1
    tp=tp+(1/(velP(layer)*sqrt(1-((velP(layer)/velP(depth))*sin(takeOffTheta))^2)));
    ts=ts+(1/(velS(layer)*sqrt(1-((velS(layer)/velS(depth))*sin(takeOffTheta))^2)));
end
