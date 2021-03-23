% Estimation of image coordinates for using in the Jacobian matrix of total accuracy estimation and also orthoimage
% generation
% Px is calculated via "adj" modul
% Ali CAM, May 2017, BEÜ, Zonguldak

function gdem = estimate_image_coor (Px, gdem, model_id)

meta = evalin('base','meta');
gcp  = evalin('base','gcp');

for i = 1 : length(gdem(: , 1))
    if model_id == 1 % Similarity
        gdem(i , 7 : 8) = [ Px(1) + Px(2) * gdem(i , 4) - Px(3) * gdem(i , 5), Px(4) + Px(3) * gdem(i , 4) + Px(2) * gdem(i , 5)];
    end
    
    for j = 0 : 1
        if model_id == 2 || model_id == 31 % Affine (2B) or polynomial (1st order)
            gdem(i , j + 7) = [1 gdem(i , 4 : 5)] * Px((1 + (j * 3)) : (3 + (j * 3)));
            
        elseif model_id > 31 && model_id < 36 % Polynomial (>1st order)
            
            A2 (i , :) = [1 gdem(i , 4 : 5) gdem(i , 4)  * gdem(i , 5)   gdem(i , 4)^2 gdem(i , 5)^2];                      
            A3 (i , :) = [A2(i , 1 : 6)   gdem(i , 5) * gdem(i , 4)^2 gdem(i , 4) * gdem(i , 5)^2 gdem(i , 4)^3 gdem(i , 5)^3];
            A4 (i , :) = [A3(i , 1 : 10)  gdem(i , 4)  * gdem(i , 5)^3 gdem(i , 5) * gdem(i , 4)^3 gdem(i , 4)^4 gdem(i , 5)^4 (gdem(i , 4)^2) * gdem(i , 5)^2];
            A5 (i , :) = [A4(i , 1 : 15) (gdem(i , 4)^3) * (gdem(i , 5)^2) (gdem(i , 4)^2) * (gdem(i , 5)^3) gdem(i , 4)^5 gdem(i , 5)^5 (gdem(i , 4)^4) * gdem(i , 5) gdem(i , 4) * (gdem(i , 5)^4)];
            if model_id == 32 
                gdem(i , j + 7) = A2(i , :) * Px((1 + (j * 6)):(6 + (j * 6)));
            elseif model_id == 33
                gdem(i , j + 7) = A3(i , :) * Px((1 + (j * 10)):(10 + (j * 10)));
            elseif model_id == 34
                gdem(i , j + 7) = A4(i , :) * Px((1 + (j * 15)):(15 + (j * 15)));
            elseif model_id == 35
                gdem(i , j + 7) = A5(i , :) * Px((1 + (j * 21)):(21 + (j * 21)));
            end
        elseif model_id == 41 % Affine projective (Model 1)
            gdem(i , j + 7) = [1 gdem(i , 4 : 6)] * Px((1 + (j * 4)):(4 + (j * 4)));
        elseif model_id == 42 % Affine projective (Model 2)
            gdem(i , 7) = [1 gdem(i , 4 : 6), gdem(i , 4 : 5) * gdem(i , 6), gdem(i , 4)^2 ] * Px(1 : 7);
            gdem(i , 8) = [1 gdem(i , 4 : 6), gdem(i , 4 : 5) * gdem(i , 6), gdem(i , 4) * gdem(i , 5)] * Px(8 : 14);
        elseif model_id == 43 % Affine projective (Model 3)
            gdem(i , j + 7) = [1 gdem(i , 4 : 6), gdem(i , 6) * gdem(i , 4 : 5)] * Px((1 + (j * 6)):(6 + (j * 6)));
            
        elseif model_id == 5 % Projective
            denominator(i) = 1 + Px(7 : 8)' * gdem(i , 4 : 5)';
            numerator(i , j + 1) = [1  gdem(i , 4 : 5)] * Px(1 + (j * 3) : 3 + (j * 3));
            gdem (i , j + 7) = numerator(i , j + 1) / denominator(i);
        elseif model_id == 6 % DLT
            gdem(i , 7) = (Px(1) + Px(2) * gdem(i , 4) + Px( 3) * gdem(i , 5) + Px( 4) * gdem(i , 6)) / (1 + Px(5) * gdem(i , 4) + Px(6) * gdem(i , 5) + Px(7) * gdem(i , 6));
            gdem(i , 8) = (Px(8) + Px(9) * gdem(i , 4) + Px(10) * gdem(i , 5) + Px(11) * gdem(i , 6)) / (1 + Px(5) * gdem(i , 4) + Px(6) * gdem(i , 5) + Px(7) * gdem(i , 6));
            
        elseif model_id > 70 && model_id < 74 % RFM (first-third degree)
        
            U = gdem(i , 4);
            V = gdem(i , 5);
            W = gdem(i , 6);
        
            A2(i , :) = [V, U, W, V * U, V * W, U * W, V^2, U^2, W^2];
            A3(i , :) = [A2(i , :), U * V * W, V^3, V * U^2, V * W^2, V^2 * U, U^3, U * W^2, V^2 * W, U^2 * W, W^3];
    
            if  model_id == 71 % RFM 1st degree
                numerator  (i , 1 + j) = [1 V U W]   * Px(1 + (j * 7) : 4 + (j * 7));
                denominator(i , 1 + j) = 1 + [V U W] * Px(5 + (j * 7) : 7 + (j * 7));

            elseif  model_id == 72 % RFM 2nd degree
                numerator  (i , 1 + j) = [1 A2(i , :)] * Px( 1 + (j * 19) : 10 + (j * 19));
                denominator(i , 1 + j) = 1 + A2(i , :) * Px(11 + (j * 19) : 19 + (j * 19));

            elseif  model_id == 73 % RFM 3rd degree
                numerator  (i , 1 + j) = [1 A3(i , :)] * Px ( 1 + (j * 39) : 20 + (j * 39));
                denominator(i , 1 + j) = 1 + A3(i , :) * Px (21 + (j * 39) : 39 + (j * 39));
            end
                gdem (i , j + 7) = numerator(i , j + 1) / denominator(i , j + 1);
        end
    end
end

if meta(1) == 0
    gdem(: , 9 : 10) = gdem(: , 7 : 8);
elseif meta(1) == 1
    for i = 1 : 2
        gdem(: , i + 8) = ((gdem(: , i + 6) * (max(gcp(: , i + 1)) - min(gcp(: , i + 1))) + max(gcp(: , i + 1)) + min(gcp(: , i + 1))) / 2);
    end
end
