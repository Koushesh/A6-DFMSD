A2B=[];
for ji=1:length(stInfo(:,1))
    A2B(ji)=lldistkm(stInfo(ji,2:3),targCen(1:2));
end
save('A2B','A2B')