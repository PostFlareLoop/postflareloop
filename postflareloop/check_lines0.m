function lines0=check_lines0(img,lines0)
lines0_ind=[];
for j=1:size(lines0,2)
    temp_gray=[];
    points=[lines0(j).point1 j];
    start_x=lines0(j).point1(1);start_y=lines0(j).point1(2);
    len=round(norm(lines0(j).point1 - lines0(j).point2));
    for k=1:len
        exact_x=start_x-k*sin(lines0(j).theta/180*pi);
        exact_y=start_y+k*cos(lines0(j).theta/180*pi);
        current_x=round(exact_x);current_y=round(exact_y);
        points=[points;current_x current_y j];
        current_gray=img(current_y,current_x);
        temp_gray=[temp_gray;current_gray];
    end
    if max(temp_gray)<1.1e4%This is an empirical threshold used to exclude some false straight lines based on grayscale
        lines0_ind=[lines0_ind j];
    end
end
lines0=lines0(lines0_ind);