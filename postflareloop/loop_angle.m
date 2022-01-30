function angle=loop_angle(points_all)
line_ind=unique(points_all(:,3));
line_angle=zeros(size(line_ind,1),1);
for k=1:size(line_ind,1)
    limit=zeros(4);
    line_seq= points_all(points_all(:,3)==line_ind(k),1:2);
    [limit(1),ind1]=min(line_seq(:,1));limit(3)=line_seq(ind1,2);
    [limit(2),ind2]=max(line_seq(:,1));limit(4)=line_seq(ind2,2);
    line_angle(k)=-atan((limit(3)-limit(4))/(limit(1)-limit(2)))*180/pi;
end
line_angle=sort(line_angle,'ascend');
angle=line_angle(round(size(line_ind,1)/2));