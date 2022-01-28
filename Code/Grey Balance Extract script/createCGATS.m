function createCGATS(centralCMY,dimension,bitStep, fileName)
    %centralCMY is [0-255]
    spanCMY=zeros([dimension dimension 3]);
    semi=floor(dimension/2);
    assert((semi*2+1)*(semi*2+1)==dimension*dimension);
    for j=(-semi:semi)
        for i=(-semi:semi)
            %incremental is every bitStep/255 units (1bit = 0,39%)
            spanCMY(j+semi+1,i+semi+1,:)=[centralCMY(1)/2.55 (centralCMY(2)+j*bitStep)/2.55 (centralCMY(3)+i*bitStep)/2.55];
        end
    end

    columns = {'CMYK_C','CMYK_M','CMYK_Y','CMYK_K'};
    T = table(reshape(spanCMY(:,:,1),[dimension*dimension 1]),reshape(spanCMY(:,:,2),...
        [dimension*dimension 1]),reshape(spanCMY(:,:,3),[dimension*dimension 1]),...
        zeros([dimension*dimension 1]),'VariableNames',columns);
    writetable(T,fileName,'Delimiter','tab');
end