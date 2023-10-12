% classification (averaging time windows which is applied for
% all 4 wave classes) based on event zon Energy spriding duration
locaWinC=0;
locaWinB=0;
locaWinA=0;
CC=0;
BB=0;
AA=0;
for i=1:length(Zon(1,:))
    if Zon(i)==1
        load('minStatisDurZon-1')
        locaWinC=fix(minStatisDurC/delta);
    elseif Zon(i)==2
        load('minStatisDurZon-2')
        locaWinB=fix(minStatisDurB/delta);
    elseif Zon(i)==3
        load('minStatisDurZon-3')
        locaWinA=fix(minStatisDurA/delta);
    end
end
BP.type='bandpass';
BP.order=3;
for pa=diviFrq(1,1):diviFrq(1,2)
    for j=1:3
        if j==1
            compo='Z';
        elseif j==2
            compo='N';
        else
            compo='E';
        end
        
        noEqual=min([length(wave.Z.vel) length(wave.N.vel) length(wave.E.vel)]);
        wave.Z.trace = wave.(compo).vel(1:noEqual);
        
        if pa==1
            BP.Fhz=[monoBanList(1,1) monoBanList(1,2)];%beginFr
        elseif pa==2
            BP.Fhz=[monoBanList(1,2) monoBanList(1,3)];
        elseif pa==3
            BP.Fhz=[monoBanList(1,3) monoBanList(1,4)];
        elseif pa==4
            BP.Fhz=[monoBanList(1,4) monoBanList(1,5)];
        elseif pa==5
            BP.Fhz=[monoBanList(1,5) monoBanList(1,6)];
        elseif pa==6
            BP.Fhz=[monoBanList(1,6) monoBanList(1,7)];
        elseif pa==7
            BP.Fhz=[monoBanList(1,7) monoBanList(1,8)];
        elseif pa==8
            BP.Fhz=[monoBanList(1,8) monoBanList(1,9)];
        elseif pa==9
            BP.Fhz=[monoBanList(1,9) monoBanList(1,10)];
        elseif pa==10
            BP.Fhz=[monoBanList(1,10) monoBanList(1,11)];
        elseif pa==11
            BP.Fhz=[monoBanList(1,11) monoBanList(1,12)];
        elseif pa==12
            BP.Fhz=[monoBanList(1,12) monoBanList(1,13)];
        elseif pa==13
            BP.Fhz=[monoBanList(1,13) monoBanList(1,14)];
        elseif pa==14
            BP.Fhz=[monoBanList(1,14) monoBanList(1,15)];
        elseif pa==15
            BP.Fhz=[monoBanList(1,15) monoBanList(1,16)];
        elseif pa==16
            BP.Fhz=[monoBanList(1,16) monoBanList(1,17)];
        elseif pa==17
            BP.Fhz=[monoBanList(1,17) monoBanList(1,18)];
        elseif pa==18
            BP.Fhz=[monoBanList(1,18) monoBanList(1,19)];
        elseif pa==19
            BP.Fhz=[monoBanList(1,19) monoBanList(1,20)];
        elseif pa==20
            BP.Fhz=[monoBanList(1,20) monoBanList(1,21)];
        elseif pa==21
            BP.Fhz=[monoBanList(1,21) monoBanList(1,22)];
        elseif pa==22
            BP.Fhz=[monoBanList(1,22) monoBanList(1,23)];
        elseif pa==23
            BP.Fhz=[monoBanList(1,23) monoBanList(1,24)];
        elseif pa==24
            BP.Fhz=[monoBanList(1,24) monoBanList(1,25)];
        elseif pa==25
            BP.Fhz=[monoBanList(1,25) monoBanList(1,26)];
        elseif pa==26
            BP.Fhz=[monoBanList(1,26) monoBanList(1,27)];
        elseif pa==27
            BP.Fhz=[monoBanList(1,27) monoBanList(1,28)];
        elseif pa==28
            BP.Fhz=[monoBanList(1,28) monoBanList(1,29)];
        elseif pa==29
            BP.Fhz=[monoBanList(1,29) monoBanList(1,30)];
