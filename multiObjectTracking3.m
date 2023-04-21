function multiObjectTracking3()
% Create System objects used for reading video, detecting moving objects, % and displaying the results.

obj_new = setupSystemObjects();
  cord_tracks = initializeTracks(); % Create an empty array of tracks.
  next_Id = 1; % ID of the next track
% Detect moving objects, and track them across video frames.
[roads,parking_array,Obstacle,row,col]=parking_map(readFrame(obj_new.reader)); 
f1=figure('Name','parking_lot_map','Position', [740, 400, 700, 400]);
f2=figure('Name','shortest_path','Position', [740, 0, 700, 400]);
axes1 = axes('Parent', f1);
axes2 = axes('Parent', f2);
set(axes1,'XAxisLocation','top','ydir','reverse');
set(axes2,'XAxisLocation','top','ydir','reverse');
axis(axes1,[0 col 0 row]); 
axis(axes2,[0 col 0 row]);
hold

create_parking_map(parking_array,true,'g',axes1);
create_parking_map(roads,false,'b',axes1);
create_parking_map(Obstacle,false,'r',axes1);

mat=create_parking_map2(roads,parking_array,Obstacle,axes2,col,row);
[c1, c2]=parking_centers(parking_array);
imshow(mat)
for i=1:length(c1)
  rectangle('Parent',axes2,'Position', [c2(i) c1(i) 15 15],'Curvature',[1 1],'FaceColor','green');  
 
end


while hasFrame(obj_new.reader)
  
     frame1  = readFrame(obj_new.reader);
      [centroids1, bboxes1, mask1] = detectObjects(frame1);
        
      cord_tracks=predictNewLocationsOfTracks(cord_tracks);
      [assignments, unassignedTracks, unassignedDetections] = ...
      detectionToTrackAssignment(cord_tracks);
      updateAssignedTracks();
      updateUnassignedTracks();
      deleteLostTracks();
      createNewTracks();
%       if size(bboxes)~=0
% 
%       end
      boxes=displayTrackingResults(roads,parking_array,Obstacle,axes1,cord_tracks);
      [rr,~]=size(boxes);
      colors=['b','g'];
      

    

      if rr>0
      
    rectangle('Parent',axes1,'Position', [boxes(end,1:2) 4 4],'Curvature',[1 1],'FaceColor',colors(1));

      
      % plot(axes1,boxes(end,1),boxes(end,2),'ro');
% set(axes1,'XAxisLocation','top','ydir','reverse');
% axis(axes1,[0 col 0 row]); 
      % pause(0.001)


      end
      
  
      
      [cars_row1,cars_col1]=cars_for_nav(roads,boxes);
      

       if ~isempty(cars_row1)
%       plot(cars_col1(end),cars_row1(end),'ro')
         rectangle('Parent',axes2,'Position', [cars_col1(end) cars_row1(end) 4 4],'Curvature',[1 1],'FaceColor',colors(1));
 [nav_row1,nav_col1,~]=shortest_path(mat,cars_row1(end),cars_col1(end),c1(2),c2(2));
     for k=1:100:length(nav_row1)
rectangle('Parent',axes2,'Position', [nav_col1(k) nav_row1(k) 4 4],'Curvature',[1 1],'FaceColor',colors(1));
% %       % plot(axes1,boxes(end,2),boxes(end,1))
       end
       end

      
       
      
    
 pause(0.5)      
  
end
close all;


   function obj = setupSystemObjects()
% Initialize Video I/O % Create objects for reading a video from a file, drawing the tracked % objects in each frame, and playing the video. % Create a video file reader.
obj.reader=VideoReader('newfile2.avi');
% obj.reader = imaq.VideoDevice('winvideo', 1, 'YUY2_320x240', ...
%                          'ReturnedColorSpace', 'rgb');
% Create two video players, one to display the video, % and one to display the foreground mask.

obj.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
      obj.maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);
   %   obj.videoPlayer2 = vision.VideoPlayer('Position', [740, 0, 700, 400]);
% Create System objects for foreground detection and blob analysis % The foreground detector is used to segment moving objects from % the background. It outputs a binary mask, where the pixel value % of 1 corresponds to the foreground and the value of 0 corresponds % to the background.

