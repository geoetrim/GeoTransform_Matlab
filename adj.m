% Adjustment for sensor independent orientation models in GeoTransform
% Developed by Ali CAM & Hüseyin TOPAN (alicam193@gmail.com, topan@beun.edu.tr)
% Zonguldak Bülent Ecevit University, Zonguldak, Turkey, June 2023
% github.com/geoetrim

function adj

Sc   = select_icp;
fid  = evalin('base','fid');
meta = evalin('base','meta');
gcp  = evalin('base','gcp');
icp  = evalin('base','icp');
model_id = evalin('base','model_id');

% Weight matrix
P = wght(gcp(: , :), fid);

% Define iteration limit
if model_id == 5 || model_id == 6 || model_id >= 70
    nj = 10; else nj = 1;
end

%% Adjustment except sensor dependent RFM
for j = 1 : nj
    if j == 1
        Px = 0;
        gcp(: , 12 : 13) = gcp(: , 7 : 8);
        if Sc > 0
            icp = evalin('base','icp');
            icp(: , 12 : 13) = icp(: , 7 : 8);
        end
        lo_gcp(length(gcp(: , 1)) , 2) = 0; % Defination of miscloser at 1st iteration as zero (0).
        if Sc > 0
            lo_icp(length(icp(: , 1)) , 2) = 0; % Defination of miscloser at 1st iteration as zero (0).
        end
    end
    
    A_gcp = Jacobo(gcp(: , :), model_id);
    if Sc > 0
        A_icp = Jacobo(icp(: , :), model_id);
    end
    
    % Remove unvalid coefficients
    if meta (11) == 1
        unvalid_parameters = evalin('base','unvalid_parameters');
        for i = 1 : length(unvalid_parameters)
            A_gcp(: , unvalid_parameters(i)) = [];
            if Sc > 0
                A_icp(: , unvalid_parameters(i)) = [];
            end
        end
    end

    % Estimate miscloser in a vector form
    l_gcp = 0;
    for i = 1 : length(gcp(: , 1))
        l_gcp (2 * i - 1) = gcp (i , 12) - lo_gcp(i , 1);
        l_gcp (2 * i)     = gcp (i , 13) - lo_gcp(i , 2);
    end
    
    if Sc > 0
        l_icp = 0;
        for i = 1 : length(icp(: , 1))
            l_icp (2 * i - 1) = icp (i , 12) - lo_icp(i , 1);
            l_icp (2 * i)     = icp (i , 13) - lo_icp(i , 2);
        end
    end
    
    [Qxx , dx , fid] = Qxx_dx(A_gcp, P, l_gcp, meta, fid, j);
    
    % Not affilated by the raw image coordinates.
    vn_gcp = A_gcp * dx - l_gcp';
    if Sc > 0
        vn_icp = A_icp * dx - l_icp';
    end
    
    Px = Px + dx;
        
    for i = 1 : length(gcp(: , 1))
        lo_gcp(i , 1) = A_gcp(2 * i - 1, :) * Px;
        lo_gcp(i , 2) = A_gcp(2 * i    , :) * Px;
    end
    if Sc > 0
        for i = 1 : length(icp(: , 1))
            lo_icp(i , 1) = A_icp(2 * i - 1, :) * Px;
            lo_icp(i , 2) = A_icp(2 * i    , :) * Px;
        end
    end
    
    % Normalized residuals in an iteration (not the final version)
    for i = 1 : length(gcp(: , 1))
        vrn_gcp(i) = vn_gcp (2 * i - 1);
        vcn_gcp(i) = vn_gcp (2 * i);
    end
    
    if Sc > 0
        for i = 1 : length(icp(: , 1))
            vrn_icp(i) = vn_icp (2 * i - 1);
            vcn_icp(i) = vn_icp (2 * i);
        end
    end

    gcp(: , 12) = gcp(: , 12) + vrn_gcp';
    gcp(: , 13) = gcp(: , 13) + vcn_gcp';
    
    if Sc > 0
        icp (: , 12) = icp(: , 12) + vrn_icp';
        icp (: , 13) = icp(: , 13) + vcn_icp';
    end
    
    % Final version of normalized residuals in an iteration (difference
    % between adjusted and raw image coordinates)
    vd_gcp = gcp(: , 12 : 13) - gcp(: , 7 : 8);
    if Sc > 0
        vd_icp = icp(: , 12 : 13) - icp(: , 7 : 8);
    end
    
    % Final version of normalized RMSE in an iteration
    mon_gcp = sqrt((vd_gcp(: , 1)' * vd_gcp(: , 1) + vd_gcp(: , 2)' * vd_gcp(: , 2)) / (2 * length(gcp(: , 1)) - length(dx)));
    if Sc > 0
        mon_icp = sqrt((vd_icp(: , 1)' * vd_icp(: , 1) + vd_icp(: , 2)' * vd_icp(: , 2)) / (2 * length(icp(: , 1)) - 1));
    end
