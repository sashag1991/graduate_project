function [p_list,frame]=calculate_distance(map_frame,parkings,cars)

len=size(cars,2);
park_len=size(cars,2);
p_list=[100];
index=1;
if len>0
    for i=1:len
         shortest_distance=inf;
         bbox_of_car_j=cars(i).bbox;
         X_CENTER=bbox_of_car_j(1)+bbox_of_car_j(3)/2;
         Y_CENTER=bbox_of_car_j(2)+bbox_of_car_j(4)/2;
         c=inf;
         d=inf;
        
         for j=1:park_len
             
              bbox_of_parking=parkings(j).shape_position;
              X_parking=bbox_of_parking(1)+bbox_of_parking(3)/2;
              Y_parking=bbox_of_parking(2)+bbox_of_parking(4)/2;
             
              two_points = [X_CENTER,Y_CENTER;X_parking,Y_parking];
              d = pdist(two_points,'euclidean');
              if d < shortest_distance
                  shortest_distance=d;
                  c=X_parking;
                  d=Y_parking;
              end
 
         end
        
      shortest_distance
      c
      d
%          p=find_path(map_frame,X_CENTER,Y_CENTER,int32(X_parking),int32(Y_parking))
         
%          p_list(index)=p;
%          index=index+1;
        
    end
end


po=[reshape([parkings(:).shape_position],[4,25])'];
co=[reshape([parkings(:).color],[1,25])'];
frame=insertShape(map_frame,'FilledRectangle',po,'Color',co);


end