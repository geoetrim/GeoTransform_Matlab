%Generation separated GCP and ICP files from given point file

function [gcp, icp, fc] = fndicp(points, Sc)

%===== Line-number of check points =====
fc = fndchk (Sc, points);

%===== Line-number of ground points =====
fg = [1 : length(points)];
fg(:, fc)=[];

for i = 1 : (length(points(: , 1)) - length(Sc))
    gcp(i, :) = points(fg(i), :);
end

for i = 1 : length(Sc)
    icp(i, :) = points(fc(i), :);
end