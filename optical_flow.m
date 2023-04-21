vidReader = VideoReader('DJI_0257_gray.avi');
opticFlow = opticalFlowHS;

h = figure;

BlobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
              'AreaOutputPort', true, 'CentroidOutputPort', true, ...
              'MinimumBlobArea', 1500);
          
Detector = vision.ForegroundDetector('NumGaussians', 3, ...
'NumTrainingFrames', 20, 'MinimumBackgroundRatio', 0.7);
 ind=1;
 skipFrames=10;
% while hasFrame(vidReader)
%      if mod(ind-1, skipFrames) == 0
%     frameGray = rgb2gray(readFrame(vidReader));
%     fra= Detector.step(frameGray );
%     fra = imopen(fra, strel('rectangle', [10,10]));
%     fra = imclose(fra, strel('rectangle', [10,10]));
% %   
%      flow = estimateFlow(opticFlow,fra);
%      normflow = flow.Magnitude./max(max(flow.Magnitude));
% %     f=normflow<0.5;
% %     Kmedian = medfilt2(f);
% %     SE = strel('rectangle',[40 40]);
% %     BW4 = imdilate(Kmedian,SE);
%      [~,centroids, bboxes] = step(BlobAnalyser ,fra);
%     centroids



opticFlow = opticalFlowHS;
while hasFrame(vidReader)
    if mod(ind-1, skipFrames) == 0
        frameGray = rgb2gray(readFrame(vidReader));
fra= Detector.step( frameGray);
    fra = imopen(fra, strel('rectangle', [5,5]));
    fra = imclose(fra, strel('rectangle', [10,10]));
%   
     flow = estimateFlow(opticFlow,fra);
     normflow = flow.Magnitude./max(max(flow.Magnitude));
     l= medfilt2(normflow, [6 5]);
     f=l>0.3;
%     Kmedian = medfilt2(f);
%     SE = strel('rectangle',[40 40]);
%     BW4 = imdilate(Kmedian,SE);
     
     [~,centroids, bboxes] = step(BlobAnalyser,f)
     mask
     imshow(f);
    pause(1E-3);
     end   
      ind = ind + 1;
end