% Definition of some parameters

function metaprog

%Normalization: 0 - No, 1 - Normalize into �1
meta(1) = 1;

%Estimate total accuracy: 0 - No, 1 - Yes
meta(2) = 0;

%Save figures: 0 - No, 1 - Yes
meta(3) = 0;

%Show GCPs on image: 0 - No, 1 - Yes
meta(4) = 0;

%Show GCP id: 0 - No, 1 - Yes
meta(5) = 1;

%Consider weight: 0 - No, 1 - Yes
meta(6) = 0;

%DEM in regular grid format: 0 - No, 1 - Yes
meta(7) = 0;

%Turkish explanations in figures:   0 - No, 1 - Yes
meta(8) = 0;

%Delete ignored and/or outlier points: 0 - No, 1 - Yes
meta(9) = 1;

% Inverse method:
% 0 - Cayley
% 1 - Pivotting
% 2 - Cholesky
% 3 - Gauss
% 4 - Ridge Estimator - Levenberg-Marquart Method
% 5 - Pseudo inverse (Moore-Penrose)
% 6 - SVD based solution by Dr. Orhan Kurt
% 7 - Partial pivoting via Gauss
% 8 - Cholesky decomposition
meta(10) = 5;

% Remove unvalid coefficients: 0 - No, 1 - Yes
meta(11) = 0;

%Show ignored and/or outlier points: 0 - No, 1 - Yes
meta(12) = 0;
assignin('base', 'meta', meta);
