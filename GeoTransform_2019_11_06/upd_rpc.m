% Updating sensor dependent RPCs for mono image

function [gcp, fid] = upd_rpc(gcp, rpc, fid)

Sc = select_icp;

if Sc > 0
    icp = evalin('base', 'icp');
end

% Weight matrix
P = wght(gcp, fid);

meta = evalin('base','meta'); 

%===== Selection of RPCs and UVWs =====
[sdm, fid] = rpc_cond(rpc, fid); %Defining the denominator
[Sr, Su, so, fid] = Srpc(2 * length(gcp(: , 1)), sdm, fid);
rpc_s = rpc(Sr); %Selected RPCs

for j = 1 : 10
    if j == 1
        gcp(: , 16 : 17) = gcp(: , 14 : 15);
        if Sc > 0
            icp(: , 16 : 17) = icp(: , 14 : 15);
        end
    end
    %===== Design matrix =====
    %for GCPs
    for i = 1 : length(gcp(:, 1))
        if sdm == 1
            [ro_gcp, co_gcp, A1_gcp] = DM_1(gcp(i , 9 : 11), rpc_s, Su, so);
    elseif sdm == 2
            [ro_gcp, co_gcp, A1_gcp] = DM_2(gcp(i , 9 : 11), rpc_s, Su, so);
    elseif sdm == 3
            [ro_gcp, co_gcp, A1_gcp] = DM_3(gcp(i , 9 : 11), rpc_s, Su, so);
        else
            [ro_gcp, co_gcp, A1_gcp] = DM_4(gcp(i , 9 : 11), rpc_s, Su, so);
        end
        
        A_gcp(2*i-1 , :) = A1_gcp(1 , :);
        A_gcp(2*i   , :) = A1_gcp(2 , :);
        
        l_gcp(2 * i - 1) = gcp(i, 16) - ro_gcp;
        l_gcp(2 * i    ) = gcp(i, 17) - co_gcp;
    end

    if Sc > 0
        for i = 1 : length(icp(:, 1))
            if sdm == 1
                [ro_icp, co_icp, A1_icp] = DM_1(icp(i , 9 : 11), rpc_s, Su, so);
            elseif sdm == 2
                [ro_icp, co_icp, A1_icp] = DM_2(icp(i , 9 : 11), rpc_s, Su, so);
            elseif sdm == 3
                [ro_icp, co_icp, A1_icp] = DM_3(icp(i , 9 : 11), rpc_s, Su, so);
            else
                [ro_icp, co_icp, A1_icp] = DM_4(icp(i , 9 : 11), rpc_s, Su, so);
            end
        
        A_icp(2*i-1 , :) = A1_icp(1 , :);
        A_icp(2*i   , :) = A1_icp(2 , :);
        
        l_icp(2 * i - 1) = icp(i, 16) - ro_icp;
        l_icp(2 * i    ) = icp(i, 17) - co_icp;
        end
    end
    
    [Qxx , dx , fid] = Qxx_dx(A_gcp, P, l_gcp, meta, fid, j);
    
    vn_gcp = A_gcp * dx - l_gcp';
    
    if Sc > 0
       vn_icp = A_icp * dx - l_icp';
       assignin('base','A_icp',A_icp)
    end
    
    rpc_s = rpc_s + dx;
    
    % Normalized residuals in an iteration (not the final version)
    for i = 1 : length(gcp(: , 1))
        vrn_gcp(i) = vn_gcp(2 * i - 1);  %vrn
        vcn_gcp(i) = vn_gcp(2 * i);      %vcn
    end
    
    gcp (: , 16) = gcp(: , 16) + vrn_gcp';
    gcp (: , 17) = gcp(: , 17) + vcn_gcp';
    
    if Sc > 0
        for i = 1 : length(icp(: , 1))
            vrn_icp(i) = vn_icp(2 * i - 1);  %vrn
            vcn_icp(i) = vn_icp(2 * i);      %vcn
        end

        icp (: , 16) = icp(: , 16) + vrn_icp';
        icp (: , 17) = icp(: , 17) + vcn_icp';
    end
    
    % Final version of normalized residuals in an iteration (difference
    % between adjusted and raw image coordinates)
    vd_gcp = gcp(: , 16 : 17) - gcp(: , 7 : 8);
    
    if Sc > 0
        vd_icp = icp(: , 16 : 17) - icp(: , 7 : 8);
    end
    
    % Final version of normalized RMSE in an iteration
    mon_gcp = sqrt((vd_gcp(: , 1)' * vd_gcp(: , 1) + vd_gcp(: , 2)' * vd_gcp(: , 2)) / (2 * length(gcp(: , 1)) - length(dx)));
    
    if Sc > 0
        mon_icp = sqrt((vd_icp(: , 1)' * vd_icp(: , 1) + vd_icp(: , 2)' * vd_icp(: , 2)) / (2 * length(gcp(: , 1)) - 1));
    end
    
    assignin('base','mon',mon_gcp)
    
    % Corrected and renormalized GCPs
    for i = 18 : 19
        gcp(:, i) = gcp(:, i - 2) * rpc(i - 12) + rpc(i - 17);
        
        if Sc > 0
            icp(:, i) = icp(:, i - 2) * rpc(i - 12) + rpc(i - 17);
        end
    end
    
    rpc(Sr) = rpc_s;
    
    v_gcp = gcp(: , 18 : 19) - gcp(: , 2 : 3);
    
    if Sc > 0
        v_icp = icp(: , 18 : 19) - icp(: , 2 : 3);
    end    
    
    % Update the weight matrix
    for i = 1 : length(gcp(: , 1)) 
        P2(i , i) = P(2 * i - 1, 2 * i - 1);
    end
    
    % Final RMSE
    mo_gcp(j) = sqrt((v_gcp(: , 1)' * P2 * v_gcp(: , 1) + v_gcp(: , 2)' * P2 * v_gcp(: , 2)) / (2 * length(gcp(: , 1)) - length(dx)));
    
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
% assignin('base','mr',mr)
% assignin('base','mc',mc)

