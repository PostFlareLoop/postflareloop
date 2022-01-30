function points_all=loop_grow_pro(img,lines,condition,points_all,angle)
if size(points_all,1)==0
    return;
end

max_rep=10;
ite=0;
repeat=zeros(size(lines,2),size(lines,2));%Count the number of repetitions for each line
while max_rep>2 && ite<100%When the number of iterations exceeds 100, or the maximum intersection of a single curve does not exceed 2, the iteration is stopped.
    if ite==0
        for j=1:size(lines,2)
            temp_points1=points_all(points_all(:,3)==j,1:2);
            temp_points=[];
            for j1=1:size(temp_points1)
                current_x=temp_points1(j1,1);current_y=temp_points1(j1,2);
                test_mat=[current_x current_y;current_x-1 current_y;current_x+1 current_y;current_x-1 current_y-1;current_x current_y-1; ...
                current_x+1 current_y-1;current_x-1 current_y+1;current_x current_y+1;current_x+1 current_y+1];
                temp_points=[temp_points;test_mat];
            end
            temp_points1=[temp_points1;temp_points];

            for k=j+1:size(lines,2)
                temp_points2=points_all(points_all(:,3)==k,1:2);
                temp_points=[];
                for k1=1:size(temp_points2)
                    current_x=temp_points2(k1,1);current_y=temp_points2(k1,2);
                    test_mat=[current_x current_y;current_x-1 current_y;current_x+1 current_y;current_x-1 current_y-1;current_x current_y-1; ...
                    current_x+1 current_y-1;current_x-1 current_y+1;current_x current_y+1;current_x+1 current_y+1];
                    temp_points=[temp_points;test_mat];
                end
                temp_points2=[temp_points2;temp_points];

                [C,~] = intersect(temp_points1,temp_points2,'rows');
                 if size(C,1)>0
                    repeat(j,k)=1;
                 end
            end
        end
        repeat=repeat+imrotate(flipud(repeat),-90);
    else
        temp_points1=points_all(points_all(:,3)==ind(1),1:2);
        temp_points=[];
        for j1=1:size(temp_points1)
            current_x=temp_points1(j1,1);current_y=temp_points1(j1,2);
            test_mat=[current_x current_y;current_x-1 current_y;current_x+1 current_y;current_x-1 current_y-1;current_x current_y-1; ...
            current_x+1 current_y-1;current_x-1 current_y+1;current_x current_y+1;current_x+1 current_y+1];
            temp_points=[temp_points;test_mat];
        end
        temp_points1=[temp_points1;temp_points];

        for k=1:size(lines,2)
            temp_points2=points_all(points_all(:,3)==k,1:2);
            temp_points=[];
            for k1=1:size(temp_points2)
                current_x=temp_points2(k1,1);current_y=temp_points2(k1,2);
                test_mat=[current_x current_y;current_x-1 current_y;current_x+1 current_y;current_x-1 current_y-1;current_x current_y-1; ...
                current_x+1 current_y-1;current_x-1 current_y+1;current_x current_y+1;current_x+1 current_y+1];
                temp_points=[temp_points;test_mat];
            end
            temp_points2=[temp_points2;temp_points];

            [C,~] = intersect(temp_points1,temp_points2,'rows');
             if size(C,1)>0
                repeat(ind(1),k)=1;
             end
        end
    end
    
    [rep_sum,ind]=sort(sum(repeat),'descend');
    max_rep=rep_sum(1);

    chosen_ind= points_all(:,3)==ind(1);

    points_all(chosen_ind,:)=[];

    points_all=loop_grow_1(img,lines,ind(1),points_all,condition,angle);
    
    repeat(:,ind(1))=0;repeat(ind(1),:)=0;
    
    ite=ite+1;
end

[~,ia,~]=unique(points_all(:,1:2),'rows');
points_all=points_all(ia,:);