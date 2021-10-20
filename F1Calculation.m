function [Prec_E, Recl_E, Fscore] = F1Calculation(pts1) % uu / IndxEdgePoint in case of edge % B_loc in case of boundary
%   fp1 = fopen('C:\SVM_Boundary\Generated_Ground_Truth\edge_13.pts', 'r');
 fp1 = fopen('C:\SVM_Boundary_VH2\Generated_Ground_Truth\boundary_5.pts', 'r');
  rP = fscanf(fp1, '%f %f %f %*f\n', [3 inf]);
rP= rP';

%  fp2 = fopen('ClassifiedFoldPoints.txt', 'r');
  % fp2 = fopen('RF_ClassifiedBoundaryPoints.txt', 'r');
 fp2 = fopen('ClassifiedBoundaryPoints.txt', 'r');
  eP = fscanf(fp2, '%f %f %f\n', [3 inf]);
eP= eP';

% idx = ismembertol(eGP, pts1, 0.01, 'rows
[LIA,LocAllB] = ismembertol(rP, pts1, 0.00001, 'ByRows', true);
 T1=zeros(1,size(pts1,1))';
%   eGP = eGP';
 T1(LocAllB)=1;

 
 [LIE,LocAllE] = ismembertol(eP, pts1, 0.00001, 'ByRows', true);
 T2=zeros(1,size(pts1,1))';
 T2(LocAllE)=1; %%% for proposed approach ## edge
%     
 [confMat,order] = confusionmat(T1,T2);
% 
 Prec_E = confMat(2,2)/(confMat(2,2)+confMat(1,2));
 Recl_E = confMat(2,2)/(confMat(2,2)+confMat(2,1));
 Fscore = 2*Prec_E*Recl_E  /(Prec_E+ Recl_E)
 
 fclose(fp1);
 fclose(fp2);
% %%%%