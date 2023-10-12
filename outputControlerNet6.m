%%
% clear all
% clc
% dato='20170404';
% dateEvTxt='date20170404finLocDivi-5.txt';
% netDelay=26.14;
% minNumbNetDetecSt=5;
% finalDateEvTxt='date20170416finNetLocDivi-5.txt';

if sepZonOutput~=1
    %     Zon=123;
    partZon=num2str(Zon(1,1));
    for i=2:length(Zon(1,:))
        partZon=[partZon,num2str(Zon(1,i))];
    end
    dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+5),'Zon-',partZon,'.txt'];
    finalDateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+6),'Zon-',partZon,'.txt'];
elseif sepZonOutput==1
    dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+5),'Zon-',num2str(Zon(1,ni)),'.txt'];
    finalDateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+6),'Zon-',num2str(Zon(1,ni)),'.txt'];
end
final = fopen(finalDateEvTxt,'a');
fileID = fopen(dateEvTxt);
% fprintf(final,'Station Codes: \n');
% for yyy=1:length(stations)-1
%     if rem(yyy,7)==0
%         fprintf(final,'%s  \n',stations{yyy});
%     else
%         fprintf(final,'%s  ',stations{yyy});
%     end
% end
% fprintf(final,'%s\n\nFiltering Codes:\n1=[4 8.5]  2=[6 9.5]  3=[8 11.5]  4=[9.5 13.5]  5=[11.5 16]  6=[13.5 18]  7=[16 21]  8=[18 25]  9=[21 30]Hz\n\n',stations{end});

fprintf(final,'\n');

Intro =textscan(fileID,'%s','Delimiter','\n');
leno=size(Intro{1});
leno(1,1);

for zz=0:fix((leno(1,1)-1)/4)-1    %fix((leno(1,1)-8)/4)-1 
    numStEv=0;
    for kk=1:3
        linInf=0;        
        if kk==2
            linInf=textscan(Intro{1}{1+kk+zz*4},'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');%Intro{1}{8+kk+zz*4}
            numStEv(kk)=str2num(cell2mat(linInf{1}));
        else
            linInf=textscan(Intro{1}{1+kk+zz*4},'%*20c %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s');%Intro{1}{8+kk+zz*4},
            numStEv(kk)=str2num(cell2mat(linInf{1}));
        end
    end
    if max(numStEv)>=minLocSearCohStNum+6
        for kk=1:3
            if kk==2
            fprintf(final,'%21s','           ',Intro{1}{1+kk+zz*4});%Intro{1}{8+kk+zz*4}
            else
                 fprintf(final,Intro{1}{1+kk+zz*4});%Intro{1}{8+kk+zz*4}
            end
            fprintf(final,'\n');
        end
        fprintf(final,'\n');
    end    
end
if (leno(1,1)-1)/4-fix((leno(1,1)-1)/4)~=0% (leno(1,1)-8)/4-fix((leno(1,1)-8)/4)
    fprintf(final,Intro{1}{leno(1,1)-1});
    fprintf(final,'\n');
    fprintf(final,'\n');
end
fclose(final)
fclose(fileID)
