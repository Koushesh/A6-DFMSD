                %                 geomean(LocalCLeng(:,1))+geostd(LocalCLeng(:,1))
                %                 geomean(LocalBLeng(:,1))+geostd(LocalBLeng(:,1))
                %                 geomean(LocalALeng(:,1))+geostd(LocalALeng(:,1))
                %                 mastStC=LocalCLeng(find(LocalCLeng(:,1) <= geomean(LocalCLeng(:,1))+geostd(LocalCLeng(:,1))),2)
                %                 mastStB=LocalBLeng(find(LocalBLeng(:,1) <= geomean(LocalBLeng(:,1))+geostd(LocalBLeng(:,1))),2)
                %                 mastStA=LocalALeng(find(LocalALeng(:,1) <= geomean(LocalALeng(:,1))+geostd(LocalALeng(:,1))),2)
                
                % this typ of averaging is selected finaly ----------------
                %                 mastStC=LocalCLeng(find(LocalCLeng(:,1) <= mean(LocalCLeng(:,1))+std(LocalCLeng(:,1))),2)
                %                 mastStB=LocalBLeng(find(LocalBLeng(:,1) <= mean(LocalBLeng(:,1))+std(LocalBLeng(:,1))),2)
                %                 mastStA=LocalALeng(find(LocalALeng(:,1) <= mean(LocalALeng(:,1))+std(LocalALeng(:,1))),2)
                %----------------------------------------------------------
                
                %                  mastStC=LocalCLeng(find(LocalCLeng(:,1) <= mean(LocalCLeng(:,1))),2)
                %                  mastStB=LocalBLeng(find(LocalBLeng(:,1) <= mean(LocalBLeng(:,1))),2)
                %                  mastStA=LocalALeng(find(LocalALeng(:,1) <= mean(LocalALeng(:,1))),2)
                
                mastStC1=LocalCLeng(find(LocalCLeng(:,1) <= mean(LocalCLeng(:,1))+std(LocalCLeng(:,1))),1:2);
                mastStB1=LocalBLeng(find(LocalBLeng(:,1) <= mean(LocalBLeng(:,1))+std(LocalBLeng(:,1))),1:2);
                mastStA1=LocalALeng(find(LocalALeng(:,1) <= mean(LocalALeng(:,1))+std(LocalALeng(:,1))),1:2);
                
                
                XC=[];Y1C=[];Y2C=[];Y3C=[];Y4C=[];
                XB=[];Y1B=[];Y2B=[];Y3B=[];Y4B=[];
                XA=[];Y1A=[];Y2A=[];Y3A=[];Y4A=[];
                
                figure(1)
                XC(1:length(LocalCLeng(:,1)))=LocalCLeng(:,2);
                Y1C=LocalCLeng(:,1);
                %                 Y2C(1:length(LocalCLeng(:,1)))=geomean(LocalCLeng(:,1))+geostd(LocalCLeng(:,1));
%                 Y2C(1:length(LocalCLeng(:,1)))=mean(LocalCLeng(:,1))+std(LocalCLeng(:,1));
                Y3C(1:length(LocalCLeng(:,1)))=maxDetecEvPerSt; % mean(mastStC1(:,1))+std(mastStC1(:,1))*1.5;
%                 Y4C(1:length(LocalCLeng(:,1)))=mean(mastStC1(:,1))*1;
                plot(XC,Y1C,'k')
                hold on
                grid on
%                                 plot(XC,Y2C,'g')
                plot(XC,Y3C,'b')
%                 plot(XC,Y4C,'r')
                
                figure(2)
                XB(1:length(LocalBLeng(:,1)))=LocalBLeng(:,2);
                Y1B=LocalBLeng(:,1);
                %                 Y2B(1:length(LocalBLeng(:,1)))=geomean(LocalBLeng(:,1))+geostd(LocalBLeng(:,1));
%                 Y2B(1:length(LocalBLeng(:,1)))=mean(LocalBLeng(:,1))+std(LocalBLeng(:,1));
                Y3B(1:length(LocalBLeng(:,1)))=maxDetecEvPerSt; % mean(mastStB1(:,1))+std(mastStB1(:,1))*1.5;
%                 Y4B(1:length(LocalBLeng(:,1)))=mean(mastStB1(:,1))*1;
                plot(XB,Y1B,'k')
                hold on
                grid on
%                                 plot(XB,Y2B,'g')
                plot(XB,Y3B,'b')
%                 plot(XB,Y4B,'r')
                
                figure(3)
                XA(1:length(LocalALeng(:,1)))=LocalALeng(:,2);
                Y1A=LocalALeng(:,1);
                %                 Y2A(1:length(LocalALeng(:,1)))=geomean(LocalALeng(:,1))+geostd(LocalALeng(:,1));
%                 Y2A(1:length(LocalALeng(:,1)))=mean(LocalALeng(:,1))+std(LocalALeng(:,1));
                Y3A(1:length(LocalALeng(:,1)))=maxDetecEvPerSt; % mean(mastStA1(:,1))+std(mastStA1(:,1))*1.5;
%                 Y4A(1:length(LocalALeng(:,1)))=mean(mastStA1(:,1))*1;
                plot(XA,Y1A,'k')
                hold on
                grid on
%                                 plot(XA,Y2A,'g')
                plot(XA,Y3A,'b')
%                 plot(XA,Y4A,'r')