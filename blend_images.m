I1 = imread('D:\CS\PRO\lower_left_new.png');
B1 = imread('D:\CS\PRO\lower_right_new.png');
% I1_1=double(imread('D:\CS\project\lower_left_new.png'));
% B1_1=double(imread('D:\CS\project\lower_right_new.png'));
points1 = detectHarrisFeatures(I1); %finds the corners
points2 = detectHarrisFeatures(B1);

[features1, valid_points1] = extractFeatures(I1,points1);
[features2, valid_points2] = extractFeatures(B1,points2);

indexPairs = matchFeatures(features1,features2,'Method','Approximate','Unique',true);

matchedPoints1 = valid_points1(indexPairs(:,1),:); 
matchedPoints2 = valid_points2(indexPairs(:,2),:);

mpoints1=matchedPoints1.Location;
mpoints2=matchedPoints2.Location;

rows=size(indexPairs,1);
A=zeros(rows,9);

%{find the trasmoramtion matrix P 
k=rows/2;
for i=1:k
    A(i*2-1,:)=[mpoints1(i,:),1,0,0,0,-mpoints2(i,1)*mpoints1(i,:),-mpoints2(i,1)];    
    A(i*2,:)=[0,0,0,mpoints1(i,:),1,-mpoints2(i,2)*mpoints1(i,:),-mpoints2(i,2)];
end

[Q,D,R] = svd(A);
p = R(:,end);

p = p/p(end);
P = reshape(p,3,3)';

%{Show matched points using

figure(1); ax = axes;
showMatchedFeatures(I1,B1,matchedPoints1(:,:),matchedPoints2(:,:),'montage','Parent',ax);
figure(2);
k=abs(P(1,3));
%{show the combined image using trandslation from P trasformation matrix 
panorama=[I1(:,1:k),B1];
imshow(panorama)


%{
using RANSAC of matched points to find trsnsformation matrix
 %}
    

[tform] = estimateGeometricTransform(...
   matchedPoints1, matchedPoints2 , 'affine','MaxNumTrials',5000,'MaxDistance',1,'Confidence',99.9);
tform=transpose(tform.T);
 figure(3);
 tx=tform(1,3);
imshow([I1(:,1:abs(tx)),B1]);
figure(4);
imshow(B1)

% tx=abs(tform.T(3,1));
% 
% %{Show matched points after using RANSAC 
% 
% figure(3); ax = axes;
% showMatchedFeatures(I1,B1,inlierDistorted,inlierOriginal,'montage','Parent',ax);
% figure(4);
% %{show combined image using translation from P trasformation matrix we get using RANSAC 
% panorama2=[I1(:,1:tx),B1];
% imshow(panorama2)
% pt1=mpoints1.';
% pt2=mpoints2.';
% pt=[pt1;pt2];
% hom=[1,-1;1,1];
% % sampleSize=2;
% % maxDistance=3;
% % a=[-pt(2,:),pt(1,:),1,0;pt(1,:),pt(2,:),0,1;-pt(2,:),pt(1,:),1,0;pt(1,:),pt(2,:),0,1];
% % c=(((a.')*a)^(-1))*(a.');
% % fitLineFcn = @(pt,c) c*[pt(3,:);pt(4,:);pt(3,:);pt(4,:)]; % fit function using polyfit
% % evalLineFcn =  @(model, pt) sum(([model(:,2),-model(:,1);model(:,1),model(:,2)]*[pt(1,:);pt(2,:)]+[model(:,3);model(:,4)]-[pt(3,:);pt(4,:)]).^2,2)% distance evaluation function
% % 
% % [modelRANSAC, inlierIdx] = ransac(pt,fitLineFcn,evalLineFcn,sampleSize,maxDistance);
% %  
% % figure(5)
% % plot(mpoints1(:,1),mpoints2(:,2))
% % 
% % figure(6)
% % plot(mpoints2(:,1),mpoints2(:,2))
% %[matrix_homography,inliers1,inliers2] = ransacfunc(mpoints1,mpoints2,2,100,1000);
% [parameter_y] = transform_homography(mpoints1,mpoints2,10);
% [parameter_x] = transform_x_homography(mpoints1,mpoints2,50);
% 
% b1_temp=B1(:,:);
% i1_temp=I1(:,1:parameter_x);
% figure(5);
% %{show combined image using translation from P trasformation matrix we get using RANSAC 
% panorama2=[i1_temp,b1_temp];
% imshow(panorama2)
% 
% [T]= find_transformation(mpoints1,mpoints2,40,2000);
% 
B=zeros(80,9);
k=rows/2;
t=20;
for i=1:40
    B(i*2-1,:)=[mpoints1(i+t,:),1,0,0,0,-mpoints2(i+t,1)*mpoints1(i+t,:),-mpoints2(i+t,1)];    
    B(i*2,:)=[0,0,0,mpoints1(i+t,:),1,-mpoints2(i+t,2)*mpoints1(i+t,:),-mpoints2(i+t,2)];
end

%B(9,:)=[0,0,0,0,0,0,0,0,1];
% 
% TTT=[0;0;0;0;0;0;0;0;1];
% 
% X=linsolve(B,TTT);
% 
% X = X/X(end);
% SOL = reshape(X,3,3)';


[~,~,R2] = svd(B);
p1 = R2(:,end);

p1 = p1/p1(end);
SOL2 = reshape(p1,3,3)';