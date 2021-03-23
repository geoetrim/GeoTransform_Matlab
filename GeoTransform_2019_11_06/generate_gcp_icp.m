%Generation GCP and ICP files from given GCP file

function [gcp, icp] = generate_gcp_icp(points, Sc)

%===== Line-number of check points =====
for i = 1 : length(Sc)
    fc(i) = find(points(: , 1) == Sc(i));
end

%===== Line-number of ground points =====
fg = [1 : length(points)];
fg(:, fc)=[];

%===== Creating the GCPs and ICPs =====
for i = 1 : length(fg)
    gcp(i, :) = points(fg(i), :);
end

for i = 1 : length(Sc)
    icp(i, :) = points(fc(i), :);
end