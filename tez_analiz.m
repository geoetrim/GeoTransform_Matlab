% YKN'leri dem contour üzrinde çizdirme

% Görüntü koordinatlarýna göre DEM dosyasý üzerinde bulma
yeni_gcp = zeros (size(gcp,1),15);

for i = 1 : size(gcp,1)
    try
        idx1(i) = find(ismember(round(gfc(:,14:15)/2),round(gcp(i,2:3)/2),'rows'));
        yeni_gcp(i,:) = gfc(idx1(i),:);
    end
end

koh = gcp(:,4:5)- yeni_gcp(:,1:2);

for i = 1 : size(gcp,1)
    koh(i,3) = sqrt(koh(i,1)^2 + koh(i,2)^2);
end

koh_analiz_table = [gcp(:,1) koh(:,3) yeni_gcp(: , 13)];

dogruluk_dagilimi = [gcp(: , 1) gcp(: , 4 : 5) koh(: , 3)];

goruntude_olmayan_noktalar = find(yeni_gcp(:,1) == 0);

koh_analiz_table(goruntude_olmayan_noktalar,:) = [];

dogruluk_dagilimi(goruntude_olmayan_noktalar,:) = [];

% %% yakýn noktayý belirleme
% hold on
% 
% plot(gcp(:,3)/2, gcp(:,2)/2,'+','Color','red')
% 
% nn = int2str(gcp(:,1));
% 
% for i = 1 : size(gcp,1)
%     text(gcp(i,3)/2, gcp(i,2)/2,nn(i,:),'Color', 'red','FontSize',14)
% end
 


%% SVK eðrisi üzerinde ykn doðruluklarýný gösterme

% figure
nn = num2str(dogruluk_dagilimi(:,4),'%2.2f');

hold on

a = plot(dogruluk_dagilimi(:,2), dogruluk_dagilimi(:,3),'+','Color','red');

set(a,'MarkerSize',10);% çember yönünde
set(a,'LineWidth',2);


for i = 1 : length(dogruluk_dagilimi(:,1))
    text(dogruluk_dagilimi(i,2), dogruluk_dagilimi(i,3), nn(i,:),'Color','red','FontSize',14);
end

orta = mean(dogruluk_dagilimi(:,2:3));

hold on

orta_plot = plot(orta(1,1),orta(1,2),'+','Color','m');
set(orta_plot,'MarkerSize',14);% çember yönünde
set(orta_plot,'LineWidth',3);


% hold on
% plot(dogruluk_dagilimi(:,2),dogruluk_dagilimi(:,3),'+');
% 
% % set(a,'MarkerSize',4);% çember yönünde
% % set(a,'Color','red');
% 
% nn = int2str(dogruluk_dagilimi(:,4));
% 
% hold on
% % if slc_id == 1
%     for i = 1 : length(dogruluk_dagilimi(:,1))
%     text(dogruluk_dagilimi(i, 2), dogruluk_dagilimi(i, 3), nn(i,:),'Color','red','FontSize',14);
%     end
% % end
