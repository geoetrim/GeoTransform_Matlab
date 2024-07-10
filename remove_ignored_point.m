%Remove points to be ignored
%Developed by Ali Cam, modified by Prof. Hüseyin Topan, December 2021

function points = remove_ignored_point(Sip, points, fid)

fprintf(fid, 'Ignored points:\n');

for i = 1 : length(Sip)
    points(points(: , 1) == Sip(i) , : , :) = [];
    
    str_Sip = num2str(Sip(i));
    sz_Sip = size(str_Sip);
    c = {'%'; sz_Sip(1 , 2); 'd'};
    prnt = sprintf('%s%d%s ', c{:});
    fprintf(fid, prnt, Sip(i));
end
fprintf(fid, '\n');

assignin('base','ignored_point', Sip)