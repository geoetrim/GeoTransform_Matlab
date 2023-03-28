%Bias compensation by Teo

function [g, fid] = bias_compensation(gcp, rpc, fid)

fprintf('Bias compensation model \n')
fprintf('No          -> 0 \n')
fprintf('Similarity  -> 1 \n')
fprintf('Affine      -> 2 \n')

m = input('Choose: ');
if (m < 0) || (m > 2)
    disp('Select 0, 1 or 2')
    m = input('Choose: ');
end

if m == 0
    fprintf(fid, 'Bias compensation model: Not applied \n\n');
elseif m == 1
    fprintf(fid, 'Bias compensation model: Similarity \n\n');
else
    fprintf(fid, 'Bias compensation model: Affine \n\n');
end

if m == 0;
    g = gcp(:, 7 : 8);
elseif ((m == 1) || (m == 2))
    [g, fid] = afin_ben(gcp, rpc, m, fid);
end