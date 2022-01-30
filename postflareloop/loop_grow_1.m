function points_all=loop_grow_1(img,lines,ind,points_all,condition,angle)

[a,b]=size(img);
len0=20;

start_x0=(lines(ind).point1(1)+lines(ind).point2(1))/2;start_y0=(lines(ind).point1(2)+lines(ind).point2(2))/2;
start_x0=round(start_x0);start_y0=round(start_y0);
start_gray0=img(start_y0,start_x0);
points=[start_x0 start_y0 ind];

%grow upward
start_x=start_x0;start_y=start_y0;
start_gray=start_gray0;len_temp=len0;
ini_theta=lines(ind).theta;pre_theta=ini_theta;
while len_temp==len0 && abs(ini_theta-pre_theta)<20
    len=ones(5,1);
    temp_points=[];temp_points1=[];temp_points2=[];temp_points3=[];temp_points4=[];temp_points5=[];
    temp_gray=[];gray_rms=zeros(5,1);
    for j=1:5
        tune_ratio=0.2*j;
        len(j)=1;current_gray=start_gray;
        while current_gray<min(1.5*start_gray,1.1e4) && len(j)<len0
            temp_theta=ini_theta+condition*len(j)*tune_ratio;
            exact_x=start_x+len(j)*sin(temp_theta/180*pi);
            exact_y=start_y-len(j)*cos(temp_theta/180*pi);
            current_x=round(exact_x);current_y=round(exact_y);
            if current_x>b || current_x<1 || current_y>a || current_y<1
                break;
            end
            test_mat=[current_x current_y;current_x-1 current_y;current_x+1 current_y;current_x-1 current_y-1; ...
                current_x current_y-1;current_x+1 current_y-1;current_x-1 current_y+1;current_x current_y+1;current_x+1 current_y+1];
            [C,~,~] = intersect(test_mat,points_all(:,1:2),'rows');
            if size(C,1)
                temp_points=temp_points(1:end-2,:);
                break;
            end
            current_gray=img(current_y,current_x);
            temp_gray=[temp_gray;current_gray];
            len(j)=len(j)+1;
            temp_points=[temp_points;current_x current_y ind];
        end
        switch j
            case 1
                temp_points1=temp_points;
            case 2
                temp_points2=temp_points;
            case 3
                temp_points3=temp_points;
            case 4
                temp_points4=temp_points;
            case 5
                temp_points5=temp_points;
        end
        gray_rms(j)=std(temp_gray);temp_gray=[];
        temp_points=[];
    end
    qua=len/min(len)*max(gray_rms)./gray_rms;
    [~,rank]=max(qua);
    switch rank
        case 1
            points=[points;temp_points1];len_temp=len(1);
        case 2
            points=[points;temp_points2];len_temp=len(2);
        case 3
            points=[points;temp_points3];len_temp=len(3);
        case 4
            points=[points;temp_points4];len_temp=len(4);
        case 5
            points=[points;temp_points5];len_temp=len(5);
    end
    start_x=points(end,1);start_y=points(end,2);start_gray=img(start_y,start_x);
    if size(points,1)>len0
        pre_theta=ini_theta;
        ini_theta=-atan((points(end,1)-points(end-5,1))/(points(end,2)-points(end-5,2)))*180/pi;
    end
    if abs(ini_theta-lines(ind).theta)>90
        ini_theta=-ini_theta;
    end
end


%grow downward
start_x=start_x0;start_y=start_y0;
start_gray=start_gray0;len_temp=len0;
ini_theta=lines(ind).theta;pre_theta=ini_theta;
while len_temp==len0 && abs(ini_theta-pre_theta)<20
    len=ones(5,1);
    temp_points=[];temp_points1=[];temp_points2=[];temp_points3=[];temp_points4=[];temp_points5=[];
    temp_gray=[];gray_rms=zeros(5,1);
    for j=1:5
        tune_ratio=0.2*j;
        len(j)=1;current_gray=start_gray;
        while current_gray<min(1.5*start_gray,1.1e4) && len(j)<len0
            temp_theta=lines(ind).theta-condition*len(j)*tune_ratio;
            exact_x=start_x-len(j)*sin(temp_theta/180*pi);
            exact_y=start_y+len(j)*cos(temp_theta/180*pi);
            current_x=round(exact_x);current_y=round(exact_y);
            if current_x>b || current_x<1 || current_y>a || current_y<1
                break;
            end
            test_mat=[current_x current_y;current_x-1 current_y;current_x+1 current_y;current_x-1 current_y-1;current_x current_y-1; ...
                current_x+1 current_y-1;current_x-1 current_y+1;current_x current_y+1;current_x+1 current_y+1];
            [C,~,~] = intersect(test_mat,points_all(:,1:2),'rows');
            if size(C,1)
                temp_points=temp_points(1:end-2,:);
                break;
            end
            current_gray=img(current_y,current_x);
            temp_gray=[temp_gray;current_gray];
            len(j)=len(j)+1;
            temp_points=[temp_points;current_x current_y ind];
        end
        switch j
            case 1
                temp_points1=temp_points;
            case 2
                temp_points2=temp_points;
            case 3
                temp_points3=temp_points;
            case 4
                temp_points4=temp_points;
            case 5
                temp_points5=temp_points;
        end
        gray_rms(j)=std(temp_gray);temp_gray=[];
        temp_points=[];
    end
    qua=len/min(len)*max(gray_rms)./gray_rms;
    [~,rank]=max(qua);
    switch rank
        case 1
            points=[points;temp_points1];len_temp=len(1);
        case 2
            points=[points;temp_points2];len_temp=len(2);
        case 3
            points=[points;temp_points3];len_temp=len(3);
        case 4
            points=[points;temp_points4];len_temp=len(4);
        case 5
            points=[points;temp_points5];len_temp=len(5);
    end
    start_x=points(end,1);start_y=points(end,2);start_gray=img(start_y,start_x);
    if size(points,1)>len0
        pre_theta=ini_theta;
        ini_theta=-atan((points(end,1)-points(end-5,1))/(points(end,2)-points(end-5,2)))*180/pi;
    end
    if abs(ini_theta-lines(ind).theta)>90
        ini_theta=-ini_theta;
    end
end

limit=zeros(4);
[limit(1),ind1]=min(points(:,1));limit(3)=points(ind1,2);
[limit(2),ind2]=max(points(:,1));limit(4)=points(ind2,2);
line_angle=-atan((limit(3)-limit(4))/(limit(1)-limit(2)))*180/pi;
angle_dis=min(abs(line_angle-angle),abs(abs(line_angle-angle)-180));

%remove short curves
if size(points,1)>20 && (angle==500 || angle_dis<20)
    points_all=[points_all;points];
end