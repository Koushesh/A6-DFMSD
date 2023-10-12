
for r=lta+2:CC %r=1:CC
    for sigTyp=1:numSigTyp
        sigNam=['typ',num2str(sigTyp)];
        meanSumSigCR=mean(sumSigC.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
        madSumSigCR=mad(sumSigC.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
        meanMadSumSigCR=meanSumSigCR+madSumSigCR;
        conC=0;
        nC=0;
        % C = ZON-1
        for pa=sig.(sigNam)(1):sig.(sigNam)(2)-1   % -1 is new
            partFilC=['pa',num2str(pa),'C',num2str(pa)];
            frTherNamC=['C',num2str(pa)];
            if  me.(partFilC)(r)< mean(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))*magniAmp ...
                    ||  sumSigC.(sigNam)(r) < meanMadSumSigCR % NEW EDITION
                break
            end
            if me.(partFilC)(r) >= mean(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))*magniAmp ...
                    &&  sumSigC.(sigNam)(r) >= meanMadSumSigCR % NEW EDITION
                nC=nC+1;
                conC(nC)=me.(partFilC)(r);
            end
        end
        if nC== sig.(sigNam)(2)-sig.(sigNam)(1) % +1
            sigTypDisperC.(sigNam)(r,sigTyp)=std(conC)/mean(conC);
            evNumC=evNumC+1;
            localC(evNumC,1:4)=[r*locaWinC*delta;sigTyp;sigTypDisperC.(sigNam)(r,sigTyp); (sumSigC.(sigNam)(r)-meanSumSigCR)/madSumSigCR];
        end
    end
end