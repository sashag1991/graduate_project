% image1 =rgb2gray(imread('D:\CS\PRO\parking.png'));
% image2=image1(:,1:300);
% image3=image1(:,200:end);
% imwrite(image2,'D:\CS\PRO\parking_1.png');
% imwrite(image3,'D:\CS\PRO\parking_2.png');
im1=imread('D:\CS\PRO\parking_1.png');
im2=imread('D:\CS\PRO\parking_2.png');
im3=rgb2gray(imread('D:\CS\PRO\parking_temp.png'));
%imwrite(im3,'parking_temp.png')
% 
%  im_r1= imrotate(im1,5);
%  im_r2 = imrotate(im2,-7);
%  imwrite(im_r1,'D:\CS\PRO\parking_1_r.png');
%  imwrite(im_r2,'D:\CS\PRO\parking_2_r.png');
%  
 
points1 = detectHarrisFeatures(im1); %finds the corners
points2 = detectHarrisFeatures(im2);


[features1, valid_points1] = extractFeatures(im1,points1);
[features2, valid_points2] = extractFeatures(im2,points2);

indexPairs = matchFeatures(features1,features2,'Method','Approximate','Unique',true);

matchedPoints1 = valid_points1(indexPairs(4:end,1),:); 
matchedPoints2 = valid_points2(indexPairs(4:end,2),:);

mpoints1=matchedPoints1.Location;
mpoints2=matchedPoints2.Location;


figure(1); ax = axes;
showMatchedFeatures(im1,im2,matchedPoints1(:,:),matchedPoints2(:,:),'montage','Parent',ax);

[tform] = estimateGeometricTransform(...
   matchedPoints1, matchedPoints2 , 'affine','MaxNumTrials',5000,'MaxDistance',1,'Confidence',99.9);
figure(2)
a=imwarp(im1,tform);
imshow(a)
figure(7)
imshow(im2)

% X = imwarp(im1, tform, 'OutputView', imref2d(size(im3)));
% figure(6)
% imshow(X)


tform.T';
inv(tform.T')

[r,c]=size(im3);

points3 = [150,50;
  150,70;
  150,90;
  150,110;
  150,130;
  150,150;
  150,170;
  150,200;
  150,277];
matrix=inv(tform.T');
p_temp=[170,277,277,277,350;300,300,250,200,200;1,1,1,1,1];
%p_temp=[170,300;277,300;277,250;277,200];
points4_temp=(matrix*p_temp)';
points4=points4_temp(:,1:2);
%points4=points4_temp';
points_total=[points3;points4];
for k = 1 : size(points_total, 1)
    
    figure(4)
    imshow(im3,'Border','tight');
    hold on
  xlim([1, c]);
  ylim([1, r]);
  plot(points_total(k,1), points_total(k,2), 'wo', 'MarkerSize',10,'MarkerFaceColor','w');

  hold off
F(k) = getframe(gcf) ;
drawnow
end

hold off

  writerObj = VideoWriter('myVideo.avi');
  writerObj.FrameRate = 1;
 open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj); 
  

  
%   
%   
% figure(5)
% imshow(im2);
% [r,c]=size(im2);
% points = [150,300;
%   170,250;
%   180,200;
%   250,150];
% 
% for k = 1 : size(points, 1)
%   xlim([1, c]);
%   ylim([1, r]);
%   hold on;
%   plot(points(k,1), points(k,2), 'ro', 'MarkerSize',5);
% drawnow
% % F2(k) = getframe(gcf) ;
% end
% 
%   writerObj2 = VideoWriter('myVideo2.avi');
%   writerObj2.FrameRate = 1;
%  open(writerObj2);
% % write the frames to the video
% for i=1:length(F2)
%     % convert the image to a frame
%     frame = F2(i) ;    
%     writeVideo(writerObj2, frame);
% end
% % close the writer object
% close(writerObj2); 
  










