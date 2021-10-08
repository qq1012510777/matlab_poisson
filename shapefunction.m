function f = shapefunction(x, y)
    area = triangle_area(x,y);
    
    b1 = 1 / area * (y(2)-y(3));
    b2 = 1 / area * (y(3)-y(1));
    b3 = 1 / area * (y(1)-y(2));
    
    c1 = 1 / area * (x(3) - x(2)); 
    c2 = 1 / area * (x(1) - x(3)); 
    c3 = 1 / area * (x(2) - x(1));
    
    f = [b1, b2, b3;
        c1, c2, c3];
end

