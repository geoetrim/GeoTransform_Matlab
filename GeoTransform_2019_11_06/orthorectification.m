% Orto görüntü üretimi (hocanýn istediði gibi) 15.10.2017

% Ham görüntü yükleme
image1 = imread('E:\2_Goruntuler\2_Gokturk\03_Bulent_Ecevit_Universitesi\Sinanli_Zonguldak_Serit_4\L1R\0\image_1.tif');

% [-1 +1] aralýðýndan çýkarma
% for i = 1 : 2
%     gfc(: , i + 13) = ((gfc(: , i + 6) * (max(gcp(: , i + 1)) - min(gcp(: , i + 1))) + max(gcp(: , i + 1)) + min(gcp(: , i + 1))) / 2); %Burasý sorunlu
% end

gfc(: , 14 : 15) = gfc(:,7:8); 

ot =  0; % ötemele yapmak istersem
dnm = 0;% görüntüler arasýndaki dönüþüm

if ot == 1
gfc(:,15) = gfc(:,15)+abs(min(gfc(:,15)))+1; % eksili deðerleri ötelemek için kullanýlýyor.
end

% Düzeltilmiþ görüntüden ham görüntüye dönüþüm.

if dnm == 1
    s1 = 2;
    Px_raw = corrected_2_raw(gcp, s1);
    gfc = generated_raw_image_coordinate(Px_raw, gfc, s1);
end


image2 = double(image1);

image2 = imresize(image2,0.5,'nearest');
c = 2;

% görüntü büyüklüðünde kesme

row1 = find(gfc(:, 14)>size(image1,1));
gfc(row1,:) = [];   

row2 = find(gfc(:, 14) < 1);
gfc(row2,:) = [];

col1 = find(gfc(:, 15)>size(image1,2));
gfc(col1,:) = []; 

col2 = find(gfc(:, 15) < 1);
gfc(col2,:) = []; 

% Boþ frame üretildi
imageortho = zeros (round(max(gfc(:,14))/2),round(max(gfc(:,15))/2),4);

for i = 1 : size(gfc,1)
    imageortho(round(gfc(i,14)/c),round(gfc(i,15)/c),1) = image2(round(gfc(i,14)/c),round(gfc(i,15)/c));
    for band = 1 : 3
        imageortho(round(gfc(i,14)/c),round(gfc(i,15)/c),band+1) = gfc(i,band);
    end
end

for i = 1 : 4
    if i == 1
        orthoimage(:,:,i) = uint16(imageortho(:,:,i));
    end
    orthoimage(:,:,i) = imageortho(:,:,i);
end

figure;
h = imshow(autocontrast(orthoimage(:,:,1)));
% intensityAtThisLocation
hText = impixelinfoval(gcf,h);
set(hText,'FontWeight','bold')
set(hText,'FontSize',10)

% imwrite(orthoimage,'ortho_deneme8bit.tif')
% 
% idx1 = find(ismember(round(gfc(:,14:15)),[2645 1480] * 2,'rows'));
% gfc(idx1,:)

