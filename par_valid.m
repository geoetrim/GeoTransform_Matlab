% Parameter validation test
% Confirmed by Ghilani, C.d., Wolf, P.R., 2006. Adjustment Computations, 4th ed. John Wiley & Sons, Inc.

function fid = par_valid (A, dx, Qxx, mon, fid)

f = length (A (: , 1)) - length (dx); %degree of freedom

for i = 1 : length (Qxx)
    m(i) = mon * sqrt (Qxx (i , i));
end

T = tinv(0.975, f); %Test value from table

for i = 1 : length (dx)
    t(i) = abs (dx(i)) / m(i);
    if t(i) <= T
        par_valid(i) = 0; %unvalid
    else
        par_valid(i) = 1; %valid
    end
end

%Showing the validation of parameters
unvalid_parameters = find(par_valid == 0);
assignin('base','unvalid_parameters',fliplr(unvalid_parameters));

if isempty(unvalid_parameters)
    fprintf(fid,'All parameters are valid. \n\n');
else fprintf(fid,'Unvalid parameters: \n');
    for i = 1 : length(unvalid_parameters)
        str_Sng = num2str(unvalid_parameters(i));
        sz_Sng = size(str_Sng);
        c = {'%'; sz_Sng(1 , 2); 'd'};
        prnt = sprintf('%s%d%s ', c{:});
        fprintf(fid, prnt, unvalid_parameters(i));
    end
    fprintf(fid, '\n\n');
end

% for i = 1 : length(Qxx)
%     for j = 1 : (length(Qxx) - 3 * nSc)
%         kor(i , j) = Qxx(i , j) / sqrt(Qxx(i , i) * Qxx(j, j));
%     end
% end