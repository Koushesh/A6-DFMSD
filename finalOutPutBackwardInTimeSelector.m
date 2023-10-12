%%
% clear all
% clc
% dato='20170518';
% dateEvTxt='date20170528LocDivi-1.txt';
% netDelay=5.3;
% dateEvTxt='date20170416LocDivi-33.txt';
% finalDateEvTxt='date20170416finLocDivi-33.txt';
dateNetDelay=['date',date,'netDelay'];
load(dateNetDelay)



if sepZonOutput~=1
    %     Zon=123;
    partZon=num2str(Zon(1,1));
    for i=2:length(Zon(1,:))
        partZon=[partZon,num2str(Zon(1,i))];
    end
    dateEvTxt=[dateEv,'Zon-',partZon,'.txt'];
    finalDateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum),'Zon-',partZon,'.txt'];
elseif sepZonOutput==1
    dateEvTxt=[dateEv,'Zon-',num2str(Zon(1,ni)),'.txt'];
    finalDateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum),'Zon-',num2str(Zon(1,ni)),'.txt'];
end




final = fopen(finalDateEvTxt,'a');
fileID = fopen(dateEvTxt);
%---------------------------> this part can be seperated as a new script
%and put before finalAoutput to prevent from repeating
if onceDoneContr==0
    zon1NetDelayEx=[];
    zon2NetDelayEx=[];
    zon3NetDelayEx=[];
    for mo=1:length(detectablSt)
        Ho1=[];
        Ho2=[];
        Ho3=[];
        veciSt=[];
        ji=detectablSt(mo);
        jiMatrPos=find(netStimator(:,1)==ji);
        veciSt(ji,1:netStimator(jiMatrPos,2))=netStimator(jiMatrPos,3:2+netStimator(jiMatrPos,2));
        % zon-1
        if ismember(1,Zon(1,:))==1
            md=0;
            for ma=1:length(veciSt(ji,:))
                if isnan(meanStdNegativPhasDelayMaxDepth12Zon1Ex(ji,veciSt(ji,ma)))==0
                    md= md+1;
                    Ho1(md)=meanStdNegativPhasDelayMaxDepth12Zon1Ex(ji,veciSt(ji,ma));
                end
            end
            if isempty(Ho1)==1
                zon1NetDelayEx(ji,1)=-1000;% here we prevent from involving stations which always receive p or s or both of them later than the master station ji. because this is the backward time consideration through event time-clustering
            else
                zon1NetDelayEx(ji,1)=mean(Ho1)+std(Ho1);%max(Ho1)
            end
            %         zon1NetDelay(ji,1)=(fix(zon1NetDelayEx(ji,1)/minStatisDurC)+1)*minStatisDurC;
        end
        % zon-2
        if ismember(2,Zon(1,:))==1
            md=0;
            for ma=1:length(veciSt(ji,:))
                if isnan(meanStdNegativPhasDelayMaxDepth12Zon2Ex(ji,veciSt(ji,ma)))==0
                    md= md+1;
                    Ho2(md)=meanStdNegativPhasDelayMaxDepth12Zon2Ex(ji,veciSt(ji,ma));
                end
            end
            if isempty(Ho2)==1
                zon2NetDelayEx(ji,1)=-1000;% the same of the above explenation
            else
                zon2NetDelayEx(ji,1)=mean(Ho2)+std(Ho2);%max(Ho2)
            end
            %         zon2NetDelay(ji,1)=(fix(zon2NetDelayEx(ji,1)/minStatisDurB)+1)*minStatisDurB;
        end
        % zon-3
        if ismember(3,Zon(1,:))==1
            md=0;
            for ma=1:length(veciSt(ji,:))
                if isnan(meanStdNegativPhasDelayMaxDepth12Zon3Ex(ji,veciSt(ji,ma)))==0
                    md= md+1;
                    Ho3(md)=meanStdNegativPhasDelayMaxDepth12Zon3Ex(ji,veciSt(ji,ma));
                end
            end
            if isempty(Ho3)==1
                zon3NetDelayEx(ji,1)=-1000; % the same of the above explenation
            else
                zon3NetDelayEx(ji,1)=mean(Ho3)+std(Ho3);%max(Ho3)
            end
            %         zon3NetDelay(ji,1)=(fix(zon3NetDelayEx(ji,1)/minStatisDurA)+1)*minStatisDurA;
        end
    end
