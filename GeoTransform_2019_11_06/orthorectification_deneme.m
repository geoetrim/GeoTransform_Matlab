% 1. görüntü yükleme

image1 = imread('E:\2_Goruntuler\2_Gokturk\03_Bulent_Ecevit_Universitesi\Sinanli_Zonguldak_Serit_4\L1R\0\image_1.tif');

% bu görüntü yükleme adýmýndan sonra görüntüyü matlab yardýmýyla yeniden
% örneklemek

image2 = double(image1);
image2 = imresize(image2,0.5,'nearest'); % buradaki 0.5 önemlidir. YÖA lýðýna göre þekilleniyor.

c = 2;

% daha sonra dönüþüm yapýldýktan sonra üretilen orta görüntü
% koordinatlarýna göre orijinal görüntü boyutlarýna göre yeniden düzeltilir. 
% yani 0'dan büyük pikseller hesaba alýnýr. Aþaðýdaki gibi...

row1 = find(gfc(:, 14)>size(image1,1));
gfc(row1,:) = [];   

row2 = find(gfc(:, 14) < 1);
gfc(row2,:) = [];

col1 = find(gfc(:, 15)>size(image1,2));
gfc(col1,:) = []; 

col2 = find(gfc(:, 15) < 1);
gfc(col2,:) = []; 

% Daha sonra boþ bir görüntü çerçevesi oluþturulur.

imageortho = zeros (round(max(gfc(:,14))/c),round(max(gfc(:,15))/c),4); % buradaki c deðeri; DEM ile orjinal görüntü arasýndaki YÖA katsayýsýdýr yani (DEM YÖA / Orjinal YÖA) 

% daha sonra en yakýn komþuluða göre üretilen görüntü koordinatlarý ile
% görüntü üzerindeki görüntü koordinatlarýnýn gri deðerleri eþleþtirilir. 

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

% üretilen bir görüntünün görüntü koordinatýna göre arazi koordinatlarýný
% üretmek için aþaðýdaki kodlar kullanýlýyor.
idx1 = find(ismember(round(gfc(:,14:15)),[2645 1480] * 2,'rows'));
gfc(idx1,:)

