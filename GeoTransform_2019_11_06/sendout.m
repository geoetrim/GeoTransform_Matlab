
 
f = figure;
imagesc(uint8(gr(:,:,1)));
button = 1;
i = 1;
while(button ~= 3)
    [x1,y1,button]=ginput(2);
  hold on
  if button == 1
      x = round(x1);
      y = round(y1);
      plot(x,y,'ro')
      text(x,y,num2str(i))
      match_green_tide(i,1) = label_target(y(1),x(1));
      match_green_tide(i,2) = label_target2(y(2),x(2));
  end
  i = 1 + i;
end
p = match_green_tide(:,1);
q = match_green_tide(:,2);
[r c] = size(match_green_tide);
for i = 1:r
  x1 = s_1(p(i),1).Centroid(1,1);
  y1 = s_1(p(i),1).Centroid(1,2);
  x2 = s_2(q(i),1).Centroid(1,1);
  y2 = s_2(q(i),1).Centroid(1,2);
    Dist_km(i) = haversine_km( ( Start_y_1+ (y1)*Ysize_1 )  ,  ( Start_x_1+ (x1)*Xsize_1 ), ...
    ( Start_y_2+ (y2)*Ysize_2 )  ,  ( Start_x_2+ (x2)*Xsize_2 )) ;
    plot(x1,y1,'ro')
    plot(x2,y2,'bo')
    plot([x1 x2], [y1 y2],'y') %% to show yellow lines between consecutive centroids as selected
end