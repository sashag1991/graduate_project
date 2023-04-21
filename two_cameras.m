
clear;
cam = webcam(1);
calib_image = rgb2gray(snapshot(cam));

[r,c]=size(calib_image);

original=calib_image(:,1:700);
distorted=calib_image(:,400:end);

ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);


[featuresOriginal,  validPtsOriginal]  = extractFeatures(original,  ptsOriginal);
[featuresDistorted, validPtsDistorted] = extractFeatures(distorted, ptsDistorted);


indexPairs = matchFeatures(featuresOriginal, featuresDistorted);




matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
    matchedDistorted, matchedOriginal, 'similarity');

% figure(1)
% imshow(original)
% figure(2)
% imshow(distorted)
% figure(3)

% b=imwarp(distorted,tt);
% 
% b2=imresize(b,[size(original,1) size(original,2)]);
% imshow([original distorted])
tt=affine2d([1 0 0; 0 1 0; 1000 0 1]);

figure(4)
imshow(imwarp(distorted,tt))
figure(5)
imshow(distorted)


