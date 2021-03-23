%Affine and similarity transformation

function [g, fid] = afin_ben(gcp, rpc, m, fid)

for i = 1 : length(gcp(:,1))
    if m == 1
    A(2 * i - 1, :) = [1 gcp(i , 12) gcp(i , 13) 0];
    A(2 * i,     :) = [0 gcp(i , 13) gcp(i , 12) 1];
    elseif m == 2
    A(2 * i - 1, :) = [1 gcp(i , 12) gcp(i , 13) 0        0           0          ];
    A(2 * i,     :) = [0 0           0           1        gcp(i , 12) gcp(i , 13)];
    end
    l(2 * i - 1, 1) = gcp(i , 7);
    l(2 * i,     1) = gcp(i , 8);
end

dx = inv(A' * A) * A' * l;

v = A * dx - l;

for i = 1 : length(v)/2
    vx(i) = v(2 * i - 1);
    vy(i) = v(2 * i);
end
g = [gcp(: , 7) + vx'  gcp(: , 8) + vy'];

mx = sqrt(vx * vx') / (2 * length(gcp(: , 1)) - length(A(1 , :))) * rpc(6);
my = sqrt(vy * vy') / (2 * length(gcp(: , 1)) - length(A(1 , :))) * rpc(7);
m0 = sqrt(mx^2 + my^2);

fprintf(fid, 'RMSE of bias compensation: %5.2f pixel \n\n', m0);