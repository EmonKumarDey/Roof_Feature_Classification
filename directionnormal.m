[x, y, z] = meshgrid(0:1);
x = x(:);
y = y(:);
z = z(:);
tri = convhull(x,y,z);
tr = triangulation(tri, x, y, z);
figure('Color', 'white')
trisurf(tr,'faceColor','cyan')
axis equal;
fn = faceNormal(tr);  
P = incenter(tr);
hold on;
quiver3(P(:,1),P(:,2),P(:,3),fn(:,1),fn(:,2),fn(:,3),0.5, 'color','r');
hold off;
% Now flip the ordering of the vertices and the normals will point
% in the opposite direction. We can do this by exchanging any two
% colums of the triangles matrix.
tri = [tri(:,1), tri(:,3), tri(:,2)];
figure('Color', 'white')
tr = triangulation(tri, x, y, z);
trisurf(tr,'faceColor','cyan', 'FaceAlpha',0.5)
axis equal;
fn = faceNormal(tr);  
P = incenter(tr);
hold on;
quiver3(P(:,1),P(:,2),P(:,3),fn(:,1),fn(:,2),fn(:,3),0.5, 'color','r');
hold off;