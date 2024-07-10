%Estimation of ground coordinates using RPCs from ground to image
%C. V. Tao and Y. Hu, "3D Reconstruction methods Based on the Rational
%Function Model," Photogrammetric Engineering & Remote Sensing, vol. 68,
%pp. 705-714, 2002, page 708

% ao' = a0 * Zs * Ys * Xs - a1 * Z0 * Ys * Xs - a2 * Zs * Y0 * Xs - a3 * Zs * Ys * X0;
% a1' = a1 * Ys * Xs;
% a2' = a2 * Zs * Xs;
% a3' = a3 * Zs * Ys;
% bo' = rpc(31 , j) * Zs * Ys * Xs - b1 * Z0 * Ys * Xs - b2 * Zs * Y0 * Xs - b3 * Zs * Ys * X0;
% b1' = b1 * Ys * Xs;
% b2' = b2 * Zs * Xs;
% b3' = b3 * Zs * Ys;
% co' = c0 * Zs * Ys * Xs - c1 * Z0 * Ys * Xs - c2 * Zs * Y0 * Xs - c3 * Zs * Ys * X0;
% c1' = c1 * Ys * Xs;
% c2' = c2 * Zs * Xs;
% c3' = c3 * Zs * Ys;
% do' = d0 * Zs * Ys * Xs - d1 * Z0 * Ys * Xs - d2 * Zs * Y0 * Xs - d3 * Zs * Ys * X0;
% d1' = d1 * Ys * Xs;
% d2' = d2 * Zs * Xs;
% d3' = d3 * Zs * Ys;
% 
% A(1 , 1) = a1l' - rl * b1l';
% A(1 , 2) = a2l' - rl * b2l';
% A(1 , 3) = a3l' - rl * b3l';
% A(2 , 1) = c1l' - cl * d1l';
% A(2 , 2) = c2l' - cl * d2l';
% A(2 , 3) = c3l' - cl * d3l';
% A(3 , 1) = a1r' - rr * b1r';
% A(3 , 2) = a2r' - rr * b2r';
% A(3 , 3) = a3r' - rr * b3r';
% A(4 , 1) = c1r' - cr * d1r';
% A(4 , 2) = c2r' - cr * d2r';
% A(4 , 3) = c3r' - cr * d3r';
% 
% l(1) = rl * bol' - aol';
% l(2) = cl * dol' - col';
% l(3) = rr * bor' - aor';
% l(4) = cr * dor' - cor';
% 
% x = inv(A' * A) * A' * l';

function estimate_ground_g2i(icp , rpc)

for ni = 1 : 2
    a0(ni) = rpc(11 , ni) * rpc(10 , ni) * rpc( 8 , ni) * rpc( 9 , ni) - rpc(14 , ni) * rpc( 5 , ni) * rpc( 8 , ni) * rpc( 9 , ni) - rpc(13 , ni) * rpc(10 , ni) * rpc( 3 , ni) * rpc( 9 , ni) - rpc(12 , ni) * rpc(10 , ni) * rpc( 8 , ni) * rpc( 4 , ni);
    a1(ni) = rpc(14 , ni) * rpc( 8 , ni) * rpc( 9 , ni);
    a2(ni) = rpc(13 , ni) * rpc(10 , ni) * rpc( 9 , ni);
    a3(ni) = rpc(12 , ni) * rpc(10 , ni) * rpc( 8 , ni);
    b0(ni) = rpc(31 , ni) * rpc(10 , ni) * rpc( 8 , ni) * rpc( 9 , ni) - rpc(34 , ni) * rpc( 5 , ni) * rpc( 8 , ni) * rpc( 9 , ni) - rpc(33 , ni) * rpc(10 , ni) * rpc( 3 , ni) * rpc( 9 , ni) - rpc(32 , ni) * rpc(10 , ni) * rpc( 8 , ni) * rpc( 4 , ni);
    b1(ni) = rpc(34 , ni) * rpc( 8 , ni) * rpc( 9 , ni);
    b2(ni) = rpc(33 , ni) * rpc(10 , ni) * rpc( 9 , ni);
    b3(ni) = rpc(32 , ni) * rpc(10 , ni) * rpc( 8 , ni);
    c0(ni) = rpc(51 , ni) * rpc(10 , ni) * rpc( 8 , ni) * rpc( 9 , ni) - rpc(54 , ni) * rpc( 5 , ni) * rpc( 8 , ni) * rpc( 9 , ni) - rpc(53 , ni) * rpc(10 , ni) * rpc( 3 , ni) * rpc( 9 , ni) - rpc(52 , ni) * rpc(10 , ni) * rpc( 8 , ni) * rpc( 4 , ni);
    c1(ni) = rpc(54 , ni) * rpc( 8 , ni) * rpc( 9 , ni);
    c2(ni) = rpc(53 , ni) * rpc(10 , ni) * rpc( 9 , ni);
    c3(ni) = rpc(52 , ni) * rpc(10 , ni) * rpc( 8 , ni);
    d0(ni) = rpc(71 , ni) * rpc(10 , ni) * rpc( 8 , ni) * rpc( 9 , ni) - rpc(74 , ni) * rpc( 5 , ni) * rpc( 8 , ni) * rpc( 9 , ni) - rpc(73 , ni) * rpc(10 , ni) * rpc( 3 , ni) * rpc( 9 , ni) - rpc(72 , ni) * rpc(10 , ni) * rpc( 8 , ni) * rpc( 4 , ni);
    d1(ni) = rpc(74 , ni) * rpc( 8 , ni) * rpc( 9 , ni);
    d2(ni) = rpc(73 , ni) * rpc(10 , ni) * rpc( 9 , ni);
    d3(ni) = rpc(72 , ni) * rpc(10 , ni) * rpc( 8 , ni);
end

for i = 1 : length(icp(: , 1 , 1))
    
    A(1 , 1) = a1(1) - icp(i , 7 , 1) * b1(1);
    A(1 , 2) = a2(1) - icp(i , 7 , 1) * b2(1);
    A(1 , 3) = a3(1) - icp(i , 7 , 1) * b3(1);
    A(2 , 1) = c1(1) - icp(i , 8 , 1) * d1(1);
    A(2 , 2) = c2(1) - icp(i , 8 , 1) * d2(1);
    A(2 , 3) = c3(1) - icp(i , 8 , 1) * d3(1);
    A(3 , 1) = a1(2) - icp(i , 7 , 2) * b1(2);
    A(3 , 2) = a2(2) - icp(i , 7 , 2) * b2(2);
    A(3 , 3) = a3(2) - icp(i , 7 , 2) * b3(2);
    A(4 , 1) = c1(2) - icp(i , 8 , 2) * d1(2);
    A(4 , 2) = c2(2) - icp(i , 8 , 2) * d2(2);
    A(4 , 3) = c3(2) - icp(i , 8 , 2) * d3(2);

    l(1) = icp(i , 7 , 1) * b0(1) - a0(1);
    l(2) = icp(i , 8 , 1) * d0(1) - c0(1);
    l(3) = icp(i , 7 , 2) * b0(2) - a0(2);
    l(4) = icp(i , 8 , 2) * d0(2) - c0(2);
    
    dx = (A' * A) \ (A' * l');
    blh(i , :) = [dx(2) ; dx(3) ; dx(1)];
end
assignin('base','blh',blh)

%Normalizing the ground coordinates for each images using their own shift
%and scale coefficients in RPC files.
for ni = 1 : 2
    for j = 1 : 3
        icp (: , j + 19 , ni) = (blh(: , j) - rpc(j + 2 , ni)) / rpc(j + 7 , ni);
    end
end
assignin('base','icp',icp)


