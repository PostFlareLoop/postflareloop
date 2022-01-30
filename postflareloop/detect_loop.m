function [points_all,valid_lines,angle]=detect_loop(img_r100,uu,scale,lines0,angle)
stats=regionprops(uu,'Area');
if size(stats,1)==0
    points_all=[];
    valid_lines=[];
    angle=500;
    return;
end
img=img_r100;
mask=detec_edge(img,scale,uu);

[lines,~,~]=detec_lines(mask,uu,scale);

[valid_line,condition]=loop_direction(uu,lines,scale);
if valid_line~=0
    lines=lines(valid_line);
end

condition=-1;

%Merge with the lines of the previous frame
lines0=check_lines0(img,lines0);
lines=[lines lines0];
for j=1:size(lines,2)
    if lines(j).point1(2)>lines(j).point2(2)
        temp=lines(j).point1;
        lines(j).point1=lines(j).point2;
        lines(j).point2=temp;
    end
end
valid_line=1:size(lines,2);

points_all=loop_grow(img,lines,valid_line,condition,angle);

points_all=loop_grow_pro(img,lines,condition,points_all,angle);

points_all=loop_filter(img,scale,points_all,uu);
if size(points_all,1)
    valid_lines=lines(unique(points_all(:,3)));
else
    valid_lines=[];
end
angle=loop_angle(points_all);