obj.detector = vision.ForegroundDetector('NumGaussians', 3, ...
          'NumTrainingFrames', 60, 'MinimumBackgroundRatio', 0.7);
% Connected groups of foreground pixels are likely to correspond to moving % objects. The blob analysis System object is used to find such groups % (called 'blobs' or 'connected components'), and compute their % characteristics, such as area, centroid, and the bounding box.

    obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
              'AreaOutputPort', true, 'CentroidOutputPort', true, ...
              'MinimumBlobArea', 1600);
   end
   function tracks = initializeTracks()
          % create an empty array of tracks
          tracks = struct(...
              'id', {}, ...
              'bbox', {}, ...
              'kalmanFilter', {}, ...
              'age', {}, ...
              'totalVisibleCount', {}, ...
              'consecutiveInvisibleCount', {});
   end
%    function frame = readFrame()
%           frame = step(obj.reader);
%    end
   function [centroids, bboxes, mask] = detectObjects(frame)
% Detect foreground.

mask = obj_new.detector.step(frame);
% Apply morphological operations to remove noise and fill in holes.


mask = imopen(mask, strel('rectangle', [5,5]));
      mask = imclose(mask, strel('rectangle', [10, 10]));
      mask = imfill(mask, 'holes');
% Perform blob analysis to find connected components.

    [~, centroids, bboxes] = obj_new.blobAnalyser.step(mask);
   end
   function predictNewLocationsOfTracks(tracks)
          for i = 1:length(tracks)
              bbox = tracks(i).bbox;
% Predict the current location of the track.

predictedCentroid = predict(tracks(i).kalmanFilter);
% Shift the bounding box so that its center is at % the predicted location.

    predictedCentroid = int32(predictedCentroid) - bbox(3:4) / 2;
              tracks(i).bbox = [predictedCentroid, bbox(3:4)];
              temp_tracks=tracks;
          end
   end
   function [assignments_t, unassignedTracks_t, unassignedDetections_t] = ...
              detectionToTrackAssignment(tracks)
          nTracks = length(tracks);
          nDetections = size(centroids, 1);
% Compute the cost of assigning each detection to each track.

cost = zeros(nTracks, nDetections);
      for i = 1:nTracks
          cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
      end
% Solve the assignment problem.

     costOfNonAssignment = 20;
          [assignments_t, unassignedTracks_t, unassignedDetections_t] = ...
              assignDetectionsToTracks(cost, costOfNonAssignment);
   end
  function [temp_track]=updateAssignedTracks(assignments,centroids,bboxes,tracks)
          numAssignedTracks = size(assignments, 1);
          for i = 1:numAssignedTracks
              trackIdx = assignments(i, 1);
              detectionIdx = assignments(i, 2);
              centroid = centroids(detectionIdx, :);
              bbox = bboxes(detectionIdx, :);
% Correct the estimate of the object's location % using the new detection.

correct(tracks(trackIdx).kalmanFilter, centroid);
% Replace predicted bounding box with detected % bounding box.

tracks(trackIdx).bbox = bbox;
% Update track's age.

tracks(trackIdx).age = tracks(trackIdx).age + 1;
% Update visibility.

     tracks(trackIdx).totalVisibleCount = ...
                  tracks(trackIdx).totalVisibleCount + 1;
              tracks(trackIdx).consecutiveInvisibleCount = 0;
          end
          temp_track=tracks;
  end
   function updateUnassignedTracks()
          for i = 1:length(unassignedTracks)
              ind = unassignedTracks(i);
              tracks(ind).age = tracks(ind).age + 1;
              tracks(ind).consecutiveInvisibleCount = ...
                  tracks(ind).consecutiveInvisibleCount + 1;
          end
   end
  function deleteLostTracks()
          if isempty(tracks)
              return;
          end
          invisibleForTooLong = 8;
          ageThreshold = 8;
% Compute the fraction of the track's age for which it was visible.

ages = [tracks(:).age];
      totalVisibleCounts = [tracks(:).totalVisibleCount];
      visibility = totalVisibleCounts ./ ages;
% Find the indices of 'lost' tracks.

