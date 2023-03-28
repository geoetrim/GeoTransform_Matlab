% görüntü koordinatý elde etme

% for i = 1 : size(gcp,1)
%     ykn_gr(i,:)=[gcp(i,1) gcp(i,3)/2 gcp(i,2)/2];
% end



gr_ykn_model3 =load ('model3_ortogoruntu_goruntu_koordinatlari.txt');

for i = 1 : size(gr_ykn_model3,1)
    orto_gcp1(i,:) = imageortho(gr_ykn_model3(i,2),gr_ykn_model3(i,3),:);
end

orto_gcp =[gr_ykn_model3(:,1) orto_gcp1(:,2:4)] ;

for i = 1 : size(orto_gcp,1)
    row(i,1) = find(gcp(:,1) == orto_gcp(i,1));
    GNSS_gcp(i,:) = gcp(row(i,1),:);
end

koh = GNSS_gcp(:,4:5)- orto_gcp(:,2:3);

for i = 1 : size(koh,1)
    koh(i,3) = sqrt(koh(i,1)^2 + koh(i,2)^2);
end

orto_gcp(:,5) = koh(:,3);

% figure
nn = num2str(orto_gcp(:,5),'%2.2f');

hold on

plot(gr_ykn_model3(:,3), gr_ykn_model3(:,2),'+','Color','red')


for i = 1 : length(gr_ykn_model3(:,1))
    text(gr_ykn_model3(i,3), gr_ykn_model3(i,2), nn(i,:),'Color','red','FontSize',11);
end


%% SVK eðrisi üzerinde ykn doðruluklarýný gösterme
hold on

plot(orto_gcp(:,2), orto_gcp(:,3),'+','Color','red')


for i = 1 : length(koh(:,1))
    text(orto_gcp(i,2), orto_gcp(i,3), nn(i,:),'Color','red','FontSize',14);
end

orta = mean(orto_gcp(:,2:3));

hold on

orta_plot = plot(orta(1,1),orta(1,2),'+','Color','red');
set(orta_plot,'MarkerSize',10);% çember yönünde
set(orta_plot,'LineWidth',2);




%% görüntü orto noktasý

% orta_nokta = mean(gr_ykn_model3(:,2:3));
% 
% hold on

% image_sz = size(imageortho)/2;
% 
% plot(image_sz(:,1),image_sz(:,2),'+','MarkerSize',12)






