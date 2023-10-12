
comEv=0;
comEvNum=0;
% dateEv=['date',date];
% load(dateEv);
comLocEv.(dateEv)=[0 0 0 0 0 0];
sortComLocEv.(dateEv)=[0 0 0 0 0 0];
com3LocEv.(dateEv)=[0 0 0 0 0 0];
comLocList=0;%comLocList.(dateEv)
comUnic3LocEv.(dateEv)=0;
if timErrPhDel~=0
    timErrPhDel=minStatisDur+0.01*minStatisDur;%shold be always a positive value. This belongs to previous versions !
end
% loc
for xxx=1:length(staChek)%for xxx=1:length(staChek); xxx=1:length(loc.(dateEv)(1,:,1));
    newStCod=staChek(xxx);%newStCod=xxx;
    if (ismember(newStCod,mastSt)==1 || ismember(newStCod,morImpoSt)==1) && (ismember(newStCod,lesImpoSt)~=1)
        if newStCod > length(locT.(dateEv)(1,:))
            break
        end
        for evNum=1:length(locT.(dateEv)(:,newStCod))
            if locT.(dateEv)(evNum,newStCod)==0
                break
            end
            comoCon=1;
            enLop=0;
            for yyy=1:length(staChek)%for yyy=1:length(staChek); yyy=1:length(loc.(dateEv)(1,:,1));
                stShift=staChek(yyy);%stShift=yyy;
                enLop=enLop+1;
                if stShift > length(locT.(dateEv)(1,:))% this is done because some times records have many zeros and they not be in single st detection then we do not need to consider them
                    break
                end
                %                 if newStCod~=stShift && ismember(stShift,veciSt(newStCod,:))==1 && lldistkm(stInfo(newStCod,2:3),stInfo(stShift,2:3)) > 0.1 % to prevent from same place station judgment
                if ismember(newStCod,mastSt)==1
                    LocaSerRadius=LocaSerRadiMast(newStCod,2);
                else
                    LocaSerRadius=LocaSerRadi(newStCod,2);
                end
                if newStCod~=stShift && lldistkm(stInfo(newStCod,2:3),stInfo(stShift,2:3))<= LocaSerRadius && lldistkm(stInfo(newStCod,2:3),stInfo(stShift,2:3)) > 0.1 % to prevent from same place station judgment
                    existEve=[];
                    if locF.(dateEv)(evNum,newStCod) < 4
                        if maxNegativPhasDelayMax(newStCod,stShift) == -1000 % if maxNegativPhasDelayMax(newStCod,stShift) < 0
                            existEve=find(locT.(dateEv)(:,stShift)>=locT.(dateEv)(evNum,newStCod)+(minPositivPhasDelayMin(newStCod,stShift)-timErrPhDel)...
                                & locT.(dateEv)(:,stShift)<=locT.(dateEv)(evNum,newStCod)+(maxPositivPhasDelayMax(newStCod,stShift)+timErrPhDel) & locF.(dateEv)(:,stShift)==locF.(dateEv)(evNum,newStCod)...
                                & locD.(dateEv)(:,stShift)>=locD.(dateEv)(evNum,newStCod)-(locD.(dateEv)(evNum,newStCod)*0.3061+0.113) & locD.(dateEv)(:,stShift)<=locD.(dateEv)(evNum,newStCod)+(locD.(dateEv)(evNum,newStCod)*0.3061+0.113));
                        end
                        if maxPositivPhasDelayMax(newStCod,stShift) == -1000 %if maxPositivPhasDelayMax(newStCod,stShift) < 0
                            existEve=find(locT.(dateEv)(:,stShift)>=locT.(dateEv)(evNum,newStCod)-(maxNegativPhasDelayMax(newStCod,stShift)+timErrPhDel)...
                                & locT.(dateEv)(:,stShift)<=locT.(dateEv)(evNum,newStCod)-minNegativPhasDelayMin(newStCod,stShift)+timErrPhDel & locF.(dateEv)(:,stShift)==locF.(dateEv)(evNum,newStCod)...
                                & locD.(dateEv)(:,stShift)>=locD.(dateEv)(evNum,newStCod)-(locD.(dateEv)(evNum,newStCod)*0.3061+0.113) & locD.(dateEv)(:,stShift)<=locD.(dateEv)(evNum,newStCod)+(locD.(dateEv)(evNum,newStCod)*0.3061+0.113));
                        end
                        if maxNegativPhasDelayMax(newStCod,stShift) >= 0 &&  maxPositivPhasDelayMax(newStCod,stShift)  >= 0
                            existEve=find(locT.(dateEv)(:,stShift)>=locT.(dateEv)(evNum,newStCod)-(maxNegativPhasDelayMax(newStCod,stShift)+timErrPhDel)...
                                & locT.(dateEv)(:,stShift)<=locT.(dateEv)(evNum,newStCod)+(maxPositivPhasDelayMax(newStCod,stShift)+timErrPhDel) & locF.(dateEv)(:,stShift)==locF.(dateEv)(evNum,newStCod)...
                                & locD.(dateEv)(:,stShift)>=locD.(dateEv)(evNum,newStCod)-(locD.(dateEv)(evNum,newStCod)*0.3061+0.113) & locD.(dateEv)(:,stShift)<=locD.(dateEv)(evNum,newStCod)+(locD.(dateEv)(evNum,newStCod)*0.3061+0.113));
                        end
                    end
                    if locF.(dateEv)(evNum,newStCod) > 3
                    if maxNegativPhasDelayMax(newStCod,stShift) == -1000 % if maxNegativPhasDelayMax(newStCod,stShift) < 0
                        existEve=find(locT.(dateEv)(:,stShift)>=locT.(dateEv)(evNum,newStCod)+(minPositivPhasDelayMin(newStCod,stShift)-timErrPhDel)...
                            & locT.(dateEv)(:,stShift)<=locT.(dateEv)(evNum,newStCod)+(maxPositivPhasDelayMax(newStCod,stShift)+timErrPhDel) & locF.(dateEv)(:,stShift)==locF.(dateEv)(evNum,newStCod)...
                            & locD.(dateEv)(:,stShift)>=locD.(dateEv)(evNum,newStCod)-1.6^(-locD.(dateEv)(evNum,newStCod)-iniSmoFacVici) & locD.(dateEv)(:,stShift)<=locD.(dateEv)(evNum,newStCod)+1.6^(-locD.(dateEv)(evNum,newStCod)-iniSmoFacVici));
                    end
                    if maxPositivPhasDelayMax(newStCod,stShift) == -1000 %if maxPositivPhasDelayMax(newStCod,stShift) < 0
                        existEve=find(locT.(dateEv)(:,stShift)>=locT.(dateEv)(evNum,newStCod)-(maxNegativPhasDelayMax(newStCod,stShift)+timErrPhDel)...
                            & locT.(dateEv)(:,stShift)<=locT.(dateEv)(evNum,newStCod)-minNegativPhasDelayMin(newStCod,stShift)+timErrPhDel & locF.(dateEv)(:,stShift)==locF.(dateEv)(evNum,newStCod)...
                            & locD.(dateEv)(:,stShift)>=locD.(dateEv)(evNum,newStCod)-1.6^(-locD.(dateEv)(evNum,newStCod)-iniSmoFacVici) & locD.(dateEv)(:,stShift)<=locD.(dateEv)(evNum,newStCod)+1.6^(-locD.(dateEv)(evNum,newStCod)-iniSmoFacVici));
                    end
                    if maxNegativPhasDelayMax(newStCod,stShift) >= 0 &&  maxPositivPhasDelayMax(newStCod,stShift)  >= 0
                        existEve=find(locT.(dateEv)(:,stShift)>=locT.(dateEv)(evNum,newStCod)-(maxNegativPhasDelayMax(newStCod,stShift)+timErrPhDel)...
                            & locT.(dateEv)(:,stShift)<=locT.(dateEv)(evNum,newStCod)+(maxPositivPhasDelayMax(newStCod,stShift)+timErrPhDel) & locF.(dateEv)(:,stShift)==locF.(dateEv)(evNum,newStCod)...
                            & locD.(dateEv)(:,stShift)>=locD.(dateEv)(evNum,newStCod)-1.6^(-locD.(dateEv)(evNum,newStCod)-iniSmoFacVici) & locD.(dateEv)(:,stShift)<=locD.(dateEv)(evNum,newStCod)+1.6^(-locD.(dateEv)(evNum,newStCod)-iniSmoFacVici));
                    end
                        
                    end
                    
                    if isempty(existEve)~=1
                        %                         if seconStON==1 %edit new
                        %                             if ismember(stShift,seconSt(:,2))~=1 || stShift==morImpoSt
                        %                                 comoCon=comoCon+1;
                        %                             end
                        %                         elseif seconStON==0 %edit new
                        comoCon=comoCon+1;
                        %                         end
                        comEvNum=comEvNum+1;
                        comLocEv.(dateEv)(comEvNum,1:6)=[locT.(dateEv)(evNum,newStCod);newStCod;stShift;locF.(dateEv)(evNum,newStCod);comoCon;locD.(dateEv)(evNum,newStCod)];%[all.(allEv)(evNum,newStCod)+180;
                    end
                end
                if seconStON==1
                    if enLop==length(staChek)
                        if locF.(dateEv)(evNum,newStCod)==1 && comoCon >=3
                            com3LocEv.(dateEv)(comEvNum,1:6)=comLocEv.(dateEv)(comEvNum,1:6);
                        end
                        if locF.(dateEv)(evNum,newStCod)~=1 && comoCon >= 2 %minLocSearCohStNum-1 % + spikiNumb % >= minLocSearCohStNum(newStCod,2)
                            com3LocEv.(dateEv)(comEvNum,1:6)=comLocEv.(dateEv)(comEvNum,1:6);
                        end
                    end
                elseif seconStON==0
                    if enLop==length(staChek) && comoCon >= minLocSearCohStNum % + spikiNumb % >= minLocSearCohStNum(newStCod,2)
                        com3LocEv.(dateEv)(comEvNum,1:6)=comLocEv.(dateEv)(comEvNum,1:6);
                    end
                end
            end
        end
    end
end
comLocEv.(dateEv) = comLocEv.(dateEv)(any(comLocEv.(dateEv),2),:);
sortComLocEv.(dateEv)= sortrows(comLocEv.(dateEv),1);

% com3LocEv.(dateEv)=sortComLocEv.(dateEv)(find(sortComLocEv.(dateEv)(:,5)>=minLocSearCohStNum),1:6);%>=minNumbDetecSt
com3LocEv.(dateEv)= com3LocEv.(dateEv)(any(com3LocEv.(dateEv),2),:);
com3LocEv.(dateEv)= sortrows(com3LocEv.(dateEv),1);
comUnic3LocEv.(dateEv)=unique(com3LocEv.(dateEv)(:,1),'rows');
%------------------------------------------------end of loc event all stations checking------------------
pause(1);

