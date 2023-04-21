function [imagePoints,worldPoints,imageSize,boardSize]=calibration(image_file)
%name=[camera_name .png];
images =  imageDatastore({image_file,image_file});
imageFileNames = images.Files;
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);
squareSizeInMM = 25;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);

I = readimage(images,1);
imageSize = [size(I,1) size(I,2)];
end

