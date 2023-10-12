
for r=lta+2:CC %r=1:CC
    for sigTyp=1:numSigTyp
        sigNam=['typ',num2str(sigTyp)];
        if r <= BB
            meanSumSigCR=mean(sumSigC.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            madSumSigCR=mad(sumSigC.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            meanMadSumSigCR=meanSumSigCR+madSumSigCR;
            conC=0;
            nC=0;
            meanSumSigBR=mean(sumSigB.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            madSumSigBR=mad(sumSigB.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            meanMadSumSigBR=meanSumSigBR+madSumSigBR;
            conB=0;
            nB=0;
        else
            meanSumSigCR=mean(sumSigC.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            madSumSigCR=mad(sumSigC.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            meanMadSumSigCR=meanSumSigCR+madSumSigCR;
            conC=0;
            nC=0;
        end
        %due to using break(which itself is designed to speed up the code!)
        %we can not merje the ABC within one for loop of
        %pa=sig.(sigNam)(1):sig.(sigNam)(2). then keep it as it is.!
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