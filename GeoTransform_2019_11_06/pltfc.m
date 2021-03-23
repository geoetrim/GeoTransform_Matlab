% Plotting total accuracy

function pltfc(gdem)

meta = evalin('base','meta');

figure
box on
hold on

% set(gca,'XDir','normal','YDir','reverse');
set(gca,'XColor','black','YColor','black');
set(gca,'DataAspectRatio',[1 1 1]);
set(gca,'FontSize',12);

if meta(7) == 1% Regular DEM
    contour_interval = input ('Contour interval: ');
    [r_dem c_dem] = demsize(gdem(: , 1 : 3));
    msk = reshape(gdem(: , 12), r_dem, c_dem);
    msk = msk';
    [C, h] = contour(msk , contour_interval); % coordinate system for graphic is row and column.
elseif meta(7) == 0 % Irregular DEM
    contour_sampling_distance = 25;%input ('Sampling distance for contour plotting: ');
    x = gdem(: , 1);
    y = gdem(: , 2);
    msk = gdem(: , 12)';
    [Xr, Yr, Wr] = griddata(x , y , msk, unique(x) , unique(y)');
    [C, h] = contourf(Xr , Yr , Wr , contour_sampling_distance); % coordinate system for graphic is East and North.
end

clabel(C, h, 'manual', 'FontSize', 15)