clear;
% cam = webcam(1);
% calib_image = rgb2gray(snapshot(cam));
% imwrite(calib_image,'parking_image.png');
% calib=imread('calibration_photo.png');
% calib=calib(100:700,300:950);
% imwrite(calib,'calibration_crop.png');
%Take photo of calibration image
% img_calibration=imread('calibration_photo2.png');
img=imread('calibration_photo2.png');

[imagePoints,worldPoints,imageSize,boardSize]=calibration('calibration_photo2.png');

%Take photo of parking lot
% clear
% 
% for i=1:3
%     pause(1)
%     i
% end
% 
% img_init=rgb2gray(calibration_photo2.);
% img_init=imread("calibration_photo2.png");
[undistorted_image,camera_parameters,param]=image_witohut_fishweye(imagePoints,worldPoints,imageSize,img);
figure(1)
imshow(img)

imwrite(undistorted_image,"a.png");
figure(2)
imshow(undistorted_image)




