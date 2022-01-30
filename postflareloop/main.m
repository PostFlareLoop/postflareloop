clear;close all hidden;clc

scale=0.3;%scaling ratio
closepath ='';
files=dir(strcat(closepath,'\*.fts')); 
closepath0 ='';
files0=dir(strcat(closepath0,'\*.fts')); 

frame_num=length(files0);
symb=zeros(frame_num,1);
area=zeros(frame_num,1);
max_int_pre=65535;%The grayscale maximum value of the previous frame
max_int_all=0;%global grayscale maximum
max_int_beg=0;
cnt0=0;%Count the number of consecutive increases in the maximum gray value, which is used to find the flare start time
cnt1=0;%Count the number of continuous non-updated maximum gray values, used to find the end time of the flare
cnt2=0;%Count the number of consecutive drops in the maximum gray value, which is used to find the end time of the flare
cnt3=0;%Count the number of consecutive maximum grayscale values below a certain threshold, used to find the time when the flare completely ends
th1=60000;th2=0.8*th1;
valid_lines=[];
angle=500;
FWHM=[];

for i=201:320
    Filesname0=strcat(closepath0,'\',files0(i).name);
    img_r000=fitsread(Filesname0);

    [uu0,img_r000,area,symb,cnt0,cnt1,cnt2,                                                                                                                                                                                                                                                                                                                                                 cnt3,max_int_pre,max_int_all,max_int_beg,th1] ...
        =flare_det1(img_r000,i,symb,area,cnt0,cnt1,cnt2,cnt3,max_int_pre,max_int_all,max_int_beg,th1,th2);
   
    stats=regionprops(uu0,'Area');
    
    Filesname=strcat(closepath,'\',files(i).name);
    img_r100=fitsread(Filesname);
    img0=pre_pro_r100(img_r100);
    
    img_r100=imresize(img0,scale);
    
    if size(stats,1)==0
        points_all=[];
        valid_lines=[];
    else
        if i~=326 && i~=327 && size(stats,1)
            uu=imresize(uu0,scale);
            [points_all,valid_lines,angle]=detect_loop(img_r100,uu,scale,valid_lines,angle);
            FWHM=cal_FWHM(img0,points_all,scale,FWHM);
        else
            continue;
        end
    end
end