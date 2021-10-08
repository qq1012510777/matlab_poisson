clc;
clear all;
close all;

currentPath = fileparts(mfilename('fullpath'));
addpath(genpath(currentPath));

load( 'matlab.mat')

H = u;
Points = p';
Topo = t;
clear e p t u

Topo = Topo';

Topo = Topo(:,1:3);
[m, ~] = size(Topo);


Velocity = [];
centers = [];
figure(2)
hold on;
patch('Vertices', Points, 'Faces', Topo, 'FaceVertexCData', H, 'FaceColor', 'interp', 'EdgeAlpha', 0.9);
colorbar
hold on;
for i = 1:1:m
    PointID1 = Topo(i, 1);
    PointID2 = Topo(i, 2);
    PointID3 = Topo(i, 3);
    
    x = [Points(PointID1, 1), Points(PointID2, 1), Points(PointID3, 1)];
    y = [Points(PointID1, 2), Points(PointID2, 2), Points(PointID3, 2)];
    
    area = triangle_area(x,y);
    b1 = 1 / area * (y(2)-y(3));
    b2 = 1 / area * (y(3)-y(1));
    b3 = 1 / area * (y(1)-y(2));
    
    c1 = 1 / area * (x(3) - x(2)); 
    c2 = 1 / area * (x(1) - x(3)); 
    c3 = 1 / area * (x(2) - x(1));
    
    f = [b1, b2, b3;
        c1, c2, c3];
    
    he = [H(PointID1), H(PointID2), H(PointID3)]';
    
    Nx = f(1, :);
    Ny = f(2, :);
    
    qx = Nx * he;
    qy = Ny * he;
    Velocity(i, 1) = -qx;
    Velocity(i, 2) = -qy;
    
    c = [sum(x)/3, sum(y)/3];
    centers(i, :) = c;
    figure(2)
    hold on;
    %scatter(centers(i, 1), centers(i, 2), '*');
    hold on;
    %text(centers(i, 1), centers(i, 2), num2str(i));
end



figure(1)
patch('Vertices', Points, 'Faces', Topo, 'FaceVertexCData', H, 'FaceColor', 'interp', 'EdgeAlpha', 0.9);
hold on;
colorbar
hold on;

quiver(centers(:,1), centers(:,2),Velocity(:, 1), Velocity(:, 2), 'r', 'linewidth', 1.2, 'AutoScaleFactor',0.89,'AutoScale','on');
view(2)

% let us calculate the inlet and outlet

x_top = 9.97807;
x_bot = 80.0439;

top_ele = [31 29 8 9 25 27 36 20 5 2];
bot_ele = [1 43 22 16];

[~, n_1] = size(top_ele);
[~, n_2] = size(bot_ele);

inlet = 0;
for i = 1 : 1 :n_1
    eleID = top_ele(i);
    for j = 1:1:3
        PointID1 = Topo(eleID, j);
        PointID2 = Topo(eleID, rem(j, 3) + 1);
        
        Point1 = Points(PointID1, :);
        Point2 = Points(PointID2, :);
        
        if (abs(Point1(1, 1) - x_top) < 1e-2 && abs(Point2(1, 1) - x_top) < 1e-1)
            L = norm(Point2 - Point1);
            inlet = inlet + dot(Velocity( eleID, :), [1, 0]) * L;
        end
    end
end

outlet = 0;
for i = 1 : 1 :n_2
    eleID = bot_ele(i);
    for j = 1:1:3
        PointID1 = Topo(eleID, j);
        PointID2 = Topo(eleID, rem(j, 3) + 1);
        
        Point1 = Points(PointID1, :);
        Point2 = Points(PointID2, :);
        
        if (abs(Point1(1, 1) - x_bot) < 1e-2 && abs(Point2(1, 1) - x_bot) < 1e-1)
            L = norm(Point2 - Point1);
            i
            outlet = outlet + dot(Velocity( eleID, :), [1, 0]) * L
        end
    end
end

inlet
outlet
error = abs(inlet - outlet) / max(inlet, outlet)
