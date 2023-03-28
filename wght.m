% Calculation weight matrix.

function P = wght(gcp, fid)
meta = evalin('base','meta');
if meta(6) == 0
   P = eye(2 * length(gcp(: , 1)));
else
    for i = 1 : length(gcp(: , 1))
        P(2 * i - 1, 2 * i - 1) = 1 / sqrt((mean(gcp(: , 7)) - gcp(i , 7))^2 +(mean(gcp(: , 8)) - gcp(i , 8))^2);
        P(2 * i    , 2 * i    ) = P(2 * i - 1, 2 * i - 1);
    end
end
%% Writting to text file
if meta(6) == 0
    fprintf(fid, 'Weight matrix not considered.\n\n');
else
    fprintf(fid, 'Weight matrix considered.\n\n');
end