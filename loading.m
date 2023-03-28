%Loading points and FCPs

function [points, model_id, fid] = loading

%% ===== Writting into the file =====
fid = fopen('cikis.txt','w+');
fprintf(fid,'Hüseyin TOPAN, Ali CAM, Bilgi TERLEMEZOÐLU (ZBEÜ - 2019)\n\n', 's');

%% ===== Points loading =====
[FileName_points PathName_points] = uigetfile('*.*','Points File');
points = load([PathName_points FileName_points]);
points = sortrows(points , 1); %Sort GCPs according to the GCP IDs
fprintf(fid, 'Points file: %1s \n\n', [PathName_points FileName_points]);

%% ===== DEM loading =====
meta = evalin('base','meta'); 
if meta(2) ==  1; 
    [FileName_DEM PathName_DEM] = uigetfile('*.*','DEM File');
    gdem = load([PathName_DEM FileName_DEM]);
%     if min(gdem(: , 3)) < 0 % Set 0 if height < 0
%         for i = 1 : size(gdem , 1)
%             if gdem(i , 3) < 0
%                 gdem(i , 3) = 0;
%             end
%         end
%     end
    fprintf(fid, 'Points file: %1s \n\n', [PathName_DEM FileName_DEM]);
    assignin('base','gdem',gdem);
end

%% ===== Model selection =====
[model_id fid] = Scm(fid); % Model selection

if model_id >= 80
    display('Attention! Points must be in order of "latitude, longitude"')
    pause
end

%% ===== RPC loading =====
if model_id > 80
    [FileName_RPC PathName_RPC] = uigetfile('*.*','RPC File');
    rpc = load([PathName_RPC FileName_RPC]);
    assignin('base','rpc',rpc);
    fprintf(fid, 'RPC file: %1s \n\n', [PathName_RPC FileName_RPC]);
end