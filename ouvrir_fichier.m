function [pts1]=ouvrir_fichier(col_nob);

%%lire le fichier de points
[filename1, pathname1] = uigetfile({'*.txt','*.txt';'*.xyz',...
    '*.xyz';'*.asc','*.asc';'*.*','*.*'},...
    'Ouvrir un fichier de points');
if pathname1~=0 
   fil2=[pathname1,filename1];
   fid=fopen(fil2,'r');
   h = waitbar(0,'Veuillez patienter...');
   format bank;
   %fid = fopen('test1.txt');
   a = fscanf(fid,'%g %g',[3 inf]);   
   pts1=a';
   fclose(fid);
   close(h);
end