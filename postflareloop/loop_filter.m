function points_all=loop_filter(img,scale,points_all,uu)
%Exclude loops that are too far
points_all=unique(points_all,'rows');
points_img=zeros(size(img));
for k=1:size(points_all,1)
    points_img(points_all(k,2),points_all(k,1))=1;
end
stats1=regionprops(im2bw(points_img),'Centroid','PixelList');
if size(stats1,1)<=1
    return;
end


%edge point of flare
temp_edge=bwboundaries(logical(uu));
flare_edge=[];
for k=1:size(temp_edge,1)
    flare_edge=[flare_edge;temp_edge{k,1}];
end
%Calculate the distance from the nearest flare edge to the four points on the top, bottom, left, and right of each connected area, and then find the minimum value.
stats_prop=zeros(1,8);
stats_save=zeros(size(stats1));
for k=1:size(stats1,1)
    temp_mat=stats1(k).PixelList;
    [~,temp_ind]=min(temp_mat(:,1));
    stats_prop(1)=temp_mat(temp_ind,1);stats_prop(2)=temp_mat(temp_ind,2);
    [~,temp_ind]=max(temp_mat(:,1));
    stats_prop(3)=temp_mat(temp_ind,1);stats_prop(4)=temp_mat(temp_ind,2);
    [~,temp_ind]=min(temp_mat(:,2));
    stats_prop(5)=temp_mat(temp_ind,1);stats_prop(6)=temp_mat(temp_ind,2);
    [~,temp_ind]=max(temp_mat(:,2));
    stats_prop(7)=temp_mat(temp_ind,1);stats_prop(8)=temp_mat(temp_ind,2);
    
    min1=min(sqrt((flare_edge(:,1)-stats_prop(1)).^2+(flare_edge(:,2)-stats_prop(2)).^2));
    min2=min(sqrt((flare_edge(:,1)-stats_prop(3)).^2+(flare_edge(:,2)-stats_prop(4)).^2));
    min3=min(sqrt((flare_edge(:,1)-stats_prop(5)).^2+(flare_edge(:,2)-stats_prop(6)).^2));
    min4=min(sqrt((flare_edge(:,1)-stats_prop(7)).^2+(flare_edge(:,2)-stats_prop(8)).^2));
    min_stats=min([min1,min2,min3,min4]);
    if min_stats<80
        stats_save(k)=1;
    end
end

for k=1:size(stats1,1)
    if stats_save(k)==1
        continue;
    end
    for j=1:size(stats1,1)
        distance=sqrt((stats1(k).Centroid(1)-stats1(j).Centroid(1))^2+ ...
            (stats1(k).Centroid(2)-stats1(j).Centroid(2))^2);
        if stats_save(j)==1 && distance<50*scale/0.3
            stats_save(k)=1;
        end
    end
end

for k=1:size(stats1)
    if stats_save(k)==0
        que=stats1(k).PixelList;
        [~,~,ib] = intersect(que,points_all(:,1:2),'rows');
        points_all(ib,:)=[];
    end
end

points_all=unique(points_all,'rows');
points_img=zeros(size(img));
for k=1:size(points_all,1)
    points_img(points_all(k,2),points_all(k,1))=1;
end
stats1=regionprops(im2bw(points_img),'Centroid','PixelList');
ib=[];
for k=1:size(stats1)
    temp_len=size(stats1(k).PixelList,1);
    if temp_len<20
        que=stats1(k).PixelList;
        for l0=1:size(que,1)
            for l1=1:size(points_all,1)
                if points_all(l1,1)==que(l0,1) && points_all(l1,2)==que(l0,2)
                    ib=[ib l1];
                end
            end
        end
    end
end
points_all(ib,:)=[];


%Exclude isolated curves
[~,ia,~]=unique(points_all(:,1:2),'rows');
points_all=points_all(ia,:);
points_img=zeros(size(img));
for k=1:size(points_all,1)
    points_img(points_all(k,2),points_all(k,1))=1;
end
stats1=regionprops(im2bw(points_img),'Centroid','PixelList');
distance=zeros(size(stats1,1),size(stats1,1));
for k=1:size(stats1,1)
    for j=1:size(stats1,1)
        distance(k,j)=sqrt((stats1(k).Centroid(1)-stats1(j).Centroid(1))^2+ ...
            (stats1(k).Centroid(2)-stats1(j).Centroid(2))^2);
    end
end
if size(stats1,1)>2
    ib=[];
    for k=1:size(stats1)
        if size(stats1(k).PixelList,1)>50
            continue;
        end
        [temp_dis,~]=sort(distance(k,:),'ascend');
        if temp_dis(round(size(stats1,1)/2))>120*scale/0.3
            que=stats1(k).PixelList;
            [~,~,l1] = intersect(que,points_all(:,1:2),'rows');
            ib=[ib;l1];
        end
    end
    points_all(ib,:)=[];
end