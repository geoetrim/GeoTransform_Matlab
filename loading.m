%Loading points and FCPs

function loading(ni)

%% ===== Writting into the file =====
fid = evalin('base','fid');
model_id = evalin('base','model_id');

%% ===== Points loading =====
if ni > 1
    points = evalin('base', 'points');
    PathName_points = evalin('base', 'PathName_points');
end
if ni == 1
    PathName_points = [];
end
[FileName_points, PathName_points] = uigetfile('*.txt*;*.gcp','Point File', PathName_points);
p = load([PathName_points FileName_points]);
points(:, :, ni) = sortrows(p, 1);
assignin('base', 'PathName_points', PathName_points)
assignin('base', 'FileName_points', FileName_points)
assignin('base', 'points', points)
fprintf(fid, '%1d. Point file: %1s \n\n', ni, [PathName_points FileName_points]);

if model_id >= 80
    if ni == 1 ; display(' Points must be in order of "latitude, longitude, height"'); end; pause(1)
    if ni > 1; rpc = evalin('base','rpc'); end
    RPC_selection = input(' RPC file selection:\n 1 > Manual\n 2 > Automatic\n Choose: ');
    if RPC_selection == 1
        [FileName_RPC, PathName_RPC] = uigetfile({'*rpc*.txt*;*.rpc'},'RPC File',PathName_points);
    elseif RPC_selection == 2
        [PathName_RPC, baseFileName, ext] = fileparts(FileName_points);
        FileName_RPC = sprintf('%s_rpc.txt', baseFileName(1:56));%JILIN
        assignin('base', 'FileName_RPC', FileName_RPC)
    end
    rpc_file = fopen([PathName_points FileName_RPC]);
    rpc_scan = textscan(rpc_file,'%s %f %s','Delimiter',':');
    rpc(: , ni) = rpc_scan{1 , 2};
    assignin('base','rpc',rpc);
    fprintf(fid, '%1d. RPC file: %1s \n\n', ni, [PathName_RPC FileName_RPC]);
end

%% ===== DEM loading =====
meta = evalin('base','meta'); 
if meta(2) ==  1; 
    [FileName_DEM, PathName_DEM] = uigetfile('*.*','DEM File');
    gdem = load([PathName_DEM, FileName_DEM]);
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
