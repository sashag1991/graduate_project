

mask=false(872,1536);
for i=1: length(parking_array)
mask(parking_array{i}(2):parking_array{i}(2)+parking_array{i}(4),parking_array{i}(1):parking_array{i}(1)+parking_array{i}(3))=true;
end
mask(roads{1}(2):roads{1}(2)+roads{1}(4),roads{1}(1):roads{1}(1)+roads{1}(3))=true;
bw1=false(872,1536);
bw2=false(872,1536);
bw1(360,200)=true;
bw2(250,1100)=true;

D1 = bwdistgeodesic(mask, bw1, 'cityblock');
D2 = bwdistgeodesic(mask, bw2, 'cityblock');
figure(3)
imagesc(D1);
figure(4)
imagesc(bw2)
D = D1 + D2;
%D = round(D * 2) / 2;
D(isnan(D)) = inf;
paths = imregionalmin(D);
paths_thinned_many = bwmorph(paths,'thin',inf);
figure(1)
imagesc(paths_thinned_many)
figure(2)
imagesc(D)
colorbar

