function [undistorted_image,camera_parameters,p]=image_witohut_fishweye(imagePoints,worldPoints,imageSize,image)
params = estimateFisheyeParameters(imagePoints,worldPoints,imageSize);
image_temp = image;
%imwrite(image_temp,'test2_re.png')
%kk = imread('C:\Users\Sasha\Downloads\test2_re.png');
p=params.Intrinsics;
[undistorted_image,camera_parameters] = undistortFisheyeImage(image_temp,params.Intrinsics,'OutputView','valid');
end
