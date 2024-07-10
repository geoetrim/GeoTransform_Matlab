%Bias compensation by Teo

function [g, fid] = bias_compensation(gcp, rpc, fid, ni)

if ni == 1
    fprintf(' Bias compensation model \n')
    fprintf(' No          -> 0 \n')
    fprintf(' Similarity  -> 1 \n')
    fprintf(' Affine      -> 2 \n')
    m = input(' Choose: ');
    if (m < 0) || (m > 2)
        disp(' Select 0, 1 or 2')
        m = input('Choose: ');
    end
    assignin('base','bias_model', m) 
elseif ni > 1
    m = evalin('base','bias_model');
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