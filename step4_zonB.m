
for r=lta+2:BB %r=1:CC
    for sigTyp=1:numSigTyp
        sigNam=['typ',num2str(sigTyp)];
        meanSumSigBR=mean(sumSigB.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
        madSumSigBR=mad(sumSigB.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
        meanMadSumSigBR=meanSumSigBR+madSumSigBR;        
        conB=0;
        nB=0;
        % B = ZON-2
        for pa=sig.(sigNam)(1):sig.(sigNam)(2)-1   % -1 is new
            partFilB=['pa',num2str(pa),'B',num2str(pa)];
            frTherNamB=['B',num2str(pa)];
            if  me.(partFilB)(r)< mean(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))*magniAmp ...
                    ||  sumSigB.(sigNam)(r) < meanMadSumSigBR % NEW EDITION
                break
            end
            if me.(partFilB)(r) >= mean(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))*magniAmp ...
                    &&  sumSigB.(sigNam)(r) >= meanMadSumSigBR % NEW EDITION
                nB=nB+1;
                conB(nB)=me.(partFilB)(r);
            end
        end
        if nB== sig.(sigNam)(2)-sig.(sigNam)(1) % +1
            sigTypDisperB.(sigNam)(r,sigTyp)=std(conB)/mean(conB);
            evNumB=evNumB+1;
            localB(evNumB,1:4)=[r*locaWinB*delta;sigTyp;sigTypDisperB.(sigNam)(r,sigTyp); (sumSigB.(sigNam)(r)-meanSumSigBR)/madSumSigBR];
        end
    end
end