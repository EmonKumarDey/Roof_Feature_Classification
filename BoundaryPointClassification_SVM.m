function [result] = BoundaryPointClassification_SVM()
%This section takes the calculated features from the training file
 fp = fopen('TrainingVAss.txt', 'r'); 
%fp = fopen('All_Training.txt', 'r');  % All_Training file contain training points from both AV and VA sites
TrainingSet = fscanf(fp, '%f %f %f %f %f %f %*f',[6, inf]); %skipping 4th column
TrainingSet = TrainingSet';
fclose(fp);

% This section takes the label of each point
 fp = fopen('TrainingVAss.txt', 'r'); 
%fp = fopen('All_Training.txt', 'r'); 
GroupTrain = fscanf(fp, '%*f %*f %*f %*f %*f %*f %f',[1, inf]); 
GroupTrain = GroupTrain';
fclose(fp);


%This section takes the features of all points of the test building
fp = fopen('Test.txt', 'r'); 
TestSet = fscanf(fp, '%*f %*f %*f %f %f %f %f %f %f\n',[6, inf]); %skipping 1,2 3rd column
TestSet = TestSet';
fclose(fp);


%Read the X Y and Z coordinates for demonstration perpuse
fp = fopen('Test.txt', 'r'); 
TestPoints = fscanf(fp, '%f %f %f %*f %*f %*f %*f %*f %*f\n',[3, inf]);
TestPoints = TestPoints';
fclose(fp);

% This line train and classifies the test point using support vector machine for
[result] = multisvm(TrainingSet,GroupTrain,TestSet);


fp1=fopen('ClassifiedBoundaryPoints.txt','w');
fp2 = fopen('ClassifiedFoldPoints.txt','w');
fp3=fopen('ClassifiedInsidepoints.txt','w');

figure; 
hold on;
for i =1:size(result,1)
    if (result(i) == 1) %% boundary
        plot3(TestPoints(i,1), TestPoints(i,2), TestPoints(i,3), '.r');
        fprintf(fp1, "%f\t %f\t %f\n", TestPoints(i,1), TestPoints(i,2), TestPoints(i,3));
    end
end

for i =1:size(result,1)
    if (result(i) == 2) %% fold
        plot3(TestPoints(i,1), TestPoints(i,2), TestPoints(i,3), '.b');
        fprintf(fp2, "%f\t %f\t %f\n", TestPoints(i,1), TestPoints(i,2), TestPoints(i,3));
    end
end

for i =1:size(result,1)
    if (result(i) == 3) %% inside
        plot3(TestPoints(i,1), TestPoints(i,2), TestPoints(i,3), '.c');
        fprintf(fp3, "%f\t %f\t %f\n", TestPoints(i,1), TestPoints(i,2), TestPoints(i,3));
    end
end
hold off;
fclose(fp1);
fclose(fp2);
fclose(fp3);
end