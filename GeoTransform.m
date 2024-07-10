tic; clear all; clc; close all; format long g
display(' GeoTransform v.2024')
% Georeferencing via sensor dependent/independent orientation models
% Developed by GeoEtrim Team @ Zonguldak Bülent Ecevit University,
% Zonguldak, Turkey, April 2024
% github.com/geoetrim

metaprog; %Definition of some parameters
report_file %Creating the report file
Scm %Selecting the math model and number of images

%Loading of data and model etc. selection
number_images = evalin('base','number_images');
for ni = 1 : number_images
    loading(ni);
end

%% Preprocessing
for ni = 1 : number_images
    prepro(ni);
end

%% Adjustment
if model_id < 80
    adj
elseif (model_id >= 80) && (number_images == 1) 
    upd_rpc
elseif (model_id >= 80) && (number_images > 1)
    rfm_ground_to_image
end
pltv

%% Total accuracy analysis
if meta(2) == 1
    [gdem, fid] = total_accuracy(Px, model_id, fid);
    % Plotting total accuracy
    pltfc(gdem);
end
%%
open('cikis.txt')
fprintf(fid,'Date: %4d %2d %2d %2d %2d %2.0f', clock);
fclose('all');
rename_report
toc