function dH = deltaH(lab1, lab2)
    dL=lab2(1)-lab1(1);
    dC=sqrt((lab2(2)^2+lab2(3)^2))-sqrt((lab1(2)^2+lab1(3)^2));
    dH=sqrt(deltaE(lab1,lab2)^2-dL^2-dC^2);
end