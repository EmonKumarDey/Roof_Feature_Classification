% function [Linearity, Planerity, BoundaryPoints, normal_pnts,alfa,alfa1,point_num, B_loc, IndxEdgePoint, mD] = features_For_Classification_new(input_pnts)
function [Linearity, Planerity, BreaklinePoint, alfa, alfa1, BoundaryPoints, max_diff, d_2D] = features_For_Classification_new(input_pnts)
number_of_neighbor=9; bp=1; bl =1; 
n=size(input_pnts,1);    
k=number_of_neighbor;
neighbor_idx=knnsearch(input_pnts,input_pnts,'k',number_of_neighbor+1);  
neighbor_idx=neighbor_idx(:,2:number_of_neighbor+1); 
%----------------------------------
neighbor_idx=cat(2,neighbor_idx,zeros(size(neighbor_idx,1),30));
planerity_error=zeros(size(neighbor_idx,1),1);
for i=1:size(neighbor_idx,1)
[Nx, Ny, Nz,Standard_D,deviations]=fit_3D_line(input_pnts(neighbor_idx(i,1:number_of_neighbor),:));
if Standard_D <=0.5       %for HB/AV, SD = 0.08/0.23 --- for VH = 0.5 ---- 0.07 for other --- 0.0004 for s_wuhan
    s1=5;

    while Standard_D<=0.5 % for HB/AV, SD = 0.08/ 0.15 --- for VH =0.5/0.7
          neighbor_idx_one=knnsearch(input_pnts,input_pnts(i,:),'k',number_of_neighbor+s1+1);
          neighbor_idx_one=neighbor_idx_one(:,2:number_of_neighbor+s1+1); 
          neighbor_idx_one_1=neighbor_idx_one;
          [Nx, Ny, Nz,Standard_D,deviations]=fit_3D_line(input_pnts(neighbor_idx_one(1,:),:)); 
          u=find(abs(deviations)>0.03);
          if length(u)>6& size(neighbor_idx_one_1,2)>50
              v=find(abs(deviations)<=0.03);
              neighbor_idx_one_1= neighbor_idx_one;
              neighbor_idx_one_1(1,v')=0;
              
              [Nx, Ny, Nz,Standard_D,deviations]=fit_3D_line(input_pnts(neighbor_idx_one_1(1,u),:));
          end
          s1=s1+5;
         
    end
    neighbor_idx(i,1:size(neighbor_idx_one,2))=neighbor_idx_one_1(1,:);
end
Standard_D_list(i,1)=Standard_D;

end

%Boundary point Calculation start
for i=1:size(neighbor_idx,1)
     k=nonzeros(neighbor_idx(i,:));
    meanPnt=mean(input_pnts(k,:),1);
    p1 = input_pnts(i,:);
    d_3D(i) = norm(input_pnts(i,:) - meanPnt);
    d_2D(i) = norm(p1(1:2) -  meanPnt(1:2));
    
    %% alphashape
    maxD = MaxDistanceCalc(input_pnts(k,:));
    mD(i)=maxD;
    %%
end

figure; hold on;
plot3(input_pnts(:,1), input_pnts(:,2), input_pnts(:,3), '.g');
for i=1:size(d_3D,2)
    if d_2D(i)>=0.25
        BoundaryPoints(bp,:) = input_pnts(i,:); 
        B_loc(bl)=i; 
        plot3(input_pnts(i,1), input_pnts(i,2), input_pnts(i,3), '.r', 'markersize', 10);
        bp = bp +1; 
        bl = bl +1; 
    end
end
hold off;

%boundary calculation end


%  neighbor_idx=neighbor_idx(:,1:number_of_neighbor); %ekhane oi point shoho neighbour
normal_pnts=zeros(3,n);    
line=zeros(n,1);
ep = 1; Fep = 1; Tep=1; Fep_T=1; 
for i=1:n
    j=find(neighbor_idx(i,:)~=0);
    number_of_neighbor=length(j);
    neighbor_num(i)=length(j);
    neighbor_pnts=input_pnts(neighbor_idx(i,j'),:);  
    mean_neighbor=mean(neighbor_pnts,1);   
    v=repmat(mean_neighbor',1,number_of_neighbor)-neighbor_pnts';
    C=v*v';       
    [V,D] = eig(C);    
    [s,j] = min(diag(D));
    %-------------------------
    %Fayez
    normal_pnts = V(:, j);  
    normal_pnts1 (:,i) = V(:, j);
    
%     i 
    
    k = number_of_neighbor; 
    
    lamda=(repmat(input_pnts(i,:)*normal_pnts,number_of_neighbor,1)-neighbor_pnts*normal_pnts)/(sum(normal_pnts.^2));% kx1列矩阵
 proj_pnts=normal_pnts*lamda'+neighbor_pnts';%3xk
 x_unit_vector=(proj_pnts(:,k)'-input_pnts(i,:))/norm(proj_pnts(:,k)'-input_pnts(i,:));% 通过探测点input_pnts(i,:)和投影邻近点最远的点proj_pnts(:,k)'构建x轴法向量 1x3 
 y_unit_vector=cross(normal_pnts,x_unit_vector)/norm(cross(normal_pnts,x_unit_vector)); %根据两个向量叉乘除以叉乘的模来确定另一个坐标轴上的单位向量 1x3
 x_plane=sum(repmat(x_unit_vector,k,1).*(proj_pnts'-repmat(input_pnts(i,:),k,1)),2); % 根据单位向量乘以法向量得到在平面x轴上的投影kx1
 y_plane=sum(repmat(y_unit_vector,k,1).*(proj_pnts'-repmat(input_pnts(i,:),k,1)),2); % 根据单位向量乘以法向量得到在平面y轴上的投影kx1
 azimuth= rad2deg(atan2(y_plane,x_plane)); %计算坐标方位角，如果是在第一和第二象限则是正值，如果是第三和第四象限则是负值
 azimuth(azimuth<0)= azimuth(azimuth<0)+360 ; %将坐标方位角的负值全部变为正值
sort_azimuth=sort(azimuth);
diff_azimuth=diff(sort_azimuth);
max_diff(i,:)=max(diff_azimuth);
    
    %----------------------------
    ev = eig(C);
    Lembd = sort(ev,'descend');
    Linearity(i) = (Lembd(1)-Lembd(2))/Lembd(1);
    Planerity(i) = (Lembd(2)-Lembd(3))/Lembd(1);
    BreaklinePoint(i) = (Lembd(3)/(Lembd(1) + Lembd(2) + Lembd(3)));   % Nurunnabi method - 2015
    
    X= neighbor_pnts;
%      X = input_pnts(neighbor_idx(i,:),:);
     if size(X,1)<4  %%% considering four neighbours minimum
        continue;
     end
 %-------------------
         

end
 [alfa1]=test_neighbours(normal_pnts1,input_pnts);
i=find(Planerity <0.5);
 for i=1:size(normal_pnts1,2)
 alfa(1,i) = atan2(norm(cross(normal_pnts1(:,i),[0,0,1])),dot(normal_pnts1(:,i),[0,0,1]));
 end
 alfa=alfa*180/pi;


 
% fp1=fopen('BoundaryPoints.txt','w');
% fp2 = fopen('FoldPoints.txt','w');
% fp3=fopen('Insidepoints.txt','w');
% 
% figure; hold on;
% for i=1:n
%     if max_diff(i)>96
% %           fprintf(fp, '%f\t %f\t %f\t %f\t %f\t %f\n', input_pnts(i,1), input_pnts(i,2), input_pnts(i,3), max_diff(i), Linearity(i), Planerity(i));
% %           fprintf(fp, '%f\t %f\t %f\n', input_pnts(i,1), input_pnts(i,2), input_pnts(i,3));
%          fprintf(fp1, '%f\t %f\t %f\t %f\t %f\n', max_diff(i), Linearity(i), Planerity(i), BreaklinePoint(i), alfa1(i));
%          plot3(input_pnts(i,1), input_pnts(i,2), input_pnts(i,3), '.r');
%     elseif alfa1(i) > 20
% %         fprintf(fp2, '%f\t %f\t %f\t %f\t %f\t %f\n', input_pnts(i,1), input_pnts(i,2), input_pnts(i,3), max_diff(i), Linearity(i), Planerity(i));
% %           fprintf(fp2, '%f\t %f\t %f\n', input_pnts(i,1), input_pnts(i,2), input_pnts(i,3));
%          fprintf(fp2, '%f\t %f\t %f\t %f\t %f\n', max_diff(i), Linearity(i), Planerity(i), BreaklinePoint(i), alfa1(i));
%          plot3(input_pnts(i,1), input_pnts(i,2), input_pnts(i,3), '.b');
%     else
% %          fprintf(fp1, '%f\t %f\t %f\t %f\t %f\t %f\n', input_pnts(i,1), input_pnts(i,2), input_pnts(i,3), max_diff(i), Linearity(i), Planerity(i));
% %          fprintf(fp1, '%f\t %f\t %f\n', input_pnts(i,1), input_pnts(i,2), input_pnts(i,3));
%          fprintf(fp3, '%f\t %f\t %f\t %f\t %f\n', max_diff(i), Linearity(i), Planerity(i), BreaklinePoint(i), alfa1(i));
%          plot3(input_pnts(i,1), input_pnts(i,2), input_pnts(i,3), '.y');
%     end
% end
% fclose(fp1);
% fclose(fp2);
% fclose(fp3); 
% 
% hold off;
 
 
end
