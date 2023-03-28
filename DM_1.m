% Design matrix for the scenario that all RPCs are different than each
% other (sdm = 1)

function [r, c, AA] = DM_1(gcp, rpc, Su, s)

U = gcp(1); %Latitude
V = gcp(2); %Longitude
W = gcp(3); %Height
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
    A = uvw * rpc ( 1 :  4);
    B = uvw * rpc ( 5 :  8); 
    C = uvw * rpc ( 9 : 12);
    D = uvw * rpc (13 : 16);
elseif s == 2
    A = uvw * rpc ( 1 : 10);
    B = uvw * rpc (11 : 20); 
    C = uvw * rpc (21 : 30);
    D = uvw * rpc (31 : 40);
elseif s == 3
    A = uvw * rpc ( 1 : 20);
    B = uvw * rpc (21 : 40); 
    C = uvw * rpc (41 : 60);
    D = uvw * rpc (61 : 80);
end

r = A / B;% size : 1 x 1
c = C / D;

AA11 = uvw / B;
AA12 = - r / B * uvw;
AA13 = zeros(1, 2 * length(uvw));
%AA21 = AA13
AA22 =  uvw / D;
AA23 = - c / D * uvw;

AA = [AA11 AA12 AA13
      AA13 AA22 AA23];