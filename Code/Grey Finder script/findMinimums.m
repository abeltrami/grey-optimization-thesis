function [M, Y, DELTA] = findMinimums(ctable)
    
    figure;
    [M,Y]=meshgrid(min(ctable.CMYK_M):2/2.55:(max(ctable.CMYK_M)+1/2.55), max(ctable.CMYK_Y):-2/2.55:(min(ctable.CMYK_Y)-1/2.55));
    if size(ctable.DELTA,1)==49
        D=reshape(ctable.DELTA,[7 7])';
    else    
        D=reshape(ctable.DELTA,[13 13])';
    end
    real_surf=surface(M, Y, D); 
    real_surf.FaceAlpha=0.5;
    view(3);
    xlabel('a*');
    ylabel('b*');
    zlabel('delta');
        
    [MinD, iMinD]=min(ctable.DELTA);
    M = ctable(iMinD,'CMYK_M').CMYK_M;
    Y = ctable(iMinD,'CMYK_Y').CMYK_Y;
    DELTA = MinD;
end
