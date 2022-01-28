% Grey Balance Extractor
% by A.Beltrami

% Open the characterization file and search for the darkest printed colour,
% and K only L values
bp = [100 0 0];
ik = 0;
kL = [];
fogra51 = fopen('FOGRA51.txt');
line = '';
while strcmp(line,'BEGIN_DATA')==0
    line=fgetl(fogra51);
end
while strcmp(line,'END_DATA')==0
    line=fgetl(fogra51);
    if strcmp(line,'END_DATA')
        break;
    end
    values=textscan(line,'%f');
    % darkest colour
    if values{1}(6)<bp(1)
        bp(1)=values{1}(6); % L
        bp(2)=values{1}(7); % a
        bp(3)=values{1}(8); % b
    end
    % kl
    if values{1}(2)==0 && values{1}(3)==0 && values{1}(4)==0
        ik=ik+1;
        kL(ik,1)=values{1}(5); % K TV
        kL(ik,2)=values{1}(6); % L
    end
end
% The array of k values and L* sorted from K0 to K100
kL=unique(sortrows(kL),'rows')

fprintf('Black Point Lab: %.2f %.2f %.2f\n',bp(1),bp(2),bp(3));
fclose(fogra51);

% Open the CMY profile and extract white point
profile = iccread('FOGRA51 CMY.icc');
lab_identity = iccread('CIELABD50.icc');
trans = makecform('icc', lab_identity, profile, 'SourceRenderingIntent',...
    'AbsoluteColorimetric', 'DestRenderingIntent', 'AbsoluteColorimetric');
wp = xyz2lab(profile.MediaWhitePoint, 'WhitePoint', 'd50');
fprintf('White Point Lab: %.2f %.2f %.2f\n',wp(1),wp(2),wp(3));

% Calculate the grey axis as per ISO 12647-2:2013
% Original formula:
%   grey_l=[ceil(wp(1)):-1:floor(bp(1))];
%   grey_a=wp(2)*(1-0.85*(wp(1)-grey_l)/(wp(1)-bp(1)));
%   grey_b=wp(3)*(1-0.85*(wp(1)-grey_l)/(wp(1)-bp(1)));
grey_high=wp;
grey_low=[bp(1) wp(2)*0.15 wp(3)*0.15];

%Calculate the grey axis
GreyScale=[5 10 15 20 25 30 40 50 60 70 75 80 85 90 95];
Lab=zeros([size(GreyScale,2) 3]);
CMY=zeros([size(GreyScale,2) 3]);
for i=(1:size(GreyScale,2))
    G=GreyScale(i);
    L=kL(kL(:,1)==G,2);
    Lab(i,:)=[L wp(2)*(1-0.85*(wp(1)-L)/(wp(1)-bp(1))) wp(3)*(1-0.85*(wp(1)-L)/(wp(1)-bp(1)))];
    CMY(i,:) = floor(applycform(Lab(i,:), trans)*255)/255; % rounded to 8 bit
end

%Verify using original CMYK ICC profile
verifLab=zeros([size(GreyScale,2) 3]);
profile = iccread('PSOCoated_v3.icc');
trans = makecform('icc', profile, lab_identity, 'SourceRenderingIntent',...
    'AbsoluteColorimetric', 'DestRenderingIntent', 'AbsoluteColorimetric');
dE=zeros([size(GreyScale,2) 1]);
dH=zeros([size(GreyScale,2) 1]);
for i=(1:size(GreyScale,2))
    G=GreyScale(i);
    verifLab(i,:)=applycform([CMY(i,:) 0], trans);
    dE(i)=deltaE(Lab(i,:),verifLab(i,:));
    dH(i)=deltaH(Lab(i,:),verifLab(i,:));
    fprintf('K %d --> Lab: %.2f %.2f %.2f --> CMY: %.2f %.2f %.2f --> verif.Lab: %.2f %.2f %.2f (DE: %.2f DH: %.2f)\n',...
        G,Lab(i,1),Lab(i,2),Lab(i,3),CMY(i,1)*100,CMY(i,2)*100,CMY(i,3)*100,verifLab(i,1),verifLab(i,2),verifLab(i,3),...
        dE(i),dH(i));
end
fprintf('dE: avg %.2f 95th %.2f\n',mean(dE), prctile(dE,95));
fprintf('dH: avg %.2f 95th %.2f\n',mean(abs(dH)), prctile(abs(dH),95));


% Plot the grey axis
figure;
p=plot([grey_high(2) grey_low(2)], [grey_high(1) grey_low(1)],...
    [grey_high(3) grey_low(3)], [grey_high(1) grey_low(1)],...
    verifLab(:,2), verifLab(:,1), verifLab(:,3), verifLab(:,1));
title 'FOGRA51 Grey Axis';
p(1).Color='#777777';
p(2).Color='#777777';
p(3).Color='r';
p(4).Color='b';
xlabel('a^* (red), b^* (blue)');
ylabel('L^*');
grid on

% Save the grey axis calculated
columns={'SAMPLE_NAME','CMYK_C','CMYK_M','CMYK_Y','CMYK_K','LAB_L','LAB_A','LAB_B'};
T=table(GreyScale',CMY(:,1)*100,CMY(:,2)*100,CMY(:,3)*100,zeros(15,1),verifLab(:,1),verifLab(:,2),verifLab(:,3),'VariableNames',columns);
writetable(T,'FOGRA51_GreyAxis.txt','Delimiter','tab');

% Set the desired incremental (1 or 2 bit)
bitStep = 2

% Output CGATS
createCGATS((CMY(GreyScale==15,:)*255),7,bitStep,sprintf('K15_%dbit.txt',bitStep));
createCGATS((CMY(GreyScale==30,:)*255),13,bitStep,sprintf('K30_%dbit.txt',bitStep));
createCGATS((CMY(GreyScale==50,:)*255),13,bitStep,sprintf('K50_%dbit.txt',bitStep));
createCGATS((CMY(GreyScale==70,:)*255),13,bitStep,sprintf('K70_%dbit.txt',bitStep));
createCGATS((CMY(GreyScale==85,:)*255),7,bitStep,sprintf('K85_%dbit.txt',bitStep));

% Output test charts images
createTestchart((CMY(GreyScale==15,:)*255),7,bitStep,8,300,3,sprintf('K15_%dbit_8mm_300dpi.tif',bitStep));
createTestchart((CMY(GreyScale==30,:)*255),13,bitStep,8,300,3,sprintf('K30_%dbit_8mm_300dpi.tif',bitStep));
createTestchart((CMY(GreyScale==50,:)*255),13,bitStep,8,300,3,sprintf('K50_%dbit_8mm_300dpi.tif',bitStep));
createTestchart((CMY(GreyScale==70,:)*255),13,bitStep,8,300,3,sprintf('K70_%dbit_8mm_300dpi.tif',bitStep));
createTestchart((CMY(GreyScale==85,:)*255),7,bitStep,8,300,3,sprintf('K85_%dbit_8mm_300dpi.tif',bitStep));



