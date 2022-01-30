function img=pre_pro(img)
    th=30000;%A grayscale threshold for judging whether it belongs to a dark spot
    ii=int16(img);
    img0=typecast(ii(:), 'uint16');
    pre_img0=double(reshape(img0,size(img,1),size(img,2)));
    
for i=1:5%number of iterations
    ordered = ordfilt2(pre_img0,25,ones(5,5));%The local gray value corresponding to each pixel point
    temp=abs(ordered-pre_img0)>th;
    pre_img=temp.*ordered+(1-temp).*pre_img0;
    if sum(sum(temp))<5000
        break;
    end
    pre_img0=pre_img;
end

img=pre_img(200:2000,500:2200);%According to the field of view of GST