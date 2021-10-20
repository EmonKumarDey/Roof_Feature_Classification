% function [Linearity, Planerity, BoundaryPoints, alfa, uu, pts1, B_loc, IndxEdgePoint,alphaV]=edge_plane_detection_new(colon_num)
function [Linearity, Planerity, alfa, alfa1, BoundaryPoints, max_diff, pts1]=Training_and_Test_Feature_Creation(colon_num)

%this function is for calculating the genetating the test file that will be
%used for training and testing steps
%---------------------------------------
%open cloud file
if colon_num==3
   [pts1]=ouvrir_fichier(3);
   
else
    
 [pts1]=ouvrir_rapid (4) ;
  pts1=pts1(:,1:3);
end

% This function calcultes the features for each roof cloud point 
[Linearity, Planerity, BreaklinePoint, alfa, alfa1, BoundaryPoints, max_diff, d_2D] =...
    features_For_Classification_new(pts1);
%%alph Value Calculation
% alphaV = mean(mD);
%%%%%

  figure;
   histogram(alfa,'BinWidth',3);
   [N,edges] = histcounts(alfa,'BinWidth',3); 
  
j=find(N>=max(N)*0.7);
% figure;
% hold on;
for u=1:length(j)
uu=find(alfa>=edges(j(u))-3);% &alfa<edges(j(u))+3);
%  plot3( pts1(uu,1), pts1(uu,2), pts1(uu,3),'b.');
end
%uu contain all the extracted fold points
 uu=find((alfa<edges(j(u))-12) & alfa>2);  %%%%% for VA -12, for other case it is -3

 

figure; hold on;
plot3( pts1(:,1), pts1(:,2), pts1(:,3),'.y');
plot3( pts1(uu,1), pts1(uu,2), pts1(uu,3),'.b', 'markersize', 10);
plot3(BoundaryPoints(:,1), BoundaryPoints(:,2), BoundaryPoints(:,3), '.r','markersize', 10);
hold off;




fp1=fopen('BoundaryPoints.txt','w');
fp2 = fopen('FoldPoints.txt','w');
fp3=fopen('Insidepoints.txt','w');

input_pnts = pts1;
v =1; 
figure; hold on;
for i =1:size(uu,2)
fprintf(fp2, '%f\t %f\t %f\t %f\t %f\t %f\n', max_diff(uu(i)), Linearity(uu(i)), Planerity(uu(i)), BreaklinePoint(uu(i)), alfa1(uu(i)), d_2D(uu(i)));
 plot3(input_pnts(uu(i),1), input_pnts(uu(i),2), input_pnts(uu(i),3), '.b');
 NPp(v,:) = [input_pnts(uu(i),1), input_pnts(uu(i),2), input_pnts(uu(i),3)];
 v = v+1;
end


[~,idx] = ismember(BoundaryPoints,pts1,'rows');
for i =1:size(idx,1)
fprintf(fp1, '%f\t %f\t %f\t %f\t %f\t %f\n', max_diff(idx(i)), Linearity(idx(i)), Planerity(idx(i)), BreaklinePoint(idx(i)), alfa1(idx(i)), d_2D(idx(i)));
 plot3(input_pnts(idx(i),1), input_pnts(idx(i),2), input_pnts(idx(i),3), '.r');
 NPp(v,:) = [input_pnts(idx(i),1), input_pnts(idx(i),2), input_pnts(idx(i),3)];
 v = v+1;
end

[inPts, ia] = setdiff(pts1,NPp, 'rows');
 plot3(pts1(ia,1), pts1(ia,2), pts1(ia,3), '.c');
for i=1:size(ia,1)
    fprintf(fp3, '%f\t %f\t %f\t %f\t %f\t %f\n', max_diff(ia(i)), Linearity(ia(i)), Planerity(ia(i)), BreaklinePoint(ia(i)), alfa1(ia(i)), d_2D(ia(i))); 
end

hold off; 


%%%%%%%%%%%Test File creation
fp4=fopen('Test.txt','w');
for i=1:size(pts1,1)
    fprintf(fp4, '%f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\t %f\n', pts1(i,1), pts1(i,2), pts1(i,3), max_diff(i), Linearity(i), Planerity(i), BreaklinePoint(i), alfa1(i), d_2D(i)); 
end

%

fclose(fp1);
fclose(fp2);
fclose(fp3); 
fclose(fp4); 


end