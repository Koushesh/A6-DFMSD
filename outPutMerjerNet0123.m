% clear all
year='2021';%2016
monthBeg=1;%7
monthEnd=2;%9
dayBeg=1;%31
diviOrder=[0];%[1 2 3 4 5]
minLocSearCohStNum=3;
zono='Zon-3'
yearlyOutput=['merg',year,zono];
out      = fopen(yearlyOutput, 'w');

yearlyOutput0=['merg',year,'St',num2str(minLocSearCohStNum),zono];
out0      = fopen(yearlyOutput0, 'w');

yearlyOutput1=['merg',year,'St',num2str(minLocSearCohStNum+1),zono];
out1      = fopen(yearlyOutput1, 'w');

yearlyOutput2=['merg',year,'St',num2str(minLocSearCohStNum+2),zono];
out2     = fopen(yearlyOutput2, 'w');

yearlyOutput3=['merg',year,'St',num2str(minLocSearCohStNum+3),zono];
out3     = fopen(yearlyOutput3, 'w');

yearlyOutput4=['merg',year,'St',num2str(minLocSearCohStNum+4),zono];
out4     = fopen(yearlyOutput4, 'w');

yearlyOutput5=['merg',year,'St',num2str(minLocSearCohStNum+5),zono];
out5     = fopen(yearlyOutput5, 'w');

yearlyOutput6=['merg',year,'St',num2str(minLocSearCohStNum+6),zono];
out6     = fopen(yearlyOutput6, 'w');

for monthBeg=monthBeg:monthEnd % in function of "KABBA_getwaveformdata" there is a problem since if you set date as 20150230 and get data it gives you data!! there is NOT such date in calendar
    if monthBeg==1||monthBeg==3||monthBeg==5||monthBeg==7||monthBeg==8||monthBeg==10||monthBeg==12
        dayEnd=31;%31
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
        dateEv=['date',date]
        if monthBeg<monthEnd && dayBeg==dayEnd
            dayBeg=1;
        end
        [monthBeg dayBeg]
        % for koo=1:1
            dateEvTxt=[dateEv,zono,'.txt'];
            s = fileread(dateEvTxt);
            fwrite(out, s, 'char');
        % end
        % for koo=1:1
            dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum),zono,'.txt'];
            s = fileread(dateEvTxt);
            fwrite(out0, s, 'char');
        % end
        % for koo=1:1
            dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+1),zono,'.txt'];
            s = fileread(dateEvTxt);
            fwrite(out1, s, 'char');
        % end
        % for koo=1:1
            dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+2),zono,'.txt'];
            s = fileread(dateEvTxt);
            fwrite(out2, s, 'char');
        % end
        % for koo=1:1
            dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+3),zono,'.txt'];
            s = fileread(dateEvTxt);
            fwrite(out3, s, 'char');
        % end
        % for koo=1:1
            dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+4),zono,'.txt'];
            s = fileread(dateEvTxt);
            fwrite(out4, s, 'char');
        % end
        % for koo=1:1
            dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+5),zono,'.txt'];
            s = fileread(dateEvTxt);
            fwrite(out5, s, 'char');
        % end
        % for koo=1:1
            dateEvTxt=[dateEv,'St',num2str(minLocSearCohStNum+6),zono,'.txt'];
            s = fileread(dateEvTxt);
            fwrite(out6, s, 'char');
        % end
        
    end
end
fclose(out);
fclose(out0);
fclose(out1);
fclose(out2);
fclose(out3);
fclose(out4);
fclose(out5);
fclose(out6);

leno=[];
outPutNum=[];
outPutNumDiv4=[];
fileID = fopen(yearlyOutput0);
Intro =textscan(fileID,'%s','Delimiter','\n');
leno=size(Intro{1});
outPutNum(1,1)= leno(1,1);
outPutNumDiv4(1,1)=fix(leno(1,1)/4);

leno=[];
fileID = fopen(yearlyOutput1);
Intro =textscan(fileID,'%s','Delimiter','\n');
leno=size(Intro{1});
outPutNum(1,2)= leno(1,1);
outPutNumDiv4(1,2)=fix(leno(1,1)/4);

leno=[];
fileID = fopen(yearlyOutput2);
Intro =textscan(fileID,'%s','Delimiter','\n');
leno=size(Intro{1});
outPutNum(1,3)= leno(1,1);
outPutNumDiv4(1,3)=fix(leno(1,1)/4);

leno=[];
fileID = fopen(yearlyOutput3);
Intro =textscan(fileID,'%s','Delimiter','\n');
leno=size(Intro{1});
outPutNum(1,4)= leno(1,1);
outPutNumDiv4(1,4)=fix(leno(1,1)/4);

leno=[];
fileID = fopen(yearlyOutput4);
Intro =textscan(fileID,'%s','Delimiter','\n');
leno=size(Intro{1});
outPutNum(1,5)= leno(1,1);
outPutNumDiv4(1,5)=fix(leno(1,1)/4);

leno=[];
fileID = fopen(yearlyOutput5);
Intro =textscan(fileID,'%s','Delimiter','\n');
leno=size(Intro{1});
outPutNum(1,6)= leno(1,1);
outPutNumDiv4(1,6)=fix(leno(1,1)/4);

outPutNum
outPutNumDiv4