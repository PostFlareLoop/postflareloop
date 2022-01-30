function [lines,theta_range,theta_peak]=detec_lines(mask,uu,scale)
%% For each connection area in the mask, perform a preliminary screening according to the area and eccentricity
stats=regionprops(im2bw(mask),'Area','Eccentricity','PixelIdxList');
for i=1:size(stats,1)
    if stats(i).Area<10 || stats(i).Eccentricity<0.9
        mask(stats(i).PixelIdxList)=0;
    end
end
%% For each connected domain, detect lines separately
stats=regionprops(im2bw(mask),'Area','Eccentricity','PixelIdxList');

lines=[];
for i=1:size(stats,1)
    temp_mask=zeros(size(mask));
    temp_mask(stats(i).PixelIdxList)=1;
    [H,theta,rou] = hough(temp_mask);

    P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));

    temp_lines = houghlines(temp_mask,theta,rou,P,'FillGap',5,'MinLength',3);
    lines=[lines temp_lines];
end


lines=lines_filter(scale,lines,uu);


%% Filter according to the angles of all detected straight lines, and exclude those with wrong angles
theta_all=zeros(18,1);
for i=1:size(lines,2)
    theta_ind=floor(lines(i).theta/10)+10;
    theta_all(theta_ind)=theta_all(theta_ind)+1;
end

[~,theta_peak]=max(theta_all);
theta_peak=theta_peak*10-90;
range=60;
theta_range=zeros(3,1);
theta_range(1)=theta_peak-range/2;theta_range(2)=theta_peak+range/2;theta_range(3)=1;
if theta_peak<-90+range/2
    theta_range(1)=theta_peak+range/2;
    theta_range(2)=theta_range(1)+180-range;
    theta_range(3)=-1;
end
if theta_peak>180-range/2
    theta_range(1)=range-(180-theta_peak);
    theta_range(2)=theta_range(1)+180-range;
    theta_range(3)=-1;
end
lines_dis=[];
for i=1:size(lines,2)
    if i>1
        temp_point1=lines(i).point1;temp_point2=lines(i).point2;
        temp_point3=lines(i-1).point1;temp_point4=lines(i-1).point2;
        if abs(temp_point1(1)-temp_point3(1))+abs(temp_point1(2)-temp_point3(2)) ...
                +abs(temp_point2(1)-temp_point4(1))+abs(temp_point2(2)-temp_point4(2))<10
            lines_dis=[lines_dis i];
            continue;
        end
    end
    if theta_range(3)
        if lines(i).theta<theta_range(1) || lines(i).theta>theta_range(2)
            lines_dis=[lines_dis i];
        end
    else
        if lines(i).theta>theta_range(1) && lines(i).theta<theta_range(2)
            lines_dis=[lines_dis i];
        end
    end
end
lines(lines_dis)=[];