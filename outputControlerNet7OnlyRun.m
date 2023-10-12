
sepZonOutput=1;
Zon=[1 2 3];
detecDivi=0;
minLocSearCohStNum=3;

year='2020';%2016
monthBeg=8;%7
monthEnd=8;%9
dayBeg=1;%31
diviOrder=0;%[1 2 3 4 5]
% yearlyOutput=[year,'output-Zon-1'];
% out      = fopen(yearlyOutput, 'w');
% 
% yearlyOutput0=[year,'output-0-Zon-1'];
% out0      = fopen(yearlyOutput0, 'w');
% 
% yearlyOutput1=[year,'output-1-Zon-1'];
% out1      = fopen(yearlyOutput1, 'w');
% 
% yearlyOutput2=[year,'output-2-Zon-1'];
% out2     = fopen(yearlyOutput2, 'w');
for monthBeg=monthBeg:monthEnd % in function of "KABBA_getwaveformdata" there is a problem since if you set date as 20150230 and get data it gives you data!! there is NOT such date in calendar
    if monthBeg==1||monthBeg==3||monthBeg==5||monthBeg==7||monthBeg==8||monthBeg==10||monthBeg==12
        dayEnd=15;%31
    elseif monthBeg==4||monthBeg==6||monthBeg==9||monthBeg==11
        dayEnd=30;%30
    elseif monthBeg==2
        if str2num(year)==2016
            dayEnd=29;%29.  feb 2016 = 29 days
        else
            dayEnd=28;%28
        end
    end
%     monthlyOutput=['month',num2str(month),'output'];
% out      = fopen(monthlyOutput, 'w');
    save('dayEnd','dayEnd')
    for dayBeg=dayBeg:dayEnd
        load('dayEnd')
        if (monthBeg<10 && dayBeg<10)
            date=[year,'0',num2str(monthBeg),'0',num2str(dayBeg)];
        elseif (monthBeg<10 && dayBeg>9)
            date=[year,'0',num2str(monthBeg),num2str(dayBeg)];
        elseif (monthBeg>9 && dayBeg<10)
            date=[year,num2str(monthBeg),'0',num2str(dayBeg)];
        elseif (monthBeg>9 && dayBeg>9)
            date=[year,num2str(monthBeg),num2str(dayBeg)];
        end
        dateEv=['date',date];
         if monthBeg<monthEnd && dayBeg==dayEnd
            dayBeg=1;
         end
        [monthBeg dayBeg];
%         for koo=1:1           
%             dateEvTxt=[dateEv,'LocDivi-',num2str(diviOrder(koo)),'Zon-1.txt'];
%             s = fileread(dateEvTxt);
%             fwrite(out, s, 'char');
%         end
%         for koo=1:1           
%             dateEvTxt=[dateEv,'Net-0Divi-',num2str(diviOrder(koo)),'Zon-1.txt'];
%             s = fileread(dateEvTxt);
%             fwrite(out0, s, 'char');
%         end
%         for koo=1:1           
%             dateEvTxt=[dateEv,'Net-1Divi-',num2str(diviOrder(koo)),'Zon-1.txt'];
%             s = fileread(dateEvTxt);
%             fwrite(out1, s, 'char');
%         end
%         for koo=1:1           
%             dateEvTxt=[dateEv,'Net-2Divi-',num2str(diviOrder(koo)),'Zon-1.txt'];
%             s = fileread(dateEvTxt);
%             fwrite(out2, s, 'char');
%         end      
for ni=1:3
if sepZonOutput~=1
    %     Zon=123;
    partZon=num2str(Zon(1,1));
    for i=2:length(Zon(1,:))
        partZon=[partZon,num2str(Zon(1,i))];
    end
    dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+6),'Zon-',partZon,'.txt'];
    finalDateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+7),'Zon-',partZon,'.txt'];
elseif sepZonOutput==1
    dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+6),'Zon-',num2str(Zon(1,ni)),'.txt'];
    finalDateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+7),'Zon-',num2str(Zon(1,ni)),'.txt'];

final = fopen(finalDateEvTxt,'a');
fileID = fopen(dateEvTxt);

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
    if max(numStEv)>=minLocSearCohStNum+7
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
end

    end
end
%     fclose(out);
%     fclose(out0);
%     fclose(out1);
%     fclose(out2);    
%    
% leno=[];
% outPutNum=[];
% outPutNumDiv4=[];
% fileID = fopen(yearlyOutput0);
% Intro =textscan(fileID,'%s','Delimiter','\n');
% leno=size(Intro{1});
% outPutNum(1,1)= leno(1,1);
% outPutNumDiv4(1,1)=fix(leno(1,1)/4);
% 
% leno=[];
% fileID = fopen(yearlyOutput1);
% Intro =textscan(fileID,'%s','Delimiter','\n');
% leno=size(Intro{1});
% outPutNum(1,2)= leno(1,1);
% outPutNumDiv4(1,2)=fix(leno(1,1)/4);
% 
% leno=[];
% fileID = fopen(yearlyOutput2);
% Intro =textscan(fileID,'%s','Delimiter','\n');
% leno=size(Intro{1});
% outPutNum(1,3)= leno(1,1);
% outPutNumDiv4(1,3)=fix(leno(1,1)/4);
% 
% outPutNum
% outPutNumDiv4