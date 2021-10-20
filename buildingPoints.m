function [input_pnts] = buildingPoints()

                    fp = fopen('build_11.pts', 'r');

%                 BuildPoints = fscanf(fp, '%f %f %f %*f %*f', [3 inf]);%okland
                   BuildPoints = fscanf(fp, '%f %f %f %*f', [3 inf]);%For FayezBuilding
%                 BuildPoints = fscanf(fp, '%f %f %f %f %f %f %f %f', [8 inf]);
fclose(fp);
input_pnts = BuildPoints';
figure;
 plot3(input_pnts(:,1), input_pnts(:,2), input_pnts(:,3), '.g');

end


