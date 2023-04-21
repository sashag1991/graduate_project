videoFReader = VideoReader('DJI_0257_gray.avi');
videoFWriter = VideoWriter('DJI_0257_gray_bottom_right.avi');
open(videoFWriter)
% top_left 1:320,1:530
% top right 1:320,430:959
% bottom left 220:540,1:530
% bottom right 220:540,430:959
close all

for i=1:720
    videoFrame = readFrame(videoFReader); 
%    videoFrame2 = rgb2gray(videoFrame(1:320,1:530));
   writeVideo(videoFWriter,videoFrame(220:540,430:959))
end
close(videoFWriter)

close all
% 
%  vid = VideoReader('DJI_gray_bottom_right.avi');
%  numImgs = get(vid, 'NumFrames');
%  frames = read(vid);
%  obj=VideoWriter('DJI_gray_bottom_right_2.avi');
%  open(obj);
% 
%  for i=1:numImgs
%      movie(i).cdata=rgb2gray(frames(:,:,:,i));
%      movie(i).colormap=gray;
%  end
% 
%  writeVideo(obj,movie);
%  close(obj);