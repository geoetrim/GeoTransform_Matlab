% Creating a report file

function report_file

if exist('cikis.txt','var') == 1; delete('cikis.txt'); end

fid = fopen('cikis.txt','w+');
assignin ('base', 'fid', fid);
fprintf(fid, 'GeoTransform: Georeferencing via sensor dependent/independent orientation models \n');
fprintf(fid, 'as a sub-tool of GeoEtrim, Zonguldak Bülent Ecevit University, June 2023, Zonguldak, Türkiye\n');
fprintf(fid, 'by Prof. Hüseyin TOPAN: Overall conception, workflow and coding by Matlab \n');
fprintf(fid, 'by Mr. Ali CAM (MSc)  : Redesigning the codes between 2014-2017, and total accuracy approach \n');
fprintf(fid, 'by Dr. Bilgi TERLEMEZOÐLU: Solving ill-conditioning problem \n');
fprintf(fid, 'Visit github.com/geoetrim for more information \n');
fprintf(fid, 'Date: %4d %2d %2d %2d %2d %2.0f\n\n', clock);