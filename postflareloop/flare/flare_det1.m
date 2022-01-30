function [uu,img,area,symb,cnt0,cnt1,cnt2,cnt3,max_int_pre,max_int_all,max_int_beg,th1] ...
    =flare_det1(img,i,symb,area,cnt0,cnt1,cnt2,cnt3,max_int_pre,max_int_all,max_int_beg,th1,th2)
%For high-resolution images, determine whether each image contains flares from scratch, extract the flares, and calculate the area
uu=zeros(size(img));
img=pre_pro(img);
if symb~=-1
    th1=find_th(img);%th1is the grayscale threshold at the flare begins
end
max_int=max(max(img));    
if max_int>max_int_all
    max_int_all=max_int;
end

if i>=2 && symb(i)==0%If it's not a flare yet, start counting
    if (max_int>max_int_pre) || max_int>65500
        cnt0=cnt0+1;
    else
        cnt0=0;
    end
    if cnt0==3
        [area(i),uu]=cal_area(img,th1);
        if max_int>th1 && area(i)>th2%The final decision is flare.
            symb(i)=1;symb(i+1)=1;cnt0=0;max_int_all=max_int;max_int_beg=max_int_pre;
        else
            area(i)=0;uu=zeros(size(img));cnt0=cnt0-1;
        end
    end
end

if symb(i)==1%The previous frame is already a flare, and it is necessary to determine whether this frame is not
    [area(i),uu]=cal_area(img,th1);
    if max_int>0.6*(max_int_all-max_int_beg)+max_int_beg
        cnt1=0;cnt2=0;
    else
        cnt1=cnt1+1;
        if max_int<max_int_pre
            cnt2=cnt2+1;
        else
            cnt2=0;
        end
    end
    if area(i)<th2 || (cnt1>=10 && cnt2>=3)
        symb(i)=-1;symb(i+1)=-1;max_int_all=0;max_int_beg=0;cnt1=0;cnt2=0;
    else
        symb(i+1)=1;
    end
end

if symb(i)==-1
    if max_int<48000
        cnt3=cnt3+1;
    else
        cnt3=0;
    end
    if cnt3>=5
        symb(i+1)=0;%Indicates that the previous flare is completely over, and is ready to identify new flares that appear later
    else
        symb(i+1)=-1;
    end
    [area(i),uu]=cal_area(img,th1);
    if area(i)>=th2 && area(i)>=area(i-1)
        cnt0=cnt0+1;
    else
        for j=0:cnt0
            area(i-j)=0;
        end
        cnt0=0;
    end
    if cnt0==3
        area(i-2)=0;area(i-1)=0;symb(i)=1;symb(i+1)=1;cnt0=0;
    end
end

max_int_pre=max_int;
