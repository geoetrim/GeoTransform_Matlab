% Model selection

function [model_id fid] = Scm(fid)

model_id = input(' Select model: \n\n Similarity (Helmert)   > 1 \n Affine (2D)            > 2 \n Polynomial             > 3 \n Affine projection      > 4 \n Projective             > 5 \n DLT                    > 6 \n RFM (GCP dependent)    > 7 \n RFM (Sensor dependent) > 8 \n Choose: ');
if model_id < 0 || model_id > 8
    error(' Model ID must be between 1-8');
end
 if model_id == 1
     fprintf(fid, 'Model: Similarity (Helmert)\n\n');
     
 elseif model_id == 2
     fprintf(fid, 'Model: Affine (2D)\n\n');
     
 elseif model_id == 3
     fprintf(fid, 'Model: Polinomial\n');
     pd = input(' Degree of polynomial: ');
     if pd < 1 || pd > 5
         error(' Degree must be between 1-5');
     end
     model_id = 30 + pd;
     fprintf(fid, 'Degree of polynomial: %1d \n\n', pd);
     
 elseif model_id == 4
     disp(' Model ID: ');
     disp(' 1 > Simple affine projection');
     disp(' 2 > AP for OrbView-3');
     disp(' 3 > AP for IKONOS & QuickBird');
     disp(' 4 > Generic AP');
     mdl = input('Model ID: ');
     if mdl < 1 || mdl > 4
         error(' Model ID must be between 1-4');
     end
     model_id = 40 + mdl;
     fprintf(fid, 'Model: Affine projection\n');
     fprintf(fid, 'Model ID for Affine Projection: %1d\n\n', mdl);

 elseif model_id == 5
     fprintf(fid, 'Model: Projective\n\n');
     
 elseif model_id == 6
     fprintf(fid, 'Model: DLT\n\n');
     
 elseif model_id == 7
     rfmd = input(' Degree of RFM: ');
     if rfmd < 1 || rfmd > 3
         error(' Degree must be between 1-3');
     end
     model_id = 70 + rfmd;
     fprintf(fid, 'Model: RFM (GCP dependent)\n');
     fprintf(fid, 'Degree of RFM: %1d\n\n', rfmd);
 
 elseif model_id == 8
     rfmd = input(' Degree of RFM: ');
     if rfmd < 1 || rfmd > 3
         error(' Degree must be between 1-3');
     end
     model_id = 80 + rfmd;
     fprintf(fid, 'Model: RFM (Sensor dependent)\n');
     fprintf(fid, 'Degree of RFM: %1d\n\n', rfmd);
     rfm_dimension = input(' 2D > 2 \n 3D > 3: ');
     assignin('base','rfm_dimension', rfm_dimension);
     fprintf(fid, 'RFM dimension: %1d\n\n', rfm_dimension);
 end