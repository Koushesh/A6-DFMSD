% clear all

function lastMembMastSt = numMasStBasedLenDetectabSt2(lenDetectabSt,locaEvLeng,seconStON)
% lenDetectabSt=15;
c=0;
possBordMasSt=[];
msAsum=[];
if seconStON==1
    if lenDetectabSt==3
        lastMembMastSt=2;
    elseif  lenDetectabSt==4
        lastMembMastSt=3;
        % for exiAsum=1:100
        %     for mastStAsum=1:exiAsum
        %         if mastStAsum/exiAsum >= 2/3 && mastStAsum/exiAsum <= 6/7% lastversion:  4/5
        %             % since in this version we already removed very excited stations with
        %             % fixed parameter limit we donot need any upper limit after 2/3 of station
        %             % consideration. from here to the last station we just select the last
        %             % master station according to the pattern of increase in length of singlSt
        %             % event declaration in each station
        %             c=c+1;
        %             msAsum(c,1:3)=[exiAsum mastStAsum mastStAsum/exiAsum];
        %         end
        %     end
        % end
        % elseif lenDetectabSt==4
        % for exiAsum=1:100
        %     for mastStAsum=1:exiAsum
        %         if mastStAsum/exiAsum >= 3/4 && mastStAsum/exiAsum <= 6/7% lastversion:  4/5
        %             c=c+1;
        %             msAsum(c,1:3)=[exiAsum mastStAsum mastStAsum/exiAsum];
        %         end
        %     end
        % end
    elseif lenDetectabSt>=5
        for exiAsum=1:100
            for mastStAsum=1:exiAsum
                if mastStAsum/exiAsum >= 4/5 && mastStAsum/exiAsum <= 9/10% lastversion:  3/4 v 6/7
                    c=c+1;
                    msAsum(c,1:3)=[exiAsum mastStAsum mastStAsum/exiAsum];
                end
            end
        end
        msAsum=sortrows(msAsum,1);
        
        possBordMasSt=msAsum(find(msAsum(:,1)==lenDetectabSt),2);

            fingo=[];
            for i=possBordMasSt(1):possBordMasSt(end)+1% lastversion: +1
                fingo(i)= (locaEvLeng(i,1)-locaEvLeng(i-1,1))/locaEvLeng(i-1,1);
            end
            lastMembMastSt=find(fingo(:)==max(fingo))-1;

    end
elseif seconStON==0
    % for exiAsum=1:100
    %     for mastStAsum=1:exiAsum
    %         if mastStAsum/exiAsum >= 4/4
    %             c=c+1;
    %             msAsum(c,1:3)=[exiAsum mastStAsum mastStAsum/exiAsum];
    %         end
    %     end
    % end
    % msAsum=[];
    lastMembMastSt=lenDetectabSt;
end
end