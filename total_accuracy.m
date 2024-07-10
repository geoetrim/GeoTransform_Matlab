% Total accuracy estimation
% Ali CAM & Hüseyin TOPAN, May 2017, BEÜ, Zonguldak

function [gdem, fid] = total_accuracy(Px, model_id, fid)

Kdpdp = evalin('base','Kdpdp');
gcp   = evalin('base','gcp');
gdem2 = evalin('base','gdem');
meta  = evalin('base','meta');
dem_quality = load('dem_quality.txt');
GSD_original_image  = 2.5;

% Normalize DEM quality
if meta(1) == 0
    dem_quality(4 : 6) = dem_quality;
elseif meta(1) == 1
    for i = 4 : 6
        dem_quality(i) = dem_quality(i - 3) / (mean(gcp(: , i)) / mean(gcp(: , i + 5)));
    end
end

Krr = [dem_quality(4)^2 0 0; 0 dem_quality(5)^2 0; 0 0 dem_quality(6)^2];

assignin('base','Krr',Krr)
assignin('base','dem_quality',dem_quality)

% Krr if Z is not available.
if model_id < 40 && model_id > 6 || model_id < 6
    Krr(3 , :) = [];
    Krr(: , 3) = [];
end

% Estimation of image coordinates of DEM
% aralik = 0 : 5e5 : size(gdem , 1); % Divide DEM file for faster calculation
% aralik(1 , end + 1) = size(gdem , 1);
% for i = 1 : size(aralik , 2) - 1
%     gdem(aralik(i) + 1 : aralik(i + 1) , :) = estimate_image_coor(Px, gdem(aralik(i) + 1 : aralik(i + 1) , :), model_id);
% end

gdem = estimate_image_coor(Px, gdem2(1 : 1e2 : length(gdem2(: , 1)) , :), model_id);

% Arrangement for Jacobo's input
gjacobo(: , 9 : 11) = gdem(: , 4 : 6);

if model_id == 5 || model_id == 6 || model_id >= 70
    gjacobo(: , 12 : 13) = gdem(: , 9 : 10);
end

assignin('base','gjacobo',gjacobo)

for i = 1 : length(gdem(:, 1))
    B = BB(gdem(i , :), Px, model_id); % B matrix
    A = Jacobo(gjacobo(i , :) , model_id); % A matrix
    Klln = A * Kdpdp * A' + B * Krr * B';
    if meta(1) == 0
        Kll = Klln;
    elseif meta(1) == 1
        for j = 1 : 2
            Kll(j , j) = (sqrt(Klln(j , j)) * (mean(gcp(: , j + 1)) / mean(gcp(: , j + 6))))^2;
        end
    end
    gdem(i , 11) = sqrt(sum(diag(Kll))); % pixel
end

gdem(: , 12) = gdem(: , 11) * GSD_original_image; % meter
gdem(: , 12) = round(gdem(: , 12) , 2);

fprintf(fid, 'Total accuracy [min] = ±%5.2f pixel = ±%5.2f meter\n', min(gdem(: , 11)) , min(gdem(: , 12)));
fprintf(fid, 'Total accuracy [max] = ±%5.2f pixel = ±%5.2f meter\n', max(gdem(: , 11)) , max(gdem(: , 12)));
