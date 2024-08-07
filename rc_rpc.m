%Estimation image coordinates by raw RPCs
function [r, c] = rc_rpc(gcp, rpc)

U = gcp(1); %latitude (normalized)
V = gcp(2); %longitude (normalized)
W = gcp(3); %elipsoidal height (normalized)
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
%==========================================================================

B = uvw * rpc (31 : 50); % size : 1 x 1

r = uvw * rpc (11 : 30) / B; % size : 1 x 1

D = uvw * rpc(71 : 90); % size : 1 x 1

c = uvw * rpc (51 : 70) / D; % size : 1 x 1