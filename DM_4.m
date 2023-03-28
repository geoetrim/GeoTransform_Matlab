% Design matrix for the scenario that b = d = and b1 = d1 = 1 (sdm = 4)

function [r, c, AA] = DM_4(gcp, rpc, Su, s)

U = gcp(1);
V = gcp(2);
W = gcp(3);
%==========================================================================
uvw(1, 1)  = 1;
uvw(1, 2)  = V;
uvw(1, 3)  = U;
uvw(1, 4)  = W;
uvw(1, 5)  = V * U;
uvw(1, 6)  = V * W;
uvw(1, 7)  = U * W;
uvw(1, 8)  = V^2;
uvw(1, 9)  = U^2;
uvw(1, 10) = W^2;
uvw(1, 11) = U * V * W;
uvw(1, 12) = V^3;
uvw(1, 13) = V * U^2;
uvw(1, 14) = V * W^2;
uvw(1, 15) = V^2 * U;
uvw(1, 16) = U^3;
uvw(1, 17) = U * W^2;
uvw(1, 18) = V^2 * W;
uvw(1, 19) = U^2 * W;
uvw(1, 20) = W^3;

uvw = uvw(Su);
%==========================================================================
if s == 1
    A = uvw                  * rpc ( 1 :  4);
    B = uvw (2 : length(Su)) * rpc ( 5 :  7) + 1;% 1 = b1 = d1
    C = uvw                  * rpc ( 8 : 11);
elseif s == 2
    A = uvw                  * rpc ( 1 : 10);
    B = uvw (2 : length(Su)) * rpc (11 : 19) + 1; 
    C = uvw                  * rpc (20 : 29);
elseif s == 3
    A = uvw                  * rpc ( 1 : 20);
    B = uvw (2 : length(Su)) * rpc (21 : 39) + 1; 
    C = uvw                  * rpc (39 : 59);
end

r = A / B;% size : 1 x 1
c = C / B;

AA11 = uvw / B;
AA12 = - r / B * uvw (2 : length(Su));
AA13 = zeros(1, length(Su));
%AA21 = AA13
AA22 = - c / B * uvw (2 : length(Su));
%AA23 = AA11;

AA = [AA11 AA12 AA13
      AA13 AA22 AA11];