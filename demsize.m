% reshape için  DEM'in satr sutununu belirleme

function [r c] = demsize(dem)

row_max = max(dem(: , 2));
row_min = min(dem(: , 2));
col_min = min(dem(: , 1));
col_max = max(dem(: , 1));

% koordinat artýþý belirleme
if (dem(2 , 1) - dem(1 , 1)) < 1 
    art = dem(2 , 2) - dem(1 , 2);
    r1 = row_min : art : row_max;
    c1 = col_min : art : col_max;
    r1 = fix(r1);
    c1 = fix(c1);
else
    art = dem(2 , 1) - dem(1 , 1);
    c1 = row_min : art : row_max;
    r1 = col_min : art : col_max;
    c1 = fix(c1);
    r1 = fix(r1);
end

r = size(r1 , 2);
c = size(c1 , 2);