% Design matrix for the scenario that all RPCs are different than each
% other except b1 = d1 = 1

function lo = rfm_lo(s, gcp, rpc)

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

if s == 71
    Su = (1 : 4);
elseif s == 72
    Su = (1 : 10);
elseif s == 73
    Su = (1 : 20);
end

uvw = uvw(Su);
%==========================================================================
if s == 71
    A = uvw                  * rpc ( 1 :  4);
    B = uvw (2 : length(Su)) * rpc ( 5 :  7) + 1;% 1 = b1 = d1 
    C = uvw                  * rpc ( 8 : 11);
    D = uvw (2 : length(Su)) * rpc (12 : 14) + 1;
elseif s == 72
    A = uvw                  * rpc ( 1 : 10);
    B = uvw (2 : length(Su)) * rpc (11 : 19) + 1; 
    C = uvw                  * rpc (20 : 29);
    D = uvw (2 : length(Su)) * rpc (30 : 38) + 1;
elseif s == 73
    A = uvw                  * rpc ( 1 : 20);
    B = uvw (2 : length(Su)) * rpc (21 : 39) + 1; 
    C = uvw                  * rpc (40 : 59);
    D = uvw (2 : length(Su)) * rpc (60 : 78) + 1;
end

lo = [A / B, C / D]; % size : 1 x 1