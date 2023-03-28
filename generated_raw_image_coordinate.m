%generated raw image coordinates from DEM in affine transformation
%Coded by Ali CAM, 23.08.2017 

function g = generated_raw_image_coordinate(Px_raw, g, s)
for i = 1 : length(g(: , 1))
    
    if s == 1 % similarity
        g(i , 4) = Px_raw(1) + Px_raw(2) * g(i , 14) - (Px_raw(3) * g(i , 15));
        g(i , 5) = Px_raw(4) + Px_raw(3) * g(i , 14) + (Px_raw(2) * g(i , 15));
    elseif s == 2 % affine
        for j = 0 : 1
            g(i , 4 + j) = Px_raw(1 + (j * 3)) + Px_raw(2 + (j * 3)) * g(i , 14) + Px_raw(3 + (j * 3)) * g(i , 15);
        end
    end
end
