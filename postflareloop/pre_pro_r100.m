function img=pre_pro_r100(img)
ii=int16(img);
img0=typecast(ii(:), 'uint16');
pre_img=double(reshape(img0,size(img,1),size(img,2)));
img=pre_img(200:2000,500:2200);
