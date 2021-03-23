function [dx, fid] = Dx(A, l, fid, j)

if j ==1
    fprintf(fid, 'Bilinmeyen hesabi: ');
    % ===============================================
    fprintf(fid, 'Normal ters \n\n');
end
% dx = inv (A' * A) * A' * l;
% ===============================================
% fprintf(fid, 'Orhan Kurtun çözümü (Yahoo mail: 5 Eylül 2008) \n\n');
% Threshold = 1e-10;
% [dx, Qx] = Ax_b (A, l, Threshold);
% ===============================================
% fprintf(fid, 'Pseudo invers \n\n');
% dx = pinv (A' * A) * A' * l;
% ===============================================
% fprintf(fid, 'Cholesky decomposition \n\n');
%     C = chol(A'*A);
%     Cinv = inv(C);
%     dx = inv(C) * (inv(C))' * A' * l; %Cholesky
% ===============================================
% fprintf(fid, 'Ridge Estimator - Levenberg-Marquart Method \n\n');
% dx = ridge(l, A, 0.01);
% ===============================================
%  fprintf(fid, 'Singular Value Decomposition \n\n');
% [S V D] = svd(A' * A);
% dx = inv(D ama bu gerçekten D mi yoksa S mi olmalý???) * inv(V) * inv(D) * A' * l;