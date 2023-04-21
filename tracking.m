videoSource = VideoReader('newfile2.avi');
detector = vision.ForegroundDetector(...
       'NumTrainingFrames', 10, ...
       'InitialVariance', 30*30,'AdaptLearningRate',true,'LearningRate',0.01,'MinimumBackgroundRatio',0.8);
blob = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea',2000,'MaximumBlobArea',3000);

shapeInserter = vision.ShapeInserter('BorderColor','White');

videoPlayer = vision.VideoPlayer();
while hasFrame(videoSource)
     frame  = readFrame(videoSource);
     fgMask = detector(frame);
     bbox   = blob(fgMask);
     out    = shapeInserter(frame,bbox);
     videoPlayer(out);
     pause(0.03);
end


release(videoPlayer);

% clear;
% cam = webcam(1);
% figure(1)
% v = VideoWriter('newfile2.avi');
% open(v)
% hold on
% for k=1:500
% calib_image = rgb2gray(snapshot(cam));
% writeVideo(v,calib_image);
% imshow(calib_image);
% end
% close(v);