lostInds = (ages < ageThreshold & visibility < 0.6) | ...
          [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;
% Delete lost tracks.

     tracks = tracks(~lostInds);
  end
   function createNewTracks()
          centroids = centroids(unassignedDetections, :);
          bboxes = bboxes(unassignedDetections, :);
          for i = 1:size(centroids, 1)
              centroid = centroids(i,:);
              bbox = bboxes(i, :);
% Create a Kalman filter object.

kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
              centroid, [100, 50], [50, 25], 700);
% Create a new track.

 newTrack = struct(...
              'id', nextId, ...
              'bbox', bbox, ...
              'kalmanFilter', kalmanFilter, ...
              'age', 1, ...
              'totalVisibleCount', 1, ...
              'consecutiveInvisibleCount', 0);
% Add it to the array of tracks.

tracks(end + 1) = newTrack;
% Increment the next id.

    nextId = nextId + 1;
          end
   end
   function [bboxes2]=displayTrackingResults(roads,parking_array,Obstacle,axes1,tracks)
% Convert the frame and the mask to uint8 RGB.
bboxes2=[];
frame = im2uint8(frame);
      mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
      minVisibleCount = 8;
      if ~isempty(tracks)
% Noisy detections tend to result in short-lived tracks. % Only display tracks that have been visible for more than % a minimum number of frames.

reliableTrackInds = ...
              [tracks(:).totalVisibleCount] > minVisibleCount;
          reliableTracks = tracks(reliableTrackInds);
% Display the objects. If an object has not been detected % in this frame, display its predicted bounding box.

if ~isempty(reliableTracks)
% Get bounding boxes.

bboxes2 = cat(1, reliableTracks.bbox);

% Get ids.

 ids = int32([reliableTracks(:).id]);
% Create labels for objects indicating the ones for % which we display the predicted rather than the actual % location.

