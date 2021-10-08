function f = triangle_area(x, y)
    L1 = norm([x(1), y(1)]-[x(2), y(2)]);
    L2 = norm([x(3), y(3)]-[x(2), y(2)]);
    L3 = norm([x(1), y(1)]-[x(3), y(3)]);
    
    d = L1 + L2 + L3;
    
    f = sqrt(d*(d-L1)*(d-L2)*(d-L3));

end

