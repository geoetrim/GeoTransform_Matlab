% Preprocessing coordinates of points and DEM

function prepro(ni)

fid      = evalin('base','fid');
meta     = evalin('base','meta');
points   = evalin('base','points');
model_id = evalin('base','model_id');
number_images = evalin('base','number_images');

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

%% ===== Normalisation except sensor dependent RFM =====
if model_id < 80
    % Normalisation
    for i = 2 : length(points(1 , :))
        for j = 1 : length(points(: , 1))
            if meta(1) == 0 % Keep original without normalisation
                points(j , i + 5 , ni) = points(j , i , ni);
            elseif meta(1) == 1% Normalize into ±1
                points(j , i + 5 , ni) = ((2 *  points(j , i , ni) - max(points(: , i , ni)) - min(points(: , i , ni))) / (max(points(: , i , ni)) - min(points(: , i , ni))));
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
        points (: , i + 6 , ni) = (points(: , i + 1 , ni) - rpc(i , ni)) / rpc(i + 5 , ni);
    end
    %% ===== Bias compensation by Teo =====
    % ===== Estimated line and column by RPCs =====
    for i = 1 : length(points(: , 1 , ni))
        [points(i, 12 : 13 , ni)] = rc_rpc(points(i, 9 : 11 , ni), rpc(: , ni));
    end
    for i = 1 : 2
        stdb (:, i) = sqrt(((points(:, i + 6 , ni) - points(:, i + 11 , ni))' * (points(:, i + 6 , ni) - points(:, i + 11 , ni))) / length(points(: , 1 , ni))) * rpc(i + 6 , ni);
    end
    fprintf(fid, '%1d. Standard devition in bias: %5.2f pixel\n\n', ni, sqrt(stdb * stdb'));

    % ===== Compensation models =====
    [points(:, 14 : 15 , ni), fid] = bias_compensation(points(: , : , ni), rpc(: , ni), fid, ni);
end
%% ===== Loading of GCPs to be ignored =====
if meta(9) == 1
Sip = ignored_points;
    display(' Ignored points are being removed from the point list.')
    pause(1)
        if ni == number_images
            points = remove_ignored_point(Sip, points, fid);
            assignin('base', 'points', points)
        end
end
%===== GCP-ICP separation =====
Sc = select_icp;
if ni > 1 %Loading GCP and ICP for the second image.
    gcp = evalin('base','gcp');
    if Sc > 0
        icp = evalin('base','icp');
    end
end

if Sc > 0
    [gcp(: , : , ni), icp(: , : , ni)] = generate_gcp_icp(points(: , : , ni), Sc);
else
    gcp(: , : , ni) = points(: , : , ni);
end

assignin('base','gcp',gcp)
if Sc > 0
    assignin('base','icp',icp)
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