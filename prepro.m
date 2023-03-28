% Preprocessing of coordinates of GCPs and DEM

function [gcp, fid] = prepro(points, model_id, fid)

meta = evalin('base','meta'); 
%% ===== Replacement of columns of latitude and longitude for sensor dependent RFM =====
% if model_id > 80 
%     for i = 0 : 1
%         g_rfm(: , i + 1) = gcp(: , 5 - i);
%         if meta(2) == 1
%             gdem = evalin('base','gdem');
%             rfm_gdem(: , i + 1) = gdem(: , 2 - i);
%         end
%     end
%     if meta(2) == 1
%         gdem(: , 1 : 2) = rfm_gdem;
%     end
%     gcp(: , 4 : 5) = g_rfm;
% end

%% ===== Normalisation =====
if model_id < 80
    % Normalisation
    for i = 2 : length(points(1 , :))
        for j = 1 : length(points(: , 1))
            if meta(1) == 0 % Keep original without normalisation
                points(j , i + 5) = points(j , i);
            elseif meta(1) == 1 % Normalize into ±1
                points(j , i + 5) = ((2 *  points(j , i) - max(points(: , i)) - min(points(: , i))) / (max(points(: , i)) - min(points(: , i))));
            end
        end
    end
    
    % DEM normalisation 
    if meta(2) == 1 % DEM available
        gdem = evalin('base','gdem');        
        for i = 1 : length(gdem(1 , :))
            for j = 1 : length(gdem(: , 1))
                if meta(1) == 0 % Keep original without normalisation
                    gdem(j , i + 3) = gdem(j , i);
                elseif meta(1) == 1 % Normalize into ±1
                    gdem(j , i + 3) = ((2 *  gdem(j , i) - max(points(: , i + 3)) - min(points(: , i + 3))) / (max(points(: , i + 3)) - min(points(: , i + 3))));
                end
            end
        end
        assignin('base','gdem',gdem);
    end
    
else %Normalization for sensor dependent RFM
    rpc = evalin('base','rpc');
    for i = 1 : 5
        points (:, i + 6) = (points(:, i + 1) - rpc(i)) / rpc(i + 5);
    end
    %% ===== Bias compensation by Teo =====
    % ===== Estimated line and column by RPCs =====
    for i = 1 : length(points(: , 1))
        [points(i, 12 : 13)] = rc(points(i, 9 : 11), rpc);
    end
    for i = 1 : 2
        stdb (:, i) = sqrt(((points(:, i + 6) - points(:, i + 11))' * (points(:, i + 6) - points(:, i + 11))) / length(points(: , 1))) * rpc(i + 6);
    end
    fprintf(fid, 'Standard devition in bias: %5.2f pixel\n\n', sqrt(stdb * stdb'));

    % ===== Compensation models =====
    [points(:, 14 : 15), fid] = bias_compensation(points, rpc, fid);
end

%% ===== Loading of GCPs to be ignored =====
if meta(9) == 1
%     Sng = [18 21 24 25 32 35 37 45 51 52 55 60 63 65 66 74 78 79 85 94 117 122 183 185 218 227 263];%input('GCP ID to be ignored. exp. [427 526 258]: ');
% Sng = [18 21 24 25 32 35 37 45 51 52 55 60 63 65 66 74 78 79 85 94 117 122 183 185 218 227 263 512 518];
Sng = [];
    for i = 1 : length(Sng)
        del_rc = find(points(: , 1)  == Sng(i));
        ignored_point(i , :) = points(del_rc , :);
        points(del_rc(1) , :) = [];
    end
    
    assignin('base','ignored_point',ignored_point);
    fprintf(fid,'Point ID ignored in the GCP file: \n\n');
    
    for i = 1 : length(Sng)
        str_Sng = num2str(Sng(i));
        sz_Sng = size(str_Sng);
        c = {'%'; sz_Sng(1 , 2); 'd'};
        prnt = sprintf('%s%d%s ', c{:});
        fprintf(fid, prnt, Sng(i));
    end
    fprintf(fid, '\n\n');
end

%===== GCP-ICP separation =====
Sc = select_icp;
if Sc > 0
    [gcp, icp] = generate_gcp_icp(points, Sc);
    assignin('base','icp',icp);
else
    gcp = points;
end

% % % 269
% alpha = 4.7331973708353;
% beta  = 4.534779563958489;
% % % 284
% % alpha = 0.7050371376820366;
% % beta  = 0.7122926278909263;
% % GOKTURK
% % alpha = -6.1181213612289;
% % beta = -0.00552436947918818;
% 
% Ralpha = [cosd(alpha) -sind(alpha); sind(alpha) cosd(alpha)];
% Rbeta  = [cosd(beta)   sind(beta) ;-sind(beta)  cosd(beta) ];
% 
% for i = 1 : length(g(: , 1))
%   snc = Ralpha * Rbeta * [g(i , 7); g(i , 8)];
%   g(i , 7) = snc(1);
%   g(i , 8) = snc(2);
% end