%Checking the condition of RPCs
% [a1...d20]              -> 80 RPCs -> sdm = 1 -> General condition
% b1 = d1 = 1             -> 78 RPCs -> sdm = 2 -> QuickBird
% b = d and b1 ~= 1       -> 60 RPCs -> sdm = 3 -> OrbView-3
% b = d and b1  = d1  = 1 -> 59 RPCs -> sdm = 4 -> IKONOS

function [sdm, fid] = rpc_cond(rpc, fid)

sdm = 1;

drpc = max(abs(rpc(31 : 50) - rpc(71 : 90))); %Equal-denominators

if (drpc > 0) && (rpc (31) == rpc (71)) && rpc(31) == 1
    sdm = 2;
elseif (drpc == 0) && (rpc(31) ~= rpc(71))
     sdm = 3;
elseif (drpc == 0) && (rpc(31) == rpc(71)) && (rpc(31) == 1)
    sdm = 4;
end

if sdm == 1
    fprintf(fid, 'RPC type: 1 -> [a1...d20] -> 80 RPCs \n\n');
elseif sdm == 2
    fprintf(fid, 'RPC type: 2 -> b1 = d1 = 1 -> 78 RPCs \n\n');
elseif sdm == 3
    fprintf(fid, 'RPC type: 3 -> b = d and b1 ~= 1 -> 60 RPCs \n\n');
else
    fprintf(fid, 'RPC type: 4 -> b = d and b1  = d1  = 1 -> 59 RPCs \n\n');
end