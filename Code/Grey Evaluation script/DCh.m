function dCh=DCh(Lab1, Lab2)
    a1 = Lab1(2);
    b1 = Lab1(3);
    a2 = Lab2(2);
    b2 = Lab2(3);
    dCh = sqrt(power(a2 - a1, 2) + power(b2 - b1, 2));
end