function de00=DE00(Lab1, Lab2)

    L1 = Lab1(1);
    a1 = Lab1(2);
    b1 = Lab1(3);
    L2 = Lab2(1);
    a2 = Lab2(2);
    b2 = Lab2(3);
    
    Kl = 1;
    Kc = 1;
    Kh = 1;
    avg_Lp = (L1 + L2) / 2;
    C1 = sqrt((a1 * a1) + (b1 * b1));
    C2 = sqrt((a2 * a2) + (b2 * b2));
    avg_C1_C2 = (C1 + C2) / 2;

    G = 0.5 * (1 - sqrt(power(avg_C1_C2, 7) / (power(avg_C1_C2, 7) + power(25, 7))));

    a1p = (1 + G) * a1;
    a2p = (1 + G) * a2;
    C1p = sqrt(power(a1p, 2) + power(b1, 2));
    C2p = sqrt(power(a2p, 2) + power(b2, 2));
    avg_C1p_C2p = (C1p + C2p) / 2;

    if rad2deg(atan2(b1, a1p)) >= 0
        h1p = rad2deg(atan2(b1, a1p));
    else
        h1p = rad2deg(atan2(b1, a1p)) + 360;
    end

    if rad2deg(atan2(b2, a2p)) >= 0 
        h2p = rad2deg(atan2(b2, a2p));
    else
        h2p = rad2deg(atan2(b2, a2p)) + 360;
    end

    if abs(h1p - h2p) > 180
        avg_Hp = (h1p + h2p + 360) / 2;
    else
        avg_Hp = (h1p + h2p) / 2;
    end

    T = (1 - 0.17 * cos(deg2rad(avg_Hp - 30)) + 0.24 * cos(deg2rad(2 * avg_Hp)) + 0.32 * cos(deg2rad(3 * avg_Hp + 6)) - 0.2 * cos(deg2rad(4 * avg_Hp - 63)));

    diff_h2p_h1p = h2p - h1p;
    if abs(diff_h2p_h1p) <= 180
        delta_Hp = diff_h2p_h1p;
    elseif (abs(diff_h2p_h1p) > 180) && (h2p <= h1p)
        delta_Hp = diff_h2p_h1p + 360;
    else
        delta_Hp = diff_h2p_h1p - 360;
    end

    delta_Lp = L2 - L1;
    delta_Cp = C2p - C1p;
    delta_Hp = 2 * sqrt(C2p * C1p) * sin(deg2rad(delta_Hp) / 2);

    S_L = 1 + ((0.015 * power(avg_Lp - 50, 2)) / sqrt(20 + power(avg_Lp - 50, 2)));
    S_C = 1 + 0.045 * avg_C1p_C2p;
    S_H = 1 + 0.015 * avg_C1p_C2p * T;

    delta_ro = 30 * exp(-(power(((avg_Hp - 275) / 25), 2)));
    R_C = sqrt((power(avg_C1p_C2p, 7)) / (power(avg_C1p_C2p, 7) + power(25, 7)));
    R_T = -2 * R_C * sin(2 * deg2rad(delta_ro));

    de00 = sqrt(power(delta_Lp / (S_L * Kl), 2) + power(delta_Cp / (S_C * Kc), 2) + power(delta_Hp / (S_H * Kh), 2) + R_T * (delta_Cp / (S_C * Kc)) * (delta_Hp / (S_H * Kh)));

end