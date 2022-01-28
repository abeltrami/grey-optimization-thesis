function dh=Dh(Lab1, Lab2)
    a1 = Lab1(2);
    b1 = Lab1(3);
    a2 = Lab2(2);
    b2 = Lab2(3);
    h1=atan2(b1,a1);
    h2=atan2(b2,a2);
    diff=h2-h1;
    if diff>pi
        diff=2*pi-diff;
    elseif diff<-pi
        diff=-2*pi-diff;
    end
    dh=diff;    
end

