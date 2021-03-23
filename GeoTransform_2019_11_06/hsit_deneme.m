ykn_dogrulk = load('YKN_dogruluk.txt');

ykn = load('SERIT_4_Gokturk_L1R_GCP_ED50_UTM_3d.txt');

for i = 1 : 72
try
idx(i,1) = find(ykn_dogrulk(:,1) == ykn(i,1));
end
end

idx0 = find(idx == 0);

idx(idx0) =[];

for i = 1 : 61

	dgrlk_new(i,:) = ykn_dogrulk(idx(i,1),:);
end

 hist(dgrlk_new(:,2));