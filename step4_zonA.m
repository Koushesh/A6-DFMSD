
for r=lta+2:AA %r=1:CC
    for sigTyp=1:numSigTyp
        sigNam=['typ',num2str(sigTyp)];
        meanSumSigAR=mean(sumSigA.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
        madSumSigAR=mad(sumSigA.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
        meanMadSumSigAR=meanSumSigAR+madSumSigAR;
        conA=0;
        nA=0;
        % A = ZON-3
        for pa=sig.(sigNam)(1):sig.(sigNam)(2)-1   % -1 is new
            partFilA=['pa',num2str(pa),'A',num2str(pa)];
            frTherNamA=['A',num2str(pa)];
            if  me.(partFilA)(r)< mean(me.(partFilA)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilA)(r-1+ltaShif-lta:r-1+ltaShif))*magniAmp ...
                    ||  sumSigA.(sigNam)(r) < meanMadSumSigAR % NEW EDITION
                break
            end
            if me.(partFilA)(r) >= mean(me.(partFilA)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilA)(r-1+ltaShif-lta:r-1+ltaShif))*magniAmp ...
                    &&  sumSigA.(sigNam)(r) >= meanMadSumSigAR % NEW EDITION
                nA=nA+1;
                conA(nA)=me.(partFilA)(r);
            end
        end
        if nA== sig.(sigNam)(2)-sig.(sigNam)(1) % +1
            sigTypDisperA.(sigNam)(r,sigTyp)=std(conA)/mean(conA);
            evNumA=evNumA+1;
            localA(evNumA,1:4)=[r*locaWinA*delta;sigTyp;sigTypDisperA.(sigNam)(r,sigTyp); (sumSigA.(sigNam)(r)-meanSumSigAR)/madSumSigAR];
        end
    end
end