function [ForestResults] = randomforestexample()

% load fisheriris
% X = meas;
% Y = species;
% BaggedEnsemble = generic_random_forests(X,Y,60,'classification')
fp = fopen('TrainingVAss.txt', 'r'); 
%fp = fopen('All_Training.txt', 'r');  % All_Training file contain training points from both AV and VA sites
TrainingSet = fscanf(fp, '%f %f %f %f %f %f %*f',[6, inf]);%skipping 6th column
TrainingSet = TrainingSet';
fclose(fp);

 fp = fopen('TrainingVAss.txt', 'r');
%fp = fopen('All_Training.txt', 'r');  % All_Training file contain training points from both AV and VA sites
Label = fscanf(fp, '%*f %*f %*f %*f %*f %*f %f',[1, inf]);  
Label = Label';
fclose(fp);

BaggedEnsemble = generic_random_forests(TrainingSet,Label,40,'classification')

% fp = fopen('TestFile_FayezBuilding.txt', 'r'); 
fp = fopen('Test.txt', 'r'); 
TestSet = fscanf(fp, '%*f %*f %*f %f %f %f %f %f %f\n',[6, inf]); %skipping 1,2 3rd column
TestSet = TestSet';
fclose(fp);

%fp = fopen('TestFile_FayezBuilding.txt', 'r'); 
fp = fopen('Test.txt', 'r'); 
TestPoints = fscanf(fp, '%f %f %f %*f %*f %*f %*f %*f %*f\n',[3, inf]);
TestPoints = TestPoints';
fclose(fp);

fp1=fopen('RF_ClassifiedBoundaryPoints.txt','w');
fp2 = fopen('RF_ClassifiedFoldPoints.txt','w');
fp3=fopen('RF_ClassifiedInsidepoints.txt','w');


ForestResults = zeros(length(TestSet(:,1)),1);

figure; 
hold on;
for i = 1:size(TestSet,1)
ForestResult(i)=str2double(predict(BaggedEnsemble,[TestSet(i,1) TestSet(i,2) TestSet(i,3) TestSet(i,4) TestSet(i,5) TestSet(i,6)]));
if (ForestResult(i)==1)
    plot3(TestPoints(i,1), TestPoints(i,2), TestPoints(i,3), '.r');
    fprintf(fp1, "%f\t %f\t %f\n", TestPoints(i,1), TestPoints(i,2), TestPoints(i,3));
elseif (ForestResult(i)==2)
    plot3(TestPoints(i,1), TestPoints(i,2), TestPoints(i,3), '.b');
    fprintf(fp2, "%f\t %f\t %f\n", TestPoints(i,1), TestPoints(i,2), TestPoints(i,3));
 else 
    plot3(TestPoints(i,1), TestPoints(i,2), TestPoints(i,3), '.c');
    fprintf(fp3, "%f\t %f\t %f\n", TestPoints(i,1), TestPoints(i,2), TestPoints(i,3));
end
end
fclose(fp1);
fclose(fp2);
fclose(fp3);
hold off; 
end