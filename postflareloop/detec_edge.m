function mask=detec_edge(img,scale,uu)
[a,b]=size(img);
temp1=zeros(a,b);%X direction
temp2=zeros(a,b);%Y direction
temp3=zeros(a,b);%Diagonal 1 direction, upper left minus lower right
temp4=zeros(a,b);%Diagonal 2 directions

temp1(1:a,1:b-1)=img(1:a,2:b);
temp2(1:a-1,1:b)=img(2:a,1:b);
temp3(1:a-1,1:b-1)=img(2:a,2:b);
temp4(1:a-1,2:b)=img(2:a,1:b-1);
diff1=abs(img-temp1);
diff2=abs(img-temp2);
diff3=abs(img-temp3);
diff4=abs(img-temp4);

diff1(1:a,b)=0;
diff2(a,1:b)=0;
diff3(a,1:b)=0;diff3(1:a,b)=0;
diff4(a,1:b)=0;diff4(1:a,1)=0;
mask1=ones(a,b);r=round(25/scale*0.3);
mask2=zeros(a,b);
for i=1:a
    for j=1:b
        [s,~]=sort([diff1(i,j) diff2(i,j) diff3(i,j) diff4(i,j)],'descend');
        temp1(i,j)=s(1);
        limit=zeros(4);limit(1)=i-r;limit(2)=i+r;limit(3)=j-r;limit(4)=j+r;
        if i<=r
            limit(1)=1;limit(2)=2*r+1;
        end
        if i>a-r
            limit(1)=a-2*r;limit(2)=a;
        end
        if j<=r
            limit(3)=1;limit(4)=2*r+1;
        end
        if j>b-r
            limit(3)=b-2*r;limit(4)=b;
        end
        temp=img(limit(1):limit(2),limit(3):limit(4));temp_uu=uu(limit(1):limit(2),limit(3):limit(4));
        if min(min(temp))<5e3 || max(max(temp_uu))==1
            mask1(i,j)=0;
        end
        mask2(i,j)=1;
    end
end
mask=double(temp1>0.8e3).*double(img<1e4).*mask1.*mask2;

mask3=ones(size(img));
mask3(211:end,1:204)=0;mask3(370:end,370:end)=0;
mask=mask.*double(mask3);