%         elseif pa==30
%             BP.Fhz=[monoBanList(1,30) monoBanList(1,31)];
%         elseif pa==31
%             BP.Fhz=[monoBanList(1,31) monoBanList(1,32)];
%         elseif pa==32
%             BP.Fhz=[monoBanList(1,32) monoBanList(1,33)];
        end
        compoPartFil=[compo,'pa',num2str(pa)];
        wave.(compoPartFil).trace=0;
        % bandpassing
        maxfreq=(0.5*(1/max([wave.Z.delta])));
        if BP.Fhz(2)>=maxfreq
            disp(' ')
            disp(['Upper corner of BP (' num2str(BP.Fhz(2)) ' Hz) is to high for sample rate!!'])
            BP.Fhz(2)=0.9*maxfreq;
            disp(['Adjusting upper corner frequency to ' num2str(BP.Fhz(2)) ' Hz!'])
            disp(' ')
        end
        wave.(compoPartFil)=filterbuttertimedomainzerophasedata(wave.Z,BP);
        wave.(compoPartFil)=demeandata(wave.(compoPartFil));
        wave.(compoPartFil)=detrenddata(wave.(compoPartFil));
        %-----------------------------------------------------------------------
        % cutting 1
        L = length(wave.(compoPartFil).trace);
        wave.(compoPartFil).trace= wave.(compoPartFil).trace(cutPar/delta:end-cutPar/delta);
        % writing new trace-length in "npts", to support
        % other function operations and requirenments
        wave.(compoPartFil).npts = length(wave.(compoPartFil).trace);
    end
    sqrPowPartFil=['sqPwPa',num2str(pa)];
    wave.(sqrPowPartFil)=[];
    zPartFil=['Zpa',num2str(pa)];
    nPartFil=['Npa',num2str(pa)];
    ePartFil=['Epa',num2str(pa)];
    wave.(sqrPowPartFil)=wave.(zPartFil).trace.^2+wave.(nPartFil).trace.^2+wave.(ePartFil).trace.^2;
    wave.(zPartFil)=[];
    wave.(nPartFil)=[];
    wave.(ePartFil)=[];
    
    if pa==diviFrq(1,1)
        %         %to speed up
        if locaWinC~=0
            CC=fix(length(wave.(sqrPowPartFil))/locaWinC);
        end
        if locaWinB~=0
            BB=fix(length(wave.(sqrPowPartFil))/locaWinB);
        end
        if locaWinA~=0
            AA=fix(length(wave.(sqrPowPartFil))/locaWinA);
        end
    end
    
    %beginning of windowing
    % C
    if locaWinC~=0
        partFilC=['pa',num2str(pa),'C',num2str(pa)];
        me.(partFilC)=[];
        me.(partFilC)(1:CC)=0;
        for n=0:CC-1
            me.(partFilC)(n+1)=sum(wave.(sqrPowPartFil)(n*locaWinC+1:(n+1)*locaWinC)); % mean(wave.(sqrPowPartFil)(n*locaWin+1:(n+1)*locaWin));
        end
    end
    % B
    if locaWinB~=0
        partFilB=['pa',num2str(pa),'B',num2str(pa)];
        me.(partFilB)=[];
        me.(partFilB)(1:BB)=0;
        for n=0:BB-1
            me.(partFilB)(n+1)=sum(wave.(sqrPowPartFil)(n*locaWinB+1:(n+1)*locaWinB)); % mean(wave.(sqrPowPartFil)(n*locaWin+1:(n+1)*locaWin));
        end
    end
    % A
    if locaWinA~=0
        partFilA=['pa',num2str(pa),'A',num2str(pa)];
        me.(partFilA)=[];
        me.(partFilA)(1:AA)=0;
        for n=0:AA-1
            me.(partFilA)(n+1)=sum(wave.(sqrPowPartFil)(n*locaWinA+1:(n+1)*locaWinA)); % mean(wave.(sqrPowPartFil)(n*locaWin+1:(n+1)*locaWin));
        end
    end
    wave.(sqrPowPartFil)=[];
end

