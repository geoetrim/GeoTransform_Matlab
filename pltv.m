 %Plot residual vectors

function pltv

meta      = evalin('base','meta');
gcp       = evalin('base','gcp');
model_id  = evalin('base','model_id');
Sc        = evalin('base','Sc');
scale_gcp = input(' Scale for GCPs: ');
scale_icp = input(' Scale for ICPs: ');
sv        = meta(3);%input('Save figures?      Y-> 1 N-> 2 : ');
slc_im    = meta(4);%input('Show GCP on image? Y-> 1 N-> 2 : ');
slc_id    = meta(5);%input('Show GCP id?       Y-> 1 N-> 2 : ');

figure
hold on;

gcp_id = int2str(gcp(: , 1));

if Sc > 0
    icp = evalin('base', 'icp');
    icp_id = int2str(icp(: , 1));
%     display('Rescaling the coordinates for visual presentation!')
%     icp(: , 2) = icp(: , 2) / (20197 / 877);
%     icp(: , 3) = icp(: , 3) / (23029 / 1000);
end

% gcp(: , 2) = gcp(: , 2) / (20197 / 877);
% gcp(: , 3) = gcp(: , 3) / (23029 / 1000);

box on

if slc_im == 1
    [FileName,PathName] = uigetfile('.');
    im = imread(fullfile(PathName,FileName));
    im_auto = imadjust(im(:,:,1));
    imshow(im_auto)
    hold on
end

set(gca,'XGrid','off','YGrid','off');
set(gca,'XDir','normal','YDir','reverse');
set(gca,'XColor','black','YColor','black');
set(gca,'FontSize',14);
set(gca,'DataAspectRatio',[1 1 1]);

%% Adding title to figure
if model_id == 1
    if meta(8) == 0
        title('Similarity (Helmert)');
    elseif meta(8) == 1
        title('Benzerlik');
    end
elseif model_id == 2
    if meta(8) == 0
        title('Affine (2D)');
    elseif meta(8) == 1
        title('Afin (2B)');
    end
elseif model_id > 30 && model_id < 36
    if meta(8) == 0
        title(sprintf('Polynomial %1d^{0}', (model_id - 30)));
    elseif meta(8) == 1
        title(sprintf('Polinom %1d^{0}', (model_id - 30)));
    end
elseif model_id > 40 && model_id < 45
    if meta(8) == 0
        title(sprintf('Affine projection model %1d', (model_id - 40)));
    elseif meta(8) == 1
        title(sprintf('Afin izdüþüm model %1d', (model_id - 40)));   
    end
elseif model_id == 5
    if meta(8) == 0
        title('Projective');
    elseif meta(8) == 1
        title('Projektif');
    end
elseif model_id == 6
    title('DLT');
elseif model_id > 70 && model_id < 74
    if meta(8) == 0
        title(sprintf('RFM %1d^{0} (GCP Dependent)', (model_id - 70)));
    elseif meta(8) == 1
        title(sprintf('RFM %1d^{0} (YKN Baðýmlý)', (model_id - 70)));
    end
elseif model_id > 80 && model_id < 84
    if meta(8) == 0
        title(sprintf('RFM %1d^{0} (Sensor Dependent)', (model_id - 80)));
    elseif meta(8) == 1
        title(sprintf('RFM %1d^{0} (Algýlayýcýya Baðýmlý)', (model_id - 80)));
    end
end

%% Adding coordinate axis names
if meta(8) == 0
    xlabel('column (pixel)','FontSize',20);
    ylabel('row (pixel)','FontSize',20);
elseif meta(8) == 1
    xlabel('sütun (piksel)','FontSize',20);
    ylabel('satýr (piksel)','FontSize',20);
end

%% Drawing the vectors
if model_id < 80
    hndl1_gcp = quiver(gcp(: , 3), gcp(: , 2), scale_gcp * (gcp(:, 15) - gcp(:, 3)), scale_gcp * (gcp(:, 14) - gcp(:, 2)), 0, 'o');
    if Sc > 0
        hndl1_icp = quiver(icp(: , 3), icp(: , 2), scale_icp * (icp(:, 15) - icp(:, 3)), scale_icp * (icp(:, 14) - icp(:, 2)), 0, 'd');
    end
else
    hndl1_gcp = quiver(gcp(: , 3), gcp(: , 2), scale_gcp * (gcp(:, 19) - gcp(:, 3)), scale_gcp * (gcp(:, 18) - gcp(:, 2)), 0, 'o');
    if Sc > 0
        hndl1_icp = quiver(icp(: , 3), icp(: , 2), scale_icp * (icp(:, 19) - icp(:, 3)), scale_icp * (icp(:, 18) - icp(:, 2)), 0, 'd');
    end
end

set(hndl1_gcp,'LineWidth', 1.5);
set(hndl1_gcp,'MarkerSize', 3);
set(hndl1_gcp,'Color','black');

if Sc > 0
    set(hndl1_icp,'LineWidth', 1.5);
    set(hndl1_icp,'MarkerSize', 8);
    set(hndl1_icp,'Color','black');
end

