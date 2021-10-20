% fp = fopen('train_height.txt', 'r');%ALS data%LIDAR_sample_01_adjusted.txt
% ALS = fscanf(fp, '%f %f %f %*f %*f %*f %*f %*f',[3, inf]);%first_sample01Th1m_FD40cm.txt
% fclose(fp);
% ALS = ALS';
% figure;
% hold on;
% plot3(ALS(:,1), ALS(:,2), ALS(:,3),'.r');


fp = fopen('BoundaryPoints.txt', 'r');%ALS data%LIDAR_sample_01_adjusted.txt
ALS = fscanf(fp, '%f %f %f',[3, inf]);%first_sample01Th1m_FD40cm.txt
fclose(fp);
ALS = ALS';
figure;
hold on;
plot3(ALS(:,1), ALS(:,2), ALS(:,3),'.r');

fp = fopen('BounInit.txt', 'r');%ALS data%LIDAR_sample_01_adjusted.txt
ALS1 = fscanf(fp, '%f %f %f %f %f %f',[6, inf]);%first_sample01Th1m_FD40cm.txt
fclose(fp);
ALS1=ALS1';

j = 1;
for i=1:size(ALS1,1)
    if(ALS1(i,5)<ALS1(i,6))
        WP(j,1:6)=ALS1(i,:);
       j = j+1;
    end
        
end

 plot3(WP(:,1), WP(:,2), WP(:,3), '*g');
 
fp = fopen('InsideInit.txt', 'r');%ALS data%LIDAR_sample_01_adjusted.txt
ALS2 = fscanf(fp, '%f %f %f %f %f %f',[6, inf]);%first_sample01Th1m_FD40cm.txt
fclose(fp);
ALS2=ALS2';

j = 1;
for i=1:size(ALS2,1)
    if(ALS2(i,5)>ALS2(i,6))
        WPI(j,1:6)=ALS2(i,:);
       j = j+1;
    end     
end

 plot3(WPI(:,1), WPI(:,2), WPI(:,3), '.b')

hold off; 