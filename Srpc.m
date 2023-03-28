% Selection RPCs and UVWs

function [Sr, Su, so, fid] = Srpc(n, sdm, fid)

model_id = evalin('base' , 'model_id');

so = model_id - 80;

if sdm == 1
    if so == 1
        Sr = [11 : 14, 31 : 34, 51 : 54, 71 : 74];
    elseif so == 2
        Sr = [11 : 20, 31 : 40, 51 : 60, 71 : 80];
    else
        Sr = (11 : 90);
    end
end

if sdm == 2
    if so == 1
        Sr = [11 : 14, 32 : 34, 51 : 54, 72 : 74];
    elseif so == 2
        Sr = [11 : 20, 32 : 40, 51 : 60, 72 : 80];
    else
        Sr = [11 : 30, 32 : 70, 72 : 90];
    end
end

if sdm == 3
    if so == 1
        Sr = [11 : 14, 31 : 34, 51 : 54];
    elseif so == 2
        Sr = [11 : 20, 31 : 40, 51 : 60];
    else
        Sr = (11 : 70);
    end
end

if sdm == 4
    if so == 1
        Sr = [11 : 14, 32 : 34, 51 : 54];
    elseif so == 2
        Sr = [11 : 20, 32 : 40, 51 : 60];
    else
        Sr = [11 : 30, 32 : 70];
    end
end

if so == 1
    Su = (1 : 4);
elseif so == 2
    Su = (1 : 10);
else
    Su = (1 : 20);
end
    
if length(Sr) >= n
    endthr(1);
end

fprintf(fid, 'Selected RPCs: \n\n', Sr);