function gray_th=find_th(img)
    [N,edges]=histcounts(img);
    span=3;
    N=smooth(N,span);%Smooth histogram
    [th0,max_ind]=max(N);
    if max_ind>0.8*size(N,1)
        [th0,max_ind]=max(N(1:floor(size(N,1)/2)));
    end
    th0=th0/2;
    ind=size(edges,2)-1;maxima=0;
    for j=size(N,1)-2:-1:max_ind+2
        maxima=max(N(j),maxima);
        if N(j)<=N(j-1) && N(j)<=N(j+1) && (N(j-1)<=N(j-2) || N(j+1)<=N(j+2)) && N(j)<th0 && N(j)<0.9*maxima
            ind=j;
            break;
        end
    end
    gray_th=edges(ind+1);