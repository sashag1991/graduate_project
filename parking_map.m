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
