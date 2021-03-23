% Sub-design matrix related to d(XYZ) of check points
% Calculates A matrix for all check points, and re-arranges it for selected points
%
% Please check the version of the desing matrix (dm).
% Recoded by H�seyin TOPAN (ZK�), August 2009.

function AXYZ = A_dXYZ(points, rpc, fc)

for i = 1 : length(points(: , 1 , 1))
    
%===== Sub-design matrix related to d(XYZ) of all points =====
AXYZ1 = Jacobian_XYZ(rpc, points(i, :));
    
AXYZ2(2*i-1, 3*i-2) = AXYZ1(1, 1);
AXYZ2(2*i-1, 3*i-1) = AXYZ1(1, 2);
AXYZ2(2*i-1, 3*i  ) = AXYZ1(1, 3);
    
AXYZ2(2*i, 3*i-2)   = AXYZ1(2, 1);
AXYZ2(2*i, 3*i-1)   = AXYZ1(2, 2);
AXYZ2(2*i, 3*i  )   = AXYZ1(2, 3);
end

%===== Re-arrangement AXYZ matrix for selected check points =====
for i = 1 : length(fc)
    AXYZ(:, 3*i-2) = AXYZ2(:, 3*fc(i)-2);
    AXYZ(:, 3*i-1) = AXYZ2(:, 3*fc(i)-1);
    AXYZ(:, 3*i  ) = AXYZ2(:, 3*fc(i)  ); 
end