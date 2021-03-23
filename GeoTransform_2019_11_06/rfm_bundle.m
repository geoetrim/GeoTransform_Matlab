% Bundle adjustment of sensor dependent RFM
% Coding starting date: 06.11.2019 by Hüseyin Topan and Resmigül Þener

function rfm_bundle

%===== GCP-ICP separation =====
Spc; Sc = evalin('base','Sc');
for i = 1 : 2
    [gcp(: , : , i), icp(: , : , i), fc] = fndicp(points(: , : , i), Sc);
end

%===== Estimation of ~ground coordinates for all points =====
for i = 1 : length(points(: , 1 , 1))
    points(i , 21 : 23 , 1) = estimate_ground(points(i , : , :));
    points(i , 21 : 23 , 2) = points(i , 21 : 23 , 1);
end

%===== Selection of RPCs and UVWs =====
[sdm, fid] = rpc_cond(rpc, fid); %Defining the denominator
[Sr, Su, so, fid] = Srpc(2 * length(points(: , 1 , 1)), sdm, fid);
rpc_s = rpc(Sr, :); %Selected RPCs

%===== Iteration limit =====
iteration_limit = 1; if iteration_limit == 1; display('Attention! Total iteration: 1'); end

for iter = 1 : iteration_limit
    
    if j == 1
        for i = 1 : 2
            points(: , 16 : 17 , i) = points(: , 14 : 15 , i);
        end
    end

    %===== Jacobian matrix regarding RPCs =====
    for j = 1 : n_image %Iteration for all images

        %===== Jacobian matrix and absolute term vector for GCPs =====
        for i = 1 : length(points(:, 1 , 1))
            if sdm == 1
                [ro_gcp(: , j), co_gcp(: , j), A1_gcp(: , : , j)] = DM_1(gcp(i , 9 : 11 , j), rpc_s(: , j), Su, so);
            elseif sdm == 2
                [ro_gcp(: , j), co_gcp(: , j), A1_gcp(: , : , j)] = DM_2(gcp(i , 9 : 11 , j), rpc_s(: , j), Su, so);
            elseif sdm == 3
                [ro_gcp(: , j), co_gcp(: , j), A1_gcp(: , : , j)] = DM_3(gcp(i , 9 : 11 , j), rpc_s(: , j), Su, so);
            else
                [ro_gcp(: , j), co_gcp(: , j), A1_gcp(: , : , j)] = DM_4(gcp(i , 9 : 11 , j), rpc_s(: , j), Su, so);
            end

            ARPC_gcp(2*i-1 , : , j) = A1_gcp(1 , : , j);
            ARPC_gcp(2*i   , : , j) = A1_gcp(2 , : , j);

            l_gcp(2 * i - 1 , j) = gcp(i, 16 , j) - ro_gcp(: , j);
            l_gcp(2 * i     , j) = gcp(i, 17 , j) - co_gcp(: , j);
        end

        %===== Jacobian matrix and absolute term vector for ICPs =====
        for i = 1 : length(points(:, 1 , 1))
            if sdm == 1
                [ro_icp(: , j), co_icp(: , j), A1_icp(: , : , j)] = DM_1(icp(i , 21 : 23 , j), rpc_s(: , j), Su, so);
            elseif sdm == 2
                [ro_icp(: , j), co_icp(: , j), A1_icp(: , : , j)] = DM_2(icp(i , 21 : 23 , j), rpc_s(: , j), Su, so);
            elseif sdm == 3
                [ro_icp(: , j), co_icp(: , j), A1_icp(: , : , j)] = DM_3(icp(i , 21 : 23 , j), rpc_s(: , j), Su, so);
            else
                [ro_icp(: , j), co_icp(: , j), A1_icp(: , : , j)] = DM_4(icp(i , 21 : 23 , j), rpc_s(: , j), Su, so);
            end

            ARPC_icp(2*i-1 , : , j) = A1_icp(1 , : , j);
            ARPC_icp(2*i   , : , j) = A1_icp(2 , : , j);

            l_icp(2 * i - 1 , j) = icp(i, 16 , j) - ro_icp(: , j);
            l_icp(2 * i     , j) = icp(i, 17 , j) - co_icp(: , j);
        end

        ARPC_all(: , : , j) = [ARPC_gcp(: , : , j); ARPC_icp(: , : , j)];

        l = [l_gcp(: , 1) l_icp(: , 1) l_gcp(: , 2) l_icp(: , 2)];
    end

        ARPC = [ARPC_all(: , : , 1)              zeros(size(ARPC_all(: , : , 1)));
                zeros(size(ARPC_all(: , : , 1))) ARPC_all(: , : , 2)            ];

    %===== Jacobian matrix regarding XYZ =====
    for i = 1 : 2
        AXYZ_pre(: , : , i) = A_dXYZ(points(: , : , i), rpc(11 : 90 , i), fc);
    end
    AXYZ = [AXYZ_pre(: , : , 1); AXYZ_pre(: , : , 2)];

    A = [ARPC AXYZ];

    [Qxx , dx , fid] = Qxx_dx(A, P, l, meta, fid, iter);
    
    vn = A * dx - l';
    vn = reshape(vn', [2 * length(points(: , 1 , 1)), 2];
    
    % Separatin of correction values of RPCs for both images =====    
    dRPC(: , 1) = dx(1 : length(Sr));
    dRPC(: , 2) = dx((length(Sr) + 1) : (2 * length(Sr)));
        
    rpc_s = rpc_s + [dRPC(: , 1) dRPC(: , 2)];
    
    % Normalized residuals in an iteration (not the final version)
    for j = 1 : n_image
        for i = 1 : length(points(: , 1 , 1))
            vrn(i , j) = vn(2 * i - 1 , j); %vrn
            vcn(i , j) = vn(2 * i     , j); %vcn
        end
    end
    
    vrn_gcp = vrn(1 : length(gcp(: , 1 , 1)) , :);
    vcn_gcp = vcn(1 : length(gcp(: , 1 , 1)) , :);
    
    vrn_icp = vrn((length(icp(: , 1 , 1)) + 1) : length(vrn(: , 1)) , :);
    vcn_icp = vcn((length(icp(: , 1 , 1)) + 1) : length(vcn(: , 1)) , :);
    
    for j = 1 : n_image
        gcp(: , 16 , j) = gcp(: , 16 , j) + vrn_gcp(: , j);
        gcp(: , 17 , j) = gcp(: , 17 , j) + vcn_gcp(: , j);
        
        icp(: , 16 , j) = icp(: , 16 , j) + vrn_icp(: , j);
        icp(: , 17 , j) = icp(: , 17 , j) + vcn_icp(: , j);
    end
    
    % Final version of normalized residuals in an iteration (difference
    % between adjusted and raw image coordinates)
    vd_gcp = gcp(: , 16 : 17 , :) - gcp(: , 7 : 8 , :);
    vd_icp = icp(: , 16 : 17 , :) - icp(: , 7 : 8 , :);
    
    % Final version of normalized RMSE in an iteration
    for j = 1 : n_image
        mon_gcp(j) = sqrt((vd_gcp(: , 1 , j)' * vd_gcp(: , 1 , j) + vd_gcp(: , 2 , j)' * vd_gcp(: , 2 , j)) / (2 * length(gcp(: , 1 , j)) - length(rpc_s(: , 1))));
        mon_icp(j) = sqrt((vd_icp(: , 1 , j)' * vd_icp(: , 1 , j) + vd_icp(: , 2 , j)' * vd_icp(: , 2 , j)) / (2 * length(gcp(: , 1 , j)) - 1));
    end
    
    % Corrected and renormalized GCPs
    for j = 1 : n_image
        for i = 18 : 19
            gcp(:, i , j) = gcp(:, i - 2 , j) * rpc(i - 12 , j) + rpc(i - 17 , j);        
            icp(:, i , j) = icp(:, i - 2 , j) * rpc(i - 12 , j) + rpc(i - 17 , j);
        end
    end
    
    % Eksik: ICP'lerin yer koordinatlarýna düzeltme getirilecek ve GPS ile
    % ölçülenler ile aralarýndaki fark belirlenecek.
    % YKN'lerin yer koorinatlarý belirlenecek (düzeltilmiþ RPC'lerle) ve GPS ile
    % ölçülenler ile aralarýndaki fark belirlenecek.
    
    rpc(Sr) = rpc_s;
    
    v_gcp = gcp(: , 18 : 19 , :) - gcp(: , 2 : 3 , :);
    v_icp = icp(: , 18 : 19 , :) - icp(: , 2 : 3 , :);
    
    % Update the weight matrix
    for i = 1 : length(gcp(: , 1)) 
        P2(i , i) = P(2 * i - 1, 2 * i - 1);
    end
    
    % Final RMSE
    for j = 1 : n_image
        mo_gcp(iter , j) = sqrt((v_gcp(: , 1 , j)' * P2 * v_gcp(: , 1 , j) + v_gcp(: , 2 , j)' * P2 * v_gcp(: , 2 , j)) / (2 * length(gcp(: , 1 , j)) - length(rpc_s(: , 1))));
    
        % Terminate the iteration
        if iter > 1
            if abs(mo_gcp(iter - 1 , 1) - mo_gcp(iter , j)) < 0.01 % pixel
                break
            end
        end
    end
end