if Sc > 0
    mr_icp = sqrt ((v_icp(: , 1)' * v_icp(: , 1)) / (length(icp(: , 1)) - 1));
    mc_icp = sqrt ((v_icp(: , 2)' * v_icp(: , 2)) / (length(icp(: , 1)) - 1));
    mp_icp = sqrt(mr_icp ^ 2 + mc_icp ^ 2);
    mo_icp = sqrt ((v_icp(: , 1)' * v_icp(: , 1) + v_icp(: , 2)' * v_icp(: , 2)) / (2 * length(icp(: , 1)) - 1));
    
    mr_icp_tgrs = sqrt ((v_icp(: , 1)' * v_icp(: , 1)) / (2 * length(icp(: , 1)) - 1)); %Bilgi'nin yayýnda kullanýlan.
    mc_icp_tgrs = sqrt ((v_icp(: , 2)' * v_icp(: , 2)) / (2 * length(icp(: , 1)) - 1));
end

if meta(1) ~= 0
    Kdpdp = mon_gcp^2 * Qxx; %Use normalized values.
elseif meta(1) == 0
    Kdpdp = mo_gcp(j)^2 * Qxx;
end

% Validation of parameters/coefficients
fid = par_valid (A_gcp, dx, Qxx, mon_gcp, fid);

% Blunder test
fid = blunder(gcp, vn_gcp, dx, A_gcp, fid, mon_gcp, P, Qxx, mo_gcp(j) / mon_gcp);

fprintf(fid, 'Total iteration: %3d \n\n', j);
fprintf(fid, 'Accuracies for GCPs\n');
fprintf(fid, 'mr = ± %5.3f pixel\n',   mr_gcp);
fprintf(fid, 'mc = ± %5.3f pixel\n',   mc_gcp);
fprintf(fid, 'mo = ± %5.3f pixel\n\n', mo_gcp(j));
fprintf(fid, 'mr(tgrs) = ± %5.3f pixel\n',   mr_gcp_tgrs);
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
    fprintf(fid, 'mr(tgrs) = ± %5.3f pixel\n',   mr_icp_tgrs);
    fprintf(fid, 'mc(tgrs) = ± %5.3f pixel\n\n', mc_icp_tgrs);
    fprintf(fid, 'vr(max)= %5.3f pixel, vr(min)= %5.3f pixel\n',   max(v_icp(: , 1)), min(v_icp(: , 1)));
    fprintf(fid, 'vc(max)= %5.3f pixel, vc(min)= %5.3f pixel\n\n', max(v_icp(: , 2)), min(v_icp(: , 2)));
    fprintf(fid, '[vr] = %5.3f pixel\n',   sum(v_icp(: , 1)));
    fprintf(fid, '[vc] = %5.3f pixel\n\n', sum(v_icp(: , 2)));
    assignin('base','icp',icp);
    assignin('base','v_icp',v_icp);
    assignin('base','vn_icp',vn_icp);
end

% Save in workspace
assignin('base','vn', vn_gcp);
assignin('base','Px', rpc);
assignin('base','Kdpdp', Kdpdp);
assignin('base','mo', mo_gcp);
assignin('base','v', v_gcp);
assignin('base','A', A_gcp);
assignin('base','vx', vrn_gcp);
assignin('base','vy', vcn_gcp);