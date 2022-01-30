function FWHM=cal_FWHM(img0,points_all,scale,FWHM)
%For each curve, a vertical line of length length is drawn every interval point, 
% and the FWHM is calculated according to the grayscale distribution of this perpendicular.
length=31;
interval=5;
[ip,~]=unique(points_all(:,3));
for i=1:size(ip,1)
    %For each curve, find the coordinates of the point on the curve where the width needs to be calculated
    points_on_curve=points_all(points_all(:,3)==ip(i),1:2);
    num_in_test=floor(size(points_on_curve,1)/interval/2);
    test_points=zeros(num_in_test,2);test_points_ori=zeros(num_in_test,2);
    temp_point1=zeros(num_in_test,2);
    temp_point2=zeros(num_in_test,2);
    cross_angle=zeros(num_in_test,1);
    for j=1:num_in_test
        temp_ind=interval+2*interval*(j-1);
        test_points(j,1)=points_on_curve(temp_ind,1);
        test_points(j,2)=points_on_curve(temp_ind,2);
        
        %Find the angle of each point corresponding to the vertical line
        temp_point1(j,1)=points_on_curve(temp_ind-interval+1,1);
        temp_point1(j,2)=points_on_curve(temp_ind-interval+1,2);
        temp_point2(j,1)=points_on_curve(temp_ind+interval-1,1);
        temp_point2(j,2)=points_on_curve(temp_ind+interval-1,2);
        curve_angle=-atan((temp_point2(j,1)-temp_point1(j,1))/(temp_point2(j,2)-temp_point1(j,2)))*180/pi;
        cross_angle(j)=curve_angle+90;%angle of the perpendicular
        
        %In the original image, find the coordinates of all points on the perpendicular
        points_seq=zeros(length,2);
        test_points_ori(j,1)=round(test_points(j,1)/scale);
        test_points_ori(j,2)=round(test_points(j,2)/scale);
        if test_points_ori(j,1)<=(size(points_seq,1)-1)/2 || test_points_ori(j,1)>size(img0,1)-(size(points_seq,1)-1)/2 ...
                || test_points_ori(j,2)<=(size(points_seq,1)-1)/2 || test_points_ori(j,2)>size(img0,2)-(size(points_seq,1)-1)/2
            continue;
        end

        points_seq((length+1)/2,1)=test_points_ori(j,1);points_seq((length+1)/2,2)=test_points_ori(j,2);
        for k=1:(length-1)/2
            points_seq(k,1)=round(test_points_ori(j,1)+((length+1)/2-k)*sin(cross_angle(j)/180*pi));
            points_seq(k,2)=round(test_points_ori(j,2)-((length+1)/2-k)*cos(cross_angle(j)/180*pi));
            points_seq(k+(length+1)/2,1)=round(test_points_ori(j,1)-k*sin(cross_angle(j)/180*pi));
            points_seq(k+(length+1)/2,2)=round(test_points_ori(j,2)+k*cos(cross_angle(j)/180*pi));
        end
        
        %Grayscale distribution on the perpendicular
        gray_seq=zeros(length,1);
        for k=1:length
            gray_seq(k)=img0(points_seq(k,2),points_seq(k,1));
        end
        gray_seq=smooth(gray_seq,3);
        
        %Calculate FWHM
        [gray_min,ind_min]=min(gray_seq(3:length-2));
        ind_min=ind_min+2;
        mmax1=max(gray_seq(1:ind_min));
        gray_max1=gray_seq(max(1,ind_min-10));ind_max1=max(1,ind_min-10);
        for k=ind_min-1:-1:max(2,ind_min-10)
            if gray_seq(k)-gray_min>300 && gray_seq(k)>=gray_seq(k-1) && gray_seq(k)>=gray_seq(k+1)
                gray_max1=gray_seq(k);ind_max1=k;
                break;
            end
        end
        mmax2=max(gray_seq(ind_min:length));
        gray_max2=gray_seq(min(ind_min+10,length));ind_max2=min(ind_min+10,length);
        for k=ind_min+1:min(ind_min+10,length-1)
            if gray_seq(k)-gray_min>300 && gray_seq(k)>=gray_seq(k-1) && gray_seq(k)>=gray_seq(k+1)
                gray_max1=gray_seq(k);ind_max2=k;
                break;
            end
        end
        gray_max=(gray_max1+gray_max2)/2;
        temp_FWHM=sum(max(0,gray_max-gray_seq(ind_max1:ind_max2)))/(gray_max-gray_min);
        if temp_FWHM>3 && temp_FWHM<10
            FWHM=[FWHM;temp_FWHM];
        end
    end
end