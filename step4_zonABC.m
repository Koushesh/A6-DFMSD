
for r=lta+2:CC %r=1:CC
    for sigTyp=1:numSigTyp
        sigNam=['typ',num2str(sigTyp)];
        if r <= AA
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
            meanSumSigAR=mean(sumSigA.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            madSumSigAR=mad(sumSigA.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            meanMadSumSigAR=meanSumSigAR+madSumSigAR;
            conA=0;
            nA=0;
            %due to using break(which itself is designed to speed up the code!)
            %we can not merje the ABC within one for loop of
            %pa=sig.(sigNam)(1):sig.(sigNam)(2). then keep it as it is.!
            % A = ZON-3
            for pa=sig.(sigNam)(1):sig.(sigNam)(2)-1   % -1 is new
                partFilA=['pa',num2str(pa),'A',num2str(pa)];
                frTherNamA=['A',num2str(pa)];
                if  me.(partFilA)(r)< mean(me.(partFilA)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilA)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
                        ||  sumSigA.(sigNam)(r) < meanMadSumSigAR % NEW EDITION
                    break
                end
                if me.(partFilA)(r) >= mean(me.(partFilA)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilA)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
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
            % B = ZON-2
            for pa=sig.(sigNam)(1):sig.(sigNam)(2)-1   % -1 is new
                partFilB=['pa',num2str(pa),'B',num2str(pa)];
                frTherNamB=['B',num2str(pa)];
                if  me.(partFilB)(r)< mean(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
                        ||  sumSigB.(sigNam)(r) < meanMadSumSigBR % NEW EDITION
                    break
                end
                if me.(partFilB)(r) >= mean(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
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
                if  me.(partFilC)(r)< mean(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
                        ||  sumSigC.(sigNam)(r) < meanMadSumSigCR % NEW EDITION
                    break
                end
                if me.(partFilC)(r) >= mean(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
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
        elseif r > AA && r <= BB
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
            %due to using break(which itself is designed to speed up the code!)
            %we can not merje the ABC within one for loop of
            %pa=sig.(sigNam)(1):sig.(sigNam)(2). then keep it as it is.!
            % B = ZON-2
            for pa=sig.(sigNam)(1):sig.(sigNam)(2)-1   % -1 is new
                partFilB=['pa',num2str(pa),'B',num2str(pa)];
                frTherNamB=['B',num2str(pa)];
                if  me.(partFilB)(r)< mean(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
                        ||  sumSigB.(sigNam)(r) < meanMadSumSigBR % NEW EDITION
                    break
                end
                if me.(partFilB)(r) >= mean(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilB)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
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
                if  me.(partFilC)(r)< mean(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
                        ||  sumSigC.(sigNam)(r) < meanMadSumSigCR % NEW EDITION
                    break
                end
                if me.(partFilC)(r) >= mean(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
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
        else
            meanSumSigCR=mean(sumSigC.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            madSumSigCR=mad(sumSigC.(sigNam)(r-1+ltaShif-lta:r-1+ltaShif));
            meanMadSumSigCR=meanSumSigCR+madSumSigCR;
            conC=0;
            nC=0;
            % C = ZON-1
            for pa=sig.(sigNam)(1):sig.(sigNam)(2)-1   % -1 is new
                partFilC=['pa',num2str(pa),'C',num2str(pa)];
                frTherNamC=['C',num2str(pa)];
                if  me.(partFilC)(r)< mean(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
                        ||  sumSigC.(sigNam)(r) < meanMadSumSigCR % NEW EDITION
                    break
                end
                if me.(partFilC)(r) >= mean(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))+mad(me.(partFilC)(r-1+ltaShif-lta:r-1+ltaShif))*monoBanSig2NoisTher ...
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
end