%     assignin('base','mon',mon_gcp)
%     assignin('base','mon',mon_icp)
    
    %% Reverse normalisation 
    if meta(1) == 0
        gcp(: , 14 : 15) = gcp (: , 12 : 13);
        if Sc > 0
            icp(: , 14 : 15) = icp (: , 12 : 13);
        end
    elseif meta(1) == 1
        for i = 1 : 2
            gcp(: , i + 13) = ((gcp(: , i + 11) * (max(gcp(: , i + 1)) - min(gcp(: , i + 1))) + max(gcp(: , i + 1)) + min(gcp(: , i + 1))) / 2);
            if Sc > 0
                icp(: , i + 13) = ((icp(: , i + 11) * (max(gcp(: , i + 1)) - min(gcp(: , i + 1))) + max(gcp(: , i + 1)) + min(gcp(: , i + 1))) / 2);
            end
        end
    end
    assignin('base','gcp',gcp);
    
    v_gcp = gcp(: , 14 : 15) - gcp(: , 2 : 3);
    if Sc > 0
        v_icp = icp(: , 14 : 15) - icp(: , 2 : 3);
    end
%     assignin('base','v_gcp',v_gcp)
%     assignin('base','v_icp',v_icp)
    
    % Update the weight matrix
    for i = 1 : length(gcp(: , 1)) 
        P2(i , i) = P(2 * i - 1, 2 * i - 1);
    end
    
    % Final RMSE
    mo_gcp(j) = sqrt ((v_gcp(: , 1)' * P2 * v_gcp(: , 1) + v_gcp(: , 2)' * P2 * v_gcp(: , 2)) / (2 * length(gcp(: , 1)) - length(dx)));
    
    % Terminate the iteration
    if j > 1
        if abs(mo_gcp(j - 1) - mo_gcp(j)) < 0.01 % pixel
            break
        end
    end
end

