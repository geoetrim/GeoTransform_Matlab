% 1. g�r�nt� y�kleme

image1 = imread('E:\2_Goruntuler\2_Gokturk\03_Bulent_Ecevit_Universitesi\Sinanli_Zonguldak_Serit_4\L1R\0\image_1.tif');

% bu g�r�nt� y�kleme ad�m�ndan sonra g�r�nt�y� matlab yard�m�yla yeniden
% �rneklemek

image2 = double(image1);
image2 = imresize(image2,0.5,'nearest'); % buradaki 0.5 �nemlidir. Y�A l���na g�re �ekilleniyor.

c = 2;

% daha sonra d�n���m yap�ld�ktan sonra �retilen orta g�r�nt�
% koordinatlar�na g�re orijinal g�r�nt� boyutlar�na g�re yeniden d�zeltilir. 
% yani 0'dan b�y�k pikseller hesaba al�n�r. A�a��daki gibi...

row1 = find(gfc(:, 14)>size(image1,1));
gfc(row1,:) = [];   

row2 = find(gfc(:, 14) < 1);
gfc(row2,:) = [];

col1 = find(gfc(:, 15)>size(image1,2));
gfc(col1,:) = []; 

col2 = find(gfc(:, 15) < 1);
gfc(col2,:) = []; 

% Daha sonra bo� bir g�r�nt� �er�evesi olu�turulur.

imageortho = zeros (round(max(gfc(:,14))/c),round(max(gfc(:,15))/c),4); % buradaki c de�eri; DEM ile orjinal g�r�nt� aras�ndaki Y�A katsay�s�d�r yani (DEM Y�A / Orjinal Y�A) 

% daha sonra en yak�n kom�ulu�a g�re �retilen g�r�nt� koordinatlar� ile
% g�r�nt� �zerindeki g�r�nt� koordinatlar�n�n gri de�erleri e�le�tirilir. 

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

% �retilen bir g�r�nt�n�n g�r�nt� koordinat�na g�re arazi koordinatlar�n�
% �retmek i�in a�a��daki kodlar kullan�l�yor.
idx1 = find(ismember(round(gfc(:,14:15)),[2645 1480] * 2,'rows'));
gfc(idx1,:)

