function [valid_line,condition]=loop_direction(uu,lines,scale)
%Find the deflection direction based on the closest bulk flare
%First give the center positions of a few large flares. There are no large flares that exceed the area threshold, the largest one is used
flare_center_all=[];
stats=regionprops(uu,'Area','Centroid');
area_cue=zeros(size(stats,1),1);
for i=1:size(stats,1)
    if stats(i).Area>4000/0.3/0.3*scale^2
        flare_center_all=[flare_center_all;stats(i).Centroid];
    end
    area_cue(i)=stats(i).Area;
end
if size(flare_center_all,1)==0
    [~,ind]=max(area_cue);
    flare_center_all=stats(ind).Centroid;
end
%First get the center of the line and the nearest flare center, and then find the relationship between the angle of the line connecting these two points and the angle of the line itself, so as to get the deflection direction
direction_cue=zeros(size(lines,2),1);
condition_cue=zeros(size(lines,2),1);
flare_center_line=zeros(size(lines,2),2);
for i=1:size(lines,2)
    line_center=(lines(i).point1+lines(i).point2)/2;
    dis=zeros(size(flare_center_all,1),1);
    for j=1:size(flare_center_all,1)
        dis(j)=(flare_center_all(j,1)-line_center(1))^2+(flare_center_all(j,2)-line_center(2))^2;
    end
    [~,ind]=min(dis);
    flare_center=flare_center_all(ind,:);
    flare_center_line(i,:)=flare_center;

    temp_theta=atan((flare_center(2)-line_center(2))/(flare_center(1)-line_center(1)))*180/pi;
    temp_theta=-temp_theta/abs(temp_theta)*(90-abs(temp_theta));
    if abs(temp_theta-lines(i).theta)>90
        if temp_theta>0
            temp_theta=temp_theta-180;
        else
            temp_theta=temp_theta+180;
        end
    end
    if temp_theta<lines(i).theta
        direction_cue(i)=-1;
    else
        direction_cue(i)=1;
    end
    if ((lines(i).point1(1)-flare_center(1))^2+(lines(i).point1(2)-flare_center(2))^2)< ...
            ((lines(i).point2(1)-flare_center(1))^2+(lines(i).point2(2)-flare_center(2))^2)

        condition_cue(i)=1;
    else
        condition_cue(i)=-1;
    end
end

direction=sum(direction_cue);
if direction==0
    condition=0;
    valid_line=0;
    return
end
direction=direction/abs(direction);

if sum(condition_cue)>0
    condition_line=1;
else
    condition_line=-1;
end
valid_line=find(condition_cue==condition_line);
condition=condition_line*direction;