mr_gcp = sqrt ((v_gcp(: , 1)' * P2 * v_gcp(: , 1)) / (length(gcp(: , 1)) - 0.5 * length(dx))); %Dengeleme Hesabý III, E. Öztürk & M. Þerbetçi, Helmert Dönüþümü
mc_gcp = sqrt ((v_gcp(: , 2)' * P2 * v_gcp(: , 2)) / (length(gcp(: , 1)) - 0.5 * length(dx)));
mp_gcp = sqrt(mr_gcp ^ 2 + mc_gcp ^ 2);

mr_gcp_tgrs = sqrt ((v_gcp(: , 1)' * P2 * v_gcp(: , 1)) / (2 * length(gcp(: , 1)) - length(dx))); %Bilgi'nin yayýnda kullanýlan.
mc_gcp_tgrs = sqrt ((v_gcp(: , 2)' * P2 * v_gcp(: , 2)) / (2 * length(gcp(: , 1)) - length(dx)));

if Sc > 0
    mr_icp = sqrt ((v_icp(: , 1)' * v_icp(: , 1)) / (length(icp(: , 1)) - 1));
    mc_icp = sqrt ((v_icp(: , 2)' * v_icp(: , 2)) / (length(icp(: , 1)) - 1));
    mp_icp = sqrt (mr_icp ^ 2 + mc_icp ^ 2);
    mo_icp = sqrt ((v_icp(: , 1)' * v_icp(: , 1) + v_icp(: , 2)' * v_icp(: , 2)) / (2 * length(icp(: , 1)) - 1));
    
    mr_icp_tgrs = sqrt ((v_icp(: , 1)' * v_icp(: , 1)) / (2 * length(icp(: , 1)) - 1)); %Bilgi'nin yayýnda kullanýlan.
    mc_icp_tgrs = sqrt ((v_icp(: , 2)' * v_icp(: , 2)) / (2 * length(icp(: , 1)) - 1));
end
% assignin('base','mr',mr)
% assignin('base','mc',mc)

if meta(1) ~= 0
    Kdpdp = mon_gcp^2 * Qxx; %Use normalized values.
elseif meta(1) == 0
    Kdpdp = mo_gcp(j)^2 * Qxx;
end

% Validation of parameters/coefficients
fid = par_valid (A_gcp, dx, Qxx, mon_gcp, fid);

% Blunder test
fid = blunder(gcp(: , :), vn_gcp, dx, A_gcp, fid, mon_gcp, P, Qxx, mo_gcp(j) / mon_gcp);

fprintf(fid, 'Total GCP number: %3d \n', length(gcp(: , 1)));
fprintf(fid, 'Total ICP number: %3d \n\n', length(icp(: , 1))); 
fprintf(fid, 'Total iteration: %3d \n\n', j);
fprintf(fid, 'Accuracies for GCPs\n');
fprintf(fid, 'mr = ± %5.3f pixel\n',   mr_gcp);
fprintf(fid, 'mc = ± %5.3f pixel\n',   mc_gcp);
fprintf(fid, 'mo = ± %5.3f pixel\n\n', mo_gcp(j));
fprintf(fid, 'mr(tgrs) = ± %5.3f pixel\n', mr_gcp_tgrs);
fprintf(fid, 'mc(tgrs) = ± %5.3f pixel\n\n', mc_gcp_tgrs);
fprintf(fid, 'vr(max)= %5.3f pixel, vr(min)= %5.3f pixel\n',   max(v_gcp(: , 1)), min(v_gcp(: , 1)));
fprintf(fid, 'vc(max)= %5.3f pixel, vc(min)= %5.3f pixel\n\n', max(v_gcp(: , 2)), min(v_gcp(: , 2)));
fprintf(fid, '[vr] = %5.3f pixel\n',   sum(v_gcp(: , 1)));
fprintf(fid, '[vc] = %5.3f pixel\n\n', sum(v_gcp(: , 2)));

if Sc > 0
    fprintf(fid, 'Accuracies for ICPs\n');
    fprintf(fid, 'mr = ± %5.3f pixel\n',   mr_icp);
    fprintf(fid, 'mc = ± %5.3f pixel\n',   mc_icp);
    fprintf(fid, 'mo = ± %5.3f pixel\n\n', mo_icp);
    fprintf(fid, 'mr(tgrs) = ± %5.3f pixel\n', mr_icp_tgrs);
    fprintf(fid, 'mc(tgrs) = ± %5.3f pixel\n\n', mc_icp_tgrs);
    fprintf(fid, 'vr(max)= %5.3f pixel, vr(min)= %5.3f pixel\n',   max(v_icp(: , 1)), min(v_icp(: , 1)));
    fprintf(fid, 'vc(max)= %5.3f pixel, vc(min)= %5.3f pixel\n\n', max(v_icp(: , 2)), min(v_icp(: , 2)));
    fprintf(fid, '[vr] = %5.3f pixel\n',   sum(v_icp(: , 1)));
    fprintf(fid, '[vc] = %5.3f pixel\n\n', sum(v_icp(: , 2)));
    assignin('base','icp',icp);
end

% Save in workspace
assignin('base','vn', vn_gcp);
assignin('base','Px', Px);
assignin('base','Kdpdp', Kdpdp);
assignin('base','mo', mo_gcp);
assignin('base','v', v_gcp);
assignin('base','A', A_gcp);
assignin('base','vx', vrn_gcp);
assignin('base','vy', vcn_gcp);