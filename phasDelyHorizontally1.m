
% close all
% to plot the calculated station-based time limits for searching signal
% anomalied station codes should be written here too
stations={'DP01';'DP02';'DP03';'DP04';'DP05';'DP06';'DP07';...
    'DP08';'DP09';'DP10';'DP11';'DP12';'DP13';'ABH ';...
    'FACH';'OCHT';'LAGB';'BLI ';'FSH ';'AHRW';'TNS ';'WLF ';'DP14';'BHE ';'TDN ';'BIW '};


fo=0;
phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus=[];
phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact=[];
for dal=1:length(stInfo(:,1))
    j=stInfo(dal,1);
    for dif=1:length(stInfo(:,1))
        daf=stInfo(dif,1);
        fo=fo+1;
        phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,1:6)=[j daf maxMinusPhasDelayExact(j,daf) ...
            minMinusPhasDelayExact(j,daf) minPlusPhasDelayExact(j,daf) maxPlusPhasDelayExact(j,daf)];
        phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,1:6)=[j daf maxMinusPhasDelay(j,daf) ...
            minMinusPhasDelay(j,daf) minPlusPhasDelay(j,daf) maxPlusPhasDelay(j,daf)];
    end
end
phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact
phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus



fo=0;
for dal=1:length(stInfo(:,1))
    j=stInfo(dal,1);
    for dif=1:length(stInfo(:,1))%for dif=1:netStimator(jMatrPos,2)
        daf=stInfo(dif,1);
        fo=fo+1;
        figure(j)
        %plot rounded part
        plot([-phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,3) -phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,4)]...
            ,[phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,2) phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,2)],'LineWidth',8,'color',[.7 .7 1])%,'.'[.3 .8 1]
        hold on
        plot([phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,5)  phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,6)]...
            ,[phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,2) phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplus(fo,2)],'LineWidth',8,'color',[1 .7 .7])
        hold on
        %plot exact part
        plot([-phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,3) -phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,4)]...
            ,[phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,2) phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,2)],'LineWidth',8,'color',[.0 .0 1])%,'.'[.3 .8 1]
        hold on
        plot([phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,5)  phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,6)]...
        ,[phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,2) phDelSummary_CentStOrbitSt_MaxminusMinminusMinplusMaxplusExact(fo,2)],'LineWidth',8,'color',[1 .0 .0])
        hold on
        
    end
    fontsize=20;%19 for jpg print - 11 for PDF print
    FontWeight='normal';%bold 'normal'
    set(gca,'fontsize',fontsize,'FontWeight',FontWeight)
    ylim([0 27])
    xlim([-50 50])
    title(['Max-Min Positive-Negative Phase Delays in each station relative to: ',stations{j},' (stCode: ',num2str(j),')'])
    xlabel('Time in S')
    ylabel('Station Code')
    yticks([1:26])
    yticklabels({stations{1:26}})
    ytickangle(0)
    grid on
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);%[0 0 1 1]
    %     legend('Negative delay','Pusitive Delay')
    plot(0,j,'.', 'markerSize',20,'color',[.0 .0 0.0])
    plot(0,j,'*', 'markerSize',10,'color',[.0 .0 0.0])
    
    print(j,'-djpeg',['phasDelaDistRelativExactZon-1',stations{j}]);
    % print(j,'-djpeg',['phasDelaDistRelativ',stations{j}]);
    
end

