% I1 = imread('D:\CS\PRO\lower_left_new.png');
% B1 = imread('D:\CS\PRO\lower_right_new.png');
obj1=VideoReader('DJI_0257_gray_bottom_left_double.avi');
obj2=VideoReader('DJI_0257_gray_bottom_right_double.avi');

I1=rgb2gray(readFrame(obj1));
B1=rgb2gray(readFrame(obj2));

% I1_1=double(imread('D:\CS\project\lower_left_new.png'));
% B1_1=double(imread('D:\CS\project\lower_right_new.png'));
points1 = detectHarrisFeatures(I1); %finds the corners
points2 = detectHarrisFeatures(B1);

[features1, valid_points1] = extractFeatures(I1,points1);
[features2, valid_points2] = extractFeatures(B1,points2);

indexPairs = matchFeatures(features1,features2,'Method','Approximate','Unique',true);

matchedPoints1 = valid_points1(indexPairs(:,1),:); 
matchedPoints2 = valid_points2(indexPairs(:,2),:);

[tform] = estimateGeometricTransform(...
   matchedPoints1, matchedPoints2 , 'affine','MaxNumTrials',5000,'MaxDistance',1,'Confidence',99.9);
tform=transpose(tform.T);
%  figure(3);
%  tx=tform(1,3);
% imshow([I1(:,1:abs(tx)),B1]);
% figure(4);
% imshow(B1)
figure(1)
showMatchedFeatures(I1,B1,matchedPoints1,matchedPoints2,'montage')