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

uvw_selected = uvw(Su);
%==========================================================================
if s == 1
    A = uvw_selected * rpc ( 1 :  4);
    B = uvw_selected * rpc ( 5 :  8); 
    C = uvw_selected * rpc ( 9 : 12);
    D = uvw_selected * rpc (13 : 16);
elseif s == 2
    A = uvw_selected * rpc ( 1 : 10);
    B = uvw_selected * rpc (11 : 20); 
    C = uvw_selected * rpc (21 : 30);
    D = uvw_selected * rpc (31 : 40);
elseif s == 3
    A = uvw_selected * rpc ( 1 : 20);
    B = uvw_selected * rpc (21 : 40); 
    C = uvw_selected * rpc (41 : 60);
    D = uvw_selected * rpc (61 : 80);
end

assignin('base','A',A)
assignin('base','B',B)
assignin('base','C',C)
assignin('base','D',D)

%Estimation of r,c to shorten the formulation. This r,c are not affiliated
%by the observed (raw/corrected) image coordinates.
r = A / B;% size : 1 x 1
c = C / D;

AA11 = uvw_selected / B;
AA12 = - r / B * uvw_selected;
AA13 = zeros(1, 2 * length(uvw_selected));
%AA21 = AA13
AA22 =  uvw_selected / D;
AA23 = - c / D * uvw_selected;

AA = [AA11 AA12 AA13
      AA13 AA22 AA23];