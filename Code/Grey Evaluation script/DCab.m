function dCab=DCab(Lab1, Lab2)
    a1 = Lab1(2);
    b1 = Lab1(3);
    a2 = Lab2(2);
    b2 = Lab2(3);
    dCab = sqrt(power(a2, 2) + power(b2, 2)) - sqrt(power(a1, 2) + power(b1, 2));    
end