function lines=lines_filter(scale,lines,uu)
if size(lines,2)<=1
    return;
end

%edge point of flare
temp_edge=bwboundaries(logical(uu));
flare_edge=[];
for k=1:size(temp_edge,1)
    flare_edge=[flare_edge;temp_edge{k,1}];
end
%Calculate the distance from the nearest flare edge to the four points on the top, bottom, left, and right of each connected area, and then find the minimum value.
stats_prop=zeros(1,4);
stats_save=zeros(1,size(lines,2));
for k=1:size(lines,2)
    stats_prop(1)=lines(k).point1(1);stats_prop(2)=lines(k).point1(2);
    stats_prop(3)=lines(k).point2(1);stats_prop(4)=lines(k).point2(2);
    
    min1=min(sqrt((flare_edge(:,1)-stats_prop(1)).^2+(flare_edge(:,2)-stats_prop(2)).^2));
    min2=min(sqrt((flare_edge(:,1)-stats_prop(3)).^2+(flare_edge(:,2)-stats_prop(4)).^2));
    min_stats=min([min1,min2]);
    if min_stats<80
        stats_save(k)=1;
    end
end

for k=1:size(lines,2)
    if stats_save(k)==1
        continue;
    end
    cen_k1=(lines(k).point1(1)+lines(k).point2(1))/2;cen_k2=(lines(k).point1(2)+lines(k).point2(2))/2;
    for j=1:size(lines,2)
        cen_j1=(lines(j).point1(1)+lines(j).point2(1))/2;cen_j2=(lines(j).point1(2)+lines(j).point2(2))/2;
        distance=sqrt((cen_k1-cen_j1)^2+ ...
            (cen_k2-cen_j2)^2);
        if stats_save(j)==1 && distance<50*scale/0.3
            stats_save(k)=1;
        end
    end
end
ib=[];

for k=1:size(lines,2)
    if stats_save(k)==0
        ib=[ib;k];
    end
end
lines(ib)=[];