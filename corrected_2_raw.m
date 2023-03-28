% Estimation of affine parameters between image coordinates from corrected
% to raw
% Coded by Ali CAM & Hüseyin TOPAN, 23.08.2017 

function Px = corrected_2_raw(g, s)

for i = 1 : length(g(: , 1))
    if s == 1 % similarity
        A (2 * i - 1, :) = [1 g(i , 14)  -g(i , 15) 0];
        A (2 * i    , :) = [0 g(i , 15)  g(i ,  14) 1];
    elseif s == 2 % affine
        A (2 * i - 1, :) = [1 g(i , 14 : 15) zeros(1 , 3)   ];
        A (2 * i    , :) = [zeros(1 , 3)    1 g(i , 14 : 15)];
    end
    
    B (2 * i - 1, :) = g(i , 2);
    B (2 * i    , :) = g(i , 3);
end

Px = inv(A' * A) * A' * B;