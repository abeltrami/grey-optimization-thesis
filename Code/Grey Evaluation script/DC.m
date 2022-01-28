function dC=DC(Lab1, Lab2)
    a1 = Lab1(2);
    b1 = Lab1(3);
    a2 = Lab2(2);
    b2 = Lab2(3);
    C1 = sqrt(power(a1, 2) + power(b1, 2));
    C2 = sqrt(power(a2, 2) + power(b2, 2));
    dC = C2-C1;   
end