%% Showing the GCP-ICP ids
if slc_id == 1
    for i = 1 : length(gcp(:,1))
        text(gcp(i , 3) + 20, gcp(i , 2), gcp_id(i , :),'FontSize',7.5);
    end
    if Sc > 0
        for i = 1 : length(icp(:,1))
            text(icp(i , 3), icp(i , 2), icp_id(i , :),'FontSize',7.5);
        end
    end
end

%% Drawing the vectoral scales
% For GCPs
hndl2 = quiver(200, 3000, scale_gcp * 5, 0, 'o');

set(hndl2,'LineWidth', 1.5);
set(hndl2,'MarkerSize', 2);
set(hndl2,'Color','black');

if scale_gcp == scale_icp
    if meta(8) == 0
        text(500, 3000, '       5 pixels','FontSize', 15);
    elseif meta(8) == 1
        text(500, 5500, '       5 piksel','FontSize', 15);
    end
else
    % For GCPs
    if meta(8) == 0
        text(min(gcp(: , 3)) + 150, min(gcp(: , 2)) + 500, '       5 pixel for GCPs','FontSize', 15);
    elseif meta(8) == 1
        text(min(gcp(: , 3)) + 150, min(gcp(: , 2)) + 500, '       5 piksel (YKN) (','FontSize', 15);
    end
    % For ICPs
    hndl3 = quiver(min(gcp(: , 3)) + 100, min(gcp(: , 2)) + 1000, scale_icp * 1, 0, 'o');
    set(hndl3,'LineWidth', 1.5);
    set(hndl3,'MarkerSize', 2);
    set(hndl3,'Color','black');
    
    if meta(8) == 0
        text(min(gcp(: , 3)) + 150, min(gcp(: , 2)) + 1000, '       5 pixel for ICPs','FontSize', 15);
    elseif meta(8) == 1
        text(min(gcp(: , 3)) + 150, min(gcp(: , 2)) + 1000, '       5 piksel (BDN)','FontSize', 15);
    end
end

%% Show ignored and/or outlier points on figure
if meta(12) == 1
    ignored_point = evalin('base','ignored_point');
    hold on 
    hndl3 = plot(ignored_point(: , 3),  ignored_point(: , 2),'X');
    set(hndl3,'LineWidth', 3);
    set(hndl3,'MarkerSize',12);
    set(hndl3,'Color','black');
end

%% ===== Save figure =====
if sv == 1
    mkdir('Figure')
    file_name = sprintf('%1d.png', model_id);
    move_file = sprintf('JILIN_Sekil/%1d.png', model_id);
    saveas(gcf, file_name);
    movefile(file_name, move_file) 
end

%% Combination of vector direction
figure
if model_id < 80
    ac_gcp = compass(scale_gcp * (gcp(:, 15) - gcp(:, 3)), scale_gcp * (gcp(:, 14) - gcp(:, 2)));
    hold on
    if exist('icp') == 1
        ac_icp = compass(scale_gcp * (icp(:, 15) - icp(:, 3)), scale_icp * (icp(:, 14) - icp(:, 2)));
    end
elseif model_id >= 80
    ac_gcp = compass(scale_gcp * (gcp(:, 19) - gcp(:, 3)), scale_gcp * (gcp(:, 18) - gcp(:, 2)));
    hold on
    if exist('icp') == 1
        ac_icp = compass(scale_gcp * (icp(:, 19) - icp(:, 3)), scale_icp * (icp(:, 18) - icp(:, 2)));
    end
end

hHiddenText = findall(gca,'type','text');
set(gca,'XDir','normal','YDir','reverse');
set(gca,'linewidth',2);
set(ac_icp,'Color','red');
Angles = 0 : 30 : 330;
hObjToDelete = zeros( length(Angles)-4, 1 );
k = 0;

for ang = Angles
   hObj = findall(hHiddenText,'string',num2str(ang));
   switch ang
   case 0
       if meta(8) == 0
           set(hObj,'string','Right','HorizontalAlignment','Left','FontSize',20);
       elseif meta(8) == 1
           set(hObj,'string','Sað','HorizontalAlignment','Left','FontSize',20);
       end
   case 90
       if meta(8) == 0
           set(hObj,'string','Down','VerticalAlignment','Bottom','FontSize',20);
       elseif meta(8) == 1
           set(hObj,'string','Aþaðý','VerticalAlignment','Bottom','FontSize',20);
       end
   case 180
       if meta(8) == 0
            set(hObj,'string','Left','HorizontalAlignment','Right','FontSize',20);
       elseif meta(8) == 1
           set(hObj,'string','Sol','HorizontalAlignment','Right','FontSize',20);
       end      
   case 270
       if meta(8) == 0
           set(hObj,'string','Upper','VerticalAlignment','Top','FontSize',20);
       elseif meta(8) == 1
           set(hObj,'string','Yukarý','VerticalAlignment','Top','FontSize',20);
       end
   otherwise
      k = k + 1;
      hObjToDelete(k) = hObj;
   end
end

delete( hObjToDelete(hObjToDelete~=0) );
%% ===== Save figure =====
if sv == 1
    file_name2 = sprintf('%1d_rose.png', model_id);
    move_file2 = sprintf('JILIN_Sekil/%1d_rose.png', model_id);
    saveas(gcf, file_name2);
    movefile(file_name2, move_file2)
end
