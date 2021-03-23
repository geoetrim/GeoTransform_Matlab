% GeoTransform: Georeferencing via sensor dependent/independent orientation models
% Developed by GeoEtrim Team @ Zonguldak Bülent Ecevit University, Zonguldak, Turkey, August 2019
% www.geoetrim.org

tic
clear all; clc; close all;
format long g

%% Definition of some parameters
meta = metaprog;

%% Loading of data and model etc. selection 
[points, model_id, fid] = loading;

%% Preprocessing
[gcp, fid] = prepro(points, model_id, fid);

%% Adjustment
if model_id < 80 %except sensor dependent RFM
    [gcp, model_id, fid] = adj(gcp, model_id, fid);
elseif model_id >= 80 && rfm_dimension == 2 %sensor dependent RFM for mono image
    [gcp, fid] = upd_rpc(gcp, rpc, fid);
elseif model_id >= 80 && rfm_dimension == 3 %sensor dependent RFM for stereo images
    rfm_bundle
end
%% Vector plotting for residuals
pltv(gcp, model_id);

%% Total accuracy analysis
if meta(2) == 1
    [gdem, fid] = total_accuracy(Px, model_id, fid);
    % Plotting total accuracy
    pltfc(gdem);
end
%%
%Orthorectification

%%
fprintf(fid,'Date: %4d %2d %2d %2d %2d %2.0f', clock);
fclose('all');
rename_report
toc