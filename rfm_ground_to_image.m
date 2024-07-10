%3D RFM from ground to image
%Derived by Prof. Hüseyin Topan, ZBEÜ, November 2023, topan@beun.edu.tr
%Reference: C. V. Tao and Y. Hu, "3D Reconstruction methods Based on the Rational Function Model," Photogrammetric Engineering & Remote Sensing, vol. 68, pp. 705-714, 2002.

function rfm_ground_to_image

number_images = evalin('base','number_images');
rpc           = evalin('base','rpc');
gcp           = evalin('base','gcp');
icp           = evalin('base','icp');
model_id      = evalin('base','model_id');
fid           = evalin('base','fid');
meta          = evalin('base','meta');

%% ===== Selection of RPCs and UVWs =====
[sdm, fid] = rpc_cond(rpc(: , 1), fid); %Defining the RPC type w.r.t. the denominator
[Sr, Su, so, fid] = Srpc(2 * length(icp(: , 1)), sdm, fid);
for ni = 1 : 2
    rpc_s(: , ni) = rpc(Sr , ni);%Selected RPCs
end

for j = 1 : 10
    if j == 1
        gcp(: , 16 : 17 , :) = gcp(: , 14 : 15 , :);
        if Sc > 0
            icp(: , 16 : 17 , :) = icp(: , 14 : 15 , :);
        end
    end

    %% ===== Design matrixes =====
    %Design matrix for GCPs is constituted by normalized coordinates as in
    %upd_rpc.m
    for ni = 1 : number_images
        for i = 1 : length(gcp(: , 1))
            if sdm == 1
                [ro_gcp(: , ni), co_gcp(: , ni), A1_gcp(: , : , ni)] = DM_1(gcp(i , 9 : 11 , ni), rpc_s(: , ni), Su, so);
            elseif sdm == 2
                [ro_gcp(: , ni), co_gcp(: , ni), A1_gcp(: , : , ni)] = DM_2(gcp(i , 9 : 11 , ni), rpc_s(: , ni), Su, so);
            elseif sdm == 3
                [ro_gcp(: , ni), co_gcp(: , ni), A1_gcp(: , : , ni)] = DM_3(gcp(i , 9 : 11 , ni), rpc_s(: , ni), Su, so);
            elseif sdm == 4
                [ro_gcp(: , ni), co_gcp(: , ni), A1_gcp(: , : , ni)] = DM_4(gcp(i , 9 : 11 , ni), rpc_s(: , ni), Su, so);
            end

            A_gcp(2*i-1 , : , ni) = A1_gcp(1 , : , ni);
            A_gcp(2*i   , : , ni) = A1_gcp(2 , : , ni);

            l_gcp(2 * i - 1 , ni) = gcp(i, 14 , ni) - ro_gcp(: , ni);
            l_gcp(2 * i     , ni) = gcp(i, 15 , ni) - co_gcp(: , ni);
        end
    end

    %Design matrix of ICPs
    %Estimation of the ground coordinates of ICPs
    estimate_ground_g2i(icp , rpc);

    %Generation of Jacobian matrix according to the ground coordinates
    for ni = 1 : number_images
        Ablh(: , : , ni) = A_dblh(icp(: , : , ni), rpc(: , ni), model_id);
    end

    for ni = 1 : number_images
        for i = 1 : length(icp(:, 1))
            if sdm == 1
                [ro_icp(: , ni), co_icp(: , ni), ~] = DM_1(icp(i , 20 : 22), rpc_s(: , ni), Su, so);
            elseif sdm == 2
                [ro_icp(: , ni), co_icp(: , ni), ~] = DM_2(icp(i , 20 : 22), rpc_s(: , ni), Su, so);
            elseif sdm == 3
                [ro_icp(: , ni), co_icp(: , ni), ~] = DM_3(icp(i , 20 : 22), rpc_s(: , ni), Su, so);
            elseif sdm == 4
                [ro_icp(: , ni), co_icp(: , ni), ~] = DM_4(icp(i , 20 : 22), rpc_s(: , ni), Su, so);
            end
        l_icp(2 * i - 1 , ni) = icp(i, 14) - ro_icp;
        l_icp(2 * i     , ni) = icp(i, 15) - co_icp;
        end
    end

    A(1 , :) = [A_gcp(: , : , 1), zeros(size(A_gcp(: , : , 1))), zeros(2 * size(Ablh(: , : , 1)))];
    A(2 , :) = [zeros(size(A_gcp(: , : , 1))), A_gcp(: , : , 2), zeros(2 * size(Ablh(: , : , 1)))];
    A(3 , :) = [A_icp(: , : , 1), zeros(size(A_icp(: , : , 1))), Ablh(: , : , 1), zeros(size(Ablh(: , : , 1)))];
    A(4 , :) = [zeros(size(A_icp(: , : , 1))), A_icp(: , : , 2), zeros(size(Ablh(: , : , 1))), Ablh(: , : , 2)];
    
    l = [l_gcp(: , 1); l_gcp(: , 2); l_icp(: , 1); l_icp(: , 2)];

    [Qxx , dx , fid] = Qxx_dx(A, P, l, meta, fid, 1);

    v = A * dx - l;

    %Updating the RPCs
    dx_rpc = reshape(dx(number_images * length(rpc_s)),[length(rpc_s) , number_images]);%Vector to matrix form.

    for ni = 1 : number_images
        rpc_s(: , ni) = rpc_s(: , ni) + dx_rpc(: , ni));
    end
    
    %% Updating the image coordinates
    %Normalized residuals in an iteration (not the final version)
    vrn_gcp = reshape(v(1 : 2 * number_images * length(gcp(: , 1))) , [2 * number_images * length(gcp(: , 1)) , number_images]));
    vrn_icp = reshape(v(2 * number_images * length(gcp(: , 1)) + 1 : length(v), [2 * number_images * length(icp(: , 1)) , number_images]));
    for ni = 1 : number_images
        for i = 1 : length(gcp(: , 1))
            vrn_gcp(i , ni) = vn_gcp(2 * i - 1 , ni);%vrn
            vcn_gcp(i , ni) = vn_gcp(2 * i     , ni);%vcn
        end
        gcp (: , 16 , ni) = gcp(: , 16 , ni) + vrn_gcp(: , ni)';
        gcp (: , 17 , ni) = gcp(: , 17 , ni) + vcn_gcp(: , ni)';
        for i = 1 : length(icp(: , 1))
            vrn_icp(i , ni) = vn_icp(2 * i - 1 , ni);%vrn
            vcn_icp(i , ni) = vn_icp(2 * i     , ni);%vcn
        end
        icp (: , 16 , ni) = icp(: , 16 , ni) + vrn_icp(: , ni)';
        icp (: , 17 , ni) = icp(: , 17 , ni) + vcn_icp(: , ni)';
    end




