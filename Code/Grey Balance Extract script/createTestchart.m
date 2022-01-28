function createTestchart(centralCMY,dimension,bitStep,patch_size_mm,dpi,gap_px,fileName)
    %centralCMY is [0-255]
    
    patch_size_px=round(patch_size_mm/25.4*300);
    CMYK=uint8(zeros([(patch_size_px+gap_px)*dimension-gap_px (patch_size_px+gap_px)*dimension-gap_px 4]));
    semi=floor(dimension/2);
    assert((semi*2+1)*(semi*2+1)==dimension*dimension);
    for j=(-semi:semi)
        for i=(-semi:semi)
            %incremental is every 2/255 units (0,78%)
            pixel=reshape([uint8(centralCMY(1)) uint8(centralCMY(2)+j*bitStep) uint8(centralCMY(3)+i*bitStep) 0],[1 1 4]);
            jstart=(j+semi)*(patch_size_px+gap_px)+1;
            istart=(i+semi)*(patch_size_px+gap_px)+1;
            CMYK(jstart:jstart+patch_size_px-1,istart:istart+patch_size_px-1,:)=repmat(pixel,patch_size_px,patch_size_px);
            if (j<semi)
                CMYK(jstart+patch_size_px:jstart+patch_size_px+gap_px-1, istart:istart+patch_size_px-1,:)=...
                    repmat(255-pixel,gap_px,patch_size_px);
            end
            if (i<semi)
                CMYK(jstart:jstart+patch_size_px-1, istart+patch_size_px:istart+patch_size_px+gap_px-1,:)=...
                    repmat(255-pixel,patch_size_px,gap_px);
            end
        end
    end

    imwrite(CMYK,fileName,'tif','Compression','lzw','Resolution',dpi);    
end