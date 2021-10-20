%M-file ,boundary_extract.m
%����ƽ����ͶӰ���귽λ���жϱ߽�㣨���Ч������õģ�
%input_pnts(nx3)
function [boundary_pnts] = boundary_extract(input_pnts,number_of_neighbor)
n=size(input_pnts,1);     %��õ�һά�ȣ��У��Ĺ�ģ
k=number_of_neighbor;
neighbor_idx=knnsearch(input_pnts,input_pnts,'k',number_of_neighbor+1);  %��P���Ӧ��k+1���ڽ�������һ��
neighbor_idx=neighbor_idx(:,2:number_of_neighbor+1);  %��P���Ӧ��k���ڽ�������һ��
normal_pnts=zeros(3,n);    %����3*n��ȫ�����
line=zeros(n,1);
for i=1:n
    neighbor_pnts=input_pnts(neighbor_idx(i,:),:);  %�ó���k����ģ�k*3������
    mean_neighbor=mean(neighbor_pnts,1);    %��k�������������ƽ��ֵ
    v=repmat(mean_neighbor',1,number_of_neighbor)-neighbor_pnts';
      C=v*v';       %ת��3*3�ľ���
  [V,D] = eig(C);    %VΪ����ֵ��Ӧ��������������DΪ����ֵ�Խ���
  [s,j] = min(diag(D));  %��D��ĶԽ�Ԫ����Сֵ��jΪ��С����ֵ��Ӧ������
                          %sΪ��С����ֵ��Ӧ����������
  normal_pnts = V(:, j);  %�������ļ���
 lamda=(repmat(input_pnts(i,:)*normal_pnts,number_of_neighbor,1)-neighbor_pnts*normal_pnts)/(sum(normal_pnts.^2));% kx1�о���
 proj_pnts=normal_pnts*lamda'+neighbor_pnts';%3xk
 x_unit_vector=(proj_pnts(:,k)'-input_pnts(i,:))/norm(proj_pnts(:,k)'-input_pnts(i,:));% ͨ��̽���input_pnts(i,:)��ͶӰ�ڽ�����Զ�ĵ�proj_pnts(:,k)'����x�ᷨ���� 1x3 
 y_unit_vector=cross(normal_pnts,x_unit_vector)/norm(cross(normal_pnts,x_unit_vector)); %��������������˳��Բ�˵�ģ��ȷ����һ���������ϵĵ�λ���� 1x3
 x_plane=sum(repmat(x_unit_vector,k,1).*(proj_pnts'-repmat(input_pnts(i,:),k,1)),2); % ���ݵ�λ�������Է������õ���ƽ��x���ϵ�ͶӰkx1
 y_plane=sum(repmat(y_unit_vector,k,1).*(proj_pnts'-repmat(input_pnts(i,:),k,1)),2); % ���ݵ�λ�������Է������õ���ƽ��y���ϵ�ͶӰkx1
 azimuth= rad2deg(atan2(y_plane,x_plane)); %�������귽λ�ǣ�������ڵ�һ�͵ڶ�����������ֵ������ǵ����͵����������Ǹ�ֵ
 azimuth(azimuth<0)= azimuth(azimuth<0)+360 ; %�����귽λ�ǵĸ�ֵȫ����Ϊ��ֵ
sort_azimuth=sort(azimuth);
diff_azimuth=diff(sort_azimuth);
max_diff(i,:)=max(diff_azimuth);
end
idx=find(max_diff>120);
boundary_pnts=input_pnts(idx,:);