end
%---------------------------<


fprintf(final,'\n');

Intro =textscan(fileID,'%s','Delimiter','\n');
leno=size(Intro{1});
leno(1,1);
jm=0;
con1=0;
betweeEv=1;
stBetweeEv=0;
stBetweeEvAll=0;
modFil=[];
modFil1=[];
modFil2=[];
fStBetweeEv=0;%0
dFStBetweeEv=0;%0
hhT=0;
mmT=0;
ssT=0;
linStDet=0;
netDelay=[];
netDelayViso=[];
for jo=9:leno(1,1)
    jm=jm+1;
    hhT=textscan(Intro{1}{jo},'%*10c  %2q %*[^\n]','delimiter',sprintf(':') );
    mmT=textscan(Intro{1}{jo},'%*13c  %2q %*[^\n]','delimiter',sprintf(':') );
    ssT=textscan(Intro{1}{jo},'%*16c  %2q %*[^\n]','delimiter',sprintf(':') );
    linInf=0;
    linInf=textscan(Intro{1}{jo},'%*20c %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');
    hh=str2num(hhT{1}{1});
    mm=str2num(mmT{1}{1});
    ss=str2num(ssT{1}{1});
    evo(jm)=hh*3600+mm*60+ss;
    numStEv(jm)=str2num(cell2mat(linInf{1}));
    for sto=1:numStEv(jm)
        linStDet(jm,sto)=str2num(cell2mat(linInf{2+sto}));
    end
    if jm==1
        fprintf(final,Intro{1}{jo});
        fprintf(final,'\n');
    end
    if jm==2
        vm=0;
        if str2num(cell2mat(linInf{2+numStEv(jm)+2+4}))==1
            for fio=1:numStEv(jm)
                if isnan(zon1NetDelayEx(linStDet(jm,fio)',1))==0
                    vm= vm + 1;
                    netDelay1(vm)=zon1NetDelayEx(linStDet(jm,fio)',1);%linStDet(jm,fio)' is equal to master station
                end
            end
            netDelay2=(fix((mean(netDelay1)+std(netDelay1))/minStatisDurC)+1)*minStatisDurC;% max(netDelay1);
        elseif str2num(cell2mat(linInf{2+numStEv(jm)+2+4}))==2
            for fio=1:numStEv(jm)
                if isnan(zon2NetDelayEx(linStDet(jm,fio)',1))==0
                    vm= vm + 1;
                    netDelay1(vm)=zon2NetDelayEx(linStDet(jm,fio)',1);%linStDet(jm,fio)' is equal to master station
                end
            end
            netDelay2=(fix((mean(netDelay1)+std(netDelay1))/minStatisDurB)+1)*minStatisDurB;% max(netDelay1);
        elseif str2num(cell2mat(linInf{2+numStEv(jm)+2+4}))==3
            for fio=1:numStEv(jm)
                if isnan(zon3NetDelayEx(linStDet(jm,fio)',1))==0
                    vm= vm + 1;
                    netDelay1(vm)=zon3NetDelayEx(linStDet(jm,fio)',1);%linStDet(jm,fio)' is equal to master station
                end
            end
            netDelay2=(fix((mean(netDelay1)+std(netDelay1))/minStatisDurA)+1)*minStatisDurA;% max(netDelay1);
        end
        netDelay=netDelay2;
    end
    
    if jm~=1 && evo(jm)-evo(jm-1)<=netDelay
        if betweeEv==1
            linInf=textscan(Intro{1}{jo-1},'%*20c %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');
            fStBetweeEv(betweeEv)=str2num(cell2mat(linInf{2+numStEv(jm-1)+2}));
            dFStBetweeEv(betweeEv)=str2num(cell2mat(linInf{2+numStEv(jm-1)+4}));
            stBetweeEv(1:numStEv(jm-1),betweeEv)=linStDet(jm-1,1:numStEv(jm-1))';
        end
        linInf=textscan(Intro{1}{jo},'%*20c %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');
        betweeEv=betweeEv+1;
        fStBetweeEv(betweeEv)=str2num(cell2mat(linInf{2+numStEv(jm)+2}));
        dFStBetweeEv(betweeEv)=str2num(cell2mat(linInf{2+numStEv(jm)+4}));
        stBetweeEv(1:numStEv(jm),betweeEv)=linStDet(jm,1:numStEv(jm))';
        if jo~=leno(1,1)
            linInf=textscan(Intro{1}{jo+1},'%*20c %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');
            numStEv(jm+1)=str2num(cell2mat(linInf{1}));
            netDelay1=[];
            netDelay2=[];
            for sto=1:numStEv(jm+1)
                linStDet(jm+1,sto)=str2num(cell2mat(linInf{2+sto}));
            end
            vm=0;
            if str2num(cell2mat(linInf{2+numStEv(jm+1)+2+4}))==1
                for fio=1:numStEv(jm+1)
                    if isnan(zon1NetDelayEx(linStDet(jm+1,fio)',1))==0
                        vm= vm + 1;
                        netDelay1(vm)=zon1NetDelayEx(linStDet(jm+1,fio)',1);%linStDet(jm,fio)' is equal to master station
                    end
                end
                netDelay2=(fix((mean(netDelay1)+std(netDelay1))/minStatisDurC)+1)*minStatisDurC;% max(netDelay1);
            elseif str2num(cell2mat(linInf{2+numStEv(jm+1)+2+4}))==2
                for fio=1:numStEv(jm+1)
                    if isnan(zon2NetDelayEx(linStDet(jm+1,fio)',1))==0
                        vm= vm + 1;
                        netDelay1(vm)=zon2NetDelayEx(linStDet(jm+1,fio)',1);%linStDet(jm,fio)' is equal to master station
                    end
                end
                netDelay2=(fix((mean(netDelay1)+std(netDelay1))/minStatisDurB)+1)*minStatisDurB;% max(netDelay1);
            elseif str2num(cell2mat(linInf{2+numStEv(jm+1)+2+4}))==3
                for fio=1:numStEv(jm+1)
                    if isnan(zon3NetDelayEx(linStDet(jm+1,fio)',1))==0
                        vm= vm + 1;
                        netDelay1(vm)=zon3NetDelayEx(linStDet(jm+1,fio)',1);%linStDet(jm,fio)' is equal to master station
                    end
                end
                netDelay2=(fix((mean(netDelay1)+std(netDelay1))/minStatisDurA)+1)*minStatisDurA;% max(netDelay1);
            end
        end
    end
    
    linInf=textscan(Intro{1}{jo},'%*20c %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');
    if (jm~=1 && evo(jm)-evo(jm-1)>netDelay) || (jm~=1 && jo==leno(1,1)) %stBetweeEv(1,1)~=0
% %         [jm  netDelay]
        modFil1=mode(fStBetweeEv(:));
%         if isempty(find(fStBetweeEv~=modFil1))==0
%             modFil2=mode(fStBetweeEv(find(fStBetweeEv~=modFil1)));
%             veciModFil=1;
%             %         modFil=fix(mean([modFil1 modFil2]));
%         else
%             modFil2= modFil1 ;
%             veciModFil=2;
%         end
        modFil=modFil1 ;
        %--------------
%         modalSel=find(fStBetweeEv(:)>=min(modFil1,modFil2)-veciModFil & fStBetweeEv(:)<=max(modFil1,modFil2)+veciModFil);% modalSel=find(fStBetweeEv(:)==modFil);
        modalSel=find(fStBetweeEv(:)>=modFil1-2 & fStBetweeEv(:)<=modFil1+3);% modalSel=find(fStBetweeEv(:)==modFil);
        dFModalSel=dFStBetweeEv(modalSel);
        stBetweeEvModalSel=stBetweeEv(:,modalSel);
        %--------------
        stBetweeEvAll= reshape(stBetweeEvModalSel,[],1);% stBetweeEvAll= reshape(stBetweeEv,[],1);
        [bp,ip,jp]=unique(stBetweeEvAll, 'first');
        stBetweeEvAll=stBetweeEvAll(sort(ip));
        stBetweeEvAll= stBetweeEvAll(any(stBetweeEvAll,2),:);
        fprintf(final,'                    %2d st: ',length(stBetweeEvAll));
        for ggg=1:length(stBetweeEvAll)
            fprintf(final,'%2d ',stBetweeEvAll(ggg));
        end
        fprintf(final,'F:%3d FD:[ %.2f %.2f ]\n',modFil,min(dFStBetweeEv),max(dFStBetweeEv));
    end
    if jm~=1 && evo(jm)-evo(jm-1)>netDelay %&& jo~=leno(1,1)
        betweeEv=1;
        stBetweeEv=0;
        %-----------
        modalSel=0;
        dFModalSel=0;
        stBetweeEvModalSel=0;
        %-----------
        stBetweeEvAll=0;
        modFil=[];
        modFil1=[];
        modFil2=[];
        fStBetweeEv=0;%0
        dFStBetweeEv=0;%0
        con1=con1+1;
        begEndEv(con1,1:2)=[evo(jm-1) evo(jm)];
        if con1 >=2
            fprintf(final,Intro{1}{jo-1});
            fprintf(final,' netDur: %3d Sec\n',begEndEv(con1,1)-begEndEv(con1-1,2));
            fprintf(final,'\n');
        end
        if con1==1
            fprintf(final,Intro{1}{jo-1});
            fprintf(final,' netDur: %3d Sec\n',evo(jm-1)-evo(1));
            fprintf(final,'\n');
        end
        if jo~=leno(1,1)
            fprintf(final,Intro{1}{jo});
            fprintf(final,'\n');
        end
        netDelayViso(con1,1)=netDelay;
        %----------new
        if jo~=leno(1,1)
            linInf=textscan(Intro{1}{jo+1},'%*20c %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');
            numStEv(jm+1)=str2num(cell2mat(linInf{1}));
            netDelay1=[];
            netDelay2=[];
            for sto=1:numStEv(jm+1)
                linStDet(jm+1,sto)=str2num(cell2mat(linInf{2+sto}));
            end
            vm=0;
            if str2num(cell2mat(linInf{2+numStEv(jm+1)+2+4}))==1
                for fio=1:numStEv(jm+1)
                    if isnan(zon1NetDelayEx(linStDet(jm+1,fio)',1))==0
                        vm= vm + 1;
                        netDelay1(vm)=zon1NetDelayEx(linStDet(jm+1,fio)',1);%linStDet(jm,fio)' is equal to master station
                    end
                end
                netDelay2=(fix((mean(netDelay1)+std(netDelay1))/minStatisDurC)+1)*minStatisDurC;% max(netDelay1);
            elseif str2num(cell2mat(linInf{2+numStEv(jm+1)+2+4}))==2
                for fio=1:numStEv(jm+1)
                    if isnan(zon2NetDelayEx(linStDet(jm+1,fio)',1))==0
                        vm= vm + 1;
                        netDelay1(vm)=zon2NetDelayEx(linStDet(jm+1,fio)',1);%linStDet(jm,fio)' is equal to master station
                    end
                end
                netDelay2=(fix((mean(netDelay1)+std(netDelay1))/minStatisDurB)+1)*minStatisDurB;% max(netDelay1);
            elseif str2num(cell2mat(linInf{2+numStEv(jm+1)+2+4}))==3
                for fio=1:numStEv(jm+1)
                    if isnan(zon3NetDelayEx(linStDet(jm+1,fio)',1))==0
                        vm= vm + 1;
                        netDelay1(vm)=zon3NetDelayEx(linStDet(jm+1,fio)',1);%linStDet(jm,fio)' is equal to master station
                    end
                end
                netDelay2=(fix((mean(netDelay1)+std(netDelay1))/minStatisDurA)+1)*minStatisDurA;% max(netDelay1);
            end
        end
        %----------
        netDelay=netDelay2;% position of this line is here no where else . do not change it
    end
    if jm>=3
        netDelay=netDelay2;%new
    end
    if jm~=1 && jo==leno(1,1)
        if con1 >=1
            fprintf(final,Intro{1}{jo});
            fprintf(final,' netDur: %3d Sec\n',evo(jm)-begEndEv(con1,2));
            fprintf(final,'\n');
        end
        if con1 ==0
            fprintf(final,Intro{1}{jo});
            fprintf(final,' netDur: %3d Sec\n',evo(jm)-evo(1));
            fprintf(final,'\n');
        end
    end
%    [jm+1  netDelay]
end
minMaxNetDelayViso=[min(netDelayViso) max(netDelayViso)];
fclose(final)
fclose(fileID)
