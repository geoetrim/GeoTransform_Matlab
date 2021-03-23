% Save cikis.txt as a new file
function rename_report

if exist('Output_Files') == 0
    mkdir('Output_Files')
end
meta = evalin('base','meta');
model_id = evalin('base','model_id');

try
    movefile('cikis.txt','Output_Files/cikis.txt');
if model_id == 1
    if meta(8) == 0
        movefile('cikis.txt','Output_Files/Similarity.txt');
    elseif meta(8) == 1
        movefile('cikis.txt','Output_Files/Benzerlik.txt');
    end
elseif model_id == 2
    if meta(8) == 0
        movefile('cikis.txt','Output_Files/Affine_2D.txt');
    elseif meta(8) == 1
        movefile('cikis.txt','Output_Files/Afin_2B.txt');
    end
elseif model_id > 30 && model_id < 36
    if meta(8) == 0
        movefile('cikis.txt',sprintf('Output_Files/Polynomial_%1d_order.txt', (model_id - 30)));
    elseif meta(8) == 1
        movefile('cikis.txt',sprintf('Output_Files/Polinom_%1d_derece.txt', (model_id - 30)));
    end
elseif model_id > 40 && model_id < 44
    if meta(8) == 0
        movefile('cikis.txt',sprintf('Output_Files/Affine_projection_model_%1d.txt', (model_id - 40)));
    elseif meta(8) == 1
        movefile('cikis.txt',sprintf('Output_Files/Afin_izdüsüm_model_%1d.txt', (model_id - 40)));   
    end
elseif model_id == 5
    if meta(8) == 0
        movefile('cikis.txt','Output_Files/Projective.txt');
    elseif meta(8) == 1
        movefile('cikis.txt','Output_Files/Projektif.txt');
    end
elseif model_id == 6
    movefile('cikis.txt','Output_Files/DLT.txt');
elseif model_id > 70 && model_id < 74
    if meta(8) == 0
        movefile('cikis.txt',sprintf('Output_Files/RFM_GCP_Dependent_%1d_order.txt', (model_id - 70)));
    elseif meta(8) == 1
        movefile('cikis.txt',sprintf('Output_Files/RFM_YKN_Bagimli_%1d_derece.txt', (model_id - 70)));
    end
elseif model_id > 80 && model_id < 84
    if meta(8) == 0
        movefile('cikis.txt',sprintf('Output_Files/RFM_Sensor_Dependent_%1d_order.txt', (model_id - 80)));
    elseif meta(8) == 1
        movefile('cikis.txt',sprintf('Output_Files/RFM_Aygilayiciya_Bagimli_%1d_derece.txt', (model_id - 80)));
    end
end
end