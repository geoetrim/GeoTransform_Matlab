% Estimation of approximate ground coordinates of each ICP
% Coding starting date: 06.11.2019 by Hüseyin Topan and Resmigül Þener

function [latitude_estimated, longitude_estimated, height_estimated] = estimate_ground(points)

rpc = evalin('base','rpc');

r = points(: , 7 , :);
c = points(: , 8 , :);

for i = 1 : 2
    a0(i) = rpc(11 , i);
    a1(i) = rpc(12 , i);
    a2(i) = rpc(13 , i);
    a3(i) = rpc(14 , i);
    
    b0(i) = rpc(31 , i);
    b1(i) = rpc(32 , i);
    b2(i) = rpc(33 , i);
    b3(i) = rpc(34 , i);
    
    c0(i) = rpc(51 , i);
    c1(i) = rpc(52 , i);
    c2(i) = rpc(53 , i);
    c3(i) = rpc(54 , i);
    
    d0(i) = rpc(71 , i);
    d1(i) = rpc(72 , i);
    d2(i) = rpc(73 , i);
    d3(i) = rpc(74 , i);
    
    Xs(i) = rpc(10 , i); %Tao and Hu, 2002, syf: 706
    Ys(i) = rpc( 8 , i);
    Zs(i) = rpc( 9 , i);
    
    Xo(i) = rpc( 5 , i);
    Yo(i) = rpc( 3 , i);
    Zo(i) = rpc( 4 , i);
    
    a01(i) = a0(i) * Zs(i) * Ys(i) * Xs(i) - a1(i) * Zo(i) * Ys(i) * Xs(i) - a2(i) * Zs(i) * Yo(i) * Xs(i) - a3(i) * Zs(i) * Ys(i) * Xo(i);
    b01(i) = b0(i) * Zs(i) * Ys(i) * Xs(i) - b1(i) * Zo(i) * Ys(i) * Xs(i) - b2(i) * Zs(i) * Yo(i) * Xs(i) - b3(i) * Zs(i) * Ys(i) * Xo(i);
    c01(i) = c0(i) * Zs(i) * Ys(i) * Xs(i) - c1(i) * Zo(i) * Ys(i) * Xs(i) - c2(i) * Zs(i) * Yo(i) * Xs(i) - c3(i) * Zs(i) * Ys(i) * Xo(i);
    d01(i) = d0(i) * Zs(i) * Ys(i) * Xs(i) - d1(i) * Zo(i) * Ys(i) * Xs(i) - d2(i) * Zs(i) * Yo(i) * Xs(i) - d3(i) * Zs(i) * Ys(i) * Xo(i);
    
    a11(i) = a1(i) * Ys(i) * Xs(i);
    a21(i) = a2(i) * Zs(i) * Xs(i);
    a31(i) = a3(i) * Zs(i) * Ys(i);
    
    b11(i) = b1(i) * Ys(i) * Xs(i);
    b21(i) = b2(i) * Zs(i) * Xs(i);
    b31(i) = b3(i) * Zs(i) * Ys(i);
    
    c11(i) = c1(i) * Ys(i) * Xs(i);
    c21(i) = c2(i) * Zs(i) * Xs(i);
    c31(i) = c3(i) * Zs(i) * Ys(i);
    
    d11(i) = d1(i) * Ys(i) * Xs(i);
    d21(i) = d2(i) * Zs(i) * Xs(i);
    d31(i) = d3(i) * Zs(i) * Ys(i);
    
    A(2 * i - 1 , :) = [a11(i) - r(i) * b11(i) a21(i) -r(i) * b21(i) a31(i) - r(i) * b31(i)];
    A(2 * i     , :) = [c11(i) - c(i) * d11(i) c21(i) -c(i) * d21(i) c31(i) - c(i) * d31(i)];
    
    l(2 * i - 1 , :) = r(i) * b01(i) - a01(i);
    l(2 * i     , :) = c(i) * d01(i) - c01(i);
end

estimated_ground = inv(A' * A) * A' * l;

Z_estimated = estimated_ground(1); longitude_estimated = Z_estimated;
Y_estimated = estimated_ground(2); latitude_estimated  = Y_estimated;
X_estimated = estimated_ground(3); height_estimated    = X_estimated;