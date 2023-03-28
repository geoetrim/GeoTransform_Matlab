% Estimation of Qxx and dx for various scenarious

function [Qxx , dx , fid] = Qxx_dx(A, P, l, meta, fid, j)

if j == 1
    eig(A' * A)
    pause
    lamda = input('lamda: ');
    assignin('base','lamda',lamda)
end

lamda = evalin('base','lamda');

if (lamda ~= 0) && (j == 1); fprintf(fid, 'lamda = %3.15f \n', lamda); disp ('Attention! lamda is nonzero.'); end

if (meta(10) == 0) ||  (meta(10) == 1) || (meta(10) == 5)
    if meta(10) == 0
        if j == 1; fprintf(fid,'Parameter estimation: Cayley inverse \n\n'); end
        Qxx = inv(A' * P * A + lamda * eye(size(A , 2)));
    elseif meta(10) == 1
        if j == 1; fprintf(fid,'Parameter estimation: Inverse with Pivotting \n\n'); end
        Qxx = pivot_inv(A' * P * A + lamda * eye(size(A , 2)));
    elseif meta(10) == 5
        if j == 1; fprintf(fid,'Parameter estimation: Pseudo inverse \n\n'); end
        Qxx = pinv(A' * P * A + lamda * eye(size(A , 2)));
    end
    dx = Qxx * A' * P * l';
end

if meta(10) == 2
    if j == 1; fprintf(fid,'Parameter estimation: Cholesky inverse \n\n'); end
    [Qxx , dx] = cholesky_ters(A' * P * A + lamda * eye(size(A , 2)), A' * P * l');
elseif meta(10) == 3
    if j == 1; fprintf(fid,'Parameter estimation: Gauss inverse \n\n'); end
    [Qxx , dx] = gauss_ters(A' * P * A + lamda * eye(size(A , 2)), A' * P * l');
elseif meta(10) == 6
    if j == 1; fprintf(fid,'Parameter estimation: SVD based solution by Dr. Orhan Kurt \n\n'); end
    [U , W , V] = svd(A' * P * A);
    Threshold = min(diag(W))-1e3
    [dx , Qxx] = Ax_b(A' * P * A + lamda * eye(size(A , 2)), A' * P * l', Threshold);
end

if meta(10) == 4
    if j == 1; fprintf(fid, 'Parameter estimation: Ridge Estimator - Levenberg-Marquart Method \n\n'); end;
    dx = ridge(l', A, 0.0001);
elseif meta(10) == 7
    if j == 1; fprintf(fid, 'Parameter estimation: Partial pivoting via Gauss \n\n'); end;
    dx = pivot_kismi_ind(A' * P * A + lamda * eye(size(A , 2)), A' * P * l');
elseif meta(10) == 8
    if j == 1; fprintf(fid, 'Parameter estimation: Cholesky decomposition \n\n'); end;
    dx = cholesky_ind(A' * P * A + lamda * eye(size(A , 2)), A' * P * l');
end
    Qxx = inv(A' * P * A + lamda * eye(size(A , 2)));
    