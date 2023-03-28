    %Jacobian matrix for GCP
function A = Jacobo(gcp, model_id)

for i = 1 : length(gcp(: , 1))
%% Similarity
if model_id == 1 
    A (2 * i - 1, :) = [1 gcp(i , 9)  -gcp(i , 10) 0];
    A (2 * i    , :) = [0 gcp(i , 10)  gcp(i ,  9) 1];
assignin('base','A_deneme',A)    
%% Affine or Polinomial (1st degree)
elseif model_id == 2 || model_id == 31
    A (2 * i - 1, :) = [1 gcp(i , 9 : 10) zeros(1 , 3)   ];
    A (2 * i    , :) = [zeros(1 , 3)    1 gcp(i , 9 : 10)];

%% Polynom
elseif model_id > 31 && model_id < 36
A2 (i , :) = [1 gcp(i , 9 : 10) gcp(i , 9) * gcp(i , 10)   gcp(i , 9)^2 gcp(i , 10)^2];                      
A3 (i , :) = [A2(i , 1 : 6)   gcp(i , 10) * gcp(i , 9)^2 gcp(i , 9) * gcp(i , 10)^2 gcp(i , 9)^3 gcp(i , 10)^3];
A4 (i , :) = [A3(i , 1 : 10)  gcp(i , 9) * gcp(i , 10)^3 gcp(i , 10) * gcp(i , 9)^3 gcp(i , 9)^4 gcp(i , 10)^4 (gcp(i , 9)^2) * gcp(i , 10)^2];
A5 (i , :) = [A4(i , 1 : 15) (gcp(i , 9)^3) * (gcp(i , 10)^2) (gcp(i , 9)^2) * (gcp(i , 10)^3) gcp(i , 9)^5 gcp(i , 10)^5 (gcp(i , 9)^4) * gcp(i , 10) gcp(i , 9) * (gcp(i , 10)^4)];

if model_id == 32 % second degree (bilinear)
    A (2 * i - 1, :) = [A2(i , 1 : 6) zeros(1 , 6)];
    A (2 * i    , :) = [zeros(1 , 6)  A2(i , 1 : 6)];

elseif model_id == 33 % third degree (cubic)
    A (2 * i - 1, :) = [A3(i , 1 : 10) zeros(1 , 10) ];
    A (2 * i    , :) = [zeros(1 , 10)  A3(i , 1 : 10)];

elseif model_id == 34 % fourth degree (quartic)
    A (2 * i - 1, :) = [A4(i , 1 : 15) zeros(1 , 15) ];
    A (2 * i    , :) = [zeros(1 , 15)  A4(i , 1 : 15)];

elseif model_id == 35 % fifth degree (quintic)
    A (2 * i - 1, :) = [A5(i , 1 : 21) zeros(1 , 21) ];
    A (2 * i    , :) = [zeros(1 , 21)  A5(i , 1 : 21)];
end
%% Affine projection
elseif model_id == 41
    A (2 * i - 1, :) = [1 gcp(i , 9 : 11) zeros(1 , 4)    ];
    A (2 * i    , :) = [zeros(1 , 4)    1  gcp(i , 9 : 11)];

elseif model_id == 42
    A (2 * i - 1, :) = [1, gcp(i , 9 : 11), gcp(i , 11) * gcp(i , 9 : 10), gcp(i , 9)^2, zeros(1 , 7)        ];
    A (2 * i    , :) = [zeros(1 , 7), 1,  gcp(i , 9 : 11), gcp(i , 11) * gcp(i , 9 : 10), gcp(i ,9) * gcp(i , 10)];

elseif model_id == 43
    A (2 * i - 1, :) = [1 gcp(i , 9 : 11), gcp(i , 11)*gcp(i , 9 : 10), zeros(1 , 6)]; 
    A (2 * i    , :) = [zeros(1 , 6), 1 gcp(i , 9 : 11), gcp(i , 11)*gcp(i , 9 : 10)];
    
elseif model_id == 44
    A (2 * i - 1, :) = [1 gcp(i , 9 : 11) gcp(i , 9) * gcp(i , 10) gcp(i , 9) * gcp(i , 11) gcp(i , 10) * gcp(i , 11) gcp(i , 9)^2 gcp(i , 10)^2 gcp(i , 11)^2 gcp(i , 9) * gcp(i , 10) * gcp(i , 11) gcp(i , 9)^2 * gcp(i , 10) gcp(i , 9)^2 * gcp(i , 11) gcp(i , 10)^2 * gcp(i , 11) gcp(i , 10) * gcp(i , 11)^2 gcp(i , 9) * gcp(i , 11)^2 gcp(i , 9)^3 gcp(i , 10)^3 gcp(i , 11)^3 zeros(1 , 19)]; 
    A (2 * i    , :) = [zeros(1 , 19) 1 gcp(i , 9 : 11) gcp(i , 9) * gcp(i , 10) gcp(i , 9) * gcp(i , 11) gcp(i , 10) * gcp(i , 11) gcp(i , 9)^2 gcp(i , 10)^2 gcp(i , 11)^2 gcp(i , 9) * gcp(i , 10) * gcp(i , 11) gcp(i , 9)^2 * gcp(i , 10) gcp(i , 9)^2 * gcp(i , 11) gcp(i , 10)^2 * gcp(i , 11) gcp(i , 10) * gcp(i , 11)^2 gcp(i , 9) * gcp(i , 11)^2 gcp(i , 9)^3 gcp(i , 10)^3 gcp(i , 11)^3];
    
%% Projective
elseif model_id == 5
    A (2 * i - 1, :) = [1, gcp(i , 9 : 10),  zeros(1 , 3),     -gcp(i , 12) * gcp(i , 9 : 10)];
    A (2 * i    , :) = [zeros(1 , 3),     1, gcp(i ,  9 : 10), -gcp(i , 13) * gcp(i , 9 : 10)];

%% DLT
elseif model_id == 6
    A (2 * i - 1, :) = [1, gcp(i , 9 : 11), -gcp(i , 12) * gcp(i , 9 : 11),    zeros(1 , 4)   ];
    A (2 * i    , :) = [zeros(1 , 4),       -gcp(i , 13) * gcp(i , 9 : 11), 1, gcp(i , 9 : 11)];

%% RFM (first-third degree)
elseif model_id > 70 && model_id < 74
    U = gcp(i ,  9);
    V = gcp(i , 10);
    W = gcp(i , 11);
    
    A2(i , :) = [1, V, U, W, V * U, V * W, U * W, V^2, U^2, W^2];
    A3(i , :) = [A2(i , :), U * V * W, V^3, V * U^2, V * W^2, V^2 * U, U^3, U * W^2, V^2 * W, U^2 * W, W^3];
    
    if  model_id == 71
    A (2 * i - 1, :) = [1, V, U, W, -gcp(i , 12) * [V, U, W], zeros(1 , 7)];
    A (2 * i    , :) = [zeros(1 , 7), 1, V, U, W, -gcp(i , 13) * [V, U, W]];
    
    elseif  model_id == 72
    A (2 * i - 1, :) = [A2(i , :), -gcp(i , 12) * A2(i , 2 : 10), zeros(1 , 19)];
    A (2 * i    , :) = [zeros(1 , 19), A2(i , :), -gcp(i , 13) * A2(i , 2 : 10)]; 

    elseif  model_id == 73
    A (2 * i - 1, :) = [A3(i , :), -gcp(i , 12) * A3(i , 2 : 20), zeros(1 , 39)];
    A (2 * i    , :) = [zeros(1 , 39), A3(i , :), -gcp(i , 13) * A3(i , 2 : 20)];
    end
end
end
end