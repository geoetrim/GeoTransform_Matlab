%Selection of ignored points

function Sip = ignored_points

% Sip = input('GCP ID to be ignored. exp. [427 526 258]: ');
% Sip = [18 21 24 25 32 35 37 45 51 52 55 60 63 65 66 74 78 79 85 94 117 122 183 185 218 227 263];%input('GCP ID to be ignored. exp. [427 526 258]: ');
% Sip = [18 21 24 25 32 35 37 45 51 52 55 60 63 65 66 74 78 79 85 94 117 122 183 185 218 227 263 512 518];
% Sip = [37 135 244 247 249 250 503 512 516 517];
% Sip = [37 137 247 249 258 305];

%JILIN_JL1GP02_PMS1_20230601182350_200161860_103_0003_001_L1_B0.tiff
% Sip = [4 6:8 10:21 24 25 27:31 33 34 36:39 41 43 44 46 47 49 101];

%JL1GP02_PMS2_20230601182350_200161860_103_0003_001_L1_B0.tiff
% Sip = [207 220 231 234 240 256];
% Sip = [220 240];

if exist('Sip','var')
    Sip = Sip;
else Sip = [];
end