function [area_sum, final_uu]=cal_area(img,th1)
    k_size = 30;
    sigma = 30;
    w=fspecial('gaussian',[k_size k_size],sigma);
    for i = 1:3
        img = imfilter(img, w, 'replicate', 'conv');
    end
   
    uu = zeros(size(img));
    uu(img > th1) = 1;
    
    final_uu = uu;
    area_sum = sum(sum(uu));
end 

