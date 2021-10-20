function [pts]=ouvrir_rapid (col_nob) 
 %[pts]=ouvrir_rapid (col_nob);
 
 %Cette fonction permet de lire rappidement un fichier des points
 %Donnees:
 %1- "col_nob":le nombre des colonne dans le fichier.
 
 %Resultat:
 %1- "pts": la liste de points
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%Copy right : Fayez TARSHA KURDI
%tarshafayez@yahoo.fr
%27.07.2008
%-----------------------------------------------------
%ouvrir une fenetre pour choisir le fichier du nuage de points
[filename1, pathname1] = uigetfile({'*.txt','*.txt';'*.xyz','*.xyz';'*.*','*.*'},...
    'Ouvrir un fichier du nuage de points');
if pathname1~=0 
   fil2=[pathname1,filename1];
   fid=fopen(fil2,'r');
   h = waitbar(0,'Veuillez patienter...');
   format bank;
   a = fscanf(fid,'%g %g',[col_nob inf]);   
   pts=a';%la liste de points
   fclose(fid);
   close(h);
end
   