labels = cellstr(int2str(ids'));
              predictedTrackInds = ...
                  [reliableTracks(:).consecutiveInvisibleCount] > 0;
              isPredicted = cell(size(labels));
              isPredicted(predictedTrackInds) = {' predicted'};
              labels = strcat(labels, isPredicted);
% Draw the objects on the frame.

frame = insertObjectAnnotation(frame, 'rectangle', ...
                  bboxes2, 'car');
% Draw the objects on the mask.

mask = insertObjectAnnotation(mask, 'rectangle', ...
                  bboxes2, 'car');
          end
      end
% Display the mask and the frame.

          %obj.maskPlayer.step(mask);
          obj.videoPlayer.step(frame);
             
%             hold on
% 
%             create_parking_map(parking_array,true,'g',axes1);
%             create_parking_map(roads,false,'b',axes1);
%             create_parking_map(Obstacle,false,'r',axes1);
%             hold off
            [cars_row,cars_col]=cars_for_nav(roads,bboxes2);
            [r,c]=size(bboxes2);
            colors=['b','g'];
 
            if r>0                   
           % rectangle('Parent',axes1,'Position', [bboxes2(end,1:2) 4 4],'Curvature',[1 1],'FaceColor',colors(i));

            
 


          end
           


  
   end

function [roads,parking_array,Obstacle,row,col]=parking_map(frame)
img=rgb2gray(frame);
[row,col]=size(img);
I1 = edge(img, 'sobel');
figure('Name','edge_map','Position',[0, 0, 700, 400])
imshow(I1)
roads = cell(1,1);
parking_array=cell(1,1);
Obstacle=cell(1,1);
parking_status="go";
while parking_status~="finish"
%temp_area=parking_lot_area;
parking_status = input('Enter these one of this statements: road,avaliable_parking,Obstacle: \n','s');
if parking_status=="road"
[coord]=define_area_on_parking(parking_status); 
% coord structure : [xmin, ymin, width, height]
roads= [roads,coord];
elseif parking_status=="avaliable_parking"
[coord]=define_area_on_parking(parking_status); 
% coord structure : [xmin, ymin, width, height]
parking_array= [parking_array,coord];
elseif parking_status=="Obstacle"
[coord]=define_area_on_parking(parking_status); 
% coord structure : [xmin, ymin, width, height]
[Obstacle]= [Obstacle,coord];
end
end

roads=roads(2:end);
parking_array=parking_array(2:end);
Obstacle=Obstacle(2:end);
end

function [nav_row,nav_col,distance]=shortest_path(mat,start_point_row,start_point_col,destination_point_row,destination_point_col)

    [r,c]=size(mat);
        start_row=start_point_row;
        start_col=start_point_col;

      des_row=destination_point_row;
      des_col=destination_point_col;

      bw1=false(r,c);

      bw2=false(r,c);

      bw1(start_row, start_col)=true;
      bw2(des_row, des_col)=true;
              
                      D1 = bwdistgeodesic(mat, bw1, 'cityblock');
                      D2 = bwdistgeodesic(mat, bw2, 'cityblock');
                      D = D1 + D2;
                      D = round(D * 32) / 32;

                      D(isnan(D)) = inf;
                      
                    paths = imregionalmin(D);
                    paths_thinned_many = bwmorph(paths, 'thin', inf);
                    [nav_row,nav_col]=find(paths_thinned_many==1);
                    dis=D(paths);
                    distance=dis(1);
     
              

end

 function [cars_row,cars_col]=cars_for_nav2(road_array,car_center)
     
     cars_row=[];
     cars_col=[];
        [r,~]=size(car_center);
     for i=1:r
         row_center=car_center(2);
         col_center=car_center(1);
            for k=1:length(road_array)
                min_row=cast(road_array{k}(2),'int32');
                max_row=cast(road_array{k}(2)+road_array{k}(4),'int32');
                min_col=cast(road_array{k}(1),'int32');
                max_col=cast(road_array{k}(2)+road_array{k}(3),'int32');
                if (row_center>min_row) && (row_center<max_row) && (col_center>min_col) && (col_center<max_col)
                
                    if (max_row-min_row) >= (max_col-min_col)
                        col=cast((max_col-min_col)/2,'int32');
                        cars_row=[cars_row,row_cente];
                        cars_col=[cars_col,min_col+col];
                 
                    end
                    
                    if (max_row-min_row) < (max_col-min_col)
                        row=cast((max_row-min_row)/2,'int32');
                        cars_row=[cars_row,min_row+row];
                        cars_col=[cars_col,col_center];
                    end
 
                end
            end
     end   
    end
   
 function [cars_row,cars_col]=cars_for_nav(road_array,car_center)
     
     cars_row=[];
     cars_col=[];
        [r,~]=size(car_center);
     for i=1:r
         row_center=cast(car_center(i,2)+car_center(i,4)/2,'int32');
         col_center=cast(car_center(i,1)+car_center(i,3)/2,'int32');
            for k=1:length(road_array)
                min_row=cast(road_array{k}(2),'int32');
                max_row=cast(road_array{k}(2)+road_array{k}(4),'int32');
                min_col=cast(road_array{k}(1),'int32');
                max_col=cast(road_array{k}(2)+road_array{k}(3),'int32');
                if (row_center>min_row) && (row_center<max_row) && (col_center>min_col) && (col_center<max_col)
                
                    if (max_row-min_row) >= (max_col-min_col)
                        col=cast((max_col-min_col)/2,'int32');
                        cars_row=[cars_row,row_cente];
                        cars_col=[cars_col,min_col+col];
                 
                    end
                    
                    if (max_row-min_row) < (max_col-min_col)
                        row=cast((max_row-min_row)/2,'int32');
                        cars_row=[cars_row,min_row+row];
                        cars_col=[cars_col,col_center];
                    end
 
                end
            end
     end   
    end

    function [parking_center_row, parking_center_col]=parking_centers(parking_cell_array)
       parking_center_row=[];
       parking_center_col=[];
    for i=1:length(parking_cell_array)
        parking_width=parking_cell_array{i}(3)/parking_cell_array{i}(5);
     for k=1:parking_cell_array{i}(5)
       parking_center_row=[parking_center_row,cast(parking_cell_array{i}(2)+parking_cell_array{i}(4)/2,'int32')];
       parking_center_col=[parking_center_col,cast(parking_cell_array{i}(1)+parking_width/2,'int32')];
       parking_cell_array{i}(1)=parking_cell_array{i}(1)+parking_width;
     end  
    end
        
    end





















































end




 